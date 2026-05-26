/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions/v2";
// import { onRequest } from "firebase-functions/https";
// import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({
  maxInstances: 10,
  region: "europe-west1",
});

// Admin Functions
import { createCompany } from "./admin/create-company";
export const admin_createCompany = createCompany;

// The MercuryEngine domain has been migrated to a standalone Cloud Run container
// inside packages/mercury-engine

// =============================================================================
// Events - Event Management
// =============================================================================
export {
  createEvent as events_create,
  updateEvent as events_update,
  deleteEvent as events_delete,
  getEvent as events_get,
  listEvents as events_list,
} from "./events";

// =============================================================================
// ServiceGroups - Service Group Management
// =============================================================================
export {
  createServiceGroup as serviceGroups_create,
  updateServiceGroup as serviceGroups_update,
  deleteServiceGroup as serviceGroups_delete,
  listServiceGroups as serviceGroups_list,
} from "./serviceGroups";

// =============================================================================
// Resources - Resource & ResourceGroup Management
// =============================================================================
export {
  createResource as resources_create,
  updateResource as resources_update,
  deleteResource as resources_delete,
  createResourceGroup as resourceGroups_create,
  updateResourceGroup as resourceGroups_update,
  deleteResourceGroup as resourceGroups_delete,
} from "./resources";

// =============================================================================
// Favorites - Firestore Triggers for favoritesCount
// =============================================================================
export {
  onFavoriteCreated as favorites_onCreated,
  onFavoriteDeleted as favorites_onDeleted,
} from "./favorites";

// =============================================================================
// Categories - Firestore Triggers for category store counts
// =============================================================================
export {
  onStoreWritten as categories_onStoreWritten,
  recountCategories as categories_recount,
} from "./categories";

// =============================================================================
// Staff Lifecycle — Claims Management & Auth Triggers
// =============================================================================
export { claimInvite as staff_claimInvite } from "./staff/claim-invite";
export { onStaffStatusChange as staff_onStatusChange } from "./staff/on-staff-status-change";
export { onStaffCreated as staff_onCreated } from "./staff/on-staff-created";
export { resendStaffInvite as staff_resendInvite } from "./staff/resend-invite";
export { onAuthUserCreated as auth_onUserCreated } from "./staff/on-auth-create";

// =============================================================================
// Notifications — User-scoped notification triggers
// =============================================================================
export { onBookingCreated as notifications_onBookingCreated } from "./notifications";

// =============================================================================
// Analytics — Search event logging
// =============================================================================
export { logSearchEvent as analytics_logSearchEvent } from "./analytics/log-search-event";

// =============================================================================
// Feedback — User & business feedback submission
// =============================================================================
export { submitFeedback as feedback_submit } from "./feedback";

