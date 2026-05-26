// apps/admin-panel/app/composables/useDashboard.ts
import { createSharedComposable } from '@vueuse/core'

const _useDashboard = () => {
  const route = useRoute()
  const router = useRouter()
  const isNotificationsSlideoverOpen = ref(false)

  defineShortcuts({
    'g-h': () => router.push('/'),
    'g-i': () => router.push('/inbox'),
    'g-c': () => router.push('/users'),
    'g-s': () => router.push('/settings'),
    'n': () =>
      (isNotificationsSlideoverOpen.value
        = !isNotificationsSlideoverOpen.value)
  })

  watch(
    () => route.fullPath,
    () => {
      isNotificationsSlideoverOpen.value = false
    }
  )

  return {
    isNotificationsSlideoverOpen
  }
}

export const useDashboard = createSharedComposable(_useDashboard)
/*
By wrapping your composable with `createSharedComposable`, you change this behavior:

1. __Singleton Pattern__: The internal function (`_useDashboard`) is executed __only once__ when the first component calls `useDashboard()`.

2. __Shared State__: All components calling `useDashboard()` will share the __exact same reactive state__. If one component sets `isNotificationsSlideoverOpen.value = true`, every other component using this composable will see that change instantly.

3. __Single Side-Effects__: Logic like `defineShortcuts` and the `watch` on the route will only be registered once. Without `createSharedComposable`, calling this in 5 components would register the same keyboard shortcuts 5 times, leading to performance issues or unexpected behavior.

4. __Smart Lifecycle__: It automatically initializes the composable when the first component uses it and cleans up (stops watchers, etc.) only when the last component using it is unmounted.

### Why it's used in `useDashboard.ts`

In your specific file, it's used for several important reasons:

- __Global UI State__: The `isNotificationsSlideoverOpen` state needs to be consistent. You don't want two different components having different ideas about whether the sidebar is open.
- __Keyboard Shortcuts__: `defineShortcuts` registers global event listeners. You only want these shortcuts (`g-h`, `g-i`, etc.) registered once for the entire dashboard session.
- __Efficiency__: The `watch` on `route.fullPath` only needs one active instance to reset the sidebar state when navigating, rather than having multiple watchers doing the same thing.

Essentially, it turns your composable into a __lightweight global store__ (similar to a Pinia store) without the boilerplate of a full state management library.
*/
