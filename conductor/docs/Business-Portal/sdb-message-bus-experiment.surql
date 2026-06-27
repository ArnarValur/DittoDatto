-- ============================================================================
-- SurrealDB Message Bus Experiment
-- ============================================================================
-- Purpose: Hands-on playground to test SurrealDB as DittoDatto's message bus.
-- Run against local SurrealDB: surreal start --user root --pass root memory
-- Connect: surreal sql --endpoint http://localhost:8000 --user root --pass root
--
-- Norwegian test data:
--   Company: "Salong Krøll" (hair salon in Drammen)
--   Staff: Lars Hansen (barber), Ingrid Solberg (stylist)
--   Customers: Kari Nordmann, Erik Johansen
--   Services: Hårklipp, Farge & Klipp
-- ============================================================================


-- ============================================================================
-- STEP 1: Namespace & Database Setup
-- ============================================================================
-- Simulates the company-per-DB multi-tenant model.

USE NS companies DB company_salong_kroll;


-- ============================================================================
-- STEP 2: Core Schema — Message Thread + Message
-- ============================================================================
-- Extended from company-blueprint.surql with fields from comms research.

-- Establishment (simplified for experiment)
DEFINE TABLE establishment SCHEMAFULL;
DEFINE FIELD name     ON establishment TYPE string;
DEFINE FIELD address  ON establishment TYPE string;
DEFINE FIELD phone    ON establishment TYPE string;
CREATE establishment:main SET
  name = "Salong Krøll",
  address = "Skolegata 9, Drammen 3046",
  phone = "92913093";

-- Staff (simplified)
DEFINE TABLE staff SCHEMAFULL;
DEFINE FIELD name  ON staff TYPE string;
DEFINE FIELD email ON staff TYPE string;
DEFINE FIELD role  ON staff TYPE string;
CREATE staff:lars SET name = "Lars Hansen", email = "lars@salongkroll.no", role = "barber";
CREATE staff:ingrid SET name = "Ingrid Solberg", email = "ingrid@salongkroll.no", role = "stylist";

-- Customers
DEFINE TABLE customer SCHEMAFULL;
DEFINE FIELD name            ON customer TYPE string;
DEFINE FIELD email           ON customer TYPE string;
DEFINE FIELD phone           ON customer TYPE option<string>;
DEFINE FIELD user_id         ON customer TYPE option<string>;  -- cross-DB ref to users/users
DEFINE FIELD status          ON customer TYPE string DEFAULT "active";
DEFINE FIELD total_visits    ON customer TYPE int DEFAULT 0;
DEFINE FIELD last_visit_at   ON customer TYPE option<datetime>;
CREATE customer:kari SET
  name = "Kari Nordmann",
  email = "kari@example.no",
  phone = "+4741234567",
  user_id = "user_kari_001";
CREATE customer:erik SET
  name = "Erik Johansen",
  email = "erik@example.no",
  phone = "+4798765432",
  user_id = "user_erik_002";

-- Services (simplified)
DEFINE TABLE service SCHEMAFULL;
DEFINE FIELD name     ON service TYPE string;
DEFINE FIELD duration ON service TYPE int;  -- minutes
DEFINE FIELD price    ON service TYPE int;  -- NOK
CREATE service:harklipp SET name = "Hårklipp", duration = 30, price = 450;
CREATE service:farge_klipp SET name = "Farge & Klipp", duration = 90, price = 1200;


-- ============================================================================
-- STEP 3: Message Thread & Message Tables
-- ============================================================================

DEFINE TABLE message_thread SCHEMAFULL CHANGEFEED 7d;
DEFINE FIELD establishment   ON message_thread TYPE record<establishment>;
DEFINE FIELD customer        ON message_thread TYPE record<customer>;
DEFINE FIELD subject         ON message_thread TYPE option<string>;
DEFINE FIELD status          ON message_thread TYPE string DEFAULT "open"
  ASSERT $value IN ["open", "closed", "archived"];
DEFINE FIELD unread_count    ON message_thread TYPE int DEFAULT 0;
DEFINE FIELD last_message    ON message_thread TYPE option<string>;
DEFINE FIELD last_message_at ON message_thread TYPE option<datetime>;
DEFINE FIELD created_at      ON message_thread TYPE datetime VALUE $value OR time::now();
DEFINE FIELD updated_at      ON message_thread TYPE datetime VALUE time::now();

