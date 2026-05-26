---
title: "Vue FileUpload Component"
source: "https://ui.nuxt.com/docs/components/file-upload"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input element to upload files."
tags:
---
## FileUpload

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/FileUpload.vue)

An input element to upload files.

## Usage

Use the `v-model` directive to control the value of the FileUpload.

```
<script setup lang="ts">

const value = ref(null)

</script>

<template>

  <UFileUpload v-model="value" class="w-96 min-h-48" />

</template>
```

### Multiple

Use the `multiple` prop to allow multiple files to be selected.

```
<template>

  <UFileUpload multiple class="w-96 min-h-48" />

</template>
```

### Dropzone

Use the `dropzone` prop to enable/disable the droppable area. Defaults to `true`.

```
<template>

  <UFileUpload :dropzone="false" class="w-96 min-h-48" />

</template>
```

### Interactive

Use the `interactive` prop to enable/disable the clickable area. Defaults to `true`.

This can be useful when adding a `Button` component in the `#actions` slot.

```
<template>

  <UFileUpload :interactive="false" class="w-96 min-h-48" />

</template>
```

### Accept

Use the `accept` prop to specify the allowed file types for the input. Provide a comma-separated list of [MIME types](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types) or file extensions (e.g., `image/png,application/pdf,.jpg`). Defaults to `*` (all file types).

```
<template>

  <UFileUpload accept="image/*" class="w-96 min-h-48" />

</template>
```

### Label

Use the `label` prop to set the label of the FileUpload.

Drop your image here

```
<template>

  <UFileUpload label="Drop your image here" class="w-96 min-h-48" />

</template>
```

### Description

Use the `description` prop to set the description of the FileUpload.

Drop your image here

SVG, PNG, JPG or GIF (max. 2MB)

```
<template>

  <UFileUpload

    label="Drop your image here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

    class="w-96 min-h-48"

  />

</template>
```

### Icon

Use the `icon` prop to set the icon of the FileUpload. Defaults to `i-lucide-upload`.

Drop your image here

SVG, PNG, JPG or GIF (max. 2MB)

```
<template>

  <UFileUpload

    icon="i-lucide-image"

    label="Drop your image here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

    class="w-96 min-h-48"

  />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.upload` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.upload` key.

### Color

Use the `color` prop to change the color of the FileUpload.

Drop your image here

SVG, PNG, JPG or GIF (max. 2MB)

```
<template>

  <UFileUpload

    color="neutral"

    highlight

    label="Drop your image here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

    class="w-96 min-h-48"

  />

</template>
```

The `highlight` prop is used here to show the focus state. It's used internally when a validation error occurs.

### Variant

Use the `variant` prop to change the variant of the FileUpload.

```
<template>

  <UFileUpload variant="button" />

</template>
```

### Size

Use the `size` prop to change the size of the FileUpload.

Drop your image here

SVG, PNG, JPG or GIF (max. 2MB)

```
<template>

  <UFileUpload

    size="xl"

    variant="area"

    label="Drop your image here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

  />

</template>
```

### Layout

Use the `layout` prop to change how the files are displayed in the FileUpload. Defaults to `grid`.

This prop only works when `variant` is `area`.

Drop your images here

SVG, PNG, JPG or GIF (max. 2MB)

```
<template>

  <UFileUpload

    layout="list"

    multiple

    label="Drop your images here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

    class="w-96"

    :ui="{

      base: 'min-h-48'

    }"

  />

</template>
```

### Position

Use the `position` prop to change the position of the files in the FileUpload. Defaults to `outside`.

This prop only works when `variant` is `area` and when `layout` is `list`.

Drop your images here

SVG, PNG, JPG or GIF (max. 2MB)

```
<template>

  <UFileUpload

    position="inside"

    layout="list"

    multiple

    label="Drop your images here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

    class="w-96"

    :ui="{

      base: 'min-h-48'

    }"

  />

</template>
```

## Examples

### With Form validation

You can use the FileUpload within a [Form](https://ui.nuxt.com/docs/components/form) and [FormField](https://ui.nuxt.com/docs/components/form-field) components to handle validation and error handling.

```
<script setup lang="ts">

