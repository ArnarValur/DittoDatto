<script setup lang="ts">
/**
 * Default Layout - Public Marketplace
 *
 * Features:
 * - Sticky header with logo, search, and user menu
 * - Mobile-first bottom navigation (Home, Search, Favorites, Profile)
 * - Responsive: Bottom nav on mobile, header-only on desktop
 * - Solar theme integration (day/night/solar cycle)
 * - Language selector
 * - Solar overlay, stars, and aurora effects
 */
// Header navigation for desktop
// const headerNavItems = computed(() => [
//   { label: t('nav.discover'), to: localePath('/discover') },
//   { label: t('categories.restaurants'), to: localePath('/restaurant') },
//   { label: t('categories.services'), to: localePath('/service') },
//   { label: t('categories.venues'), to: localePath('/venue') }
// ])

// Firebase auth (must be at top-level of setup)
import { signOut } from "firebase/auth";
import { useFirebaseAuth, useFirestore, useDocument } from "vuefire";
import { doc } from "firebase/firestore";

const { t } = useI18n();
const localePath = useLocalePath();
const route = useRoute();
const user = useCurrentUser();
const { userProfile } = useAuth();

// Solar theme — drives color mode and overlay effects
const {
  themePreference,
  isActive: isSolarActive,
  solarPhase,
} = useSolarTheme();

// Breadcrumb — derive page label from route path
const breadcrumbLabel = computed(() => {
  const path = route.path
  if (path === '/' || path === '') return null
  const segment = path.split('/').filter(Boolean)[0]
  if (!segment) return null
  const labels: Record<string, string> = {
    discover: t('nav.discover', 'Utforsk'),
    profile: t('nav.profile', 'Profil'),
    contact: t('footer.contact', 'Kontakt'),
    mission: 'Misjon',
    login: t('auth.login', 'Logg inn'),
    signup: t('auth.signup', 'Registrer'),
  }
  return labels[segment] || segment
});

// Solar debug bar — reads live from Firestore settings/general
// Toggled from Admin Panel → Settings → General → Solar Debug
let settingsDoc: ReturnType<typeof useDocument<{ solarDebugEnabled?: boolean }>> | null = null
if (import.meta.client) {
  const db = useFirestore()
  settingsDoc = useDocument<{ solarDebugEnabled?: boolean }>(doc(db, 'settings', 'general'))
}

const solarDebugEnabled = computed(() => {
  return settingsDoc?.data.value?.solarDebugEnabled ?? false
})

// Notifications — unread badge count
const { unreadCount } = useNotifications();

// Mobile bottom navigation items
const bottomNavItems = computed(() => [
  {
    label: t("nav.home"),
    icon: "i-lucide-home",
    to: localePath("/"),
    active: false,
  },
  {
    label: t("nav.discover"),
    icon: "i-lucide-search",
    to: localePath("/discover"),
    active: false,
  },
  {
    label: t("nav.favorites"),
    icon: "i-lucide-heart",
    to: localePath("/profile/favorites"),
    active: false,
  },
  {
    label: t("nav.profile"),
    icon: user.value ? "i-lucide-user" : "i-lucide-log-in",
    to: user.value ? localePath("/profile") : localePath("/login"),
    active: false,
  },
]);

const auth = useFirebaseAuth();

// User menu items
const userMenuItems = computed(() => {
  if (!user.value) {
    return [
      [
        {
          label: t("auth.login"),
          icon: "i-lucide-log-in",
          to: localePath("/login"),
        },
        {
          label: t("auth.signup"),
          icon: "i-lucide-user-plus",
          to: localePath("/signup"),
        },
      ],
    ];
  }
  return [
    [
      {
        label: t("nav.profile"),
        icon: "i-lucide-user",
        to: localePath("/profile"),
      },
      {
        label: t("nav.favorites"),
        icon: "i-lucide-heart",
        to: localePath("/profile/favorites"),
      },
    ],
    [
      {
        label: t("auth.logout"),
        icon: "i-lucide-log-out",
        onSelect: (e: Event) => {
          e.preventDefault();
          handleSignOut();
        },
      },
    ],
  ];
});

async function handleSignOut() {
  console.log("Attempting to sign out...");

  if (!auth) {
    console.error("FirebaseAuth instance not found!");
    return;
  }

  try {
    await signOut(auth);
    console.log("Sign out successful");
    // Force full page reload or navigate to ensure state is cleared
    await navigateTo(localePath("/"), { external: true });
  } catch (error) {
    console.error("Sign out failed:", error);
  }
}

// Generate random star positions (client-side only)
const stars = ref<
  Array<{ id: number; x: number; y: number; size: number; delay: number }>
>([]);

onMounted(() => {
  const starCount = 60;
  stars.value = Array.from({ length: starCount }, (_, i) => ({
    id: i,
    x: Math.random() * 100,
    y: Math.random() * 100,
    size: Math.random() * 2 + 1,
    delay: Math.random() * 3,
  }));
});
</script>