-- Indexes for inbox queries
DEFINE INDEX idx_thread_est     ON message_thread FIELDS establishment;
DEFINE INDEX idx_thread_cust    ON message_thread FIELDS customer;
DEFINE INDEX idx_thread_updated ON message_thread FIELDS updated_at;

DEFINE TABLE message SCHEMAFULL CHANGEFEED 7d;
DEFINE FIELD thread       ON message TYPE record<message_thread>;
DEFINE FIELD sender_type  ON message TYPE string
  ASSERT $value IN ["customer", "staff", "datto", "ditto", "system"];
DEFINE FIELD sender_id    ON message TYPE string;       -- user_id or staff record or "datto"
DEFINE FIELD sender_name  ON message TYPE string;       -- display name snapshot
DEFINE FIELD body         ON message TYPE string;
DEFINE FIELD message_type ON message TYPE string DEFAULT "text"
  ASSERT $value IN ["text", "booking_confirmation", "reminder", "system", "marketing"];
DEFINE FIELD metadata     ON message TYPE option<object> FLEXIBLE;  -- structured payload
DEFINE FIELD read_at      ON message TYPE option<datetime>;
DEFINE FIELD created_at   ON message TYPE datetime VALUE $value OR time::now();

DEFINE INDEX idx_msg_thread ON message FIELDS thread;


-- ============================================================================
-- STEP 4: DEFINE EVENT — Auto-Update Thread on New Message
-- ============================================================================
-- When a message is created, update the thread's preview and unread count.
-- This is the core "event chain" that makes the inbox feel real-time.

DEFINE EVENT on_message_created ON TABLE message
  ASYNC
  WHEN $event = "CREATE"
  THEN {
    UPDATE $after.thread SET
      updated_at = time::now(),
      last_message = string::slice($after.body, 0, 100),
      last_message_at = time::now(),
      unread_count += 1;
  };


-- ============================================================================
-- STEP 5: Notification Schedule Table
-- ============================================================================
-- Side-effect target: booking events auto-create notification schedules.
-- MercuryEngine would poll this table and call Sveve/MailerSend.

DEFINE TABLE notification_schedule SCHEMAFULL;
DEFINE FIELD type        ON notification_schedule TYPE string
  ASSERT $value IN ["sms_reminder", "email_confirmation", "push"];
DEFINE FIELD channel     ON notification_schedule TYPE string
  ASSERT $value IN ["sms", "email", "push"];
DEFINE FIELD recipient   ON notification_schedule TYPE string;  -- phone or email
DEFINE FIELD body        ON notification_schedule TYPE string;
DEFINE FIELD send_at     ON notification_schedule TYPE datetime;
DEFINE FIELD status      ON notification_schedule TYPE string DEFAULT "pending"
  ASSERT $value IN ["pending", "sent", "failed", "cancelled"];
DEFINE FIELD booking     ON notification_schedule TYPE option<string>;
DEFINE FIELD thread      ON notification_schedule TYPE option<record<message_thread>>;
DEFINE FIELD created_at  ON notification_schedule TYPE datetime VALUE time::now();

DEFINE INDEX idx_notif_status  ON notification_schedule FIELDS status;
DEFINE INDEX idx_notif_send_at ON notification_schedule FIELDS send_at;


-- ============================================================================
-- STEP 6: Booking Table with Event Chain
-- ============================================================================
-- Simplified booking → auto-creates confirmation message + SMS reminder.

DEFINE TABLE booking SCHEMAFULL;
DEFINE FIELD customer      ON booking TYPE record<customer>;
DEFINE FIELD service       ON booking TYPE record<service>;
DEFINE FIELD staff         ON booking TYPE option<record<staff>>;
DEFINE FIELD establishment ON booking TYPE record<establishment>;
DEFINE FIELD starts_at     ON booking TYPE datetime;
DEFINE FIELD status        ON booking TYPE string DEFAULT "confirmed";
DEFINE FIELD created_at    ON booking TYPE datetime VALUE time::now();

