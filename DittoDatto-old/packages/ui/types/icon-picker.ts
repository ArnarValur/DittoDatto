/**
 * Icon item for the picker dropdown
 */
export interface IconItem {
  /** Display name, e.g., "Restaurant" */
  label: string
  /** Icon name, e.g., "i-material-symbols-restaurant" */
  value: string
  /** Same as value - used for UInputMenu icon display */
  icon: string
}

/**
 * Props for the DDIconPicker component
 */
export interface DDIconPickerProps {
  /** Selected icon value (v-model) */
  modelValue?: string
  /** Placeholder text when no icon selected */
  placeholder?: string
  /** Disable the picker */
  disabled?: boolean
  /** Size of the input */
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
}

/**
 * Emits for the DDIconPicker component
 */
export interface DDIconPickerEmits {
  (e: 'update:modelValue', value: string): void
}
