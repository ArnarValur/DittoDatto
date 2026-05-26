import { doc, updateDoc } from 'firebase/firestore'
import { ref as storageRef, uploadBytes, getDownloadURL } from 'firebase/storage'
import { useCurrentUser, useFirestore, useFirebaseStorage, useDocument } from 'vuefire'
import type { User } from '@dittodatto/shared-types'

export const useUserProfile = () => {
  const user = useCurrentUser()
  const db = useFirestore()
  const storage = useFirebaseStorage()
  const toast = useToast()

  const userDocRef = computed(() => user.value ? doc(db, 'users', user.value.uid) : null)
  const profile = useDocument<User>(userDocRef)

  const loading = ref(false)

  async function updateProfile(data: Partial<User>) {
    if (!userDocRef.value) return

    loading.value = true
    try {
      await updateDoc(userDocRef.value, {
        ...data,
        updatedAt: new Date().toISOString()
      })
      toast.add({ title: 'Profile updated', color: 'success' })
    } catch (err: unknown) {
      console.error('Error updating profile:', err)
      toast.add({
        title: 'Failed to update profile',
        color: 'error',
        description: (err as Error).message
      })
      throw err
    } finally {
      loading.value = false
    }
  }

  async function uploadAvatar(file: File) {
    if (!user.value || !userDocRef.value) return

    loading.value = true
    try {
      const fileRef = storageRef(storage, `avatars/${user.value.uid}`)
      await uploadBytes(fileRef, file)
      const downloadURL = await getDownloadURL(fileRef)

      await updateDoc(userDocRef.value, {
        photoUrl: downloadURL,
        updatedAt: new Date().toISOString()
      })

      toast.add({ title: 'Avatar updated', color: 'success' })
      return downloadURL
    } catch (err: unknown) {
      console.error('Error uploading avatar:', err)
      toast.add({
        title: 'Failed to upload avatar',
        color: 'error',
        description: (err as Error).message
      })
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    profile,
    loading,
    updateProfile,
    uploadAvatar
  }
}
