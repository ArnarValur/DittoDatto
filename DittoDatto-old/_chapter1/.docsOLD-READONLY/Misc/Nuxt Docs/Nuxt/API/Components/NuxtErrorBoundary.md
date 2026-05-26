---
title: "<NuxtErrorBoundary> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-error-boundary"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <NuxtErrorBoundary>

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/nuxt-error-boundary.vue)

The <NuxtErrorBoundary> component handles client-side errors happening in its default slot.

The `<NuxtErrorBoundary>` uses Vue's [`onErrorCaptured`](https://vuejs.org/api/composition-api-lifecycle#onerrorcaptured) hook under the hood.

## Events

- `@error`: Event emitted when the default slot of the component throws an error.
	```
	<template>
	  <NuxtErrorBoundary @error="logSomeError">
	    <!-- ... -->
	  </NuxtErrorBoundary>
	</template>
	```

## Slots

- `#error`: Specify a fallback content to display in case of error.
	```
	<template>
	  <NuxtErrorBoundary>
	    <!-- ... -->
	    <template #error="{ error, clearError }">
	      <p>An error occurred: {{ error }}</p>
	      <button @click="clearError">
	        Clear error
	      </button>
	    </template>
	  </NuxtErrorBoundary>
	</template>
	```

Read more in Docs > 4 X > Getting Started > Error Handling.

## Examples

### Accessing error and clearError in script

You can access `error` and `clearError` properties within the component's script as below:

```
<template>

  <NuxtErrorBoundary ref="errorBoundary">

    <!-- ... -->

  </NuxtErrorBoundary>

</template>

<script setup lang="ts">

const errorBoundary = useTemplateRef('errorBoundary')

// errorBoundary.value?.error

// errorBoundary.value?.clearError()

</script>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/6.nuxt-error-boundary.md)