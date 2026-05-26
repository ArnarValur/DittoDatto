# Drammen Digital Twin (Seed Generator)

This folder contains a small Python CLI that generates realistic, relational demo data for your Firebase Firestore Emulator.

- Script: `twin_drammen.py`
- Output: `drammen_seed.json` (written in the current working directory)

## What it generates

A single run produces one JSON file with these top-level collections:

- `users` (business owners)
- `companies` (1..N per owner)
- `stores` (1..N per company, placed in Drammen neighborhoods)
- `persons` (optional staff per store)
- `services` (bookable services per store, optionally linked to a person)

IDs are generated once and reused across the cascade, so references always match (e.g., `company.ownerId` points to an existing user).

## How the data is built (relational cascade)

For each **Owner**:

1. Create `OwnerModel` → appended to `users`
2. Create 1..N `CompanyModel` linked via `ownerId` → appended to `companies`
3. Create 1..N `StoreModel` linked via `companyId` → appended to `stores`
4. Optionally create 0..N `PersonModel` linked via `storeId` → appended to `persons`
5. Create N `ServiceModel` linked via `storeId` and (if staff exists) a random `personId` → appended to `services`

## Quick start

From this folder:

```bash
python .\twin_drammen.py --menu
```

Or the non-interactive form:

```bash
python .\twin_drammen.py 10
```

## Incremental builds (append mode)

To grow your dataset over time (instead of overwriting the file):

```bash
python .\twin_drammen.py 5 --append --out drammen_seed.json
```

This loads the existing JSON (if present) and appends new entities to each array.

## Categories / sectors

You can steer business names, service titles, and keywords toward a category (useful for demo UI categories and search filters):

```bash
python .\twin_drammen.py 10 --companies-min 1 --companies-max 1 --sector "Hairdressing" --append
```

Supported sectors (matched by keywords, case-insensitive; slugs are derived via kebab-case):

- Restaurants
- Fast Food
- Hairdressing
- Barbershops
- Grooming
- Feet
- Nails
- Tattoos and Piercing
- Tanning
- Massage
- Chiropractic
- Osteopathy
- Physiotherapy
- Podiatry
- Dentists
- Optical services
- Psychology
- Coaching
- Counseling
- Photography
- Law
- Government
- Automotive
- Cycling
- Repair
- Cleaning
- Animals
- Golfing
- Fitness
- Entertainment
- Venues
- Other

If you omit `--sector`, the generator will pick a random allowed sector **per company** (useful for building a mixed city dataset).

## Most useful flags

- Owners:
  - positional `owners` = number of BUSINESS owners (e.g. `python .\twin_drammen.py 10`)
- Customers:
  - `--customers 200` (adds CUSTOMER users)
  - `--customers-only` (generate only customers; no companies/stores)
- Companies per owner:
  - `--companies-min`, `--companies-max`
- Stores per company:
  - `--stores-min`, `--stores-max`
- Staff:
  - `--staff-mode` = `auto` | `resource` | `facility`
  - `--staff-probability` (0.0–1.0, only used in `auto`)
  - `--persons-min`, `--persons-max`
- Services:
  - `--services-per-store`
  - `--durations` (comma-separated minutes, e.g. `30,45,60,90`)
  - `--price-min`, `--price-max`
- Output:
  - `--out` (default: `drammen_seed.json`)
  - `--append`
- Optional collections:
  - `--include-categories` (adds `categories` array matching the UI)
- Speed / determinism:
  - `--no-ollama` (uses a safe fallback description/keywords)
- UI feedback:
  - `--no-progress` (suppresses console output)

## Example recipes

```bash
python .\twin_drammen.py 5 --append --out drammen_seed.json --sector "Automotive" --companies-min 1 --companies-max 2 --stores-min 1 --stores-max 3 --staff-mode auto --staff-probability 0.7 --services-per-store 8 --include-categories
```

Create 3 owners, each with 2–4 companies, and 1–2 stores per company:

```bash
python .\twin_drammen.py 3 --companies-min 2 --companies-max 4 --stores-min 1 --stores-max 2 --append
```

Generate 10 “Restaurants” businesses (fast mode):

```bash
python .\twin_drammen.py 10 --companies-min 1 --companies-max 1 --sector "Restaurants" --no-ollama --append
```

Generate only customers (for customer-side UI testing):

```bash
python .\twin_drammen.py 0 --customers 200 --customers-only --append
```

Facility-based mode (no staff created, services have `personId: null`):

```bash
python .\twin_drammen.py 2 --staff-mode facility --append
```

## Sector command cheatsheet

