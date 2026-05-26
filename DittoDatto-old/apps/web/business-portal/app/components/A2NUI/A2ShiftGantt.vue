<script setup lang="ts">
/**
 * A2ShiftGantt — Reactive Mermaid.js Gantt chart for shift planning.
 *
 * Architecture: a2nui-gantt-shift-planner.md
 * Two paths feed this renderer:
 *   1. A2NUI Recipe: Hermes/Datto generates mermaid syntax conversationally
 *   2. Data-Driven: Firestore onSnapshot → shiftsToGantt() → mermaid string
 *
 * This component is stateless. The parent handles data sourcing.
 */
import { ref, computed, watch, onMounted, nextTick, onBeforeUnmount } from 'vue'

// ── Color mode ─────────────────────────────────────
const colorMode = useColorMode()
const isDark = computed(() => colorMode.value === 'dark')

// ── Types ──────────────────────────────────────────
interface Shift {
  id?: string
  staffId?: string
  staffName: string
  storeId?: string
  date: string           // "YYYY-MM-DD"
  startTime: string      // "HH:MM"
  endTime: string        // "HH:MM"
  breakMinutes?: number
  label?: string         // "Morning", "Closing", etc.
  status: 'scheduled' | 'confirmed' | 'swapRequested' | 'cancelled'
  updatedBy?: string
}

const props = defineProps<{
  shifts: Shift[]
  weekStart?: string     // ISO date string for the week start
  title?: string
  companyId?: string
}>()

const emit = defineEmits<{
  (e: 'shift-click', shift: { staffName: string, date: string, label: string }): void
}>()

// ── Mermaid rendering state ────────────────────────
const svgContent = ref('')
const renderError = ref('')
const renderId = ref('')

// ── Tooltip state ──────────────────────────────────
const tooltip = ref<{ visible: boolean, x: number, y: number, staffName: string, time: string, status: string, label: string }>({
  visible: false, x: 0, y: 0, staffName: '', time: '', status: '', label: ''
})
const chartRef = ref<HTMLElement | null>(null)

// ── Expand / lightbox state ────────────────────────
const expanded = ref(false)
const modalUi = { content: 'max-w-[95vw]' }