import * as z from 'zod'

import type { FormSubmitEvent } from '@nuxt/ui'

const MAX_FILE_SIZE = 2 * 1024 * 1024 // 2MB

const MIN_DIMENSIONS = { width: 200, height: 200 }

const MAX_DIMENSIONS = { width: 4096, height: 4096 }

const ACCEPTED_IMAGE_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp']

const formatBytes = (bytes: number, decimals = 2) => {

  if (bytes === 0) return '0 Bytes'

  const k = 1024

  const dm = decimals < 0 ? 0 : decimals

  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']

  const i = Math.floor(Math.log(bytes) / Math.log(k))

  return Number.parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]

}

const schema = z.object({

  image: z

    .instanceof(File, {

      message: 'Please select an image file.'

    })

    .refine((file) => file.size <= MAX_FILE_SIZE, {

      message: \`The image is too large. Please choose an image smaller than ${formatBytes(MAX_FILE_SIZE)}.\`

    })

    .refine((file) => ACCEPTED_IMAGE_TYPES.includes(file.type), {

      message: 'Please upload a valid image file (JPEG, PNG, or WebP).'

    })

    .refine(

      (file) =>

        new Promise((resolve) => {

          const reader = new FileReader()

          reader.onload = (e) => {

            const img = new Image()

            img.onload = () => {

              const meetsDimensions =

                img.width >= MIN_DIMENSIONS.width &&

                img.height >= MIN_DIMENSIONS.height &&

                img.width <= MAX_DIMENSIONS.width &&

                img.height <= MAX_DIMENSIONS.height

              resolve(meetsDimensions)

            }

            img.src = e.target?.result as string

          }

          reader.readAsDataURL(file)

        }),

      {

        message: \`The image dimensions are invalid. Please upload an image between ${MIN_DIMENSIONS.width}x${MIN_DIMENSIONS.height} and ${MAX_DIMENSIONS.width}x${MAX_DIMENSIONS.height} pixels.\`

      }

    )

})

type Schema = z.output<typeof schema>

const state = reactive<Partial<Schema>>({

  image: undefined

})

async function onSubmit(event: FormSubmitEvent<Schema>) {

  console.log(event.data)

}

</script>

<template>

  <UForm :schema="schema" :state="state" class="space-y-4 w-96" @submit="onSubmit">

    <UFormField name="image" label="Image" description="JPG, GIF or PNG. 2MB Max.">

      <UFileUpload v-model="state.image" accept="image/*" class="min-h-48" />

    </UFormField>

    <UButton type="submit" label="Submit" color="neutral" />

  </UForm>

</template>
```

### With default slot

You can use the default slot to make your own FileUpload component.

```
<script setup lang="ts">

import * as z from 'zod'

import type { FormSubmitEvent } from '@nuxt/ui'

const MAX_FILE_SIZE = 2 * 1024 * 1024 // 2MB

const MIN_DIMENSIONS = { width: 200, height: 200 }

const MAX_DIMENSIONS = { width: 4096, height: 4096 }

const ACCEPTED_IMAGE_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp']

const formatBytes = (bytes: number, decimals = 2) => {

  if (bytes === 0) return '0 Bytes'

  const k = 1024

  const dm = decimals < 0 ? 0 : decimals

  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']

  const i = Math.floor(Math.log(bytes) / Math.log(k))

  return Number.parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]

}

const schema = z.object({

  avatar: z

    .instanceof(File, {

      message: 'Please select an image file.'

    })

    .refine((file) => file.size <= MAX_FILE_SIZE, {

      message: \`The image is too large. Please choose an image smaller than ${formatBytes(MAX_FILE_SIZE)}.\`

    })

    .refine((file) => ACCEPTED_IMAGE_TYPES.includes(file.type), {

      message: 'Please upload a valid image file (JPEG, PNG, or WebP).'

    })

    .refine(

      (file) =>

        new Promise((resolve) => {

          const reader = new FileReader()

          reader.onload = (e) => {

            const img = new Image()

            img.onload = () => {

              const meetsDimensions =

                img.width >= MIN_DIMENSIONS.width &&

                img.height >= MIN_DIMENSIONS.height &&

                img.width <= MAX_DIMENSIONS.width &&

                img.height <= MAX_DIMENSIONS.height

              resolve(meetsDimensions)

            }

            img.src = e.target?.result as string

          }

          reader.readAsDataURL(file)

        }),

      {

        message: \`The image dimensions are invalid. Please upload an image between ${MIN_DIMENSIONS.width}x${MIN_DIMENSIONS.height} and ${MAX_DIMENSIONS.width}x${MAX_DIMENSIONS.height} pixels.\`

      }

    )

})

type Schema = z.output<typeof schema>

const state = reactive<Partial<Schema>>({

  avatar: undefined

})

function createObjectUrl(file: File): string {

  return URL.createObjectURL(file)

}

async function onSubmit(event: FormSubmitEvent<Schema>) {

  console.log(event.data)

}

</script>

<template>

  <UForm :schema="schema" :state="state" class="space-y-4 w-64" @submit="onSubmit">

    <UFormField name="avatar" label="Avatar" description="JPG, GIF or PNG. 1MB Max.">

      <UFileUpload v-slot="{ open, removeFile }" v-model="state.avatar" accept="image/*">

        <div class="flex flex-wrap items-center gap-3">

          <UAvatar

            size="lg"

            :src="state.avatar ? createObjectUrl(state.avatar) : undefined"

            icon="i-lucide-image"

          />

          <UButton

            :label="state.avatar ? 'Change image' : 'Upload image'"

            color="neutral"

            variant="outline"

            @click="open()"

          />

        </div>

        <p v-if="state.avatar" class="text-xs text-muted mt-1.5">

          {{ state.avatar.name }}

          <UButton

            label="Remove"

            color="error"

            variant="link"

            size="xs"

            class="p-0"

            @click="removeFile()"

          />

        </p>

      </UFileUpload>

    </UFormField>

    <UButton type="submit" label="Submit" color="neutral" />

  </UForm>

</template>
```

### With files-bottom slot

You can use the `files-bottom` slot to add a [Button](https://ui.nuxt.com/docs/components/button) under the files list to remove all files for example.

Drop your images here

SVG, PNG, JPG or GIF (max. 2MB)

```
<script setup lang="ts">

const value = ref<File[]>([])

</script>

<template>

  <UFileUpload

    v-model="value"

    icon="i-lucide-image"

    label="Drop your images here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

    layout="list"

    multiple

    :interactive="false"

    class="w-96 min-h-48"

  >

    <template #actions="{ open }">

      <UButton

        label="Select images"

        icon="i-lucide-upload"

        color="neutral"

        variant="outline"

        @click="open()"

      />

    </template>

    <template #files-bottom="{ removeFile, files }">

      <UButton

        v-if="files?.length"

        label="Remove all files"

        color="neutral"

        @click="removeFile()"

      />

    </template>

  </UFileUpload>

</template>
```

The `interactive` prop is set to `false` in this example to prevent the default clickable area.

### With files-top slot

You can use the `files-top` slot to add a [Button](https://ui.nuxt.com/docs/components/button) above the files list to add new files for example.

Drop your images here

SVG, PNG, JPG or GIF (max. 2MB)

```
<script setup lang="ts">

const value = ref<File[]>([])

</script>

<template>

  <UFileUpload

    v-model="value"

    icon="i-lucide-image"

    label="Drop your images here"

    description="SVG, PNG, JPG or GIF (max. 2MB)"

    layout="grid"

    multiple

    :interactive="false"

    class="w-96 min-h-48"

  >

    <template #actions="{ open }">

      <UButton

        label="Select images"

        icon="i-lucide-upload"

        color="neutral"

        variant="outline"

        @click="open()"

      />

    </template>

    <template #files-top="{ open, files }">

      <div v-if="files?.length" class="mb-2 flex items-center justify-between">

        <p class="font-bold">Files ({{ files?.length }})</p>

        <UButton

          icon="i-lucide-plus"

          label="Add more"

          color="neutral"

          variant="outline"

          class="-my-2"

          @click="open()"

        />

      </div>

    </template>

  </UFileUpload>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `id` |  | ` string` |
| `name` |  | ` string` |
| `icon` | `appConfig.ui.icons.upload` | `any`  The icon to display. |
| `label` |  | ` string` |
| `description` |  | ` string` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'area'` | ` "button" \| "area"`  The `button` variant is only available when `multiple` is `false`. |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `layout` | `'grid'` | ` "list" \| "grid"`  The layout of how files are displayed. Only works when `variant` is `area`. |
| `position` | `'outside'` | ` "inside" \| "outside"`  The position of the files. Only works when `variant` is `area` and when `layout` is `list`. |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `accept` | `'*'` | ` string`  Specifies the allowed file types for the input. Provide a comma-separated list of MIME types or file extensions (e.g., "image/png,application/pdf,.jpg").  - [https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/accept](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/accept) |
| `multiple` | `false` | ` M` |
| `reset` | `false` | `boolean`  Reset the file input when the dialog is opened. |
| `dropzone` | `true` | `boolean`  Create a zone that allows the user to drop files onto it. |
| `interactive` | `true` | `boolean`  Make the dropzone interactive when the user is clicking on it. |
| `required` |  | `boolean` |
| `disabled` |  | `boolean` |
| `fileIcon` | `appConfig.ui.icons.file` | `any`  The icon to display for the file. |
| `fileDelete` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Configure the delete button for the file. When `layout` is `grid`, the default is `{ color: 'neutral', variant: 'solid', size: 'xs' }` When `layout` is `list`, the default is `{ color: 'neutral', variant: 'link' }` |
| `fileDeleteIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed to delete a file. |
| `preview` | `true` | `boolean`  Show the file preview/list after upload. |
| `modelValue` |  | ` null \| M extends true ? File[] : File` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; wrapper?: ClassNameValue; icon?: ClassNameValue; avatar?: ClassNameValue; label?: ClassNameValue; description?: ClassNameValue; actions?: ClassNameValue; files?: ClassNameValue; file?: ClassNameValue; fileLeadingAvatar?: ClassNameValue; fileWrapper?: ClassNameValue; fileName?: ClassNameValue; fileSize?: ClassNameValue; fileTrailingButton?: ClassNameValue; }` |

This component also supports all native `<input>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ open: (localOptions?: Partial<UseFileDialogOptions> \| undefined) => void; removeFile: (index?: number \| undefined) => void; ui: object; }` |
| `leading` | `{ ui: object; }` |
| `label` | `{}` |
| `description` | `{}` |
| `actions` | `{ files?: FileUploadFiles<M> \| undefined; open: (localOptions?: Partial<UseFileDialogOptions> \| undefined) => void; removeFile: (index?: number \| undefined) => void; }` |
| `files` | `{ files?: FileUploadFiles<M> \| undefined; }` |
| `files-top` | `{ files?: FileUploadFiles<M> \| undefined; open: (localOptions?: Partial<UseFileDialogOptions> \| undefined) => void; removeFile: (index?: number \| undefined) => void; }` |
| `files-bottom` | `{ files?: FileUploadFiles<M> \| undefined; open: (localOptions?: Partial<UseFileDialogOptions> \| undefined) => void; removeFile: (index?: number \| undefined) => void; }` |
| `file` | `{ file: File; index: number; }` |
| `file-leading` | `{ file: File; index: number; ui: object; }` |
| `file-name` | `{ file: File; index: number; }` |
| `file-size` | `{ file: File; index: number; }` |
| `file-trailing` | `{ file: File; index: number; ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `change` | `[event: Event]` |
| `update:modelValue` | `[value: (M extends true ? File[] : File) \| null \| undefined]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `inputRef` | `Ref<HTMLInputElement \| null>` |
| `dropzoneRef` | `Ref<HTMLDivElement \| null>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    fileUpload: {

      slots: {

        root: 'relative flex flex-col',

        base: [

          'w-full flex-1 bg-default border border-default flex flex-col gap-2 items-stretch justify-center rounded-lg focus-visible:outline-2',

          'transition-[background]'

        ],

        wrapper: 'flex flex-col items-center justify-center text-center',

        icon: 'shrink-0',

        avatar: 'shrink-0',

        label: 'font-medium text-default mt-2',

        description: 'text-muted mt-1',

        actions: 'flex flex-wrap gap-1.5 shrink-0 mt-4',

        files: '',

        file: 'relative',

        fileLeadingAvatar: 'shrink-0',

        fileWrapper: 'flex flex-col min-w-0',

        fileName: 'text-default truncate',

        fileSize: 'text-muted truncate',

        fileTrailingButton: ''

      },

      variants: {

        color: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        variant: {

          area: {

            wrapper: 'px-4 py-3',

            base: 'p-4'

          },

          button: {}

        },

        size: {

          xs: {

            base: 'text-xs',

            icon: 'size-4',

            file: 'text-xs px-2 py-1 gap-1',

            fileWrapper: 'flex-row gap-1'

          },

          sm: {

            base: 'text-xs',

            icon: 'size-4',

            file: 'text-xs px-2.5 py-1.5 gap-1.5',

            fileWrapper: 'flex-row gap-1'

          },

          md: {

            base: 'text-sm',

            icon: 'size-5',

            file: 'text-xs px-2.5 py-1.5 gap-1.5'

          },

          lg: {

            base: 'text-sm',

            icon: 'size-5',

            file: 'text-sm px-3 py-2 gap-2',

            fileSize: 'text-xs'

          },

          xl: {

            base: 'text-base',

            icon: 'size-6',

            file: 'text-sm px-3 py-2 gap-2'

          }

        },

        layout: {

          list: {

            root: 'gap-2 items-start',

            files: 'flex flex-col w-full gap-2',

            file: 'min-w-0 flex items-center border border-default rounded-md w-full',

            fileTrailingButton: 'ms-auto'

          },

          grid: {

            fileWrapper: 'hidden',

            fileLeadingAvatar: 'size-full rounded-lg',

            fileTrailingButton: 'absolute -top-1.5 -end-1.5 p-0 rounded-full border-2 border-bg'

          }

        },

        position: {

          inside: '',

          outside: ''

        },

        dropzone: {

          true: 'border-dashed data-[dragging=true]:bg-elevated/25'

        },

        interactive: {

          true: ''

        },

        highlight: {

          true: ''

        },

        multiple: {

          true: ''

        },

        disabled: {

          true: 'cursor-not-allowed opacity-75'

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          class: 'focus-visible:outline-primary'

        },

        {

          color: 'primary',

          highlight: true,

          class: 'border-primary'

        },

        {

          color: 'neutral',

          class: 'focus-visible:outline-inverted'

        },

        {

          color: 'neutral',

          highlight: true,

          class: 'border-inverted'

        },

        {

          size: 'xs',

          layout: 'list',

          class: {

            fileTrailingButton: '-me-1'

          }

        },

        {

          size: 'sm',

          layout: 'list',

          class: {

            fileTrailingButton: '-me-1.5'

          }

        },

        {

          size: 'md',

          layout: 'list',

          class: {

            fileTrailingButton: '-me-1.5'

          }

        },

        {

          size: 'lg',

          layout: 'list',

          class: {

            fileTrailingButton: '-me-2'

          }

        },

        {

          size: 'xl',

          layout: 'list',

          class: {

            fileTrailingButton: '-me-2'

          }

        },

        {

          variant: 'button',

          size: 'xs',

          class: {

            base: 'p-1'

          }

        },

        {

          variant: 'button',

          size: 'sm',

          class: {

            base: 'p-1.5'

          }

        },

        {

          variant: 'button',

          size: 'md',

          class: {

            base: 'p-1.5'

          }

        },

        {

          variant: 'button',

          size: 'lg',

          class: {

            base: 'p-2'

          }

        },

        {

          variant: 'button',

          size: 'xl',

          class: {

            base: 'p-2'

          }

        },

        {

          layout: 'grid',

          multiple: true,

          class: {

            files: 'grid grid-cols-2 md:grid-cols-3 gap-4 w-full',

            file: 'p-0 aspect-square'

          }

        },

        {

          layout: 'grid',

          multiple: false,

          class: {

            file: 'absolute inset-0 p-0'

          }

        },

        {

          interactive: true,

          disabled: false,

          class: 'hover:bg-elevated/25'

        }

      ],

      defaultVariants: {

        color: 'primary',

        variant: 'area',

        size: 'md'

      }

    }

  }

})
```

vite.config.ts

```ts
import { defineConfig } from 'vite'

import vue from '@vitejs/plugin-vue'

import ui from '@nuxt/ui/vite'

export default defineConfig({

  plugins: [

    vue(),

    ui({

      ui: {

        fileUpload: {

          slots: {

            root: 'relative flex flex-col',

            base: [

              'w-full flex-1 bg-default border border-default flex flex-col gap-2 items-stretch justify-center rounded-lg focus-visible:outline-2',

              'transition-[background]'

            ],

            wrapper: 'flex flex-col items-center justify-center text-center',

            icon: 'shrink-0',

            avatar: 'shrink-0',

            label: 'font-medium text-default mt-2',

            description: 'text-muted mt-1',

            actions: 'flex flex-wrap gap-1.5 shrink-0 mt-4',

            files: '',

            file: 'relative',

            fileLeadingAvatar: 'shrink-0',

            fileWrapper: 'flex flex-col min-w-0',

            fileName: 'text-default truncate',

            fileSize: 'text-muted truncate',

            fileTrailingButton: ''

          },

          variants: {

            color: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            variant: {

              area: {

                wrapper: 'px-4 py-3',

                base: 'p-4'

              },

              button: {}

            },

            size: {

              xs: {

                base: 'text-xs',

                icon: 'size-4',

                file: 'text-xs px-2 py-1 gap-1',

                fileWrapper: 'flex-row gap-1'

              },

              sm: {

                base: 'text-xs',

                icon: 'size-4',

                file: 'text-xs px-2.5 py-1.5 gap-1.5',

                fileWrapper: 'flex-row gap-1'

              },

              md: {

                base: 'text-sm',

                icon: 'size-5',

                file: 'text-xs px-2.5 py-1.5 gap-1.5'

              },

              lg: {

                base: 'text-sm',

                icon: 'size-5',

                file: 'text-sm px-3 py-2 gap-2',

                fileSize: 'text-xs'

              },

              xl: {

                base: 'text-base',

                icon: 'size-6',

                file: 'text-sm px-3 py-2 gap-2'

              }

            },

            layout: {

              list: {

                root: 'gap-2 items-start',

                files: 'flex flex-col w-full gap-2',

                file: 'min-w-0 flex items-center border border-default rounded-md w-full',

                fileTrailingButton: 'ms-auto'

              },

              grid: {

                fileWrapper: 'hidden',

                fileLeadingAvatar: 'size-full rounded-lg',

                fileTrailingButton: 'absolute -top-1.5 -end-1.5 p-0 rounded-full border-2 border-bg'

              }

            },

            position: {

              inside: '',

              outside: ''

            },

            dropzone: {

              true: 'border-dashed data-[dragging=true]:bg-elevated/25'

            },

            interactive: {

              true: ''

            },

            highlight: {

              true: ''

            },

            multiple: {

              true: ''

            },

            disabled: {

              true: 'cursor-not-allowed opacity-75'

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              class: 'focus-visible:outline-primary'

            },

            {

              color: 'primary',

              highlight: true,

              class: 'border-primary'

            },

            {

              color: 'neutral',

              class: 'focus-visible:outline-inverted'

            },

            {

              color: 'neutral',

              highlight: true,

              class: 'border-inverted'

            },

            {

              size: 'xs',

              layout: 'list',

              class: {

                fileTrailingButton: '-me-1'

              }

            },

            {

              size: 'sm',

              layout: 'list',

              class: {

                fileTrailingButton: '-me-1.5'

              }

            },

            {

              size: 'md',

              layout: 'list',

              class: {

                fileTrailingButton: '-me-1.5'

              }

            },

            {

              size: 'lg',

              layout: 'list',

              class: {

                fileTrailingButton: '-me-2'

              }

            },

            {

              size: 'xl',

              layout: 'list',

              class: {

                fileTrailingButton: '-me-2'

              }

            },

            {

              variant: 'button',

              size: 'xs',

              class: {

                base: 'p-1'

              }

            },

            {

              variant: 'button',

              size: 'sm',

              class: {

                base: 'p-1.5'

              }

            },

            {

              variant: 'button',

              size: 'md',

              class: {

                base: 'p-1.5'

              }

            },

            {

              variant: 'button',

              size: 'lg',

              class: {

                base: 'p-2'

              }

            },

            {

              variant: 'button',

              size: 'xl',

              class: {

                base: 'p-2'

              }

            },

            {

              layout: 'grid',

              multiple: true,

              class: {

                files: 'grid grid-cols-2 md:grid-cols-3 gap-4 w-full',

                file: 'p-0 aspect-square'

              }

            },

            {

              layout: 'grid',

              multiple: false,

              class: {

                file: 'absolute inset-0 p-0'

              }

            },

            {

              interactive: true,

              disabled: false,

              class: 'hover:bg-elevated/25'

            }

          ],

          defaultVariants: {

            color: 'primary',

            variant: 'area',

            size: 'md'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`1d9a2`](https://github.com/nuxt/ui/commit/1d9a2fdfe7187dc43e2e5e341e04c297326149b6) — fix: emit null when clearing file ([#5892](https://github.com/nuxt/ui/issues/5892))

[`597ac`](https://github.com/nuxt/ui/commit/597ac29582d4902630d7c9c165298cfb0e9db04c) — fix: keep input visible when preview is disabled with multiple files

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`2af82`](https://github.com/nuxt/ui/commit/2af82e7a7e4936939f35394e0c3cfaf9fbabd0b3) — feat: add `preview` prop ([#5443](https://github.com/nuxt/ui/issues/5443))

[`fda3c`](https://github.com/nuxt/ui/commit/fda3c98ab798f045e6e3d781ec482ebe5f360c4e) — fix: clean html attributes extend

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`eb491`](https://github.com/nuxt/ui/commit/eb491e1f25d47109ffe4e2c43601f8220558df1b) — fix: ensure native validation works with required ([#5358](https://github.com/nuxt/ui/issues/5358))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`08c30`](https://github.com/nuxt/ui/commit/08c30cfecd2313d5323aa37c5a83fbfe63af39f1) — fix: handle disabling file delete button

[`69906`](https://github.com/nuxt/ui/commit/69906bcc12e43b9cf9a1572457f633c8794eda51) — fix: use native img element for blob URLs preview

[`2477d`](https://github.com/nuxt/ui/commit/2477d44e9c448b41da00020d1a0bd3d7331aef64) — fix: stuck focus while tabbing ([#5128](https://github.com/nuxt/ui/issues/5128))

[`f33e4`](https://github.com/nuxt/ui/commit/f33e43cddeef333efe086607f404808a7c211f5c) — fix: add missing `button` type

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`68d8a`](https://github.com/nuxt/ui/commit/68d8a983ed2665941f7c2ad53bd67b66e8d13f37) — fix: prevent default on keydown ([#4633](https://github.com/nuxt/ui/issues/4633))

[`8e926`](https://github.com/nuxt/ui/commit/8e9265e91f3e43a39a4867565f415faabf6315bc) — fix: open dialog on keyup ([#4629](https://github.com/nuxt/ui/issues/4629))

[`f90bb`](https://github.com/nuxt/ui/commit/f90bba00c140394e9f1c71979a9072503f2377e1) — fix: improve file removal a11y ([#4607](https://github.com/nuxt/ui/issues/4607))

[`02161`](https://github.com/nuxt/ui/commit/02161ed2cbda445b5c2761242b91657a24711321) — fix: handle RTL mode ([#4585](https://github.com/nuxt/ui/issues/4585))

[`35dbe`](https://github.com/nuxt/ui/commit/35dbe6c2ab2297a9cb12fc8a35fff22555a20f34) — feat: new component ([#4564](https://github.com/nuxt/ui/issues/4564))[ColorPicker](https://ui.nuxt.com/docs/components/color-picker)

[

A component to select a color.

](https://ui.nuxt.com/docs/components/color-picker)[

Form

A form component with built-in validation and submission handling.

](https://ui.nuxt.com/docs/components/form)