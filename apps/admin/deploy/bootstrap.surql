-- DittoDatto Admin Panel — SurrealDB Bootstrap
-- Run as root user against SurrealDB on Saturn.
--
-- Creates namespaces, databases, tables, namespace users, and seed data.
-- Idempotent: safe to re-run (DEFINE uses OVERWRITE implicitly in v3).

-- ═══════════════════════════════════════════════════
-- 1. Namespaces
-- ═══════════════════════════════════════════════════

DEFINE NAMESPACE IF NOT EXISTS companies;
DEFINE NAMESPACE IF NOT EXISTS users;

-- ═══════════════════════════════════════════════════
-- 2. Namespace Users (admin panel auth)
-- ═══════════════════════════════════════════════════
-- These are the credentials used by the Flutter admin panel.
-- ROLES OWNER grants full access to all databases in the namespace.

USE NS companies;
DEFINE USER arnar ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;
DEFINE USER hoddi ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;

USE NS users;
DEFINE USER arnar ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;
DEFINE USER hoddi ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;

-- ═══════════════════════════════════════════════════
-- 3. Databases
-- ═══════════════════════════════════════════════════

USE NS companies;
DEFINE DATABASE IF NOT EXISTS registry;
DEFINE DATABASE IF NOT EXISTS discovery;

USE NS users;
DEFINE DATABASE IF NOT EXISTS profiles;

-- ═══════════════════════════════════════════════════
-- 4. Table Schemas — users/profiles
-- ═══════════════════════════════════════════════════

USE NS users DB profiles;

DEFINE TABLE IF NOT EXISTS user SCHEMAFULL;
DEFINE FIELD name        ON TABLE user TYPE string;
DEFINE FIELD email       ON TABLE user TYPE string;
DEFINE FIELD phone       ON TABLE user TYPE option<string>;
DEFINE FIELD password_hash ON TABLE user TYPE option<string>;
DEFINE FIELD role        ON TABLE user TYPE string DEFAULT 'customer';
DEFINE FIELD company_slug ON TABLE user TYPE option<string>;
DEFINE FIELD vipps_sub   ON TABLE user TYPE option<string>;
DEFINE FIELD created_at  ON TABLE user TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at  ON TABLE user TYPE datetime DEFAULT time::now();

DEFINE INDEX idx_user_email ON TABLE user FIELDS email UNIQUE;

-- ═══════════════════════════════════════════════════
-- 5. Table Schemas — companies/registry
-- ═══════════════════════════════════════════════════

USE NS companies DB registry;

DEFINE TABLE IF NOT EXISTS company SCHEMAFULL;
DEFINE FIELD name               ON TABLE company TYPE string;
DEFINE FIELD slug               ON TABLE company TYPE string;
DEFINE FIELD description        ON TABLE company TYPE option<string>;
DEFINE FIELD email              ON TABLE company TYPE option<string>;
DEFINE FIELD phone              ON TABLE company TYPE option<string>;
DEFINE FIELD address            ON TABLE company TYPE option<string>;
DEFINE FIELD city               ON TABLE company TYPE option<string>;
DEFINE FIELD postal_code        ON TABLE company TYPE option<string>;
DEFINE FIELD country            ON TABLE company TYPE string DEFAULT 'NO';
DEFINE FIELD tier               ON TABLE company TYPE string DEFAULT 'free';
DEFINE FIELD onboarding_status  ON TABLE company TYPE string DEFAULT 'not_started';
DEFINE FIELD owner_email        ON TABLE company TYPE option<string>;
DEFINE FIELD social_links       ON TABLE company TYPE option<object>;
DEFINE FIELD store_policy       ON TABLE company TYPE option<object>;
DEFINE FIELD enabled_features   ON TABLE company TYPE option<object>;
DEFINE FIELD created_at         ON TABLE company TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at         ON TABLE company TYPE datetime DEFAULT time::now();

DEFINE INDEX idx_company_slug ON TABLE company FIELDS slug UNIQUE;

-- ═══════════════════════════════════════════════════
-- 6. Table Schemas — companies/discovery
-- ═══════════════════════════════════════════════════

USE NS companies DB discovery;

DEFINE TABLE IF NOT EXISTS category SCHEMAFULL;
DEFINE FIELD name        ON TABLE category TYPE string;
DEFINE FIELD slug        ON TABLE category TYPE string;
DEFINE FIELD description ON TABLE category TYPE option<string>;
DEFINE FIELD icon        ON TABLE category TYPE option<string>;
DEFINE FIELD count       ON TABLE category TYPE int DEFAULT 0;
DEFINE FIELD created_at  ON TABLE category TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at  ON TABLE category TYPE datetime DEFAULT time::now();

DEFINE INDEX idx_category_slug ON TABLE category FIELDS slug UNIQUE;

-- ═══════════════════════════════════════════════════
-- 7. Seed Data — Admin Users
-- ═══════════════════════════════════════════════════

USE NS users DB profiles;

CREATE user:arnar SET
  name = 'Arnar Valur',
  email = 'arnar@dittodatto.no',
  phone = '+47 900 12 345',
  role = 'super_admin',
  password_hash = crypto::argon2::generate('admin123');

CREATE user:hoddi SET
  name = 'Höddi Jónsson',
  email = 'hoddi@dittodatto.no',
  phone = '+47 900 23 456',
  role = 'admin',
  password_hash = crypto::argon2::generate('admin123');