-- EVENT CHAIN: booking created → system message + SMS reminder
DEFINE EVENT on_booking_created ON TABLE booking
  ASYNC
  WHEN $event = "CREATE"
  THEN {
    -- 1. Find or create message thread for this customer+establishment
    LET $threads = SELECT * FROM message_thread
      WHERE customer = $after.customer
        AND establishment = $after.establishment
      LIMIT 1;

    LET $thread = IF array::len($threads) > 0 {
      $threads[0].id
    } ELSE {
      (CREATE message_thread SET
        customer = $after.customer,
        establishment = $after.establishment,
        subject = "Bestillinger"
      ).id
    };

    -- 2. Create a system confirmation message in the thread
    LET $svc = (SELECT name, price FROM $after.service)[0];
    LET $staff_name = (SELECT name FROM $after.staff)[0].name;
    CREATE message SET
      thread = $thread,
      sender_type = "system",
      sender_id = "system",
      sender_name = "Salong Krøll",
      message_type = "booking_confirmation",
      body = string::concat(
        "✅ Bestilling bekreftet!\n",
        "Tjeneste: ", $svc.name, "\n",
        "Med: ", $staff_name, "\n",
        "Pris: ", <string>$svc.price, " NOK"
      ),
      metadata = {
        intent: "booking_confirmation",
        booking_id: <string>$after.id,
        service: $svc.name,
        staff: $staff_name,
        starts_at: <string>$after.starts_at
      };

    -- 3. Schedule SMS reminder for 24h before appointment
    LET $cust = (SELECT phone, name FROM $after.customer)[0];
    CREATE notification_schedule SET
      type = "sms_reminder",
      channel = "sms",
      recipient = $cust.phone,
      body = string::concat(
        "Hei ", $cust.name,
        "! Påminnelse: Du har time hos Salong Krøll i morgen. Velkommen! 💇"
      ),
      send_at = $after.starts_at - 24h,
      status = "pending",
      booking = <string>$after.id;
  };


-- ============================================================================
-- STEP 7: Create Test Data — Threads and Messages
-- ============================================================================
-- Observe: the DEFINE EVENT will auto-update thread metadata.

-- Thread between Kari and the salon
CREATE message_thread:kari_thread SET
  establishment = establishment:main,
  customer = customer:kari,
  subject = "Hårklipp bestilling";

-- Kari sends a message
CREATE message:msg_001 SET
  thread = message_thread:kari_thread,
  sender_type = "customer",
  sender_id = "user_kari_001",
  sender_name = "Kari Nordmann",
  body = "Hei! Kan jeg bestille hårklipp på tirsdag kl 15?";

-- OBSERVE: Check that the thread was auto-updated by the event:
SELECT id, last_message, last_message_at, unread_count FROM message_thread:kari_thread;
-- Expected: last_message = "Hei! Kan jeg bestille hårklipp...", unread_count = 1

-- Staff responds
CREATE message:msg_002 SET
  thread = message_thread:kari_thread,
  sender_type = "staff",
  sender_id = "staff:lars",
  sender_name = "Lars Hansen",
  body = "Hei Kari! Ja, kl 15 på tirsdag passer fint. Jeg booker deg inn! 😊";

-- OBSERVE: unread_count should now be 2 (both messages increment it)
SELECT id, last_message, unread_count FROM message_thread:kari_thread;


-- ============================================================================
-- STEP 8: Agent Message Demo — Datto Handles a Request
-- ============================================================================
-- Datto reads the customer message and auto-responds with availability.

CREATE message:msg_003 SET
  thread = message_thread:kari_thread,
  sender_type = "datto",
  sender_id = "datto",
  sender_name = "Datto 🤖",
  message_type = "text",
  body = "Hei Kari! Jeg sjekker ledige tider for deg... Tirsdag kl 15 er ledig hos Lars. Skal jeg booke? 🗓️",
  metadata = {
    intent: "check_availability",
    service_id: "service:harklipp",
    preferred_times: ["2026-07-01T15:00:00Z"],
    available_slots: [
      { staff: "staff:lars", time: "2026-07-01T15:00:00Z", available: true },
      { staff: "staff:ingrid", time: "2026-07-01T15:00:00Z", available: false },
      { staff: "staff:lars", time: "2026-07-01T16:00:00Z", available: true }
    ],
    a2a_task_id: "task_booking_001",
    a2a_status: "awaiting_confirmation"
  };

-- OBSERVE: The message has both human-readable body AND machine-readable metadata
SELECT sender_type, sender_name, body, metadata FROM message:msg_003;


