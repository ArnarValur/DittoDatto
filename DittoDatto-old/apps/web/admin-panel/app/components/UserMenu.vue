<script setup lang="ts">
import type { DropdownMenuItem } from '@nuxt/ui'
import { useFirebaseAuth, useCurrentUser } from 'vuefire'

defineProps<{
  collapsed?: boolean
}>()

const colorMode = useColorMode()
const appConfig = useAppConfig()
const { t } = useI18n()

const colors = ['red', 'orange', 'amber', 'yellow', 'lime', 'green', 'emerald', 'teal', 'cyan', 'sky', 'blue', 'indigo', 'violet', 'purple', 'fuchsia', 'pink', 'rose']
const neutrals = ['slate', 'gray', 'zinc', 'neutral', 'stone']

// Real Auth User
const currentUser = useCurrentUser()

const user = computed(() => {
  const u = currentUser.value
  return {
    name: u?.displayName || u?.email?.split('@')[0] || 'User',
    avatar: {
      src: u?.photoURL || '',
      alt: u?.displayName || 'User'
    }
  }
})

const items = computed<DropdownMenuItem[][]>(() => ([[{
  type: 'label',
  label: user.value.name,
  avatar: user.value.avatar
}], [{
  label: t('user_menu.profile'),
  icon: 'i-lucide-user'
}, {
  label: t('user_menu.settings'),
  icon: 'i-lucide-settings',
  to: '/settings'
}], [{
  label: t('user_menu.theme'),
  icon: 'i-lucide-palette',
  children: [{
    label: t('user_menu.primary'),
    slot: 'chip',
    chip: appConfig.ui.colors.primary,
    content: {
      align: 'center',
      collisionPadding: 16
    },
    children: colors.map(color => ({
      label: color,
      chip: color,
      slot: 'chip',
      checked: appConfig.ui.colors.primary === color,
      type: 'checkbox',
      onSelect: (e) => {
        e.preventDefault()

        appConfig.ui.colors.primary = color
      }
    }))
  }, {
    label: t('user_menu.neutral'),
    slot: 'chip',
    chip: appConfig.ui.colors.neutral === 'neutral' ? 'old-neutral' : appConfig.ui.colors.neutral,
    content: {
      align: 'end',
      collisionPadding: 16
    },
    children: neutrals.map(color => ({
      label: color,
      chip: color === 'neutral' ? 'old-neutral' : color,
      slot: 'chip',
      type: 'checkbox',
      checked: appConfig.ui.colors.neutral === color,
      onSelect: (e) => {
        e.preventDefault()

        appConfig.ui.colors.neutral = color
      }
    }))
  }]
}, {
  label: t('user_menu.appearance'),
  icon: 'i-lucide-sun-moon',
  children: [{
    label: t('user_menu.light'),
    icon: 'i-lucide-sun',
    type: 'checkbox',
    checked: colorMode.value === 'light',
    onSelect(e: Event) {
      e.preventDefault()

      colorMode.preference = 'light'
    }
  }, {
    label: t('user_menu.dark'),
    icon: 'i-lucide-moon',
    type: 'checkbox',
    checked: colorMode.value === 'dark',
    onUpdateChecked(checked: boolean) {
      if (checked) {
        colorMode.preference = 'dark'
      }
    },
    onSelect(e: Event) {
      e.preventDefault()
    }
  }]
}], [{
  label: t('user_menu.templates'),
  icon: 'i-lucide-layout-template',
  children: [{
    label: t('user_menu.starter'),
    to: 'https://starter-template.nuxt.dev/'
  }, {
    label: t('user_menu.landing'),
    to: 'https://landing-template.nuxt.dev/'
  }, {
    label: t('user_menu.docs'),
    to: 'https://docs-template.nuxt.dev/'
  }, {
    label: t('user_menu.saas'),
    to: 'https://saas-template.nuxt.dev/'
  }, {
    label: t('user_menu.dashboard'),
    to: 'https://dashboard-template.nuxt.dev/',
    color: 'primary',
    checked: true,
    type: 'checkbox'
  }, {
    label: t('user_menu.chat'),
    to: 'https://chat-template.nuxt.dev/'
  }, {
    label: t('user_menu.portfolio'),
    to: 'https://portfolio-template.nuxt.dev/'
  }, {
    label: t('user_menu.changelog'),
    to: 'https://changelog-template.nuxt.dev/'
  }]
}], [{
  label: t('user_menu.documentation'),
  icon: 'i-lucide-book-open',
  to: 'https://ui.nuxt.com/docs/getting-started/installation/nuxt',
  target: '_blank'
}, {
  label: t('user_menu.github_repo'),
  icon: 'i-simple-icons-github',
  to: 'https://github.com/Merkurial-Studio/dittodatto',
  target: '_blank'
}, {
  label: t('user_menu.logout'),
  icon: 'i-lucide-log-out',
  onSelect: async () => {
    // 1. Sign out from Firebase
    const auth = useFirebaseAuth()
    if (auth) await auth.signOut()

    // 2. Navigate to login with logout flag (prevents middleware redirect loop)
    await navigateTo('/?logout=true', { replace: true, external: true })
  }
}]]))
</script>

<template>
  <UDropdownMenu
    :items="items"
    :content="{ align: 'center', collisionPadding: 12 }"
    :ui="{ content: collapsed ? 'w-48' : 'w-(--reka-dropdown-menu-trigger-width)' }"
  >
    <UButton
      v-bind="{
        ...user,
        label: collapsed ? undefined : user?.name,
        trailingIcon: collapsed ? undefined : 'i-lucide-chevrons-up-down'
      }"
      color="neutral"
      variant="ghost"
      block
      :square="collapsed"
      class="data-[state=open]:bg-elevated"
      :ui="{
        trailingIcon: 'text-dimmed'
      }"
    />

    <template #chip-leading="{ item }">
      <div class="inline-flex items-center justify-center shrink-0 size-5">
        <span
          class="rounded-full ring ring-bg bg-(--chip-light) dark:bg-(--chip-dark) size-2"
          :style="{
            '--chip-light': `var(--color-${(item as any).chip}-500)`,
            '--chip-dark': `var(--color-${(item as any).chip}-400)`
          }"
        />
      </div>
    </template>
  </UDropdownMenu>
</template>
