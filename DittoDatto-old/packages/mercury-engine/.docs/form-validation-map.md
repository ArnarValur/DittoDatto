# Form Validation Map (Zod / UForm)

This document maps every form submission (`v-model` + `submit`) across the `public-marketplace` and `business-portal` domains, explicitly identifying which forms implement Zod schema validation before hitting the server.

## 1. Public Marketplace (`apps/web/public-marketplace`)

### ✅ Forms with Zod Validation
These components utilize Nuxt UI's `<UForm>` bound to a Zod schema (`:schema="schema"`) to ensure payload validity before execution.

* **`app/pages/signup.vue`**
  * **Implementation:** `<UForm :schema="schema" :state="state" @submit="onEmailSubmit">`
  * **Schema:** Validates email formatting.
* **`app/pages/login.vue`**
  * **Implementation:** `<UForm :schema="schema" :state="state" @submit="onEmailSubmit">`
  * **Schema:** Validates email formatting.
* **`app/components/AuthLoginForm.vue`**
  * **Implementation:** `<UForm :schema="schema" :state="state" @submit="onSubmit">`
  * **Schema:** Validates email and password constraints (min length).

### ❌ Forms Missing Zod Validation
These components use standard HTML `<form>` or `<UForm>` without a bound `:schema`. Validation relies on manual checks or HTML5 constraints (`required`).

* **`app/pages/profile/settings.vue`**
  * **Implementation:** `<UForm :state="form" @submit.prevent="handleUpdate">`
  * **Issue:** Missing `:schema` prop.
* **`app/pages/contact.vue`**
  * **Implementation:** `<form @submit.prevent="handleSubmit">`
  * **Issue:** Standard HTML form. Manual validation.
* **`app/pages/for-business.vue`**
  * **Implementation:** `<form @submit.prevent="handleSubmit">`
  * **Issue:** Standard HTML form. Manual validation.
* **`app/components/booking/BookingChatSlideover.vue`**
  * **Implementation:** `<form @submit="handleSend">`
  * **Issue:** Standard HTML form.
* **`app/components/auth/PhoneOTPForm.vue`**
  * **Implementation:** Uses individual `UFormField` inputs.
  * **Issue:** Missing Zod validation wrapper.

---

## 2. Business Portal (`apps/web/business-portal`)

### ✅ Forms with Zod Validation
The portal makes extensive use of Zod-backed `<UForm>` components for CRUD operations.

* **`app/pages/settings/index.vue`**
  * `<UForm :schema="UserSchema.partial()" :state="state" @submit="onSubmit">`
* **`app/pages/index.vue`** (Login/Signup Flow)
  * `<UForm :schema="schema" :state="state" @submit="onEmailSubmit">`
* **`app/components/resources/ResourceGroupFormSlideover.vue`**
  * `<UForm :schema="FormSchema" :state="state" @submit="onSubmit">`
* **`app/components/resources/ResourceFormSlideover.vue`**
  * `<UForm :schema="FormSchema" :state="state" @submit="onSubmit">`
* **`app/components/staff/StaffFormSlideover.vue`**
  * `<UForm :schema="FormSchema" :state="state" @submit="onSubmit">` *(Schema adapts dynamically based on create/edit mode).*
* **`app/components/services/ServiceGroupFormSlideover.vue`**
  * `<UForm :schema="FormSchema" :state="state" @submit="onSubmit">`
* **`app/components/stores/StoreFormSlideover.vue`**
  * `<UForm :schema="FormSchema" :state="state" @submit="onSubmit">`
* **`app/components/services/ServiceFormSlideover.vue`**
  * `<UForm :schema="FormSchema" :state="state" @submit="onSubmit">`
* **`app/components/customers/CustomerProfileForm.vue`**
  * `<UForm :schema="formSchema" :state="state" @submit="onSubmit">`
* **`app/components/customers/AddModal.vue`**
  * `<UForm :schema="schema" :state="state" @submit="onSubmit">`
* **`app/components/events/EventFormSlideover.vue`**
  * `<UForm :schema="FormSchema" :state="state" @submit="onSubmit">`

### ❌ Forms Missing Zod Validation
These forms handle user inputs and submissions but lack strict Zod validation bindings.

* **`app/components/inbox/InboxMail.vue`**
  * **Implementation:** `<form @submit.prevent="onSubmit">`
  * **Issue:** Standard HTML form.
* **`app/components/FeedbackSlideover.vue`**
  * **Implementation:** `<form class="space-y-4" @submit.prevent="handleSubmit">`
  * **Issue:** Standard HTML form.
* **`app/pages/sandbox/activity-hub.vue`**
  * **Implementation:** Contains scattered `UFormField` usages.
  * **Issue:** No parent `<UForm>` with a validation schema.
* **`app/components/reservations/ReservationSlideover.vue`**
  * **Implementation:** Uses `UFormGroup` directly.
  * **Issue:** Lacks a structured schema validation wrapper before hitting the server.

---

## 3. Shared UI Package (`packages/ui`)

A thorough scan of `@packages/ui/components` reveals that while the package has `zod` as a dependency, there are **no form submission wrappers or components** (`<UForm>` or `<form>`) acting as a submission layer within the UI layer itself. All form submission logic is handled at the application level (Public Marketplace & Business Portal).