-- ============================================================================
-- STEP 9: Booking Event Chain Demo
-- ============================================================================
-- Create a booking and watch the event chain fire.
-- Expected chain: booking → system message in thread → SMS reminder scheduled

CREATE booking:b001 SET
  customer = customer:kari,
  service = service:harklipp,
  staff = staff:lars,
  establishment = establishment:main,
  starts_at = d"2026-07-01T15:00:00Z";

-- OBSERVE: A new system message should appear in Kari's thread
SELECT sender_type, sender_name, message_type, body, metadata
  FROM message
  WHERE thread = message_thread:kari_thread
    AND message_type = "booking_confirmation";

-- OBSERVE: An SMS reminder should be scheduled
SELECT type, channel, recipient, body, send_at, status
  FROM notification_schedule
  WHERE status = "pending";


-- ============================================================================
-- STEP 10: LIVE SELECT Demo
-- ============================================================================
-- Run these in a SEPARATE terminal/connection to see real-time updates.
-- Then create new messages in the first terminal and watch them appear.

-- Subscribe to new messages in Kari's thread:
-- LIVE SELECT * FROM message WHERE thread = message_thread:kari_thread;

-- Subscribe to thread list updates (inbox view):
-- LIVE SELECT * FROM message_thread WHERE establishment = establishment:main;

-- Subscribe with DIFF for bandwidth efficiency:
-- LIVE SELECT DIFF FROM message_thread WHERE establishment = establishment:main;

-- Then in your first terminal, create a new message:
-- CREATE message SET
--   thread = message_thread:kari_thread,
--   sender_type = "customer",
--   sender_id = "user_kari_001",
--   sender_name = "Kari Nordmann",
--   body = "Perfekt! Takk for hjelpen! 🙏";
--
-- Watch the LIVE SELECT terminal — you should see the message appear instantly.


-- ============================================================================
-- STEP 11: Changefeed Demo
-- ============================================================================
-- Read all message changes since the beginning of this experiment.
-- This is what MercuryEngine would poll for cross-namespace sync + notifications.

SHOW CHANGES FOR TABLE message SINCE d"2026-06-01T00:00:00Z" LIMIT 50;

-- OBSERVE: Every message CREATE is listed in order.
-- In production, MercuryEngine would track the versionstamp and poll:
-- SHOW CHANGES FOR TABLE message SINCE <last_versionstamp> LIMIT 100;


-- ============================================================================
-- STEP 12: Second Customer — Erik's Thread
-- ============================================================================
-- Demonstrates multiple threads, multiple customers.

CREATE message_thread:erik_thread SET
  establishment = establishment:main,
  customer = customer:erik,
  subject = "Farge & Klipp forespørsel";

CREATE message:msg_erik_001 SET
  thread = message_thread:erik_thread,
  sender_type = "customer",
  sender_id = "user_erik_002",
  sender_name = "Erik Johansen",
  body = "Hei! Jeg lurer på om Ingrid har ledig tid for farge og klipp denne uken?";

-- OBSERVE: Both threads exist in the inbox
SELECT id, customer, subject, last_message, unread_count, updated_at
  FROM message_thread
  WHERE establishment = establishment:main
  ORDER BY updated_at DESC;


-- ============================================================================
-- STEP 13: Permission Demo (RECORD ACCESS)
-- ============================================================================
-- Demonstrates row-level security: customers only see their own threads.
-- NOTE: To test this properly, you need to define access and sign in as a customer.

-- Define customer access on this database
-- DEFINE ACCESS customer_access ON DATABASE TYPE RECORD
--   SIGNUP (
--     CREATE customer SET
--       name = $name,
--       email = $email,
--       user_id = $user_id,
--       phone = $phone
--   )
--   SIGNIN (
--     SELECT * FROM customer WHERE user_id = $user_id AND email = $email
--   )
--   DURATION FOR TOKEN 1h, FOR SESSION 24h;
--
-- -- Add permissions to message_thread
-- DEFINE TABLE message_thread PERMISSIONS
--   FOR select WHERE customer = $auth.id
--   FOR create WHERE customer = $auth.id
--   FOR update, delete NONE;
--
-- -- Add permissions to message
-- DEFINE TABLE message PERMISSIONS
--   FOR select WHERE thread.customer = $auth.id
--   FOR create WHERE sender_type = 'customer' AND thread.customer = $auth.id
--   FOR update, delete NONE;
--
-- -- Sign in as Kari:
-- SIGNIN { user_id: "user_kari_001", email: "kari@example.no" };
-- -- Now: SELECT * FROM message_thread; → only Kari's thread
-- -- Erik's thread is invisible!


