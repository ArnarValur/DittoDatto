<script setup lang="ts">
import { h } from 'vue'
import type { TableColumn } from '@nuxt/ui'
import type { Row } from '@tanstack/table-core'
import type { MediaItem, Company } from '@dittodatto/shared-types'
import { UBadge, UButton, UDropdownMenu } from '#components'
import { collection, query, where, orderBy } from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'

definePageMeta({ layout: 'admin-dashboard' })

const db = useFirestore()
const toast = useToast()
const { state: uploadState, uploadFile, deleteMedia } = useMediaUpload()

// Company Filter State
const selectedCompany = ref<{ id: string, label: string } | undefined>(undefined)

// Fetch companies for the dropdown
const { data: companiesData } = await useFetch<{ companies: Company[] }>('/api/companies/companies', {
  lazy: true,
  default: () => ({ companies: [] })
})

const companyOptions = computed(() => companiesData.value.companies.map(c => ({
  id: c.id,
  label: c.name
})))

// Firestore query for media - filtered by company
const mediaQuery = computed(() => {
  if (selectedCompany.value) {
    return query(
      collection(db, 'media'),
      where('companyId', '==', selectedCompany.value.id),
      orderBy('createdAt', 'desc')
    )
  }
  // No filter - show all (for super admin)
  return query(collection(db, 'media'), orderBy('createdAt', 'desc'))
})

const mediaItems = useCollection<MediaItem>(mediaQuery)
const isLoading = computed(() => mediaItems.pending.value)

// File input reference
const fileInput = ref<HTMLInputElement | null>(null)

function triggerUpload() {
  if (!selectedCompany.value) {
    toast.add({ title: 'Select a company', description: 'Please select a company before uploading.', color: 'warning' })
    return
  }
  fileInput.value?.click()
}

async function handleFileSelect(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file || !selectedCompany.value) return

  const result = await uploadFile(file, {
    companyId: selectedCompany.value.id,
    type: 'general'
  })

  if (result) {
    toast.add({ title: 'Uploaded', description: `${file.name} uploaded successfully.`, color: 'success' })
  } else if (uploadState.error) {
    toast.add({ title: 'Upload Failed', description: uploadState.error, color: 'error' })
  }

  // Reset file input
  target.value = ''
}

async function handleDelete(item: MediaItem) {
  if (!confirm(`Delete "${item.filename}"? This cannot be undone.`)) return

  const success = await deleteMedia(item)
  if (success) {
    toast.add({ title: 'Deleted', description: 'Media file deleted.', color: 'success' })
  } else {
    toast.add({ title: 'Error', description: 'Failed to delete media.', color: 'error' })
  }
}

function formatBytes(bytes: number): string {
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB'
}

function getRowItems(row: Row<MediaItem>) {
  return [
    { type: 'label', label: 'Actions' },
    {
      label: 'Copy URL',
      icon: 'i-lucide-link',
      onSelect() {
        navigator.clipboard.writeText(row.original.url)
        toast.add({ title: 'Copied', description: 'URL copied to clipboard.' })
      }
    },
    {
      label: 'Open in new tab',
      icon: 'i-lucide-external-link',
      onSelect() {
        window.open(row.original.url, '_blank')
      }
    },
    { type: 'separator' },
    {
      label: 'Delete',
      icon: 'i-lucide-trash-2',
      class: 'text-red-500 hover:text-red-600',
      onSelect: () => handleDelete(row.original)
    }
  ]
}

const columns: TableColumn<MediaItem>[] = [
  {
    id: 'preview',
    header: 'Preview',
    cell: ({ row }) => h('img', {
      src: row.original.url,
      alt: row.original.filename,
      class: 'w-12 h-12 object-cover rounded'
    })
  },
  {
    accessorKey: 'filename',
    header: 'Filename'
  },
  {
    accessorKey: 'type',
    header: 'Type',
    cell: ({ row }) => h(UBadge, {
      color: 'neutral',
      variant: 'subtle'
    }, () => row.original.type)
  },
  {
    accessorKey: 'size',
    header: 'Size',
    cell: ({ row }) => formatBytes(row.original.size)
  },
  {
    id: 'actions',
    cell: ({ row }) => {
      return h('div', { class: 'text-right' },
        h(UDropdownMenu as any, {
          items: getRowItems(row)
        }, {
          default: () => h(UButton, {
            icon: 'i-lucide-ellipsis-vertical',
            color: 'neutral',
            variant: 'ghost',
            class: 'ml-auto'
          })
        })
      )
    }
  }
]
</script>

<template>
  <UDashboardPanel id="media">
    <template #header>
      <UDashboardNavbar title="Media Gallery">
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Media Gallery
          </div>
        </template>

        <template #right>
          <div class="flex gap-2 min-w-0">
            <USelectMenu
              v-model="selectedCompany"
              :items="companyOptions"
              searchable
              searchable-placeholder="Search company..."
              placeholder="All Companies"
              icon="i-lucide-building-2"
              class="w-48 lg:w-64"
              option-attribute="label"
            />
          </div>
          <div class="flex gap-3">
            <UButton
              icon="i-lucide-upload"
              label="Upload"
              color="neutral"
              :loading="uploadState.isUploading"
              @click="triggerUpload"
            />
          </div>
          <!-- Hidden file input -->
          <input
            ref="fileInput"
            type="file"
            accept="image/*"
            class="hidden"
            @change="handleFileSelect"
          >
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <!-- Upload progress bar -->
      <div
        v-if="uploadState.isUploading"
        class="px-4 py-2 bg-blue-50 dark:bg-blue-950"
      >
        <div class="flex items-center gap-3">
          <span class="text-sm text-blue-600 dark:text-blue-400">Uploading...</span>
          <div class="flex-1 bg-blue-200 dark:bg-blue-800 rounded-full h-2">
            <div
              class="bg-blue-600 h-2 rounded-full transition-all"
              :style="{ width: `${uploadState.progress}%` }"
            />
          </div>
          <span class="text-sm text-blue-600 dark:text-blue-400">{{ uploadState.progress }}%</span>
        </div>
      </div>

      <UTable
        :columns="columns"
        :data="mediaItems ?? []"
        :loading="isLoading"
        class="flex-1 border border-gray-200 dark:border-gray-800"
        :ui="{
          base: 'table-fixed border-separate border-spacing-0',
          thead: '[&>tr]:bg-elevated/50 [&>tr]:after:content-none',
          tbody: '[&>tr]:last:[&>td]:border-b-0',
          th: '',
          td: 'border-b border-default',
          separator: 'h-0'
        }"
      >
        <template #empty>
          <div class="flex flex-col items-center justify-center py-12 gap-3">
            <UIcon
              name="i-lucide-image"
              class="w-12 h-12 text-gray-400"
            />
            <span class="text-gray-500">
              {{ selectedCompany ? 'No media found for this company' : 'Select a company to view media' }}
            </span>
          </div>
        </template>
      </UTable>
    </template>

    <template #footer>
      <div class="flex items-center justify-between px-4 py-3 border-t border-gray-200 dark:border-gray-800">
        <div class="text-sm text-gray-500">
          {{ mediaItems?.length ?? 0 }} items
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
