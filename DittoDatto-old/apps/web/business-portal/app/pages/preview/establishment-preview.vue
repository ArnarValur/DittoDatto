<script setup lang="ts">
import { mockRestaurant } from '../../data/mockRestaurant'

/**
 * Establishment Preview Page
 * Composes shared UI components to demo the restaurant page.
 */

definePageMeta({
  layout: 'visual-preview'
})

// State
const bookingOpen = ref(false)
const activeTab = ref(0)

const tabs = [
  { label: 'Experiences' },
  { label: 'About Us' }
]

function handleBook() {
  bookingOpen.value = true
}
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 pb-32">
    <!-- 1. Hero Gallery -->
    <DDEstablishmentImageGallery
      :images="mockRestaurant.images"
    />

    <!-- 2. Info Bar -->
    <DDEstablishmentInfoBar
      :name="mockRestaurant.name"
      :logo="mockRestaurant.logo"
      :address="mockRestaurant.address"
      :city="mockRestaurant.city"
      :rating="mockRestaurant.rating"
      :review-count="mockRestaurant.reviewCount"
      :hours-display="mockRestaurant.hoursDisplay"
      @book="handleBook"
      @favorite="console.log('Fav')"
      @more="console.log('More')"
    />

    <!-- 3. Tabs Navigation -->
    <div class="border-b border-default">
      <div class="flex gap-8">
        <button
          v-for="(tab, index) in tabs"
          :key="index"
          class="pb-4 text-sm font-semibold border-b-2 transition-colors duration-200"
          :class="[
            activeTab === index
              ? 'border-primary text-primary'
              : 'border-transparent text-muted hover:text-default'
          ]"
          @click="activeTab = index"
        >
          {{ tab.label }}
        </button>
      </div>
    </div>

    <!-- 4. Tab Content -->
    <div class="min-h-[400px]">
      <!-- Experiences Tab -->
      <div v-if="activeTab === 0" class="animate-fade-in">
        <h2 class="text-xl font-bold mb-6">
          Experiences
        </h2>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <DDEstablishmentExperienceCard
            v-for="exp in mockRestaurant.experiences"
            :key="exp.id"
            v-bind="exp"
            @click="handleBook"
          />
        </div>
      </div>

      <!-- About Tab -->
      <div v-else class="animate-fade-in">
        <h2 class="text-xl font-bold mb-6">
          About Us
        </h2>
        <DDEstablishmentAboutSection
          :description="mockRestaurant.description"
          :address="mockRestaurant.address"
          :city="mockRestaurant.city"
          :map-image="mockRestaurant.mapImage"
        />
      </div>
    </div>

    <!-- Booking Modal -->
    <DDBookingModal
      v-model:open="bookingOpen"
      :store-name="mockRestaurant.name"
      :store-address="mockRestaurant.address"
      :store-logo="mockRestaurant.logo"
      :services="[]"
    />
  </div>
</template>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.4s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