-- ============================================================================
-- STEP 14: Platform Feedback Demo (Registry Namespace)
-- ============================================================================
-- Feedback lives in the registry DB, not company DBs.

USE NS companies DB registry;

DEFINE TABLE feedback SCHEMAFULL;
DEFINE FIELD subject        ON feedback TYPE string;
DEFINE FIELD body           ON feedback TYPE string;
DEFINE FIELD category       ON feedback TYPE string DEFAULT "general"
  ASSERT $value IN ["bug", "feature_request", "complaint", "support", "general"];
DEFINE FIELD source_app     ON feedback TYPE string
  ASSERT $value IN ["business_portal", "marketplace", "admin_panel"];
DEFINE FIELD submitter_id   ON feedback TYPE string;
DEFINE FIELD submitter_name ON feedback TYPE string;
DEFINE FIELD submitter_email ON feedback TYPE string;
DEFINE FIELD company_slug   ON feedback TYPE option<string>;
DEFINE FIELD status         ON feedback TYPE string DEFAULT "new"
  ASSERT $value IN ["new", "acknowledged", "in_progress", "resolved", "closed"];
DEFINE FIELD priority       ON feedback TYPE string DEFAULT "normal"
  ASSERT $value IN ["low", "normal", "high", "urgent"];
DEFINE FIELD created_at     ON feedback TYPE datetime VALUE $value OR time::now();
DEFINE FIELD updated_at     ON feedback TYPE datetime VALUE time::now();

DEFINE TABLE feedback_response SCHEMAFULL;
DEFINE FIELD feedback       ON feedback_response TYPE record<feedback>;
DEFINE FIELD responder_name ON feedback_response TYPE string;
DEFINE FIELD body           ON feedback_response TYPE string;
DEFINE FIELD is_internal    ON feedback_response TYPE bool DEFAULT false;
DEFINE FIELD created_at     ON feedback_response TYPE datetime VALUE $value OR time::now();

-- Lars submits a bug report from the Business Portal
CREATE feedback:fb_001 SET
  subject = "Bilder lastes ikke opp på Safari",
  body = "Når jeg prøver å laste opp bilder i media-galleriet fra Safari på Mac, skjer ingenting. Fungerer fint i Chrome.",
  category = "bug",
  source_app = "business_portal",
  submitter_id = "staff:lars",
  submitter_name = "Lars Hansen",
  submitter_email = "lars@salongkroll.no",
  company_slug = "salong_kroll",
  priority = "high";

-- Admin subscribes to feedback (in separate terminal):
-- LIVE SELECT * FROM feedback WHERE status IN ["new", "acknowledged", "in_progress"];

-- Admin responds
CREATE feedback_response:fbr_001 SET
  feedback = feedback:fb_001,
  responder_name = "Arnar (DittoDatto)",
  body = "Takk for rapporten, Lars! Vi har identifisert problemet — Safari håndterer file input annerledes. Fix kommer i neste deploy.";

-- Update ticket status
UPDATE feedback:fb_001 SET status = "in_progress";

-- OBSERVE: Full feedback lifecycle
SELECT id, subject, category, status, priority, submitter_name
  FROM feedback;


-- ============================================================================
-- SUMMARY: What You Just Tested
-- ============================================================================
--
-- ✅ message_thread + message schema with all CRM research fields
-- ✅ DEFINE EVENT auto-updating thread on new message (unread, preview)
-- ✅ Event chain: booking → system message → SMS reminder scheduled
-- ✅ Agent (Datto) message with structured metadata
-- ✅ Multi-customer threads (Kari + Erik)
-- ✅ CHANGEFEED for durable event replay
-- ✅ LIVE SELECT patterns (commented — run in separate terminal)
-- ✅ Permission model (commented — RECORD ACCESS demo)
-- ✅ Platform feedback in registry namespace
--
-- All of this runs on SurrealDB alone. No Kafka. No Redis. No RabbitMQ.
-- SDB is the source of everything. 🚀
