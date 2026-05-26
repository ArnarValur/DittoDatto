---
title: "<NuxtTime> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-time"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <NuxtTime>

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/nuxt-time.vue)

The <NuxtTime> component displays time in a locale-friendly format with server-client consistency.

This component is available in Nuxt v3.17+.

The `<NuxtTime>` component lets you display dates and times in a locale-friendly format with proper `<time>` HTML semantics. It ensures consistent rendering between server and client without hydration mismatches.

## Usage

You can use the `<NuxtTime>` component anywhere in your app:

```
<template>

  <NuxtTime :datetime="Date.now()" />

</template>
```

## Props

### datetime

- Type: `Date | number | string`
- Required: `true`

The date and time value to display. You can provide:

- A `Date` object
- A timestamp (number)
- An ISO-formatted date string

```
<template>

  <NuxtTime :datetime="Date.now()" />

  <NuxtTime :datetime="new Date()" />

  <NuxtTime datetime="2023-06-15T09:30:00.000Z" />

</template>
```

### locale

- Type: `string`
- Required: `false`
- Default: Uses the browser or server's default locale

The [BCP 47 language tag](https://datatracker.ietf.org/doc/html/rfc5646) for formatting (e.g., 'en-US', 'fr-FR', 'ja-JP'):

```
<template>

  <NuxtTime

    :datetime="Date.now()"

    locale="fr-FR"

  />

</template>
```

### Formatting Props

The component accepts any property from the [Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat) options:

```
<template>

  <NuxtTime

    :datetime="Date.now()"

    year="numeric"

    month="long"

    day="numeric"

    hour="2-digit"

    minute="2-digit"

  />

</template>
```

This would output something like: "April 22, 2025, 08:30 AM"

### relative

- Type: `boolean`
- Required: `false`
- Default: `false`

Enables relative time formatting using the Intl.RelativeTimeFormat API:

```
<template>

  <!-- Shows something like "5 minutes ago" -->

  <NuxtTime

    :datetime="Date.now() - 5 * 60 * 1000"

    relative

  />

</template>
```

### Relative Time Formatting Props

When `relative` is set to `true`, the component also accepts properties from [Intl.RelativeTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/RelativeTimeFormat/RelativeTimeFormat):

Due to `style` being a reserved prop, `relativeStyle` prop is used instead.

```
<template>

  <NuxtTime

    :datetime="Date.now() - 3 * 24 * 60 * 60 * 1000"

    relative

    numeric="auto"

    relative-style="long"

  />

</template>
```

This would output something like: "3 days ago" or "last Friday" depending on the `numeric` setting.

## Examples

### Basic Usage

```
<template>

  <NuxtTime :datetime="Date.now()" />

</template>
```

### Custom Formatting

```
<template>

  <NuxtTime

    :datetime="Date.now()"

    weekday="long"

    year="numeric"

    month="short"

    day="numeric"

    hour="numeric"

    minute="numeric"

    second="numeric"

    time-zone-name="short"

  />

</template>
```

### Relative Time

```
<template>

  <div>

    <p>

      <NuxtTime

        :datetime="Date.now() - 30 * 1000"

        relative

      />

      <!-- 30 seconds ago -->

    </p>

    <p>

      <NuxtTime

        :datetime="Date.now() - 45 * 60 * 1000"

        relative

      />

      <!-- 45 minutes ago -->

    </p>

    <p>

      <NuxtTime

        :datetime="Date.now() + 2 * 24 * 60 * 60 * 1000"

        relative

      />

      <!-- in 2 days -->

    </p>

  </div>

</template>
```

### With Custom Locale

```
<template>

  <div>

    <NuxtTime

      :datetime="Date.now()"

      locale="en-US"

      weekday="long"

    />

    <NuxtTime

      :datetime="Date.now()"

      locale="fr-FR"

      weekday="long"

    />

    <NuxtTime

      :datetime="Date.now()"

      locale="ja-JP"

      weekday="long"

    />

  </div>

</template>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/13.nuxt-time.md)[<NuxtRouteAnnouncer>](https://nuxt.com/docs/4.x/api/components/nuxt-route-announcer)

[

The <NuxtRouteAnnouncer> component adds a hidden element with the page title to announce route changes to assistive technologies.

](https://nuxt.com/docs/4.x/api/components/nuxt-route-announcer)[

<NuxtPage>

The <NuxtPage> component is required to display pages located in the pages/ directory.

](https://nuxt.com/docs/4.x/api/components/nuxt-page)