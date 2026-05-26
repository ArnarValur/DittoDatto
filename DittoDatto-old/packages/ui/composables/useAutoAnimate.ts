/**
 * useAutoAnimate Composable
 * Re-exports @formkit/auto-animate for Vue 3 / Nuxt 4
 * 
 * Usage:
 * ```vue
 * <script setup>
 * const [parent] = useAutoAnimate()
 * </script>
 * 
 * <template>
 *   <ul ref="parent">
 *     <li v-for="item in items">{{ item }}</li>
 *   </ul>
 * </template>
 * ```
 */
export { useAutoAnimate } from '@formkit/auto-animate/vue'