// ── shiftsToGantt() — deterministic template function ──
function formatWeekDate(date?: string): string {
  if (!date) {
    const now = new Date()
    return now.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
  }
  return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

function shiftsToGantt(shifts: Shift[], weekStart?: string): string {
  const titleText = props.title || `Staff Schedule — Week of ${formatWeekDate(weekStart)}`

  const lines = [
    'gantt',
    `  title ${titleText}`,
    '  dateFormat YYYY-MM-DDTHH:mm',
    '  axisFormat %H:%M'
  ]

  // Group shifts by staff name
  const byStaff: Record<string, Shift[]> = {}
  for (const shift of shifts) {
    if (!byStaff[shift.staffName]) byStaff[shift.staffName] = []
    byStaff[shift.staffName]!.push(shift)
  }

  // Sort staff alphabetically, then shifts by date within each staff
  const staffNames = Object.keys(byStaff).sort()

  for (const name of staffNames) {
    lines.push(`  section ${name}`)

    const staffShifts = (byStaff[name] ?? []).sort((a, b) => {
      const da = `${a.date}T${a.startTime}`
      const db = `${b.date}T${b.startTime}`
      return da.localeCompare(db)
    })

    for (const shift of staffShifts) {
      // Map status to mermaid task states
      const statusTag = shift.status === 'confirmed' ? 'active, '
        : shift.status === 'cancelled' ? 'done, '
        : shift.status === 'swapRequested' ? 'crit, '
        : ''

      const label = shift.label || 'Shift'
      // Use a deterministic ID for click tracking
      const taskId = `${name.replace(/\s/g, '_')}_${shift.date}_${shift.startTime.replace(':', '')}`

      lines.push(
        `  ${label} :${statusTag}${taskId}, ${shift.date}T${shift.startTime}, ${shift.date}T${shift.endTime}`
      )
    }
  }

  return lines.join('\n')
}

// ── Mermaid rendering ──────────────────────────────
function getThemeConfig() {
  if (isDark.value) {
    return {
      theme: 'dark' as const,
      themeVariables: {
        primaryColor: '#6366f1',
        primaryTextColor: '#e2e8f0',
        primaryBorderColor: '#818cf8',
        lineColor: '#94a3b8',
        secondaryColor: '#1e293b',
        tertiaryColor: '#0f172a',
        background: '#0f172a',
        mainBkg: '#1e293b',
        nodeBorder: '#6366f1',
        clusterBkg: '#1e293b',
        clusterBorder: '#334155',
        titleColor: '#e2e8f0',
        edgeLabelBackground: '#1e293b',
        nodeTextColor: '#e2e8f0',
        gridColor: '#334155',
        todayLineColor: '#6366f1',
        sectionBkgColor: '#1e293b',
        altSectionBkgColor: '#0f172a',
        sectionBkgColor2: '#1e293b',
        taskBorderColor: '#818cf8',
        taskBkgColor: '#4f46e5',
        activeTaskBorderColor: '#22c55e',
        activeTaskBkgColor: '#166534',
        critBorderColor: '#f59e0b',
        critBkgColor: '#92400e',
        doneTaskBorderColor: '#64748b',
        doneTaskBkgColor: '#334155'
      }
    }
  }
  return {
    theme: 'default' as const,
    themeVariables: {
      primaryColor: '#6366f1',
      primaryTextColor: '#1e293b',
      primaryBorderColor: '#818cf8',
      lineColor: '#cbd5e1',
      secondaryColor: '#f1f5f9',
      tertiaryColor: '#ffffff',
      background: '#ffffff',
      mainBkg: '#f8fafc',
      nodeBorder: '#6366f1',
      clusterBkg: '#f8fafc',
      clusterBorder: '#e2e8f0',
      titleColor: '#0f172a',
      edgeLabelBackground: '#f8fafc',
      nodeTextColor: '#0f172a',
      gridColor: '#e2e8f0',
      todayLineColor: '#6366f1',
      sectionBkgColor: '#f8fafc',
      altSectionBkgColor: '#f1f5f9',
      sectionBkgColor2: '#f8fafc',
      taskBorderColor: '#818cf8',
      taskBkgColor: '#6366f1',
      activeTaskBorderColor: '#16a34a',
      activeTaskBkgColor: '#22c55e',
      critBorderColor: '#d97706',
      critBkgColor: '#f59e0b',
      doneTaskBorderColor: '#94a3b8',
      doneTaskBkgColor: '#cbd5e1'
    }
  }
}

async function renderChart() {
  if (!props.shifts || props.shifts.length === 0) {
    svgContent.value = ''
    return
  }

  const ganttCode = shiftsToGantt(props.shifts, props.weekStart)
  const id = `shift-gantt-${Math.random().toString(36).substring(2, 9)}`
  renderId.value = id

  const themeConfig = getThemeConfig()

  try {
    const mermaid = (await import('mermaid')).default
    mermaid.initialize({
      startOnLoad: false,
      suppressErrorRendering: true,
      ...themeConfig,
      fontFamily: 'Inter, system-ui, sans-serif',
      fontSize: 13,
      gantt: {
        barHeight: 24,
        barGap: 4,
        topPadding: 40,
        leftPadding: 100,
        gridLineStartPadding: 20,
        fontSize: 12,
        sectionFontSize: 13,
        numberSectionStyles: 4
      }
    })

    const { svg } = await mermaid.render(id, ganttCode)
    svgContent.value = svg
    renderError.value = ''
  } catch (err: any) {
    console.warn('[ShiftGantt] Render error:', err?.message || err)
    renderError.value = err?.message || 'Failed to render shift chart'
    svgContent.value = ''
  }
}

// ── Click handling ─────────────────────────────────
function handleBarClick(e: MouseEvent) {
  const target = e.target as HTMLElement
  const taskEl = target.closest('.task') || target.closest('[class*="task"]')
  if (!taskEl) return

  const taskText = taskEl.querySelector('text')?.textContent?.trim()
  if (taskText) {
    const sections = svgContent.value.match(/section\s+(.+)/g) || []
    emit('shift-click', {
      staffName: sections.length > 0 ? sections[0]!.replace('section ', '') : 'Unknown',
      date: props.weekStart ?? new Date().toISOString().split('T')[0] ?? '',
      label: taskText
    })
  }
}

// ── Tooltip handling ───────────────────────────────
function handleBarHover(e: MouseEvent) {
  const target = e.target as HTMLElement
  const taskEl = target.closest('.task') || target.closest('[class*="task"]')

  if (!taskEl) {
    tooltip.value.visible = false
    return
  }

  const taskText = taskEl.querySelector('text')?.textContent?.trim() || 'Shift'
  // Find the matching shift from our data
  const match = props.shifts.find(s => (s.label || 'Shift') === taskText)

  const rect = chartRef.value?.getBoundingClientRect()
  if (!rect) return

  tooltip.value = {
    visible: true,
    x: e.clientX - rect.left + 12,
    y: e.clientY - rect.top - 40,
    staffName: match?.staffName || '',
    time: match ? `${match.startTime} – ${match.endTime}` : '',
    status: match?.status || 'scheduled',
    label: taskText
  }
}

function hideTooltip() {
  tooltip.value.visible = false
}

// ── Lifecycle & watchers ───────────────────────────
onMounted(() => {
  nextTick(renderChart)
})

onBeforeUnmount(() => {
  if (renderId.value && import.meta.client) {
    document.getElementById(renderId.value)?.remove()
  }
})

// Re-render when shifts data or color mode changes
watch(() => [props.shifts, props.weekStart], () => {
  nextTick(renderChart)
}, { deep: true })

watch(() => colorMode.value, () => {
  nextTick(renderChart)
})
</script>

<template>
  <div class="shift-gantt-container">
    <!-- Chart rendered -->
    <div
      v-if="svgContent"
      ref="chartRef"
      class="gantt-chart"
      v-html="svgContent"
      @click="handleBarClick"
      @mousemove="handleBarHover"
      @mouseleave="hideTooltip"
    />

    <!-- Error state -->
    <div v-else-if="renderError" class="gantt-error">
      <div class="flex items-center gap-2 text-sm text-error mb-2">
        <UIcon name="i-lucide-alert-triangle" class="w-4 h-4" />
        <span class="font-medium">Chart render error</span>
      </div>
      <pre class="text-xs text-muted whitespace-pre-wrap">{{ renderError }}</pre>
    </div>

    <!-- Empty state -->
    <div v-else-if="!shifts || shifts.length === 0" class="gantt-empty">
      <UIcon name="i-lucide-calendar-off" class="w-8 h-8 text-muted opacity-40" />
      <p class="text-sm text-muted">No shifts to display.</p>
    </div>

    <!-- Loading state -->
    <div v-else class="gantt-loading">
      <UIcon name="i-lucide-loader-2" class="w-5 h-5 text-primary animate-spin" />
      <span class="text-sm text-muted">Rendering schedule...</span>
    </div>

    <!-- Floating tooltip (outside v-if chain) -->
    <Transition name="tooltip-fade">
      <div
        v-if="tooltip.visible"
        class="gantt-tooltip"
        :style="{ left: `${tooltip.x}px`, top: `${tooltip.y}px` }"
      >
        <div class="tooltip-row">
          <span class="tooltip-label">{{ tooltip.staffName }}</span>
          <span class="tooltip-dot" :class="`dot-${tooltip.status}`" />
        </div>
        <div class="tooltip-detail">
          <span>{{ tooltip.label }}</span>
          <span class="tooltip-sep">•</span>
          <span>{{ tooltip.time }}</span>
        </div>
        <div class="tooltip-status">{{ tooltip.status }}</div>
      </div>
    </Transition>

    <!-- Expand button -->
    <button
      v-if="svgContent"
      class="gantt-expand-btn"
      title="Expand chart"
      @click="expanded = true"
    >
      <UIcon name="i-lucide-maximize-2" class="w-3.5 h-3.5" />
    </button>

    <!-- Fullscreen modal -->
    <UModal v-model:open="expanded" :ui="modalUi">
      <template #content>
        <div class="p-6">
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-2">
              <UIcon name="i-lucide-calendar" class="w-5 h-5 text-primary" />
              <span class="font-semibold text-highlighted">{{ props.title || 'Shift Schedule' }}</span>
            </div>
            <UButton
              icon="i-lucide-x"
              color="neutral"
              variant="ghost"
              size="sm"
              @click="expanded = false"
            />
          </div>
          <div
            class="gantt-chart gantt-chart-expanded"
            v-html="svgContent"
            @click="handleBarClick"
          />
        </div>
      </template>
    </UModal>
  </div>
</template>

<style>
@import '~/assets/css/a2nui-gantt.css';
</style>

