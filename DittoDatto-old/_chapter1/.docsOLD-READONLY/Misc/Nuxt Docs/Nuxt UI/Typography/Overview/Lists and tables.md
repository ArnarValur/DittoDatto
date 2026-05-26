# Lists and tables

> Organize information with styled lists and responsive tables for clear, consistent readability.

## Lists

Markdown supports unordered, ordered, and nested lists for various content needs.

### Unordered lists

Use unordered lists for items without a specific sequence. Start each item with a `-` symbol.

<tabs className="gap-0">
<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full" label="Preview">

- I'm a list item.
- I'm another list item.
- I'm the last list item.

<template v-slot:code="">

```mdc
- I'm a list item.
- I'm another list item.
- I'm the last list item.
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      ul: {
        base: 'list-disc ps-6 my-5 marker:text-(--ui-border-accented)'
      }
    }
  }
})
```

</tabs>

### Ordered lists

Use ordered lists when item order matters, like steps in a process. Start each item with a number.

<tabs className="gap-0">
<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full" label="Preview">

1. I'm a list item.
2. I'm another list item.
3. I'm the last list item.

<template v-slot:code="">

```mdc
1. I'm a list item.
2. I'm another list item.
3. I'm the last list item.
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      ol: {
        base: 'list-decimal ps-6 my-5 marker:text-muted'
      }
    }
  }
})
```

</tabs>

### Nested lists

Create hierarchical lists with sub-items for complex structures. Indent sub-items by four spaces for nesting.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">

- I'm a list item.

  - I'm a nested list item.
  - I'm another nested list item.
- I'm another list item.

  - Another nested item
    - Deep nested item
    - Another deep nested item
  - Back to second level

<template v-slot:code="">

```mdc
- I'm a list item.
  - I'm a nested list item.
  - I'm another nested list item.
- I'm another list item.
  - Another nested item
    - Deep nested item
    - Another deep nested item
  - Back to second level
```

</template>
</code-preview>

### Mixed lists

You can combine ordered and unordered lists for complex hierarchies.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">

1. First major step
  - Sub-requirement A
  - Sub-requirement B
2. Second major step
  - Another sub-item
  - Final sub-item
3. Final step

<template v-slot:code="">

```mdc
1. First major step
   - Sub-requirement A
   - Sub-requirement B
2. Second major step
   - Another sub-item
   - Final sub-item
3. Final step
```

</template>
</code-preview>

## Tables

Present structured data in rows and columns clearly. Tables are ideal for comparing data or listing properties.

<tabs className="gap-0">
<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full" label="Preview">
<table>
<thead>
  <tr>
    <th>
      Prop
    </th>
    
    <th>
      Default
    </th>
    
    <th>
      Type
    </th>
  </tr>
</thead>

<tbody>
  <tr>
    <td>
      <code>
        name
      </code>
    </td>
    
    <td>
      
    </td>
    
    <td>
      <code className="language-ts-type shiki shiki-themes material-theme-lighter material-theme material-theme-palenight" language="ts-type" style="">
        <span class="sBMFI">
          string
        </span>
      </code>
    </td>
  </tr>
  
  <tr>
    <td>
      <code>
        size
      </code>
    </td>
    
    <td>
      <code>
        md
      </code>
    </td>
    
    <td>
      <code className="language-ts-type shiki shiki-themes material-theme-lighter material-theme material-theme-palenight" language="ts-type" style="">
        <span class="sBMFI">
          string
        </span>
      </code>
    </td>
  </tr>
  
  <tr>
    <td>
      <code>
        color
      </code>
    </td>
    
    <td>
      <code>
        neutral
      </code>
    </td>
    
    <td>
      <code className="language-ts-type shiki shiki-themes material-theme-lighter material-theme material-theme-palenight" language="ts-type" style="">
        <span class="sBMFI">
          string
        </span>
      </code>
    </td>
  </tr>
</tbody>
</table>

<template v-slot:code="">

```mdc
| Prop    | Default   | Type                     |
|---------|-----------|--------------------------|
| `name`  |           | `string`{lang="ts-type"} |
| `size`  | `md`      | `string`{lang="ts-type"} |
| `color` | `neutral` | `string`{lang="ts-type"} |
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      table: {
        slots: {
          root: 'relative my-5 overflow-x-auto',
          base: 'w-full border-separate border-spacing-0 rounded-md'
        }
      }
    }
  }
})
```

</tabs>
