---
title: "Vue Carousel Component"
source: "https://ui.nuxt.com/docs/components/carousel"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A carousel with motion and swipe built using Embla."
tags:
---
## Carousel

[Embla](https://www.embla-carousel.com/api/) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Carousel.vue)

A carousel with motion and swipe built using Embla.

## Usage

Use the Carousel component to display a list of items in a carousel.

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    loop

    arrows

    :autoplay="{ delay: 2000 }"

    wheel-gestures

    :prev="{ variant: 'solid' }"

    :next="{ variant: 'solid' }"

    :items="items"

    :ui="{

      item: 'basis-1/3 ps-0',

      prev: 'sm:start-8',

      next: 'sm:end-8',

      container: 'ms-0'

    }"

  >

    <img :src="item" width="320" height="320">

  </UCarousel>

</template>
```

Use your mouse to drag the carousel horizontally on desktop.

### Items

Use the `items` prop as an array and render each item using the default slot:

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel v-slot="{ item }" :items="items" class="w-full max-w-xs mx-auto">

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

You can also pass an array of objects with the following properties:

- `class?: any`
- `ui?: { item?: ClassNameValue }`

You can control how many items are visible by using the [`basis`](https://tailwindcss.com/docs/flex-basis) / [`width`](https://tailwindcss.com/docs/width) utility classes on the `item`:

![](https://picsum.photos/468/468?random=1) ![](https://picsum.photos/468/468?random=2) ![](https://picsum.photos/468/468?random=3) ![](https://picsum.photos/468/468?random=4) ![](https://picsum.photos/468/468?random=5) ![](https://picsum.photos/468/468?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/468/468?random=1',

  'https://picsum.photos/468/468?random=2',

  'https://picsum.photos/468/468?random=3',

  'https://picsum.photos/468/468?random=4',

  'https://picsum.photos/468/468?random=5',

  'https://picsum.photos/468/468?random=6'

]

</script>

<template>

  <UCarousel v-slot="{ item }" :items="items" :ui="{ item: 'basis-1/3' }">

    <img :src="item" width="234" height="234" class="rounded-lg">

  </UCarousel>

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the Progress. Defaults to `horizontal`.

Use your mouse to drag the carousel vertically on desktop.

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    orientation="vertical"

    :items="items"

    :ui="{ container: 'h-[336px]' }"

    class="w-full max-w-xs mx-auto"

  >

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

### Arrows

Use the `arrows` prop to display prev and next buttons.

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel v-slot="{ item }" arrows :items="items" class="w-full max-w-xs mx-auto">

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

Use the `prev` and `next` props to customize the prev and next buttons with any [Button](https://ui.nuxt.com/docs/components/button) props.

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    arrows

    :prev="{ color: 'primary' }"

    :next="{ variant: 'solid' }"

    :items="items"

    class="w-full max-w-xs mx-auto"

  >

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

Use the `prev-icon` and `next-icon` props to customize the buttons [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-arrow-left` / `i-lucide-arrow-right`.

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

defineProps<{

  prevIcon?: string

  nextIcon?: string

}>()

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    arrows

    :prev-icon="prevIcon"

    :next-icon="nextIcon"

    :items="items"

    class="w-full max-w-xs mx-auto"

  >

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

You can customize these icons globally in your `app.config.ts` under `ui.icons.arrowLeft` / `ui.icons.arrowRight` key.

You can customize these icons globally in your `vite.config.ts` under `ui.icons.arrowLeft` / `ui.icons.arrowRight` key.

### Dots

Use the `dots` prop to display a list of dots to scroll to a specific slide.

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel v-slot="{ item }" dots :items="items" class="w-full max-w-xs mx-auto">

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

The number of dots is based on the number of slides displayed in the view:

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel v-slot="{ item }" dots :items="items" :ui="{ item: 'basis-1/3' }">

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

## Plugins

