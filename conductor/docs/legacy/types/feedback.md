---
schema: FeedbackSchema, SubmitFeedbackSchema
domain_term: Feedback
firestore_path: feedback/{feedbackId}
status: active
version: v1.0
related: [user]
noona_equivalent: N/A
tags: [platform, admin-panel]
---

# Feedback

User-submitted feedback, support requests, bug reports, and business inquiries. A flat, AI-friendly schema designed for future Datto-powered triage and response.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `senderId` | `string` | ❌ | User ID (if logged in) |
| `senderEmail` | `string (email)` | ✅ | Sender's email |
| `senderName` | `string` | ✅ | Sender's name |
| `source` | `enum` | ✅ | `public_contact`, `public_feedback`, `portal_feedback`, `portal_support`, `business_inquiry` |
| `category` | `enum` | ✅ | `general`, `bug`, `feature_request`, `ux_issue`, `compliment`, `question`. Default: `"general"` |
| `subject` | `string` | ❌ | Subject line (max 200 chars) |
| `body` | `string` | ✅ | Feedback content (1–2000 chars) |
| `metadata` | `object` | ❌ | Auto-captured: `url`, `userAgent`, `viewport`, `appVersion` |
| `status` | `enum` | ✅ | `new`, `read`, `in_progress`, `resolved`, `archived`. Default: `"new"` |
| `priority` | `enum: low, medium, high` | ❌ | Admin-set priority |
| `tags` | `string[]` | ❌ | Admin-applied tags |
| `adminNotes` | `string` | ❌ | Internal admin notes |
| `createdAt` | `Timestamp` | ✅ | Submission timestamp |
| `updatedAt` | `Timestamp` | ❌ | Last modification |

## Design Notes

- **Sources** distinguish where feedback came from: public contact form, logged-in user feedback, portal support request, business inquiry.
- **`metadata`** auto-captures browser context for bug reports — URL, user agent, viewport, app version. Invaluable for reproduction.
- Flat schema (no threads) — for simple submissions. Complex back-and-forth uses the Thread/Message system in the Activity schema.
