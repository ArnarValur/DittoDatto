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
}

/**
 * Media upload composable for handling file uploads to Firebase Storage
 * and creating corresponding Firestore documents in the `media` collection.
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
  })

  /**
   * Validate a file before upload
   */
  function validateFile(file: File): { valid: boolean; error?: string } {
    // Check file size
    if (file.size > MEDIA_MAX_FILE_SIZE) {
      return {
        valid: false,
        error: `File size exceeds ${MEDIA_MAX_FILE_SIZE / 1024 / 1024}MB limit`,
      }
    }

    // Check MIME type
    if (!MEDIA_ALLOWED_TYPES.includes(file.type as typeof MEDIA_ALLOWED_TYPES[number])) {
      return {
        valid: false,
        error: `File type "${file.type}" is not allowed. Allowed: ${MEDIA_ALLOWED_TYPES.join(', ')}`,
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
   * Upload a file to Firebase Storage and create a Firestore media document
   */
  async function uploadFile(file: File, options: UploadOptions): Promise<MediaItem | null> {
    // Reset state
    state.isUploading = true
    state.progress = 0
    state.error = null
    state.downloadUrl = null

    // Validate file
    const validation = validateFile(file)
    if (!validation.valid) {
      state.error = validation.error || 'Invalid file'
      state.isUploading = false
      return null
    }

    // Check user is authenticated
    if (!user.value) {
      state.error = 'User must be authenticated to upload'
      state.isUploading = false
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
        updatedAt: serverTimestamp(),
      })

      state.isUploading = false

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
        updatedAt: new Date(),
      }
    } catch (err: unknown) {
      const errorMessage = err instanceof Error ? err.message : 'Upload failed'
      console.error('Upload error:', err)
      state.error = errorMessage
      state.isUploading = false
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
      console.error('Delete error:', err)
      state.error = errorMessage
      return false
    }
  }

  return {
    state: readonly(state),
    validateFile,
    uploadFile,
    deleteMedia,
  }
}