<template>
  <div class="min-h-screen bg-default flex flex-col">
    <!-- Solar Theme Layers -->
    <ClientOnly>
      <!-- Warm/cool overlay for golden hour and twilight -->
      <div class="solar-overlay" />

      <!-- Star field — visible during night -->
      <div class="solar-stars-container">
        <div
          v-for="star in stars"
          :key="star.id"
          class="solar-star"
          :style="{
            left: `${star.x}%`,
            top: `${star.y}%`,
            width: `${star.size}px`,
            height: `${star.size}px`,
            background: 'white',
            animationDelay: `${star.delay}s`,
            opacity: 0.6 + Math.random() * 0.4,
          }"
        />
      </div>

      <!-- Aurora hint at the top during night -->
      <div class="solar-aurora" />

      <!-- Solar Debug Bar — dev tool for inspecting twilight transitions -->
      <CommonSolarDebugBar v-if="solarDebugEnabled" />
    </ClientOnly>

    <!-- Header -->
    <header
      class="sticky top-0 z-50 bg-default/80 backdrop-blur-lg border-b border-default"
    >
      <UContainer>
        <div class="flex items-center justify-between h-16">
          <!-- Logo + Breadcrumb -->
          <div class="flex items-center gap-2">
            <NuxtLink :to="localePath('/')" class="text-xl font-bold text-primary">
              DittoDatto
            </NuxtLink>
            <!-- Desktop breadcrumb -->
            <template v-if="breadcrumbLabel">
              <span class="hidden md:inline text-muted text-sm">—</span>
              <span class="hidden md:inline text-sm font-medium text-default">{{ breadcrumbLabel }}</span>
            </template>
          </div>

          <!-- Right Side: Theme, Language, User -->
          <div class="flex items-center gap-2">
            <!-- Language Selector -->
            <DDLanguageSelector />

            <!-- Solar Theme Toggle (Day → Night → Solar → Day) -->
            <CommonColorModeToggle />

            <!-- Notification Bell (logged-in users) -->
            <NuxtLink
              v-if="user"
              :to="localePath('/profile/messages')"
              class="relative hidden sm:flex items-center justify-center w-9 h-9 rounded-lg text-muted hover:text-primary hover:bg-elevated transition-colors"
            >
              <UIcon name="i-lucide-bell" class="size-5" />
              <span
                v-if="unreadCount > 0"
                class="absolute -top-0.5 -right-0.5 flex items-center justify-center min-w-[18px] h-[18px] px-1 rounded-full bg-primary-500 text-white text-[10px] font-bold leading-none"
              >
                {{ unreadCount > 9 ? '9+' : unreadCount }}
              </span>
            </NuxtLink>

            <!-- Guest: Login/Signup -->
            <ClientOnly>
              <template v-if="!user">
                <UButton
                  :to="localePath('/login')"
                  variant="ghost"
                  color="neutral"
                  class="hidden sm:flex"
                >
                  {{ t("auth.login") }}
                </UButton>
                <UButton
                  :to="localePath('/signup')"
                  color="primary"
                  class="font-semibold"
                >
                  {{ t("auth.signup") }}
                </UButton>
              </template>

              <!-- Logged In: Avatar Dropdown -->
              <UDropdownMenu v-else :items="userMenuItems">
                <UButton variant="ghost" color="neutral">
                  <UAvatar
                    :src="userProfile?.photoUrl || user.photoURL || undefined"
                    :alt="userProfile?.name || user.displayName || 'User'"
                    size="sm"
                  />
                </UButton>
              </UDropdownMenu>
            </ClientOnly>
          </div>
        </div>
      </UContainer>
    </header>

    <!-- Main Content -->
    <main class="flex-1 pb-20 md:pb-0 relative z-2">
      <slot />
    </main>

    <!-- Mobile Bottom Navigation -->
    <nav
      class="fixed bottom-0 left-0 right-0 z-50 md:hidden bg-default/95 backdrop-blur-lg border-t border-default safe-area-bottom"
    >
      <div class="flex items-center justify-around h-16">
        <NuxtLink
          v-for="item in bottomNavItems"
          :key="item.to"
          :to="item.to"
          class="flex flex-col items-center justify-center flex-1 py-2 text-muted hover:text-primary transition-colors"
          active-class="text-primary"
        >
          <UIcon :name="item.icon" class="size-6 mb-1" />
          <span class="text-xs font-medium">{{ item.label }}</span>
        </NuxtLink>
      </div>
    </nav>

    <!-- Footer (Desktop Only) -->
    <footer
      class="hidden md:block border-t border-default bg-muted/30 py-8 mt-auto relative z-2"
    >
      <UContainer>
        <div class="flex flex-col items-center gap-4">
          <!-- Brand + Links -->
          <div class="flex items-center gap-6 text-sm">
            <NuxtLink :to="localePath('/')" class="font-bold text-primary">
              DittoDatto
            </NuxtLink>
            <span class="text-muted/40">·</span>
            <NuxtLink :to="localePath('/contact')" class="text-muted hover:text-primary transition-colors">
              {{ t('footer.contact', 'Kontakt') }}
            </NuxtLink>
            <span class="text-muted/40">·</span>
            <NuxtLink :to="localePath('/discover')" class="text-muted hover:text-primary transition-colors">
              {{ t('nav.discover', 'Utforsk') }}
            </NuxtLink>
            
            <span class="text-muted/40">·</span>
            <NuxtLink :to="localePath('/vision')" class="text-muted hover:text-primary transition-colors">
              {{ t('footer.vision', 'Vision') }}
            </NuxtLink>
          </div>
          

          <!-- Copyright -->
          <p class="text-xs text-muted/60">
            {{ t('footer.copyright', { year: new Date().getFullYear() }) }}
          </p>
        </div>
      </UContainer>
    </footer>
  </div>
</template>

<style scoped>
/* Safe area for iOS bottom bar */
.safe-area-bottom {
  padding-bottom: env(safe-area-inset-bottom, 0);
}
</style>
