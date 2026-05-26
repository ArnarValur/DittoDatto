<script setup lang="ts">
import { h } from 'vue' // Required for your render functions
import type { TableColumn } from '@nuxt/ui'
import type { Row } from '@tanstack/table-core'
import type { FirebaseUser } from '@dittodatto/shared-types'
import { UCheckbox, UAvatar, UButton, UBadge, UDropdownMenu } from '#components' // Explicit import for use in h()
import UserFormSlidedover from '~/components/users/UserFormSlidedover.vue'
import { getApp } from 'firebase/app'
import { getFunctions, httpsCallable } from 'firebase/functions'

// 1. Data Composable
// We alias 'selectedItem' to 'selectedUser' so your existing code works
const {
  search, page, pageCount, isFormOpen,
  selectedItem: selectedUser, // Aliased to match your code
  rows, total, isLoading, refresh, handleCreate
} = useDataTable<FirebaseUser>('/api/users/users')

definePageMeta({
  layout: 'admin-dashboard'
})

async function handleDelete(user: FirebaseUser) {
  // TODO: Replace with Nuxt UI modal - native confirm() is blocked in dropdown context
  // if (!confirm(`Are you sure you want to delete ${user.displayName || user.email}?`)) return

  try {
    await $fetch('/api/users/users', {
      method: 'DELETE',
      body: { uid: user.uid }
    })

    useToast().add({ title: 'Deleted', description: 'User deleted successfully.', color: 'success' })
    refresh()
  } catch (error: any) {
    useToast().add({ title: 'Error', description: error.message || 'Failed to delete', color: 'error' })
  }
}

async function handlePromote(user: FirebaseUser) {
  if (!confirm(`Promote ${user.email} to Business Owner? This will modify their claims.`)) return

  const toast = useToast()
  try {
    const functions = getFunctions(getApp(), 'europe-west1')
    const updateUserRole = httpsCallable(functions, 'admin_updateUserRole')

    await updateUserRole({ userId: user.uid, role: 'business' })

    toast.add({ title: 'Promoted', description: 'User is now a Business Owner.', color: 'success' })
    refresh()
  } catch (error: any) {
    console.error(error)
    toast.add({ title: 'Promotion Failed', description: error.message || 'Unknown error', color: 'error' })
  }
}

// 2. YOUR EXACT Row Items Function
function getRowItems(row: Row<FirebaseUser>) {
  const items = [
    { type: 'label', label: 'Actions' },
    {
      label: 'Copy user ID',
      icon: 'i-lucide-copy',
      onSelect() {
        navigator.clipboard.writeText(row.original.uid)
        useToast().add({ title: 'Copied', description: 'ID copied.' })
      }
    },
    { type: 'separator' }
  ]

  // Only show promotion if not already business/admin
  if (row.original.role !== 'business' && row.original.role !== 'admin' && row.original.role !== 'super_admin') {
    items.push({
      label: 'Promote to Business',
      icon: 'i-lucide-briefcase',
      onSelect: () => handlePromote(row.original)
    })
  }

  items.push(
    {
      label: 'View Overview',
      icon: 'i-lucide-file-user',
      disabled: true,
      onSelect: () => navigateTo(`/users/${row.original.uid}`)
    },
    {
      label: 'Edit user',
      icon: 'i-lucide-pencil',
      onSelect: () => {
        selectedUser.value = row.original
        isFormOpen.value = true
      }
    },
    { type: 'separator' },
    {
      label: 'Delete user',
      icon: 'i-lucide-trash-2',
      class: 'text-red-500 hover:text-red-600',
      onSelect: () => handleDelete(row.original)
    }
  )

  return items
}