The Carousel component implements the official [Embla Carousel plugins](https://www.embla-carousel.com/plugins/).

### Autoplay

This plugin is used to extend Embla Carousel with **autoplay** functionality.

Use the `autoplay` prop as a boolean or an object to configure the [Autoplay plugin](https://www.embla-carousel.com/plugins/autoplay/).

![](https://picsum.photos/468/468?random=1) ![](https://picsum.photos/468/468?random=2) ![](https://picsum.photos/468/468?random=3) ![](https://picsum.photos/468/468?random=4) ![](https://picsum.photos/468/468?random=5) ![](https://picsum.photos/468/468?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/468/468?random=1',

  'https://picsum.photos/468/468?random=2',

  'https://picsum.photos/468/468?random=3',

  'https://picsum.photos/468/468?random=4',

  'https://picsum.photos/468/468?random=5',

  'https://picsum.photos/468/468?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    loop

    arrows

    dots

    :autoplay="{ delay: 2000 }"

    :items="items"

    :ui="{ item: 'basis-1/3' }"

  >

    <img :src="item" width="234" height="234" class="rounded-lg">

  </UCarousel>

</template>
```

In this example, we're using the `loop` prop for an infinite carousel.

### Auto Scroll

This plugin is used to extend Embla Carousel with **auto scroll** functionality.

Use the `auto-scroll` prop as a boolean or an object to configure the [Auto Scroll plugin](https://www.embla-carousel.com/plugins/auto-scroll/).

![](https://picsum.photos/468/468?random=1) ![](https://picsum.photos/468/468?random=2) ![](https://picsum.photos/468/468?random=3) ![](https://picsum.photos/468/468?random=4) ![](https://picsum.photos/468/468?random=5) ![](https://picsum.photos/468/468?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/468/468?random=1',

  'https://picsum.photos/468/468?random=2',

  'https://picsum.photos/468/468?random=3',

  'https://picsum.photos/468/468?random=4',

  'https://picsum.photos/468/468?random=5',

  'https://picsum.photos/468/468?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    loop

    dots

    arrows

    auto-scroll

    :items="items"

    :ui="{ item: 'basis-1/3' }"

  >

    <img :src="item" width="234" height="234" class="rounded-lg">

  </UCarousel>

</template>
```

In this example, we're using the `loop` prop for an infinite carousel.

### Auto Height

This plugin is used to extend Embla Carousel with **auto height** functionality. It changes the height of the carousel container to fit the height of the highest slide in view.

Use the `auto-height` prop as a boolean or an object to configure the [Auto Height plugin](https://www.embla-carousel.com/plugins/auto-height/).

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/320?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/320?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/320?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/320?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/320?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/320?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    auto-height

    arrows

    dots

    :items="items"

    :ui="{

      container: 'transition-[height]',

      controls: 'absolute -top-8 inset-x-12',

      dots: '-top-7',

      dot: 'w-6 h-1'

    }"

    class="w-full max-w-xs mx-auto"

  >

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

In this example, we add the `transition-[height]` class on the container to animate the height change.

### Class Names

Class Names is a **class name toggle** utility plugin for Embla Carousel that enables you to automate the toggling of class names on your carousel.

Use the `class-names` prop as a boolean or an object to configure the [Class Names plugin](https://www.embla-carousel.com/plugins/class-names/).

![](https://picsum.photos/528/528?random=1) ![](https://picsum.photos/528/528?random=2) ![](https://picsum.photos/528/528?random=3) ![](https://picsum.photos/528/528?random=4) ![](https://picsum.photos/528/528?random=5) ![](https://picsum.photos/528/528?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/528/528?random=1',

  'https://picsum.photos/528/528?random=2',

  'https://picsum.photos/528/528?random=3',

  'https://picsum.photos/528/528?random=4',

  'https://picsum.photos/528/528?random=5',

  'https://picsum.photos/528/528?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    class-names

    arrows

    :items="items"

    :ui="{

      item: 'basis-[70%] transition-opacity [&:not(.is-snapped)]:opacity-10'

    }"

    class="mx-auto max-w-sm"

  >

    <img :src="item" width="264" height="264" class="rounded-lg">

  </UCarousel>

</template>
```

In this example, we add the `transition-opacity [&:not(.is-snapped)]:opacity-10` classes on the `item` to animate the opacity change.

### Fade

This plugin is used to replace the Embla Carousel scroll functionality with **fade transitions**.

Use the `fade` prop as a boolean or an object to configure the [Fade plugin](https://www.embla-carousel.com/plugins/fade/).

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    fade

    arrows

    dots

    :items="items"

    class="w-full max-w-xs mx-auto"

  >

    <img :src="item" width="320" height="320" class="rounded-lg">

  </UCarousel>

</template>
```

### Wheel Gestures

This plugin is used to extend Embla Carousel with the ability to **use the mouse/trackpad wheel** to navigate the carousel.

Use the `wheel-gestures` prop as a boolean or an object to configure the [Wheel Gestures plugin](https://www.embla-carousel.com/plugins/wheel-gestures/).

Use your mouse wheel to scroll the carousel.

![](https://picsum.photos/468/468?random=1) ![](https://picsum.photos/468/468?random=2) ![](https://picsum.photos/468/468?random=3) ![](https://picsum.photos/468/468?random=4) ![](https://picsum.photos/468/468?random=5) ![](https://picsum.photos/468/468?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/468/468?random=1',

  'https://picsum.photos/468/468?random=2',

  'https://picsum.photos/468/468?random=3',

  'https://picsum.photos/468/468?random=4',

  'https://picsum.photos/468/468?random=5',

  'https://picsum.photos/468/468?random=6'

]

</script>

<template>

  <UCarousel

    v-slot="{ item }"

    loop

    wheel-gestures

    :items="items"

    :ui="{ item: 'basis-1/3' }"

  >

    <img :src="item" width="234" height="234" class="rounded-lg">

  </UCarousel>

</template>
```

## Examples

### With thumbnails

You can use the [`emblaApi`](https://ui.nuxt.com/docs/components/#expose) function [scrollTo](https://www.embla-carousel.com/api/methods/#scrollto) to display thumbnails under the carousel that allows you to navigate to a specific slide.

![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6) ![](https://picsum.photos/640/640?random=1) ![](https://picsum.photos/640/640?random=2) ![](https://picsum.photos/640/640?random=3) ![](https://picsum.photos/640/640?random=4) ![](https://picsum.photos/640/640?random=5) ![](https://picsum.photos/640/640?random=6)

```
<script setup lang="ts">

const items = [

  'https://picsum.photos/640/640?random=1',

  'https://picsum.photos/640/640?random=2',

  'https://picsum.photos/640/640?random=3',

  'https://picsum.photos/640/640?random=4',

  'https://picsum.photos/640/640?random=5',

  'https://picsum.photos/640/640?random=6'

]

const carousel = useTemplateRef('carousel')

const activeIndex = ref(0)

function onClickPrev() {

  activeIndex.value--

}

function onClickNext() {

  activeIndex.value++

}

function onSelect(index: number) {

  activeIndex.value = index

}

function select(index: number) {

  activeIndex.value = index

  carousel.value?.emblaApi?.scrollTo(index)

}

</script>

<template>

  <div class="flex-1 w-full">

    <UCarousel

      ref="carousel"

      v-slot="{ item }"

      arrows

      :items="items"

      :prev="{ onClick: onClickPrev }"

      :next="{ onClick: onClickNext }"

      class="w-full max-w-xs mx-auto"

      @select="onSelect"

    >

      <img :src="item" width="320" height="320" class="rounded-lg">

    </UCarousel>

    <div class="flex gap-1 justify-between pt-4 max-w-xs mx-auto">

      <div

        v-for="(item, index) in items"

        :key="index"

        class="size-11 opacity-25 hover:opacity-100 transition-opacity"

        :class="{ 'opacity-100': activeIndex === index }"

        @click="select(index)"

      >

        <img :src="item" width="44" height="44" class="rounded-lg">

      </div>

    </div>

  </div>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `prev` | `{ size: 'md', color: 'neutral', variant: 'link' }` | ` Omit<ButtonProps, LinkPropsKeys>`  Configure the prev button when arrows are enabled. |
| `prevIcon` | `appConfig.ui.icons.arrowLeft` | `any`  The icon displayed in the prev button. |
| `next` | `{ size: 'md', color: 'neutral', variant: 'link' }` | ` Omit<ButtonProps, LinkPropsKeys>`  Configure the next button when arrows are enabled. |
| `nextIcon` | `appConfig.ui.icons.arrowRight` | `any`  The icon displayed in the next button. |
| `arrows` | `false` | `boolean`  Display prev and next buttons to scroll the carousel. |
| `dots` | `false` | `boolean`  Display dots to scroll to a specific slide. |
| `orientation` | `'horizontal'` | ` "vertical" \| "horizontal"`  The orientation of the carousel. |
| `items` |  | ` T[]` |
| `autoplay` | `false` | `boolean \| Partial<CreateOptionsType<OptionsType>>`  Enable Autoplay plugin  - [https://www.embla-carousel.com/plugins/autoplay/](https://www.embla-carousel.com/plugins/autoplay/) |
| `autoScroll` | `false` | `boolean \| Partial<CreateOptionsType<OptionsType>>`  Enable Auto Scroll plugin  - [https://www.embla-carousel.com/plugins/auto-scroll/](https://www.embla-carousel.com/plugins/auto-scroll/) |
| `autoHeight` | `false` | `boolean \| Partial<CreateOptionsType<{ active: boolean; breakpoints: { [key: string]: Omit<Partial<any>, "breakpoints">; }; }>>`  Enable Auto Height plugin  - [https://www.embla-carousel.com/plugins/auto-height/](https://www.embla-carousel.com/plugins/auto-height/) |
| `classNames` | `false` | `boolean \| Partial<CreateOptionsType<OptionsType>>`  Enable Class Names plugin  - [https://www.embla-carousel.com/plugins/class-names/](https://www.embla-carousel.com/plugins/class-names/) |
| `fade` | `false` | `boolean \| Partial<CreateOptionsType<{ active: boolean; breakpoints: { [key: string]: Omit<Partial<any>, "breakpoints">; }; }>>`  Enable Fade plugin  - [https://www.embla-carousel.com/plugins/fade/](https://www.embla-carousel.com/plugins/fade/) |
| `wheelGestures` | `false` | `boolean \| WheelGesturesPluginOptions`  Enable Wheel Gestures plugin  - [https://www.embla-carousel.com/plugins/wheel-gestures/](https://www.embla-carousel.com/plugins/wheel-gestures/) |
| `align` | `'center'` | ` "start" \| "center" \| "end" \| (viewSize: number, snapSize: number, index: number): number` |
| `containScroll` | `'trimSnaps'` | ` false \| "trimSnaps" \| "keepSnaps"` |
| `slidesToScroll` | `1` | ` number \| "auto"` |
| `dragFree` | `false` | `boolean` |
| `dragThreshold` | `10` | ` number` |
| `inViewThreshold` | `0` | ` number \| number[]` |
| `loop` | `false` | `boolean` |
| `skipSnaps` | `false` | `boolean` |
| `duration` | `25` | ` number` |
| `startIndex` | `0` | ` number` |
| `watchDrag` | `true` | ` false \| true \| (emblaApi: EmblaCarouselType, evt: PointerEventType): boolean \| void` |
| `watchResize` | `true` | ` false \| true \| (emblaApi: EmblaCarouselType, entries: ResizeObserverEntry[]): boolean \| void` |
| `watchSlides` | `true` | ` false \| true \| (emblaApi: EmblaCarouselType, mutations: MutationRecord[]): boolean \| void` |
| `watchFocus` | `true` | ` false \| true \| (emblaApi: EmblaCarouselType, evt: FocusEvent): boolean \| void` |
| `active` | `true` | `boolean` |
| `breakpoints` | `{}` | ` { [key: string]: Omit<Partial<CreateOptionsType<{ align: AlignmentOptionType; axis: AxisOptionType; container: string \| HTMLElement \| null; slides: string \| HTMLElement[] \| NodeListOf<HTMLElement> \| null; containScroll: ScrollContainOptionType; direction: AxisDirectionOptionType; slidesToScroll: SlidesToScrollOptionType; dragFree: boolean; dragThreshold: number; inViewThreshold: number \| number[] \| undefined; loop: boolean; skipSnaps: boolean; duration: number; startIndex: number; watchDrag: DragHandlerOptionType; watchResize: ResizeHandlerOptionType; watchSlides: SlidesHandlerOptionType; watchFocus: FocusHandlerOptionType; }>>, "breakpoints">; }` |
| `ui` |  | ` { root?: ClassNameValue; viewport?: ClassNameValue; container?: ClassNameValue; item?: ClassNameValue; controls?: ClassNameValue; arrows?: ClassNameValue; prev?: ClassNameValue; next?: ClassNameValue; dots?: ClassNameValue; dot?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ item: T; index: number; }` |

### Emits

| Event | Type |
| --- | --- |
| `select` | `[selectedIndex: number]` |

### Expose

You can access the typed component instance using [`useTemplateRef`](https://vuejs.org/api/composition-api-helpers.html#usetemplateref).

```
<script setup lang="ts">

const carousel = useTemplateRef('carousel')

</script>

<template>

  <UCarousel ref="carousel" />

</template>
```

This will give you access to the following:

| Name | Type |
| --- | --- |
| `emblaRef` | `Ref<HTMLElement \| null>` |
| `emblaApi` | [`Ref<EmblaCarouselType \| null>`](https://www.embla-carousel.com/api/methods/#typescript) |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    carousel: {

      slots: {

        root: 'relative focus:outline-none',

        viewport: 'overflow-hidden',

        container: 'flex items-start',

        item: 'min-w-0 shrink-0 basis-full',

        controls: '',

        arrows: '',

        prev: 'absolute rounded-full',

        next: 'absolute rounded-full',

        dots: 'absolute inset-x-0 -bottom-7 flex flex-wrap items-center justify-center gap-3',

        dot: [

          'cursor-pointer size-3 bg-accented rounded-full focus:outline-none focus-visible:ring-2 focus-visible:ring-primary',

          'transition'

        ]

      },

      variants: {

        orientation: {

          vertical: {

            container: 'flex-col -mt-4',

            item: 'pt-4',

            prev: 'top-4 sm:-top-12 left-1/2 -translate-x-1/2 rotate-90 rtl:-rotate-90',

            next: 'bottom-4 sm:-bottom-12 left-1/2 -translate-x-1/2 rotate-90 rtl:-rotate-90'

          },

          horizontal: {

            container: 'flex-row -ms-4',

            item: 'ps-4',

            prev: 'start-4 sm:-start-12 top-1/2 -translate-y-1/2',

            next: 'end-4 sm:-end-12 top-1/2 -translate-y-1/2'

          }

        },

        active: {

          true: {

            dot: 'data-[state=active]:bg-inverted'

          }

        }

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

        carousel: {

          slots: {

            root: 'relative focus:outline-none',

            viewport: 'overflow-hidden',

            container: 'flex items-start',

            item: 'min-w-0 shrink-0 basis-full',

            controls: '',

            arrows: '',

            prev: 'absolute rounded-full',

            next: 'absolute rounded-full',

            dots: 'absolute inset-x-0 -bottom-7 flex flex-wrap items-center justify-center gap-3',

            dot: [

              'cursor-pointer size-3 bg-accented rounded-full focus:outline-none focus-visible:ring-2 focus-visible:ring-primary',

              'transition'

            ]

          },

          variants: {

            orientation: {

              vertical: {

                container: 'flex-col -mt-4',

                item: 'pt-4',

                prev: 'top-4 sm:-top-12 left-1/2 -translate-x-1/2 rotate-90 rtl:-rotate-90',

                next: 'bottom-4 sm:-bottom-12 left-1/2 -translate-x-1/2 rotate-90 rtl:-rotate-90'

              },

              horizontal: {

                container: 'flex-row -ms-4',

                item: 'ps-4',

                prev: 'start-4 sm:-start-12 top-1/2 -translate-y-1/2',

                next: 'end-4 sm:-end-12 top-1/2 -translate-y-1/2'

              }

            },

            active: {

              true: {

                dot: 'data-[state=active]:bg-inverted'

              }

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`cc90f`](https://github.com/nuxt/ui/commit/cc90fb818caf1796c71f9e55f200a299a17f2875) — fix: improve dots focus styles

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`36a78`](https://github.com/nuxt/ui/commit/36a7861afa95a6cb165899be443bf9ad66bfc530) — fix: consistent stopOnInteraction behavior ([#5489](https://github.com/nuxt/ui/issues/5489))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`a9fe7`](https://github.com/nuxt/ui/commit/a9fe7c61f43feb0639e8d0546496a51c993c05fe) — fix: add missing `data-orientation` for consistency

[`fde53`](https://github.com/nuxt/ui/commit/fde53ee3cbeb9aaed4314aafc90f325273a00c3a) — fix: invert arrow keys in RTL direction ([#5072](https://github.com/nuxt/ui/issues/5072))

[`788d2`](https://github.com/nuxt/ui/commit/788d2deb53b2a96c8d87828629b3d5d5ec5187d6) — fix: standardize naming for type interfaces ([#4990](https://github.com/nuxt/ui/issues/4990))

[`fd6a6`](https://github.com/nuxt/ui/commit/fd6a6bb6b72c1a014531c3bea693076079b210be) — chore: use tsdoc `@see` instead of `@link`

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`55e06`](https://github.com/nuxt/ui/commit/55e06e97e7739d7f08cfd15425a4be10596e6d6a) — fix: improve accessibility

[`fc24e`](https://github.com/nuxt/ui/commit/fc24e03cc4b0d38dd4f64d739eeaf18de5e744e0) — fix: add type to button elements for accessibility ([#4493](https://github.com/nuxt/ui/issues/4493))

[`1ba8a`](https://github.com/nuxt/ui/commit/1ba8a55bcb7220500a20864ea99c93bdfca82ee5) — fix: add `aria-current` attribute to active dot ([#4447](https://github.com/nuxt/ui/issues/4447))

[`3b67d`](https://github.com/nuxt/ui/commit/3b67d54833462760406786d9ba8a18eea2a8bde0) — fix: resolve plugins with page transitions ([#4380](https://github.com/nuxt/ui/issues/4380))

[`be41a`](https://github.com/nuxt/ui/commit/be41aed1f3d3476801e1840dbb8766926bc93c05) — fix: remove default `md` size on buttons ([#4357](https://github.com/nuxt/ui/issues/4357))

[`2ee1c`](https://github.com/nuxt/ui/commit/2ee1c5ac2e20ab9ce2f4037a8e8c64e561b0428b) — feat: allow customization of active dot color ([#4229](https://github.com/nuxt/ui/issues/4229))

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`22edf`](https://github.com/nuxt/ui/commit/22edfd708ae3eeadbd4ff6c830cdfd5632948286) — feat: add `select` event ([#3678](https://github.com/nuxt/ui/issues/3678))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`d339d`](https://github.com/nuxt/ui/commit/d339dcbfb8fe244bd198d247d8448e3ef856dfef) — fix: move arrows inside container on mobile

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))[Accordion](https://ui.nuxt.com/docs/components/accordion)

[

A stacked set of collapsible panels.

](https://ui.nuxt.com/docs/components/accordion)[

Empty

A component to display an empty state.

](https://ui.nuxt.com/docs/components/empty)