All commands below append into the same file so you can build the city “in layers”.

Tip: to avoid a single owner owning many companies, increase the first positional argument (`owners`) and keep `--companies-min 1 --companies-max 1`.

```bash
python .\twin_drammen.py 10 --companies-min 1 --companies-max 1 --stores-min 1 --stores-max 1 --services-per-store 6 --sector "Restaurants" --include-categories
python .\twin_drammen.py 15  --companies-min 1 --companies-max 1 --stores-min 1 --stores-max 1 --services-per-store 4 --sector "Fast Food"
python .\twin_drammen.py 12 --companies-min 1 --companies-max 1 --services-per-store 8 --sector "Hairdressing"
python .\twin_drammen.py 6  --companies-min 1 --companies-max 1 --services-per-store 6 --sector "Barbershops" 
python .\twin_drammen.py 8  --companies-min 1 --companies-max 1 --services-per-store 6 --sector "Nails" 
python .\twin_drammen.py 6  --companies-min 1 --companies-max 1 --services-per-store 5 --sector "Massage" 
python .\twin_drammen.py 4  --companies-min 1 --companies-max 1 --services-per-store 4 --sector "Chiropractic" 
python .\twin_drammen.py 4  --companies-min 1 --companies-max 1 --services-per-store 4 --sector "Physiotherapy" 
python .\twin_drammen.py 5  --companies-min 1 --companies-max 1 --services-per-store 3 --sector "Dentists" 
python .\twin_drammen.py 3  --companies-min 1 --companies-max 1 --services-per-store 3 --sector "Optical services"
python .\twin_drammen.py 4  --companies-min 1 --companies-max 1 --services-per-store 3 --sector "Psychology"
python .\twin_drammen.py 4  --companies-min 1 --companies-max 1 --services-per-store 3 --sector "Coaching"
python .\twin_drammen.py 3  --companies-min 1 --companies-max 1 --services-per-store 3 --sector "Counseling"
python .\twin_drammen.py 4  --companies-min 1 --companies-max 1 --services-per-store 4 --sector "Photography"
python .\twin_drammen.py 5  --companies-min 1 --companies-max 1 --services-per-store 3 --sector "Law"
python .\twin_drammen.py 3  --companies-min 1 --companies-max 1 --stores-min 1 --stores-max 1 --services-per-store 2 --price-min 0 --price-max 0 --sector "Government"
python .\twin_drammen.py 6  --companies-min 1 --companies-max 1 --services-per-store 5 --sector "Automotive"
python .\twin_drammen.py 5  --companies-min 1 --companies-max 1 --services-per-store 5 --sector "Cycling"
python .\twin_drammen.py 6  --companies-min 1 --companies-max 1 --services-per-store 4 --sector "Repair"
python .\twin_drammen.py 9  --companies-min 1 --companies-max 1 --services-per-store 4 --sector "Cleaning"
python .\twin_drammen.py 4  --companies-min 1 --companies-max 1 --services-per-store 4 --sector "Animals"
python .\twin_drammen.py 2  --companies-min 1 --companies-max 1 --stores-min 1 --stores-max 1 --services-per-store 3 --sector "Golfing"
python .\twin_drammen.py 6  --companies-min 1 --companies-max 1 --services-per-store 6 --sector "Fitness"
python .\twin_drammen.py 7  --companies-min 1 --companies-max 1 --stores-min 1 --stores-max 1 --services-per-store 3 --sector "Entertainment"
python .\twin_drammen.py 5  --companies-min 1 --companies-max 1 --stores-min 1 --stores-max 1 --services-per-store 3 --sector "Venues"
python .\twin_drammen.py 2  --companies-min 1 --companies-max 1 --services-per-store 3 --sector "Other"
```

## Twin Drammen (realistic city demo recipe)

Drammen municipality is a mid-sized Norwegian city/municipality (recent figures are ~105k residents and ~137 km²). For a believable demo dataset:

1) Start with a mixed city baseline (random sector per company):

```bash
python .\twin_drammen.py 60 --companies-min 1 --companies-max 2 --stores-min 1 --stores-max 2 --services-per-store 6 --customers 1200 --append --include-categories
```

2) Add sector-specific “boosts” (use the cheatsheet above) to ensure each sector is represented.

3) If you want faster runs without Ollama: add `--no-ollama`.

## What to expect in the output

- `services[].keywords` is always a 5-item array (good for search/filter testing).
- `personId` is `null` when staff is not created for that store.
- Addresses and names are generated with a Norwegian locale when available.
- `stores[].images` is populated with placeholder image URLs for thumbnails.
