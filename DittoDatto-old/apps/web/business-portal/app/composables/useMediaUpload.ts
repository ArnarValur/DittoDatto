import { ref as storageRef, uploadBytesResumable, getDownloadURL, deleteObject } from 'firebase/storage'
import { collection, addDoc, deleteDoc, doc, serverTimestamp } from 'firebase/firestore'
import { useCurrentUser, useFirestore, useFirebaseStorage } from 'vuefire'
import type { MediaType, MediaItem } from '@dittodatto/shared-types'
import { MEDIA_MAX_FILE_SIZE, MEDIA_ALLOWED_TYPES } from '@dittodatto/shared-types'
import { reactive, readonly } from 'vue'

export interface UploadOptions {
  companyId: string
  storeId?: string
  type: MediaType
  /** Custom path within company folder, e.g., 'logos', 'stores/{storeId}/gallery' */
  subPath?: string
}

export interface UploadState {
  isUploading: boolean
  progress: number
  error: string | null
  downloadUrl: string | null
  /** Current file being uploaded (for multi-upload) */
  currentFileName: string | null
  /** Current file index (1-based) */
  currentIndex: number
  /** Total files in current batch */
  totalFiles: number
}

/**
 * Media upload composable for handling file uploads to Firebase Storage
 * and creating corresponding Firestore documents in the `media` collection.
 *
 * Supports single-file and multi-file (sequential) uploads.
 */
export const useMediaUpload = () => {
  const user = useCurrentUser()
  const db = useFirestore()
  const storage = useFirebaseStorage()

  const state = reactive<UploadState>({
    isUploading: false,
    progress: 0,
    error: null,
    downloadUrl: null,
    currentFileName: null,
    currentIndex: 0,
    totalFiles: 0
  })

  /**
   * Validate a file before upload.
   * Accepts standard image types + HEIC/HEIF from mobile devices.
   * Also allows files with generic 'image/' prefix as a fallback for
   * mobile browsers that may not report specific MIME types.
   */
  function validateFile(file: File): { valid: boolean, error?: string } {
    // Check file size
    if (file.size > MEDIA_MAX_FILE_SIZE) {
      return {
        valid: false,
        error: `File size (${(file.size / 1024 / 1024).toFixed(1)}MB) exceeds ${MEDIA_MAX_FILE_SIZE / 1024 / 1024}MB limit`
      }
    }

    // Check MIME type — allow any image/* as fallback for mobile browsers
    // that report non-standard MIME types (e.g., 'image/jpg' instead of 'image/jpeg')
    const isAllowedType = MEDIA_ALLOWED_TYPES.includes(file.type as typeof MEDIA_ALLOWED_TYPES[number])
    const isGenericImage = file.type.startsWith('image/')

    if (!isAllowedType && !isGenericImage) {
      return {
        valid: false,
        error: `File type "${file.type || 'unknown'}" is not an image. Please upload JPEG, PNG, WebP, or HEIC files.`
      }
    }

    return { valid: true }
  }

  /**
   * Generate a safe filename with timestamp
   */
  function generateFilename(originalName: string): string {
    const timestamp = Date.now()
    const safeName = originalName
      .toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[^a-z0-9.-]/g, '')
    return `${timestamp}-${safeName}`
  }

  /**
   * Upload a single file to Firebase Storage and create a Firestore media document
   */
  async function uploadFile(file: File, options: UploadOptions): Promise<MediaItem | null> {
    // Reset state for single upload
    state.isUploading = true
    state.progress = 0
    state.error = null
    state.downloadUrl = null
    state.currentFileName = file.name
    state.currentIndex = 1
    state.totalFiles = 1

    const result = await _doUpload(file, options)

    state.isUploading = false
    state.currentFileName = null
    return result
  }

  /**
   * Upload multiple files sequentially.
   * Returns an array of results (null for failed uploads).
   */
  async function uploadFiles(
    files: File[],
    options: UploadOptions,
    onFileComplete?: (file: File, result: MediaItem | null, index: number) => void
  ): Promise<(MediaItem | null)[]> {
    if (files.length === 0) return []

    state.isUploading = true
    state.error = null
    state.downloadUrl = null
    state.totalFiles = files.length
    state.currentIndex = 0

    const results: (MediaItem | null)[] = []

    for (let i = 0; i < files.length; i++) {
      const file = files[i]
      state.currentIndex = i + 1
      state.currentFileName = file.name
      state.progress = 0

      const result = await _doUpload(file, options)
      results.push(result)

      onFileComplete?.(file, result, i)
    }

    state.isUploading = false
    state.currentFileName = null
    state.currentIndex = 0
    state.totalFiles = 0

    return results
  }

  /**
   * Internal upload implementation — handles a single file upload.
   * Does NOT manage isUploading state (caller is responsible).
   */
  async function _doUpload(file: File, options: UploadOptions): Promise<MediaItem | null> {
    // Validate file
    const validation = validateFile(file)
    if (!validation.valid) {
      state.error = validation.error || 'Invalid file'
      return null
    }

    // Check user is authenticated
    if (!user.value) {
      state.error = 'User must be authenticated to upload'
      return null
    }

    try {
      // Build storage path
      const filename = generateFilename(file.name)
      const subPath = options.subPath || options.type
      const storagePath = `companies/${options.companyId}/${subPath}/${filename}`
      const fileRef = storageRef(storage, storagePath)

      // Start upload with progress tracking
      const uploadTask = uploadBytesResumable(fileRef, file)

      // Wait for upload to complete
      await new Promise<void>((resolve, reject) => {
        uploadTask.on(
          'state_changed',
          (snapshot) => {
            state.progress = Math.round((snapshot.bytesTransferred / snapshot.totalBytes) * 100)
          },
          (error) => {
            reject(error)
          },
          () => {
            resolve()
          }
        )
      })

      // Get download URL
      const downloadURL = await getDownloadURL(fileRef)
      state.downloadUrl = downloadURL

      // Create Firestore document
      const mediaDocRef = await addDoc(collection(db, 'media'), {
        companyId: options.companyId,
        storeId: options.storeId || null,
        uploaderId: user.value.uid,
        url: downloadURL,
        path: storagePath,
        filename: file.name,
        mimeType: file.type,
        size: file.size,
        type: options.type,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      })

      return {
        id: mediaDocRef.id,
        companyId: options.companyId,
        storeId: options.storeId,
        uploaderId: user.value.uid,
        url: downloadURL,
        path: storagePath,
        filename: file.name,
        mimeType: file.type as MediaItem['mimeType'],
        size: file.size,
        type: options.type,
        tags: [],
        createdAt: new Date(),
        updatedAt: new Date()
      }
    } catch (err: unknown) {
      const errorMessage = err instanceof Error ? err.message : 'Upload failed'
      console.error('[MediaUpload] Upload error:', file.name, err)
      state.error = errorMessage
      return null
    }
  }

  /**
   * Delete a media item from Storage and Firestore
   */
  async function deleteMedia(mediaItem: MediaItem): Promise<boolean> {
    try {
      // Delete from Storage
      const fileRef = storageRef(storage, mediaItem.path)
      await deleteObject(fileRef)

      // Delete from Firestore
      await deleteDoc(doc(db, 'media', mediaItem.id))

      return true
    } catch (err: unknown) {
      const errorMessage = err instanceof Error ? err.message : 'Delete failed'
      console.error('[MediaUpload] Delete error:', err)
      state.error = errorMessage
      return false
    }
  }

  return {
    state: readonly(state),
    validateFile,
    uploadFile,
    uploadFiles,
    deleteMedia
  }
}
