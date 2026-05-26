<script setup lang="ts">
definePageMeta({
  middleware: "auth",
});

const { user, userProfile } = useAuth();
const { unreadCount } = useNotifications();
const route = useRoute();
const router = useRouter();
const { t } = useI18n();

const navigationItems = computed(() => [
  {
    label: t('profile.nav.overview'),
    icon: "i-lucide-layout-dashboard",
    to: "/profile",
  },
  {
    label: t('profile.nav.bookings'),
    icon: "i-lucide-calendar",
    to: "/profile/bookings",
  },
  {
    label: t('profile.nav.notifications'),
    icon: "i-lucide-bell",
    to: "/profile/messages",
    badge: true,
  },
  {
    label: t('profile.nav.favorites'),
    icon: "i-lucide-heart",
    to: "/profile/favorites",
  },
]);

const isActiveRoute = (path: string) => {
  if (path === "/profile") {
    return route.path === "/profile";
  }
  return route.path.startsWith(path);
};

const activeItem = computed(() => {
  return (
    navigationItems.value.find((item) => isActiveRoute(item.to)) || navigationItems.value[0]
  );
});

const mobileMenuOpen = ref(false);

const navigateTo = (to: string) => {
  router.push(to);
  mobileMenuOpen.value = false;
};
</script>

<template>
  <div class="min-h-screen">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Profile Header -->
      <div class="mb-8">
        <div class="flex items-center gap-4">
          <UAvatar
            :src="userProfile?.photoUrl || user?.photoURL || undefined"
            :alt="userProfile?.name || user?.displayName || 'User'"
            size="xl"
            class="ring-4 ring-white dark:ring-gray-900 shadow-lg"
          />
          <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
              {{ userProfile?.name || user?.displayName || "Welcome" }}
            </h1>
            <p class="text-gray-500 dark:text-gray-400">
              {{ user?.email }}
            </p>
          </div>
        </div>
      </div>

      <div class="flex flex-col md:flex-row gap-8">
        <!-- Sidebar Navigation (tablet + desktop) -->
        <aside class="hidden md:block w-56 lg:w-64 shrink-0">
          <nav class="sticky top-20 space-y-1">
            <NuxtLink
              v-for="item in navigationItems"
              :key="item.to"
              :to="item.to"
              class="flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-colors"
              :class="[
                isActiveRoute(item.to)
                  ? 'bg-primary-50 dark:bg-primary-950 text-primary-600 dark:text-primary-400'
                  : 'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-900 hover:text-gray-900 dark:hover:text-white',
              ]"
            >
              <UIcon :name="item.icon" class="w-5 h-5" />
              {{ item.label }}
              <span
                v-if="item.badge && unreadCount > 0"
                class="ml-auto flex items-center justify-center min-w-[20px] h-5 px-1.5 rounded-full bg-primary-500 text-white text-[11px] font-bold leading-none"
              >
                {{ unreadCount > 9 ? '9+' : unreadCount }}
              </span>
            </NuxtLink>
          </nav>
        </aside>

        <!-- Mobile Section Selector (phone only) -->
        <div class="md:hidden">
          <button
            class="w-full flex items-center justify-between gap-3 px-4 py-3 rounded-xl bg-elevated border border-default text-sm font-medium transition-colors"
            @click="mobileMenuOpen = !mobileMenuOpen"
          >
            <span class="flex items-center gap-3">
              <UIcon :name="activeItem.icon" class="w-5 h-5 text-primary" />
              <span class="text-gray-900 dark:text-white">{{
                activeItem.label
              }}</span>
            </span>
            <UIcon
              name="i-lucide-chevron-down"
              class="w-4 h-4 text-gray-400 transition-transform duration-200"
              :class="{ 'rotate-180': mobileMenuOpen }"
            />
          </button>

          <!-- Expandable menu -->
          <Transition
            enter-active-class="transition-all duration-200 ease-out"
            enter-from-class="opacity-0 -translate-y-2 max-h-0"
            enter-to-class="opacity-100 translate-y-0 max-h-96"
            leave-active-class="transition-all duration-150 ease-in"
            leave-from-class="opacity-100 translate-y-0 max-h-96"
            leave-to-class="opacity-0 -translate-y-2 max-h-0"
          >
            <nav
              v-show="mobileMenuOpen"
              class="mt-2 rounded-xl bg-elevated border border-default overflow-hidden"
            >
              <button
                v-for="item in navigationItems"
                :key="item.to"
                class="w-full flex items-center gap-3 px-4 py-3 text-sm font-medium transition-colors"
                :class="[
                  isActiveRoute(item.to)
                    ? 'bg-primary-50 dark:bg-primary-950 text-primary-600 dark:text-primary-400'
                    : 'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-900',
                ]"
                @click="navigateTo(item.to)"
              >
                <UIcon :name="item.icon" class="w-5 h-5" />
                {{ item.label }}
              </button>
            </nav>
          </Transition>
        </div>

        <!-- Main Content -->
        <main class="flex-1 min-w-0">
          <NuxtPage />
        </main>
      </div>
    </div>
  </div>
</template>
