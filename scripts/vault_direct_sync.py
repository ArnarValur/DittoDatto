#!/usr/bin/env python3
import os
import sys
import json
import hashlib
import argparse
import logging
import requests
import google.auth
from google.oauth2 import service_account
from google.auth.transport.requests import Request
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger("vault_sync")

def get_credentials(sa_key_path):
    """
    Authenticate using a service account key if available,
    otherwise fallback to Application Default Credentials (ADC).
    """
    scopes = ['https://www.googleapis.com/auth/cloud-platform']
    
    if sa_key_path and os.path.exists(sa_key_path):
        logger.info(f"Authenticating with Service Account key: {sa_key_path}")
        credentials = service_account.Credentials.from_service_account_file(
            sa_key_path, scopes=scopes
        )
    else:
        logger.info("Service Account key not found or path not specified. Falling back to Application Default Credentials (ADC)...")
        credentials, _ = google.auth.default(scopes=scopes)
        
    credentials.refresh(Request())
    return credentials

def compute_sha256(file_path):
    """Compute SHA256 of local file content."""
    sha256 = hashlib.sha256()
    with open(file_path, 'rb') as f:
        while chunk := f.read(8192):
            sha256.update(chunk)
    return sha256.hexdigest()

def get_local_vault_files(vault_path):
    """
    Recursively scans the local vault directory for .md files,
    ignoring hidden folders/files.
    Returns a dict of relative_path -> absolute_path.
    """
    vault = Path(vault_path)
    if not vault.exists():
        logger.error(f"Vault path does not exist: {vault_path}")
        sys.exit(1)
        
    local_files = {}
    for path in vault.rglob('*.md'):
        # Check if any parent folder in the relative path starts with '.'
        relative_path = path.relative_to(vault)
        parts = relative_path.parts
        if any(part.startswith('.') for part in parts):
            continue
        if path.name.startswith('.'):
            continue
        
        local_files[str(relative_path)] = path
        
    return local_files

def get_notebook_sources(domain, project_number, location, notebook_id, credentials):
    """
    Fetches the notebook resource from the Discovery Engine API to extract current sources.
    Returns a list of source objects.
    """
    url = f"https://{domain}/v1alpha/projects/{project_number}/locations/{location}/notebooks/{notebook_id}"
    headers = {
        'Authorization': f'Bearer {credentials.token}',
        'Content-Type': 'application/json'
    }
    
    logger.info(f"Fetching notebook metadata from: {url}")
    r = requests.get(url, headers=headers)
    
    if r.status_code != 200:
        logger.error(f"Failed to fetch notebook. Status: {r.status_code}")
        logger.error(r.text)
        # If the license error is encountered, we explain it clearly
        if r.status_code == 400 and "SUBSCRIPTION_TIER_NOTEBOOK_LM_INTERACT" in r.text:
            logger.error("\n" + "="*80 + "\n"
                         "LICENSE ERROR: Your account / service account lacks the required \n"
                         "SUBSCRIPTION_TIER_NOTEBOOK_LM_INTERACT license.\n"
                         "Please assign the Gemini Enterprise / NotebookLM Enterprise license in the \n"
                         "Workspace Admin Console or Google Cloud console.\n" + "="*80 + "\n")
        sys.exit(1)
        
    notebook_data = r.json()
    # The API returns sources under the 'sources' key
    return notebook_data.get('sources', [])

def upload_source(upload_domain, project_number, location, notebook_id, relative_path, file_path, credentials, dry_run=False):
    """
    Uploads a markdown file directly to NotebookLM.
    """
    url = f"https://{upload_domain}/upload/v1alpha/projects/{project_number}/locations/{location}/notebooks/{notebook_id}/sources:uploadFile"
    headers = {
        'Authorization': f'Bearer {credentials.token}',
        'X-Goog-Upload-Protocol': 'raw',
        'X-Goog-Upload-File-Name': relative_path,
        'Content-Type': 'text/markdown'
    }
    
    if dry_run:
        logger.info(f"[DRY-RUN] Would upload local file: {relative_path}")
        return True
        
    logger.info(f"Uploading {relative_path}...")
    with open(file_path, 'rb') as f:
        data = f.read()
        
    r = requests.post(url, headers=headers, data=data)
    if r.status_code in (200, 201):
        logger.info(f"Successfully uploaded: {relative_path}")
        return True
    else:
        logger.error(f"Failed to upload: {relative_path}. Status: {r.status_code}")
        logger.error(r.text)
        return False

def delete_sources(domain, project_number, location, notebook_id, source_names, credentials, dry_run=False):
    """
    Batch deletes sources from NotebookLM.
    """
    url = f"https://{domain}/v1alpha/projects/{project_number}/locations/{location}/notebooks/{notebook_id}/sources:batchDelete"
    headers = {
        'Authorization': f'Bearer {credentials.token}',
        'Content-Type': 'application/json'
    }
    
    body = {
        "names": source_names
    }
    
    if dry_run:
        logger.info(f"[DRY-RUN] Would delete sources: {source_names}")
        return True
        
    logger.info(f"Deleting {len(source_names)} stale source(s)...")
    r = requests.post(url, headers=headers, json=body)
    if r.status_code == 200:
        logger.info("Successfully deleted stale sources.")
        return True
    else:
        logger.error(f"Failed to delete sources. Status: {r.status_code}")
        logger.error(r.text)
        return False

