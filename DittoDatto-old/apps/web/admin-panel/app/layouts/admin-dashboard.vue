<script setup lang="ts">
import type { NavigationMenuItem } from '@nuxt/ui'

const route = useRoute()
// const toast = useAppToast()

const open = ref(false)

const { t } = useI18n()

const { unreadCount } = useNotifications()

const links = computed(() => [[{
  label: t('nav.mainboard'),
  icon: 'i-lucide-house',
  to: '/dashboard',
  onSelect: () => {
    open.value = false
  }
}, {
  label: t('nav.inbox'),
  icon: 'i-lucide-inbox',
  to: '/inbox',
  badge: unreadCount.value > 0 ? String(unreadCount.value) : undefined,
  onSelect: () => {
    open.value = false
  },
  children: [{
    label: 'System Alerts',
    to: '/inbox/alerts',
    icon: 'i-lucide-megaphone',
    exact: true,
    onSelect: () => { open.value = false },
  }]
}, {
  label: 'Feedback',
  icon: 'i-lucide-message-square-text',
  to: '/feedback',
  onSelect: () => {
    open.value = false
  }
}, {
  label: t('nav.users'),
  icon: 'i-lucide-users',
  to: '/users',
  onSelect: () => {
    open.value = false
  },
  children: [{
    label: t('nav.user_lookup'),
    to: '/users/search',
    icon: 'i-lucide-search',
    disabled: true,
    defaultOpen: false,
    type: 'trigger',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }]
}, {
  label: t('nav.companies'),
  icon: 'i-lucide-building',
  to: '/companies',
  defaultOpen: false,
  // type: 'trigger',
  onSelect: () => {
    open.value = false
  },
  children: [{
    label: t('nav.new_company'),
    to: '/companies/create',
    icon: 'i-lucide-plus',
    defaultOpen: false,
    disabled: true,
    type: 'trigger',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }/* , {
    label: 'Onboarding',
    to: '/companies/onboarding',
    icon: 'i-lucide-list-checks',
    defaultOpen: false,
    type: 'trigger',
    exact: true,
    onSelect: () => {
      open.value = false
    },
    children: [{
      label: 'Verified',
      to: '/companies/onboarding/list',
      icon: 'i-lucide-check-circle',
      exact: true
    }, {
      label: 'Pending',
      to: '/companies/onboarding/list',
      icon: 'i-lucide-clock',
      exact: true
    }]
  }, {
    label: 'List',
    to: '/companies/onboarding/list',
    icon: 'i-lucide-list',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  } */]
}, {
  label: t('nav.stores'),
  icon: 'i-lucide-store',
  to: '/stores',
  onSelect: () => {
    open.value = false
  },
  children: [{
    label: t('nav.overview'),
    to: '/stores',
    icon: 'i-lucide-layout-list',
    exact: true
  }, {
    label: t('nav.services'),
    to: '/stores/services',
    icon: 'i-lucide-briefcase',
    exact: true
  }]
}, {
  label: t('nav.bookings'),
  icon: 'i-lucide-calendar-clock',
  to: '/bookings',
  defaultOpen: false,
  onSelect: () => {
    open.value = false
  },
  children: [{
    label: t('nav.mercury_engine'),
    to: '/bookings/mercury-engine',
    icon: 'i-lucide-flask-conical',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }]
}, {
  label: t('nav.reviews'),
  disabled: true,

  icon: 'i-lucide-star',
  to: '/reviews',
  onSelect: () => {
    open.value = false
  }
}, {
  label: t('nav.media'),
  icon: 'i-lucide-image',
  to: '/media',
  onSelect: () => {
    open.value = false
  }
}, {
  label: t('nav.restaurants'),
  disabled: true,
  to: '/restaurants',
  icon: 'lucide-lab:fork-knife-crossed',
  defaultOpen: false,
  type: 'trigger',
  children: [{
    label: t('nav.list'),
    to: '/restaurants/list',
    icon: 'i-lucide-list',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }]
}, {
  label: t('nav.events'),
  disabled: true,
  icon: 'i-lucide-calendar-clock',
  to: '/events',
  defaultOpen: false,
  type: 'trigger',
  onSelect: () => {
    open.value = false
  },
  children: [{
    label: t('nav.ticketing'),
    to: '/events/ticketing',
    icon: 'i-lucide-ticket',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }]
}, {
  label: t('settings'),
  to: '/settings',
  icon: 'i-lucide-settings',
  defaultOpen: false,
  type: 'trigger',
  children: [{
    label: t('nav.general'),
    to: '/settings',
    icon: 'i-lucide-settings',
    type: 'trigger',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }, {
    label: t('nav.categories'),
    to: '/settings/categories',
    icon: 'i-lucide-list',
    type: 'trigger',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }, {
    label: t('nav.icon_manager'),
    to: '/settings/icon-manager',
    icon: 'i-lucide-image',
    type: 'trigger',
    exact: true,
    onSelect: () => {
      open.value = false
    }
  }, {
    label: t('nav.members'),
    to: '/settings/members',
    disabled: true,
    icon: 'i-lucide-users',
    type: 'trigger',
    onSelect: () => {
      open.value = false
    }
  }, {
    label: t('nav.notifications'),
    to: '/settings/notifications',
    disabled: true,
    icon: 'i-lucide-bell',
    type: 'trigger',
    onSelect: () => {
      open.value = false
    }
  }, {
    label: t('nav.security'),
    to: '/settings/security',
    disabled: true,
    icon: 'i-lucide-shield',
    type: 'trigger',
    onSelect: () => {
      open.value = false
    }
  }]
}]]) satisfies ComputedRef<NavigationMenuItem[][]>