-- Business users
CREATE user:ingrid SET
  name = 'Ingrid Pedersen',
  email = 'ingrid@frisorsalongen.no',
  phone = '+47 901 34 567',
  role = 'business',
  company_slug = 'frisorsalongen';

CREATE user:ole SET
  name = 'Ole Hansen',
  email = 'ole@drammen-treningssenter.no',
  phone = '+47 902 45 678',
  role = 'business',
  company_slug = 'drammen-treningssenter';

CREATE user:kari SET
  name = 'Kari Nordström',
  email = 'kari@hotell-nordre.no',
  role = 'business',
  company_slug = 'hotell-nordre';

CREATE user:lars SET
  name = 'Lars Berge',
  email = 'lars@berge-bygg.no',
  phone = '+47 903 56 789',
  role = 'business',
  company_slug = 'berge-bygg';

-- Customer users
CREATE user:marte SET
  name = 'Marte Eriksen',
  email = 'marte.eriksen@gmail.com',
  role = 'customer';

CREATE user:erik SET
  name = 'Erik Svendsen',
  email = 'erik.s@outlook.com',
  phone = '+47 904 67 890',
  role = 'customer';

CREATE user:sofie SET
  name = 'Sofie Andersen',
  email = 'sofie.a@proton.me',
  role = 'customer';

CREATE user:jonas SET
  name = 'Jonas Lie',
  email = 'jonas.lie@drammen.kommune.no',
  phone = '+47 905 78 901',
  role = 'customer';

-- ═══════════════════════════════════════════════════
-- 8. Seed Data — Companies
-- ═══════════════════════════════════════════════════

USE NS companies DB registry;

CREATE company:frisorsalongen SET
  name = 'Frisørsalongen',
  slug = 'frisorsalongen',
  description = 'Premium frisørsalong i Drammen sentrum',
  email = 'post@frisorsalongen.no',
  phone = '+47 32 83 00 00',
  address = 'Nedre Storgate 12',
  city = 'Drammen',
  postal_code = '3015',
  tier = 'premium',
  onboarding_status = 'completed',
  owner_email = 'ingrid@frisorsalongen.no';

CREATE company:drammen_treningssenter SET
  name = 'Drammen Treningssenter',
  slug = 'drammen-treningssenter',
  description = 'Moderne treningssenter med personlig trener',
  email = 'post@drammen-treningssenter.no',
  address = 'Grønland 56',
  city = 'Drammen',
  postal_code = '3045',
  tier = 'premium',
  onboarding_status = 'completed',
  owner_email = 'ole@drammen-treningssenter.no';

CREATE company:hotell_nordre SET
  name = 'Hotell Nordre',
  slug = 'hotell-nordre',
  description = 'Historisk hotell ved Drammenselva',
  email = 'resepsjon@hotell-nordre.no',
  phone = '+47 32 26 00 00',
  address = 'Bragernes Torg 1',
  city = 'Drammen',
  postal_code = '3017',
  tier = 'enterprise',
  onboarding_status = 'completed',
  owner_email = 'kari@hotell-nordre.no';

CREATE company:berge_bygg SET
  name = 'Berge Bygg AS',
  slug = 'berge-bygg',
  description = 'Byggmester og renovering',
  email = 'post@berge-bygg.no',
  phone = '+47 32 89 00 00',
  address = 'Industriveien 8',
  city = 'Lier',
  postal_code = '3400',
  tier = 'free',
  onboarding_status = 'in_progress',
  owner_email = 'lars@berge-bygg.no';

CREATE company:cafe_elvebris SET
  name = 'Café Elvebris',
  slug = 'cafe-elvebris',
  description = 'Koselig kafé med utsikt over Drammenselva',
  email = 'hei@elvebris.no',
  address = 'Elvegata 3',
  city = 'Drammen',
  postal_code = '3015',
  tier = 'free',
  onboarding_status = 'not_started';

-- ═══════════════════════════════════════════════════
-- 9. Seed Data — Categories
-- ═══════════════════════════════════════════════════

USE NS companies DB discovery;

CREATE category:frisor SET
  name = 'Frisør',
  slug = 'frisor',
  description = 'Frisørsalonger og barberere',
  icon = '💇',
  count = 23;

CREATE category:restaurant SET
  name = 'Restaurant',
  slug = 'restaurant',
  description = 'Restauranter og kafeer',
  icon = '🍽️',
  count = 45;

CREATE category:trening SET
  name = 'Trening',
  slug = 'trening',
  description = 'Treningssentre og PT',
  icon = '🏋️',
  count = 12;

CREATE category:hotell SET
  name = 'Hotell',
  slug = 'hotell',
  description = 'Hotell og overnatting',
  icon = '🏨',
  count = 8;

CREATE category:helse SET
  name = 'Helse',
  slug = 'helse',
  description = 'Leger, tannleger og helsepersonell',
  icon = '⚕️',
  count = 31;

CREATE category:verksted SET
  name = 'Verksted',
  slug = 'verksted',
  description = 'Bilverksted og reparasjon',
  icon = '🔧',
  count = 15;

CREATE category:skjonnhet SET
  name = 'Skjønnhet',
  slug = 'skjonnhet',
  description = 'Skjønnhetssalonger og spa',
  icon = '💆',
  count = 19;

CREATE category:rengjoring SET
  name = 'Rengjøring',
  slug = 'rengjoring',
  description = 'Rengjøringstjenester',
  icon = '🧹',
  count = 7;