def main():
    parser = argparse.ArgumentParser(description="Directly sync DittoDatto Obsidian Vault markdown files to NotebookLM Enterprise API.")
    parser.add_argument('--dry-run', action='store_true', help="Scan local files and construct plan without uploading/deleting.")
    parser.add_argument('--state-file', default=None, help="Path to state file to cache SHA256 hashes of uploaded files.")
    args = parser.parse_args()
    
    # 1. Load config from environment
    project_number = os.getenv("NOTEBOOK_PROJECT_NUMBER")
    location = os.getenv("NOTEBOOK_LOCATION", "global")
    endpoint_location = os.getenv("NOTEBOOK_ENDPOINT_LOCATION", "us")
    notebook_id = os.getenv("NOTEBOOK_ID")
    vault_path = os.getenv("NOTEBOOK_VAULT_PATH")
    sa_key_path = os.getenv("GCP_SA_KEY_PATH")
    
    # Validation
    missing = []
    if not project_number: missing.append("NOTEBOOK_PROJECT_NUMBER")
    if not notebook_id: missing.append("NOTEBOOK_ID")
    if not vault_path: missing.append("NOTEBOOK_VAULT_PATH")
    
    if missing:
        logger.error(f"Missing required environment variables: {', '.join(missing)}")
        sys.exit(1)
        
    # Standard domains
    if endpoint_location == "global" or not endpoint_location:
        domain = "discoveryengine.googleapis.com"
        upload_domain = f"{location}-discoveryengine.googleapis.com"
    else:
        domain = f"{endpoint_location}-discoveryengine.googleapis.com"
        upload_domain = f"{endpoint_location}-discoveryengine.googleapis.com"
        
    # State file path setup
    state_file = args.state_file or os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sync_state.json')
    
    # Load state
    state = {}
    if os.path.exists(state_file):
        try:
            with open(state_file, 'r') as f:
                state = json.load(f)
        except Exception as e:
            logger.warning(f"Failed to load sync state file, starting fresh: {e}")
            
    # 2. Authenticate
    credentials = get_credentials(sa_key_path)
    
    # 3. Scan local files
    logger.info(f"Scanning local Obsidian Vault at: {vault_path}")
    local_files = get_local_vault_files(vault_path)
    logger.info(f"Found {len(local_files)} markdown files in local vault.")
    
    # 4. Fetch remote sources
    remote_sources = get_notebook_sources(domain, project_number, location, notebook_id, credentials)
    logger.info(f"Found {len(remote_sources)} sources in remote notebook.")
    
    # Build remote map: title -> sourceName
    remote_map = {}
    for src in remote_sources:
        title = src.get('title')
        name = src.get('name')
        if title and name:
            remote_map[title] = name
            
    # 5. Compute Deltas
    to_upload = {}  # relative_path -> absolute_path
    to_delete = []  # list of remote source names
    
    # A. Check for uploads (new or modified)
    for rel_path, abs_path in local_files.items():
        local_hash = compute_sha256(abs_path)
        
        # If it doesn't exist in remote notebook, upload it
        if rel_path not in remote_map:
            to_upload[rel_path] = (abs_path, local_hash)
        else:
            # If it exists remotely, check if it's modified based on cached hash
            cached_hash = state.get(rel_path)
            if cached_hash != local_hash:
                to_upload[rel_path] = (abs_path, local_hash)
                # We need to delete the old one first to avoid duplicates
                to_delete.append(remote_map[rel_path])
                
    # B. Check for deletions (remote exists but local is gone)
    for title, name in remote_map.items():
        if title not in local_files:
            to_delete.append(name)
            
    # Log plan
    logger.info("=" * 40)
    logger.info(f"PLAN TO EXECUTE:")
    logger.info(f"  Upload/Update: {len(to_upload)} files")
    logger.info(f"  Delete:        {len(to_delete)} sources")
    logger.info("=" * 40)
    
    if args.dry_run:
        logger.info("Dry-run complete. No changes made.")
        return
        
    # 6. Execute Deletions
    success_deletes = True
    if to_delete:
        # GCP limits batch delete sizes sometimes, we delete all at once if <= 100, otherwise split
        chunk_size = 100
        for i in range(0, len(to_delete), chunk_size):
            chunk = to_delete[i:i+chunk_size]
            if not delete_sources(domain, project_number, location, notebook_id, chunk, credentials):
                success_deletes = False
                
    # 7. Execute Uploads
    success_uploads = True
    uploaded_state_updates = {}
    for rel_path, (abs_path, local_hash) in to_upload.items():
        # If we had to delete it first, it's already in to_delete
        if upload_source(upload_domain, project_number, location, notebook_id, rel_path, abs_path, credentials):
            uploaded_state_updates[rel_path] = local_hash
        else:
            success_uploads = False
            
    # Update local state file
    # Only keep local files in state, clean up deleted ones
    new_state = {rel_path: compute_sha256(abs_path) for rel_path, abs_path in local_files.items()}
    # Update state with successfully uploaded hashes, keep old state for failed uploads
    for rel_path, local_hash in new_state.items():
        if rel_path in uploaded_state_updates:
            state[rel_path] = uploaded_state_updates[rel_path]
        elif rel_path not in state:
            # New file that failed to upload shouldn't be in state
            pass
            
    # Save state file
    try:
        with open(state_file, 'w') as f:
            json.dump(state, f, indent=2)
        logger.info(f"Saved sync state to {state_file}")
    except Exception as e:
        logger.error(f"Failed to save sync state file: {e}")
        
    if success_deletes and success_uploads:
        logger.info("Direct sync completed successfully!")
    else:
        logger.warning("Sync finished with errors. Some operations failed.")
        sys.exit(1)

if __name__ == "__main__":
    main()