// 3. YOUR EXACT Column Definitions
const columns: TableColumn<FirebaseUser>[] = [
  {
    id: 'select',
    header: ({ table }) =>
      h(UCheckbox, {
        'modelValue': table.getIsSomePageRowsSelected() ? 'indeterminate' : table.getIsAllPageRowsSelected(),
        'onUpdate:modelValue': (value: boolean | 'indeterminate') => table.toggleAllPageRowsSelected(!!value),
        'ariaLabel': 'Select all'
      }),
    cell: ({ row }) =>
      h(UCheckbox, {
        'modelValue': row.getIsSelected(),
        'onUpdate:modelValue': (value: boolean | 'indeterminate') => row.toggleSelected(!!value),
        'ariaLabel': 'Select row'
      })
  },
  {
    accessorKey: 'uid',
    header: 'ID',
    cell: ({ row }) => h('span', { class: 'font-mono text-xs' }, row.original.uid.substring(0, 8) + '...')
  },
  {
    accessorKey: 'displayName',
    header: 'Name',
    cell: ({ row }) => {
      // Fallback to email if display name is missing
      const name = row.original.displayName || 'No Name'
      const email = row.original.email

      return h('div', { class: 'flex items-center gap-3' }, [
        h(UAvatar, {
          src: row.original.photoURL || undefined,
          alt: name,
          size: 'lg'
        }),
        h('div', undefined, [
          h('p', { class: 'font-medium text-highlighted' }, name),
          h('p', { class: 'text-muted text-xs' }, email)
        ])
      ])
    }
  },
  {
    accessorKey: 'email',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButton, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Email',
        icon: isSorted ? (isSorted === 'asc' ? 'i-lucide-arrow-up-narrow-wide' : 'i-lucide-arrow-down-wide-narrow') : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    }
  },
  {
    accessorKey: 'companyId',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButton, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Company',
        icon: isSorted ? (isSorted === 'asc' ? 'i-lucide-arrow-up-narrow-wide' : 'i-lucide-arrow-down-wide-narrow') : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    }
  },
  {
    accessorKey: 'role',
    header: 'Role',
    filterFn: 'equals',
    cell: ({ row }) => {
      const colour = {
        admin: 'warning' as const,
        business: 'secondary' as const,
        customer: 'primary' as const,
        super_admin: 'error' as const
      }[row.original.role as string] || 'neutral'

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color: colour }, () => row.original.role || 'user')
    }
  },
  {
    id: 'actions',
    cell: ({ row }) => {
      return h('div', { class: 'text-right' },
        h(UDropdownMenu as Component, {
          items: getRowItems(row)
        }, {
          default: ({ open: _open }: { open: boolean }) => h(UButton, {
            icon: 'i-lucide-ellipsis-vertical',
            color: 'neutral',
            variant: 'ghost',
            class: 'ml-auto'
          })
        }
        )
      )
    }
  }
]
</script>

<template>
  <!-- eslint-disable vue/no-multiple-template-root -->
  <UDashboardPanel id="users">
    <!-- 1. Use UDashboardNavbar within the #header slot -->
    <template #header>
      <UDashboardNavbar>
        <!-- RESTORED: Sidebar Collapse Button -->
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Users
          </div>
        </template>

        <!-- Search and Add User moved to #right slot -->
        <template #right>
          <div class="flex gap-3">
            <UInput
              v-model="search"
              icon="i-lucide-search"
              placeholder="Search users..."
              class="w-64"
            />
            <UButton
              icon="i-lucide-plus"
              label="Add User"
              color="neutral"
              @click="handleCreate"
            />
          </div>
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <!-- Table content goes in default slot or #body (if using group) -->
      <UTable
        :columns="columns"
        :data="rows"
        :loading="isLoading"
        class="flex-1 border border-gray-200 dark:border-gray-800 "
        :ui="{
          base: 'table-fixed border-separate border-spacing-0',
          thead: '[&>tr]:bg-elevated/50 [&>tr]:after:content-none',
          tbody: '[&>tr]:last:[&>td]:border-b-0',
          th: '',
          td: 'border-b border-default',
          separator: 'h-0'
          // wrapper: 'border-b border-gray-200 dark:border-gray-800',
          // th: { padding: 'py-3.5 pl-4 pr-3', color: 'text-gray-900 dark:text-white font-semibold' },
          // td: { padding: 'py-4 pl-4 pr-3' }
        }"
      >
        <template #empty>
          <div class="flex flex-col items-center justify-center py-12 gap-3">
            <UIcon
              name="i-lucide-database"
              class="w-12 h-12 text-gray-400"
            />
            <span class="text-gray-500">No users found</span>
          </div>
        </template>
      </UTable>

      <!-- Footer -->
    </template>

    <template #footer>
      <div class="flex items-center justify-between px-4 py-3 border-t border-gray-200 dark:border-gray-800">
        <div class="text-sm text-gray-500">
          {{ total }} results
        </div>

        <!--
        -- TODO: Fix UPagination
        -->

        <UPagination
          v-model:page="page"
          :items-per-page="pageCount"
          :total="total"
        />
      </div>
    </template>
  </UDashboardPanel>

  <UserFormSlidedover
    v-if="isFormOpen"
    v-model:open="isFormOpen"
    :user="selectedUser"
    @saved="refresh"
  />
</template>