const groups = computed(() => [{
  id: 'links',
  label: t('nav.go_to'),
  items: links.value.flat()
}, {
  id: 'code',
  label: t('nav.code'),
  items: [{
    id: 'source',
    label: t('nav.view_page_source'),
    icon: 'i-simple-icons-github',
    to: `https://github.com/nuxt-ui-templates/dashboard/blob/main/app/pages${route.path === '/' ? '/index' : route.path}.vue`,
    target: '_blank'
  }]
}])

onMounted(async () => {
  const cookie = useCookie('cookie-consent')
  if (cookie.value === 'accepted') {
    return
  }

  // toast.add({
  //   title: 'We use first-party cookies to enhance your experience on our website.',
  //   duration: 0,
  //   close: false,
  //   actions: [{
  //     label: 'Accept',
  //     color: 'neutral',
  //     variant: 'outline',
  //     onClick: () => {
  //       cookie.value = 'accepted'
  //     }
  //   }, {
  //     label: 'Opt out',
  //     color: 'neutral',
  //     variant: 'ghost'
  //   }]
  // })
})
</script>

<template>
  <UDashboardGroup unit="rem">
    <UDashboardSidebar
      id="default"
      v-model:open="open"
      collapsible
      resizable
      class="bg-elevated"
      :ui="{ footer: 'lg:border-t lg:border-default' }"
    >
      <template #header="{ collapsed }">
        <TeamsMenu :collapsed="collapsed" />
      </template>

      <template #default="{ collapsed }">
        <UDashboardSearchButton
          :collapsed="collapsed"
          :label="t('dashboardSearchButton.label')"
          class="bg-transparent ring-default"
        />

        <UNavigationMenu
          :collapsed="collapsed"
          :items="links[0]"
          orientation="vertical"
          tooltip
          popover
        />

        <UNavigationMenu
          :collapsed="collapsed"
          :items="links[1]"
          orientation="vertical"
          tooltip
          class="mt-auto"
        />
      </template>

      <template #footer="{ collapsed }">
        <div class="flex flex-col gap-2 w-full px-2">
          <DDLanguageSelector v-if="!collapsed" />
          <UserMenu :collapsed="collapsed" />
        </div>
      </template>
    </UDashboardSidebar>

    <UDashboardSearch
      :groups="groups"
    />

    <slot />

    <NotificationsSlideover />
  </UDashboardGroup>
</template>
