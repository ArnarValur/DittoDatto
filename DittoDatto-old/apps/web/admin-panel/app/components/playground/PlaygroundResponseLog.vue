<script setup lang="ts">
/**
 * PlaygroundResponseLog — Terminal-style API response inspector
 * Logs every engine API call with timestamp, method, path, status, latency, and expandable payload.
 */

export interface LogEntry {
  id: string
  timestamp: Date
  method: string
  path: string
  status: number | null
  latencyMs: number
  request?: unknown
  response?: unknown
  error?: string
}

defineProps<{
  entries: LogEntry[]
}>()

defineEmits<{
  clear: []
}>()

const expandedId = ref<string | null>(null)

function toggle(id: string) {
  expandedId.value = expandedId.value === id ? null : id
}

function statusColor(status: number | null): string {
  if (!status) return 'text-red-400'
  if (status < 300) return 'text-emerald-400'
  if (status < 400) return 'text-yellow-400'
  return 'text-red-400'
}

function methodColor(method: string): string {
  switch (method) {
    case 'GET': return 'text-sky-400'
    case 'POST': return 'text-amber-400'
    case 'DELETE': return 'text-red-400'
    case 'PUT': return 'text-violet-400'
    default: return 'text-neutral-400'
  }
}

function formatTime(date: Date): string {
  return date.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
}
</script>

<template>
  <div class="bg-neutral-950 rounded-xl border border-neutral-800 overflow-hidden">
    <!-- Header -->
    <div class="flex items-center justify-between px-4 py-2.5 border-b border-neutral-800 bg-neutral-900/50">
      <div class="flex items-center gap-2">
        <div class="flex gap-1.5">
          <span class="size-3 rounded-full bg-red-500/80" />
          <span class="size-3 rounded-full bg-yellow-500/80" />
          <span class="size-3 rounded-full bg-green-500/80" />
        </div>
        <span class="text-xs font-mono text-neutral-400 ml-2">Response Log</span>
        <UBadge
          v-if="entries.length > 0"
          :label="String(entries.length)"
          color="neutral"
          variant="subtle"
          size="xs"
        />
      </div>
      <UButton
        v-if="entries.length > 0"
        icon="i-lucide-trash-2"
        size="xs"
        color="neutral"
        variant="ghost"
        @click="$emit('clear')"
      />
    </div>

    <!-- Log entries -->
    <div class="max-h-80 overflow-y-auto font-mono text-xs">
      <div v-if="entries.length === 0" class="px-4 py-8 text-center text-neutral-500">
        <UIcon name="i-lucide-terminal" class="size-6 mb-2 opacity-50" />
        <p>No API calls yet. Run a simulation to see responses here.</p>
      </div>

      <div
        v-for="entry in [...entries].reverse()"
        :key="entry.id"
        class="border-b border-neutral-800/50 last:border-b-0 transition-colors hover:bg-neutral-900/30"
      >
        <!-- Summary line -->
        <button
          class="w-full flex items-center gap-2 px-4 py-2 text-left cursor-pointer"
          @click="toggle(entry.id)"
        >
          <span class="text-neutral-600 shrink-0">{{ formatTime(entry.timestamp) }}</span>
          <span :class="methodColor(entry.method)" class="font-bold shrink-0 w-12">{{ entry.method }}</span>
          <span class="text-neutral-300 truncate flex-1">{{ entry.path }}</span>
          <span class="text-neutral-600 shrink-0">→</span>
          <span :class="statusColor(entry.status)" class="font-bold shrink-0 w-8">{{ entry.status || 'ERR' }}</span>
          <span class="text-neutral-600 shrink-0">{{ entry.latencyMs }}ms</span>
          <UIcon
            :name="expandedId === entry.id ? 'i-lucide-chevron-up' : 'i-lucide-chevron-down'"
            class="size-3.5 text-neutral-500 shrink-0"
          />
        </button>

        <!-- Expanded detail -->
        <Transition
          enter-active-class="transition-all duration-200 ease-out"
          enter-from-class="opacity-0 max-h-0"
          enter-to-class="opacity-100 max-h-96"
          leave-active-class="transition-all duration-150 ease-in"
          leave-from-class="opacity-100 max-h-96"
          leave-to-class="opacity-0 max-h-0"
        >
          <div v-if="expandedId === entry.id" class="px-4 pb-3 overflow-hidden">
            <!-- Error -->
            <div v-if="entry.error" class="mb-2">
              <span class="text-red-500 text-[10px] uppercase tracking-wider font-semibold">Error</span>
              <pre class="text-red-300 mt-1 whitespace-pre-wrap break-all">{{ entry.error }}</pre>
            </div>

            <!-- Request -->
            <div v-if="entry.request" class="mb-2">
              <span class="text-neutral-500 text-[10px] uppercase tracking-wider font-semibold">Request</span>
              <pre class="text-sky-300/80 mt-1 whitespace-pre-wrap break-all">{{ JSON.stringify(entry.request, null, 2) }}</pre>
            </div>

            <!-- Response -->
            <div v-if="entry.response">
              <span class="text-neutral-500 text-[10px] uppercase tracking-wider font-semibold">Response</span>
              <pre class="text-emerald-300/80 mt-1 whitespace-pre-wrap break-all">{{ JSON.stringify(entry.response, null, 2) }}</pre>
            </div>
          </div>
        </Transition>
      </div>
    </div>
  </div>
</template>
