import json
import uuid
import random
import sys
import argparse
from dataclasses import dataclass
from datetime import datetime, timezone
from functools import lru_cache
from typing import Any, Dict, List, Optional
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen
from pydantic import BaseModel, Field
from faker import Faker

# --- CONFIG ---
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "granite4:tiny-h" 


def _create_faker() -> Faker:
    # Faker locale naming changed in newer releases (nb_NO -> no_NO).
    for locale in ("nb_NO", "no_NO"):
        try:
            return Faker(locale)
        except Exception:
            continue
    return Faker()


fake = _create_faker()

# Only these sectors are allowed in generated demo data.
# (Blank lines in the source list are intentionally ignored.)
ALLOWED_SECTOR_NAMES: List[str] = [
    "Restaurants",
    "Fast Food",
    "Hairdressing",
    "Barbershops",
    "Grooming",
    "Feet",
    "Nails",
    "Tattoos and Piercing",
    "Tanning",
    "Massage",
    "Chiropractic",
    "Osteopathy",
    "Physiotherapy",
    "Podiatry",
    "Dentists",
    "Optical services",
    "Psychology",
    "Coaching",
    "Counseling",
    "Photography",
    "Law",
    "Government",
    "Automotive",
    "Cycling",
    "Repair",
    "Cleaning",
    "Animals",
    "Golfing",
    "Fitness",
    "Entertainment",
    "Venues",
    "Other",
]

DRAMMEN_LOCATIONS = [
    {"neighborhood": "Bragernes", "zip": "3015"},
    {"neighborhood": "Strømsø", "zip": "3044"},
    {"neighborhood": "Åssiden", "zip": "3048"},
    {"neighborhood": "Konnerud", "zip": "3031"},
    # Additional municipal regions / areas (postcode generated deterministically if unknown).
    {"neighborhood": "Gulskogen", "zip": None},
    {"neighborhood": "Fjell", "zip": None},
    {"neighborhood": "Åskollen", "zip": None},
    {"neighborhood": "Skoger", "zip": None},
    {"neighborhood": "Mjøndalen", "zip": None},
    {"neighborhood": "Krokstadelva", "zip": None},
    {"neighborhood": "Svelvik", "zip": None},
]


def _drammen_postcode(neighborhood: str) -> str:
    """Return a deterministic, plausible Drammen-area postcode.

    If a neighborhood doesn't have a known postcode, we derive a stable 30xx value
    (Norwegian postcodes are 4 digits). This is demo data; it's not intended to be
    postal-authoritative.
    """

    r = random.Random(f"zip:{neighborhood}")
    return f"{r.randint(3000, 3099):04d}"


def _now_utc() -> datetime:
    return datetime.now(timezone.utc)


def _slugify(text: str) -> str:
    s = (text or "").strip().lower()
    s = (
        s.replace("æ", "ae")
        .replace("ø", "o")
        .replace("å", "a")
        .replace("é", "e")
        .replace("è", "e")
        .replace("ê", "e")
    )
    out: List[str] = []
    prev_dash = False
    for ch in s:
        is_alnum = ("a" <= ch <= "z") or ("0" <= ch <= "9")
        if is_alnum:
            out.append(ch)
            prev_dash = False
        else:
            if not prev_dash:
                out.append("-")
                prev_dash = True
    slug = "".join(out).strip("-")
    while "--" in slug:
        slug = slug.replace("--", "-")
    return slug or "store"


def _random_allowed_sector_name() -> str:
    return random.choice(ALLOWED_SECTOR_NAMES)


def _build_sector_presets() -> Dict[str, Dict[str, Any]]:
    """Builds a preset map keyed by sector slug.

    Each preset drives business naming, service titles, keywords, booking form type,
    and default staff role names.
    """

    def preset(
        name: str,
        *,
        match_tokens: List[str],
        booking_form_type: str = "standard",
        person_role: str = "Ansatt",
        name_templates: Optional[List[str]] = None,
        service_titles: Optional[List[str]] = None,
        seed_keywords: Optional[List[str]] = None,
    ) -> Dict[str, Any]:
        return {
            "kind": _slugify(name),
            "display_name": name,
            "match_tokens": [t.strip().lower() for t in match_tokens if t.strip()],
            "bookingFormType": booking_form_type,
            "personRole": person_role,
            "name_templates": name_templates or ["{company}"],
            "service_titles": service_titles or [],
            "seed_keywords": seed_keywords
            or ["drammen", "service", "lokal", "kvalitet", "nærhet"],
        }

    catalog: List[Dict[str, Any]] = [
        preset(
            "Restaurants",
            match_tokens=["restaurant", "restaur", "bistro", "brasserie", "kafe", "kafé", "cafe"],
            booking_form_type="restaurant",
            person_role="Servitør",
            name_templates=[
                "{last} Restaurant",
                "{neighborhood} Spiseri",
                "Drammen {last} Bistro",
                "{last} Kjøkken & Vin",
                "{company}",
            ],
            service_titles=[
                "Bordreservasjon",
                "Lunsjreservasjon",
                "Middag (2 personer)",
                "Middag (4 personer)",
                "Selskapsreservasjon",
            ],
            seed_keywords=["restaurant", "mat", "bord", "servering", "drammen"],
        ),
        preset(
            "Fast Food",
            match_tokens=["fast", "fastfood", "takeaway", "burger", "pizza", "kebab", "grill"],
            booking_form_type="restaurant",
            person_role="Kokk",
            name_templates=[
                "{last} Takeaway",
                "{neighborhood} Grill",
                "Drammen {last} Burger",
                "{last} Pizza & Kebab",
                "{company}",
            ],
            service_titles=[
                "Takeaway",
                "Bestilling (henting)",
                "Familiepakke",
                "Lunsjdeal",
            ],
            seed_keywords=["takeaway", "burger", "pizza", "kebab", "drammen"],
        ),
        preset(
            "Hairdressing",
            match_tokens=["hair", "salon", "frisør", "frisor", "hairdressing", "klipp", "farge"],
            booking_form_type="standard",
            person_role="Frisør",
            name_templates=[
                "{last} Frisør",
                "{neighborhood} Hair Studio",
                "Drammen {last} Klipp & Farge",
                "{company}",
            ],
            service_titles=[
                "Klipp (herre)",
                "Klipp (dame)",
                "Vask & føn",
                "Farging",
                "Striper",
            ],
            seed_keywords=["frisør", "klipp", "farge", "styling", "drammen"],
        ),
        preset(
            "Barbershops",
            match_tokens=["barber", "barbershop", "skjegg", "fade"],
            booking_form_type="standard",
            person_role="Barber",
            name_templates=[
                "{last} Barber",
                "{neighborhood} Barber & Skjegg",
                "Drammen {last} Barbershop",
                "{company}",
            ],
            service_titles=[
                "Barbering",
                "Skjeggtrim",
                "Klipp (fade)",
                "Skjegg & form",
            ],
            seed_keywords=["barber", "skjegg", "klipp", "fade", "drammen"],
        ),
        preset(
            "Grooming",
            match_tokens=["groom", "grooming", "pleie", "ansikts", "hud"],
            booking_form_type="standard",
            person_role="Hudterapeut",
            name_templates=[
                "{last} Grooming",
                "{neighborhood} Pleie",
                "Drammen Grooming Studio",
                "{company}",
            ],
            service_titles=[
                "Ansiktsbehandling",
                "Bryn & vipper",
                "Voksing",
                "Hudkonsultasjon",
            ],
            seed_keywords=["grooming", "pleie", "hud", "voksing", "drammen"],
        ),
        preset(
            "Feet",
            match_tokens=["feet", "fot", "fotpleie", "hard hud", "hæler"],
            booking_form_type="standard",
            person_role="Fotterapeut",
            name_templates=[
                "{last} Fotpleie",
                "{neighborhood} Fot & Velvære",
                "Drammen Fotklinikk",
                "{company}",
            ],
            service_titles=[
                "Fotpleie (standard)",
                "Hard hud",
                "Negleklipp",
                "Fotmassasje",
            ],
            seed_keywords=["fotpleie", "føtter", "velvære", "klinikk", "drammen"],
        ),
        preset(
            "Nails",
            match_tokens=["nails", "negler", "manikyr", "pedikyr", "gel"],
            booking_form_type="standard",
            person_role="Negledesigner",
            name_templates=[
                "{last} Negler",
                "{neighborhood} Nail Studio",
                "Drammen {last} Nails",
                "{company}",
            ],
            service_titles=[
                "Manikyr",
                "Gellakk",
                "Akryl (påfyll)",
                "Nytt sett",
            ],
            seed_keywords=["negler", "manikyr", "gellakk", "salong", "drammen"],
        ),
        preset(
            "Tattoos and Piercing",
            match_tokens=["tattoo", "tatover", "tatovering", "piercing"],
            booking_form_type="standard",
            person_role="Tatovør",
            name_templates=[
                "{last} Tattoo",
                "{neighborhood} Ink & Piercing",
                "Drammen Tattoo Studio",
                "{company}",
            ],
            service_titles=[
                "Konsultasjon",
                "Tatovering (30 min)",
                "Tatovering (60 min)",
                "Piercing",
            ],
            seed_keywords=["tattoo", "piercing", "ink", "studio", "drammen"],
        ),
        preset(
            "Tanning",
            match_tokens=["tanning", "sol", "solarium", "spraytan"],
            booking_form_type="standard",
            person_role="Vert",
            name_templates=[
                "{last} Solstudio",
                "{neighborhood} Solarium",
                "Drammen Tanning",
                "{company}",
            ],
            service_titles=[
                "Solarium (10 min)",
                "Solarium (20 min)",
                "Spraytan",
                "Klippekort",
            ],
            seed_keywords=["solarium", "tanning", "spraytan", "sol", "drammen"],
        ),
        preset(
            "Massage",
            match_tokens=["massage", "massasje", "spa", "velvære", "wellness"],
            booking_form_type="standard",
            person_role="Massør",
            name_templates=[
                "{last} Massasje",
                "{neighborhood} Velvære",
                "Drammen Massasje Studio",
                "{company}",
            ],
            service_titles=[
                "Klassisk massasje",
                "Dypvevsmassasje",
                "Idrettsmassasje",
                "Rygg & nakke",
            ],
            seed_keywords=["massasje", "velvære", "terapi", "rygg", "drammen"],
        ),
        preset(
            "Chiropractic",
            match_tokens=["chiro", "chiropr", "kiroprakt"],
            booking_form_type="standard",
            person_role="Kiropraktor",
            name_templates=[
                "{last} Kiropraktor",
                "{neighborhood} Kiropraktikk",
                "Drammen Kiropraktorsenter",
                "{company}",
            ],
            service_titles=["Førstegangskonsultasjon", "Oppfølging", "Behandling"],
            seed_keywords=["kiropraktor", "rygg", "nakke", "behandling", "drammen"],
        ),
        preset(
            "Osteopathy",
            match_tokens=["osteo", "osteop"],
            booking_form_type="standard",
            person_role="Osteopat",
            name_templates=[
                "{last} Osteopati",
                "{neighborhood} Osteopat",
                "Drammen Osteopati",
                "{company}",
            ],
            service_titles=["Førstegangskonsultasjon", "Oppfølging", "Behandling"],
            seed_keywords=["osteopat", "behandling", "kropp", "helse", "drammen"],
        ),
        preset(
            "Physiotherapy",
            match_tokens=["physio", "fysio", "fysioter"],
            booking_form_type="standard",
            person_role="Fysioterapeut",
            name_templates=[
                "{last} Fysioterapi",
                "{neighborhood} Fysio",
                "Drammen Fysioterapi",
                "{company}",
            ],
            service_titles=["Førstegangskonsultasjon", "Behandling", "Opptrening"],
            seed_keywords=["fysioterapi", "rehab", "opptrening", "helse", "drammen"],
        ),
        preset(
            "Podiatry",
            match_tokens=["podi", "podiat", "fotklinikk"],
            booking_form_type="standard",
            person_role="Fotterapeut",
            name_templates=[
                "{last} Fotklinikk",
                "{neighborhood} Fotterapi",
                "Drammen Podiatry",
                "{company}",
            ],
            service_titles=["Fotkonsultasjon", "Behandling", "Oppfølging"],
            seed_keywords=["fot", "klinikk", "behandling", "helse", "drammen"],
        ),
        preset(
            "Dentists",
            match_tokens=["dent", "tann", "tannlege"],
            booking_form_type="standard",
            person_role="Tannlege",
            name_templates=[
                "{last} Tannklinikk",
                "{neighborhood} Tannlege",
                "Drammen Tannhelse",
                "{company}",
            ],
            service_titles=["Undersøkelse", "Rens", "Akuttime", "Konsultasjon"],
            seed_keywords=["tannlege", "tannhelse", "klinikk", "time", "drammen"],
        ),
        preset(
            "Optical services",
            match_tokens=["opt", "optiker", "briller", "linser", "syn"],
            booking_form_type="standard",
            person_role="Optiker",
            name_templates=[
                "{last} Optikk",
                "{neighborhood} Optiker",
                "Drammen Syn & Optikk",
                "{company}",
            ],
            service_titles=["Synstest", "Kontaktlinsekontroll", "Brilletilpasning"],
            seed_keywords=["optiker", "synstest", "briller", "linser", "drammen"],
        ),
        preset(
            "Psychology",
            match_tokens=["psy", "psykolog", "therapy", "terapi"],
            booking_form_type="standard",
            person_role="Psykolog",
            name_templates=[
                "{last} Psykolog",
                "{neighborhood} Psykologtjenester",
                "Drammen Psykologi",
                "{company}",
            ],
            service_titles=["Samtale (60 min)", "Oppfølging", "Kartlegging"],
            seed_keywords=["psykolog", "samtale", "helse", "støtte", "drammen"],
        ),
        preset(
            "Coaching",
            match_tokens=["coach", "coaching", "mentor"],
            booking_form_type="standard",
            person_role="Coach",
            name_templates=[
                "{last} Coaching",
                "{neighborhood} Coach",
                "Drammen Coaching",
                "{company}",
            ],
            service_titles=["Coaching (45 min)", "Coaching (60 min)", "Planlegging"],
            seed_keywords=["coaching", "mål", "utvikling", "plan", "drammen"],
        ),
        preset(
            "Counseling",
            match_tokens=["counsel", "rådg", "radgiv", "veiled"],
            booking_form_type="standard",
            person_role="Rådgiver",
            name_templates=[
                "{last} Rådgivning",
                "{neighborhood} Veiledning",
                "Drammen Rådgiver",
                "{company}",
            ],
            service_titles=["Veiledning (45 min)", "Oppfølging", "Kartlegging"],
            seed_keywords=["rådgivning", "veiledning", "støtte", "plan", "drammen"],
        ),
        preset(
            "Photography",
            match_tokens=["photo", "foto", "fotograf", "studio", "bilde"],
            booking_form_type="standard",
            person_role="Fotograf",
            name_templates=[
                "{last} Foto",
                "{neighborhood} Fotostudio",
                "Drammen Fotograf",
                "{company}",
            ],
            service_titles=["Portrett", "Bedriftsfoto", "Familiefoto", "Produktfoto"],
            seed_keywords=["fotograf", "foto", "portrett", "studio", "drammen"],
        ),
        preset(
            "Law",
            match_tokens=["law", "advokat", "jurid"],
            booking_form_type="standard",
            person_role="Advokat",
            name_templates=[
                "Advokat {last}",
                "{last} Juridisk",
                "Drammen Advokatkontor",
                "{company}",
            ],
            service_titles=["Konsultasjon (30 min)", "Konsultasjon (60 min)", "Saksgjennomgang"],
            seed_keywords=["advokat", "juridisk", "rådgivning", "sak", "drammen"],
        ),
        preset(
            "Government",
            match_tokens=["government", "kommune", "offentlig", "nav"],
            booking_form_type="none",
            person_role="Saksbehandler",
            name_templates=[
                "{neighborhood} Innbyggertorg",
                "Drammen Servicekontor",
                "{company}",
            ],
            service_titles=["Veiledning", "Innsyn", "Timebestilling"],
            seed_keywords=["kommune", "tjeneste", "innbyggertorg", "veiledning", "drammen"],
        ),
        preset(
            "Automotive",
            match_tokens=["auto", "bil", "verksted", "dekk", "eu-kontroll", "motor"],
            booking_form_type="standard",
            person_role="Mekaniker",
            name_templates=[
                "{last} Bilverksted",
                "{neighborhood} Auto Service",
                "Drammen Dekk & Felg",
                "{company}",
            ],
            service_titles=["EU-kontroll", "Oljeskift", "Dekkskift", "Feilsøking", "Bilservice"],
            seed_keywords=["bil", "verksted", "eu-kontroll", "dekk", "drammen"],
        ),
        preset(
            "Cycling",
            match_tokens=["cycle", "cycling", "sykkel", "elsykkel"],
            booking_form_type="standard",
            person_role="Sykkelmekaniker",
            name_templates=[
                "{last} Sykkelservice",
                "{neighborhood} Sykkelverksted",
                "Drammen Sykkel & Sport",
                "{company}",
            ],
            service_titles=["Sykkelservice", "Bremsejustering", "Girjustering", "Kjedeskift", "Elsykkel diagnose"],
            seed_keywords=["sykkel", "service", "verksted", "elsykkel", "drammen"],
        ),
        preset(
            "Repair",
            match_tokens=["repair", "repairs", "repar", "fikse", "håndver", "handyman", "vaktmester"],
            booking_form_type="standard",
            person_role="Håndverker",
            name_templates=[
                "{last} Reparasjon",
                "{neighborhood} Vaktmester",
                "Drammen Fix & Service",
                "{company}",
            ],
            service_titles=["Småreparasjoner", "Montering", "Vaktmestertjenester", "Utrykning"],
            seed_keywords=["reparasjon", "vaktmester", "montering", "håndverk", "drammen"],
        ),
        preset(
            "Cleaning",
            match_tokens=["clean", "cleaning", "rengjør", "rengjor", "vaske", "renhold", "flyttevask"],
            booking_form_type="standard",
            person_role="Renholder",
            name_templates=[
                "{last} Renhold",
                "{neighborhood} Rengjøring",
                "Drammen Flyttevask",
                "{company}",
            ],
            service_titles=["Flyttevask", "Husvask", "Kontorrenhold", "Vindusvask", "Hovedrengjøring"],
            seed_keywords=["renhold", "rengjøring", "flyttevask", "vask", "drammen"],
        ),
        preset(
            "Animals",
            match_tokens=["animal", "animals", "dyr", "hund", "katt", "veter", "groom"],
            booking_form_type="standard",
            person_role="Dyrepleier",
            name_templates=[
                "{last} Dyreklinikk",
                "{neighborhood} Dyr & Pleie",
                "Drammen Dyreklinikk",
                "{company}",
            ],
            service_titles=["Konsultasjon", "Vaksine", "Kloklipp", "Hundeklipp"],
            seed_keywords=["hund", "katt", "dyreklinikk", "pleie", "drammen"],
        ),
        preset(
            "Golfing",
            match_tokens=["golf", "golfing", "tee"],
            booking_form_type="venue",
            person_role="Instruktør",
            name_templates=[
                "{neighborhood} Golf",
                "Drammen Golf",
                "{company}",
            ],
            service_titles=["Starttid (9 hull)", "Starttid (18 hull)", "Pro-time (45 min)"],
            seed_keywords=["golf", "starttid", "instruktør", "bane", "drammen"],
        ),
        preset(
            "Fitness",
            match_tokens=["fitness", "gym", "pt", "trening"],
            booking_form_type="standard",
            person_role="Personlig trener",
            name_templates=[
                "{last} Treningssenter",
                "{neighborhood} Fitness",
                "Drammen Gym",
                "{company}",
            ],
            service_titles=["PT-time (60 min)", "PT-time (45 min)", "Oppstartssamtale", "Gruppetime"],
            seed_keywords=["trening", "fitness", "pt", "helse", "drammen"],
        ),
        preset(
            "Entertainment",
            match_tokens=["entertain", "show", "konsert", "kino", "escape", "aktivitet"],
            booking_form_type="ticketing",
            person_role="Arrangør",
            name_templates=[
                "{neighborhood} Opplevelser",
                "Drammen Entertainment",
                "{company}",
            ],
            service_titles=["Billetter", "Drop-in", "Gruppebooking", "Arrangement"],
            seed_keywords=["opplevelse", "billetter", "arrangement", "underholdning", "drammen"],
        ),
        preset(
            "Venues",
            match_tokens=["venue", "lokale", "utleie", "selskap", "konferanse"],
            booking_form_type="venue",
            person_role="Vert",
            name_templates=[
                "{last} Lokaler",
                "{neighborhood} Venue",
                "Drammen Selskapslokale",
                "{company}",
            ],
            service_titles=["Befaring", "Leie (heldag)", "Leie (kveld)", "Konferanse"],
            seed_keywords=["lokale", "utleie", "konferanse", "selskap", "drammen"],
        ),
        preset(
            "Other",
            match_tokens=["other", "annet", "diverse"],
            booking_form_type="standard",
            person_role="Ansatt",
            name_templates=["{company}", "{last} Tjenester", "{neighborhood} Service"],
            service_titles=["Konsultasjon", "Oppdrag", "Timebestilling"],
            seed_keywords=["service", "lokal", "drammen", "kvalitet", "nærhet"],
        ),
    ]

    out: Dict[str, Dict[str, Any]] = {}
    for item in catalog:
        slug = _slugify(item["display_name"])
        out[slug] = item

    # Ensure every allowed sector exists, even if it wasn't explicitly configured.
    for sector_name in ALLOWED_SECTOR_NAMES:
        slug = _slugify(sector_name)
        out.setdefault(
            slug,
            {
                "kind": slug,
                "display_name": sector_name,
                "match_tokens": [sector_name.strip().lower()],
                "bookingFormType": "standard",
                "personRole": "Ansatt",
                "name_templates": ["{company}", f"{{company}} – {sector_name}"],
                "service_titles": [],
                "seed_keywords": ["drammen", "service", "lokal", "kvalitet", "nærhet"],
            },
        )

    return out


SECTOR_PRESETS_BY_SLUG: Dict[str, Dict[str, Any]] = _build_sector_presets()


def _opening_schedule_default() -> Dict[str, Any]:
    open_day = {"isOpen": True, "open": "09:00", "close": "17:00"}
    sat = {"isOpen": True, "open": "10:00", "close": "15:00"}
    sun = {"isOpen": False, "open": "00:00", "close": "00:00"}
    return {"mon": open_day, "tue": open_day, "wed": open_day, "thu": open_day, "fri": open_day, "sat": sat, "sun": sun}


def _store_gmap_coord(store_id: str) -> Dict[str, float]:
    # Rough Drammen-ish bounding box. Deterministic per store id.
    r = random.Random(store_id)
    lat = r.uniform(59.72, 59.76)
    lng = r.uniform(10.17, 10.25)
    return {"lat": round(lat, 6), "lng": round(lng, 6)}


def _category_label_from_sector(sector: Optional[str]) -> str:
    preset = _sector_preset(sector)
    display = preset.get("display_name")
    if isinstance(display, str) and display.strip():
        return display.strip()
    if isinstance(sector, str) and sector.strip():
        return sector.strip()
    return "Service"


def _category_definitions() -> List[Dict[str, str]]:
    return [{"name": name, "slug": _slugify(name)} for name in ALLOWED_SECTOR_NAMES]


def _category_icon_for_slug(slug: str) -> str:
    # Optional. Use simple lucide-ish names (your schema says this is optional).
    mapping = {
        "restaurants": "utensils",
        "fast-food": "utensils",
        "hairdressing": "scissors",
        "barbershops": "scissors",
        "massage": "leaf",
        "cleaning": "spray-can",
        "automotive": "car",
        "cycling": "bike",
        "repair": "wrench",
        "animals": "paw-print",
        "photography": "camera",
        "law": "scale",
        "fitness": "dumbbell",
        "entertainment": "ticket",
        "venues": "building",
    }
    return mapping.get(slug, "tag")


def _booking_form_type_from_sector(sector: Optional[str]) -> str:
    preset = _sector_preset(sector)
    bft = preset.get("bookingFormType")
    return bft if isinstance(bft, str) and bft else "standard"


def _person_role_from_sector(sector: Optional[str]) -> str:
    preset = _sector_preset(sector)
    role = preset.get("personRole")
    return role if isinstance(role, str) and role.strip() else "Ansatt"

# --- PYDANTIC MODELS (Mirroring your shared-types/schema.ts) ---
class CategoryModel(BaseModel):
    id: str
    name: str
    slug: str
    description: Optional[str] = None
    icon: Optional[str] = None
    createdAt: datetime = Field(default_factory=_now_utc)
    updatedAt: datetime = Field(default_factory=_now_utc)


class UserCompanyMembershipModel(BaseModel):
    companyId: str
    role: str = "owner"
    assignedAt: datetime = Field(default_factory=_now_utc)


class ServiceModel(BaseModel):
    id: str = Field(default_factory=lambda: f"serv_{uuid.uuid4().hex[:6]}")
    storeId: str
    groupId: Optional[str] = None
    personId: Optional[str] = None

    title: str
    description: Optional[str] = None

    bookingMode: str = "standard"  # standard | tableReservation | ticketSystem

    coverImage: Optional[str] = None
    gallery: Optional[List[str]] = None

    serviceType: List[str] = Field(default_factory=list)
    subcategory: Optional[str] = None

    keywords: List[str]
    aiDescription: Optional[str] = None
    _embedding: Optional[List[float]] = None

    duration: int
    price: int
    bufferTime: int = 0
    capacity: int = 1
    currency: str = "NOK"

    availabilityStart: str = "09:00"
    availabilityEnd: str = "17:00"

    isActive: bool = True

class PersonModel(BaseModel):
    id: str = Field(default_factory=lambda: f"pers_{uuid.uuid4().hex[:6]}")
    storeId: str

    userId: Optional[str] = None
    name: str
    role: Optional[str] = None
    groups: Optional[List[str]] = None
    imageUrl: Optional[str] = None
    isBookable: bool = True
    schedule: Optional[Dict[str, Any]] = None

class StoreModel(BaseModel):
    id: str = Field(default_factory=lambda: f"store_{uuid.uuid4().hex[:6]}")
    companyId: str
    name: str
    slug: str
    address: str
    zip: str
    city: str = "Drammen"
    country: str = "NO"

    gmapCoord: Optional[Dict[str, float]] = None
    geoHash: Optional[str] = None

    about: Optional[str] = None
    images: Dict[str, Any] = Field(default_factory=lambda: {"logo": None, "cover": None, "gallery": []})
    coverLayoutMode: str = "bento"  # showcase | spotlight | bento

    openingSchedule: Dict[str, Any] = Field(default_factory=_opening_schedule_default)
    timezone: str = "Europe/Oslo"

    storeType: str = "store"  # store | restaurant | venue
    bookingFormType: str = "standard"
    isPublished: bool = True
    isActive: bool = True
    category: Optional[str] = None
    aggregateRating: Optional[Dict[str, Any]] = None
    favoritesCount: int = 0

    createdAt: datetime = Field(default_factory=_now_utc)
    updatedAt: datetime = Field(default_factory=_now_utc)


def _store_image_urls(store_id: str, *, gallery_count: int = 3, width: int = 800, height: int = 600) -> Dict[str, Any]:
    # Deterministic, unique-per-store placeholder images.
    gallery_count = max(1, min(10, gallery_count))
    return {
        "logo": f"https://picsum.photos/seed/{store_id}-logo/256/256",
        "cover": f"https://picsum.photos/seed/{store_id}-cover/{width}/{height}",
        "gallery": [
            f"https://picsum.photos/seed/{store_id}-{i}/{width}/{height}"
            for i in range(1, gallery_count + 1)
        ],
    }

class CompanyModel(BaseModel):
    id: str = Field(default_factory=lambda: f"comp_{uuid.uuid4().hex[:6]}")
    ownerId: str
    ownerEmail: Optional[str] = None
    name: str
    description: Optional[str] = None
    website: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    zip: Optional[str] = None
    country: str = "NO"

    email: Optional[str] = None
    phone: Optional[str] = None
    logoUrl: Optional[str] = None
    tier: str = "free"
    slinks: Optional[Dict[str, Any]] = None

    onboardingStatus: str = "complete"
    aiSuggestedData: Optional[Dict[str, Any]] = None

    enabledFeatures: Dict[str, bool] = Field(default_factory=lambda: {
        "tableReservation": False,
        "aiAssistance": False,
        "ticketSystem": False,
        "eventSystem": False,
    })
    storePolicy: Dict[str, Any] = Field(default_factory=lambda: {
        "maxStores": 1,
        "canCreateOwnStores": False,
    })
    mediaConfig: Dict[str, Any] = Field(default_factory=lambda: {
        "defaultTags": ["logo", "cover", "staff", "store", "menu", "misc"],
    })

    createdAt: datetime = Field(default_factory=_now_utc)
    updatedAt: datetime = Field(default_factory=_now_utc)
    managerIds: Optional[List[str]] = None
    memberIds: Optional[List[str]] = None

class OwnerModel(BaseModel):
    id: str = Field(default_factory=lambda: f"user_{uuid.uuid4().hex[:6]}")
    name: str
    email: str
    username: Optional[str] = None
    bio: Optional[str] = None
    phone: Optional[str] = None
    photoUrl: Optional[str] = None
    role: str = "business"  # customer | business | admin | super_admin

    isOnboarded: bool = True
    companyMemberships: List[UserCompanyMembershipModel] = Field(default_factory=list)
    companyMembershipIds: List[str] = Field(default_factory=list)
    language: str = "nb"

    createdAt: datetime = Field(default_factory=_now_utc)
    updatedAt: datetime = Field(default_factory=_now_utc)

# --- OLLAMA BRAIN ---
def _safe_model_dump(model: BaseModel) -> Dict[str, Any]:
    # Ensure JSON-safe output (datetimes become ISO strings).
    dump = getattr(model, "model_dump", None)
    if callable(dump):
        return dump(mode="json")  # type: ignore
    json_fn = getattr(model, "json", None)
    if callable(json_fn):
        result = json_fn()
        if isinstance(result, str):
            return json.loads(result)
    return model.model_dump()  # type: ignore


def _extract_json_object(text: str) -> Optional[Dict[str, Any]]:
    if not text:
        return None
    try:
        parsed = json.loads(text)
        return parsed if isinstance(parsed, dict) else None
    except Exception:
        pass

    start = text.find("{")
    end = text.rfind("}")
    if start == -1 or end == -1 or end <= start:
        return None
    candidate = text[start : end + 1]
    try:
        parsed = json.loads(candidate)
        return parsed if isinstance(parsed, dict) else None
    except Exception:
        return None


def _normalize_ai_data(ai_data: Any, *, seed_keywords: Optional[List[str]] = None) -> Dict[str, Any]:
    fallback = {
        "description": "En flott bedrift i hjertet av Drammen.",
        "keywords": ["drammen", "service", "lokal", "kvalitet", "nærhet"],
    }
    description: str = fallback["description"]
    raw_keywords: Any = None
    if isinstance(ai_data, dict):
        description_value = ai_data.get("description")
        if isinstance(description_value, str) and description_value.strip():
            description = description_value.strip()
        raw_keywords = ai_data.get("keywords")

    # Extract keywords from AI response (if any)
    keywords: List[str] = []
    if isinstance(raw_keywords, list):
        for item in raw_keywords:
            if isinstance(item, str):
                token = item.strip().lower()
                if token and token not in keywords:
                    keywords.append(token)

    # Prefer 5 keywords; pad with sector hints first, then defaults.
    seed: List[str] = []
    if isinstance(seed_keywords, list):
        for token in seed_keywords:
            if isinstance(token, str):
                t = token.strip().lower()
                if t and t not in seed:
                    seed.append(t)

    for token in (seed + fallback["keywords"]):
        if len(keywords) >= 5:
            break
        if token not in keywords:
            keywords.append(token)

    return {"description": description, "keywords": keywords[:5]}
def _post_json(url: str, payload: Dict[str, Any], *, timeout: int = 15) -> Dict[str, Any]:
    body = json.dumps(payload).encode("utf-8")
    req = Request(
        url,
        data=body,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        method="POST",
    )
    with urlopen(req, timeout=timeout) as resp:
        raw = resp.read().decode("utf-8", errors="replace")
    parsed = json.loads(raw)
    if not isinstance(parsed, dict):
        raise ValueError("Unexpected non-object JSON response")
    return parsed


def _post_json_stream(url: str, payload: Dict[str, Any], *, timeout: int = 60):
    """Yields parsed JSON objects from an Ollama streaming response."""
    body = json.dumps(payload).encode("utf-8")
    req = Request(
        url,
        data=body,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        method="POST",
    )
    resp = urlopen(req, timeout=timeout)
    try:
        for raw_line in resp:
            line = raw_line.decode("utf-8", errors="replace").strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
            except Exception:
                continue
            if isinstance(obj, dict):
                yield obj
            if isinstance(obj, dict) and obj.get("done") is True:
                break
    finally:
        try:
            resp.close()
        except Exception:
            pass


@lru_cache(maxsize=512)
def _brainstorm_business_cached(biz_name: str, sector: str) -> Dict[str, Any]:
    """Non-streaming brainstorm; cached for speed when generating lots of data."""
    sector_hint = f"The business category/sector is: {sector}. " if sector else ""
    prompt = (
        f"Generate a Norwegian response for a business named '{biz_name}'. "
        f"{sector_hint}"
        "Return ONLY JSON: {\"description\": \"2 sentences in Norwegian\", \"keywords\": [\"word1\", \"word2\", \"word3\", \"word4\", \"word5\"]}"
    )
    try:
        payload = _post_json(
            OLLAMA_URL,
            {"model": MODEL, "prompt": prompt, "stream": False, "format": "json"},
            timeout=15,
        )
        response = payload.get("response")
        if isinstance(response, dict):
            return _normalize_ai_data(response)
        if isinstance(response, str):
            parsed = _extract_json_object(response)
            return _normalize_ai_data(parsed)
        return _normalize_ai_data(None)
    except (HTTPError, URLError, ValueError, json.JSONDecodeError, Exception):
        return _normalize_ai_data(None)


def brainstorm_business(
    biz_name: str,
    *,
    sector: Optional[str] = None,
    use_stream: bool = False,
    show_progress: bool = False,
    stream_dots: bool = True,
) -> Dict[str, Any]:
    """Asks Granite to give a 2-sentence description + 5 keywords.

    If use_stream=True, prints progress while Ollama is generating.
    """
    sector_hint = f"The business category/sector is: {sector}. " if sector else ""

    if not use_stream:
        if show_progress:
            print(f"🧠 Ollama: {biz_name} …", flush=True)
        return _brainstorm_business_cached(biz_name, sector or "")

    prompt = (
        f"Generate a Norwegian response for a business named '{biz_name}'. "
        f"{sector_hint}"
        "Return ONLY JSON: {\"description\": \"2 sentences in Norwegian\", \"keywords\": [\"word1\", \"word2\", \"word3\", \"word4\", \"word5\"]}"
    )

    if show_progress:
        print(f"🧠 Ollama(stream): {biz_name} ", end="", flush=True)

    response_text = ""
    try:
        for obj in _post_json_stream(
            OLLAMA_URL,
            {"model": MODEL, "prompt": prompt, "stream": True, "format": "json"},
            timeout=60,
        ):
            chunk = obj.get("response")
            if isinstance(chunk, str):
                response_text += chunk
            if show_progress:
                if stream_dots:
                    print(".", end="", flush=True)
                else:
                    # Best-effort: show raw chunk (may include JSON fragments)
                    print(chunk or "", end="", flush=True)
        if show_progress:
            print("", flush=True)
        parsed = _extract_json_object(response_text)
        return _normalize_ai_data(parsed)
    except (HTTPError, URLError, ValueError, json.JSONDecodeError, Exception):
        if show_progress:
            print("(fallback)")
        return _normalize_ai_data(None)


@dataclass(frozen=True)
class GenerationConfig:
    # Business owners (each owner can have companies/stores/etc)
    owners: int = 1
    # Customer-only users (no companies)
    customers: int = 0
    customers_only: bool = False
    companies_min: int = 1
    companies_max: int = 3
    stores_min: int = 1
    stores_max: int = 2

    sector: Optional[str] = None

    staff_mode: str = "auto"  # auto | resource | facility
    staff_probability: float = 0.5
    persons_min: int = 1
    persons_max: int = 3

    services_per_store: int = 3
    duration_options: tuple[int, ...] = (30, 45, 60, 90)
    price_min: int = 500
    price_max: int = 2000

    output_path: str = "drammen_seed.json"
    append: bool = False

    include_categories: bool = False

    use_ollama: bool = True
    ollama_stream: bool = False
    verbose: bool = True


def _clamp_int(value: int, *, min_value: int, max_value: int) -> int:
    return max(min_value, min(max_value, value))


def _prompt_int(label: str, *, default: int, min_value: int = 0, max_value: int = 10_000) -> int:
    while True:
        raw = input(f"{label} [{default}]: ").strip()
        if not raw:
            return _clamp_int(default, min_value=min_value, max_value=max_value)
        try:
            value = int(raw)
            return _clamp_int(value, min_value=min_value, max_value=max_value)
        except ValueError:
            print("Please enter a whole number.")


def _prompt_float(label: str, *, default: float, min_value: float = 0.0, max_value: float = 1.0) -> float:
    while True:
        raw = input(f"{label} [{default}]: ").strip().replace(",", ".")
        if not raw:
            return max(min_value, min(max_value, default))
        try:
            value = float(raw)
            return max(min_value, min(max_value, value))
        except ValueError:
            print("Please enter a number.")


def _prompt_bool(label: str, *, default: bool) -> bool:
    suffix = "Y/n" if default else "y/N"
    while True:
        raw = input(f"{label} ({suffix}): ").strip().lower()
        if not raw:
            return default
        if raw in ("y", "yes"):
            return True
        if raw in ("n", "no"):
            return False
        print("Please answer y/n.")


def _prompt_choice(label: str, *, default: str, choices: List[str]) -> str:
    choices_str = "/".join(choices)
    while True:
        raw = input(f"{label} ({choices_str}) [{default}]: ").strip().lower()
        if not raw:
            return default
        if raw in choices:
            return raw
        print(f"Please choose one of: {choices_str}")


def _prompt_duration_options(default: tuple[int, ...]) -> tuple[int, ...]:
    raw = input(f"Service durations (comma-separated minutes) [{','.join(map(str, default))}]: ").strip()
    if not raw:
        return default
    items: List[int] = []
    for part in raw.split(","):
        part = part.strip()
        if not part:
            continue
        try:
            val = int(part)
        except ValueError:
            continue
        if val > 0 and val not in items:
            items.append(val)
    return tuple(items) if items else default


def run_menu() -> GenerationConfig:
    print("\n=== Drammen Digital Twin Generator ===\n")

    mode = _prompt_choice(
        "Generate mode",
        default="business",
        choices=["business", "customers", "both"],
    )

    owners_default = 1 if mode in ("business", "both") else 0
    customers_default = 50 if mode in ("customers", "both") else 0

    owners = _prompt_int("How many business owners to create?", default=owners_default, min_value=0, max_value=50_000)
    customers = _prompt_int("How many customer users to create?", default=customers_default, min_value=0, max_value=200_000)
    companies_min = _prompt_int("Companies per owner (min)", default=1, min_value=0, max_value=50)
    companies_max = _prompt_int("Companies per owner (max)", default=3, min_value=0, max_value=50)
    if companies_max < companies_min:
        companies_max = companies_min

    stores_min = _prompt_int("Stores per company (min)", default=1, min_value=0, max_value=50)
    stores_max = _prompt_int("Stores per company (max)", default=2, min_value=0, max_value=50)
    if stores_max < stores_min:
        stores_max = stores_min

    sector = input("Sector/category (optional, e.g. 'Hair salons'): ").strip()
    sector = sector or None

    staff_mode = _prompt_choice("Staff mode", default="auto", choices=["auto", "resource", "facility"])
    staff_probability = 0.5
    if staff_mode == "auto":
        pct = _prompt_int("If auto: probability store has staff (%)", default=50, min_value=0, max_value=100)
        staff_probability = pct / 100.0

    persons_min = 1
    persons_max = 3
    if staff_mode in ("auto", "resource"):
        persons_min = _prompt_int("Persons per staffed store (min)", default=1, min_value=0, max_value=50)
        persons_max = _prompt_int("Persons per staffed store (max)", default=3, min_value=0, max_value=50)
        if persons_max < persons_min:
            persons_max = persons_min

    services_per_store = _prompt_int("Services per store", default=3, min_value=0, max_value=200)
    duration_options = _prompt_duration_options((30, 45, 60, 90))
    price_min = _prompt_int("Service price min (NOK)", default=500, min_value=0, max_value=1_000_000)
    price_max = _prompt_int("Service price max (NOK)", default=2000, min_value=0, max_value=1_000_000)
    if price_max < price_min:
        price_max = price_min

    output_path = input("Output file [drammen_seed.json]: ").strip() or "drammen_seed.json"
    append = _prompt_bool("Append to existing JSON (incremental build)?", default=False)

    include_categories = _prompt_bool("Include 'categories' collection in JSON?", default=True)

    use_ollama = _prompt_bool("Use Ollama (creative descriptions/keywords)?", default=True)
    ollama_stream = False
    verbose = True
    if use_ollama:
        verbose = _prompt_bool("Show progress while generating?", default=True)
        ollama_stream = _prompt_bool("Use streaming progress (dots) from Ollama?", default=True)

    print("")
    return GenerationConfig(
        owners=owners,
        customers=customers,
        customers_only=(mode == "customers"),
        companies_min=companies_min,
        companies_max=companies_max,
        stores_min=stores_min,
        stores_max=stores_max,
        sector=sector,
        staff_mode=staff_mode,
        staff_probability=staff_probability,
        persons_min=persons_min,
        persons_max=persons_max,
        services_per_store=services_per_store,
        duration_options=duration_options,
        price_min=price_min,
        price_max=price_max,
        output_path=output_path,
        append=append,
        include_categories=include_categories,
        use_ollama=use_ollama,
        ollama_stream=ollama_stream,
        verbose=verbose,
    )


def _normalize_sector(sector: Optional[str]) -> str:
    return (sector or "").strip().lower()


def _sector_preset(sector: Optional[str]) -> Dict[str, Any]:
    s_raw = (sector or "").strip()
    if not s_raw:
        return {
            "kind": "generic",
            "display_name": "Other",
            "name_templates": ["{company}"],
            "service_titles": [],
            "seed_keywords": ["drammen", "service", "lokal", "kvalitet", "nærhet"],
            "bookingFormType": "standard",
            "personRole": "Ansatt",
            "match_tokens": [],
        }

    # 1) Exact match by slug (preferred)
    slug = _slugify(s_raw)
    preset = SECTOR_PRESETS_BY_SLUG.get(slug)
    if isinstance(preset, dict):
        return preset

    # 2) Token matching fallback (supports inputs like "Hair salons" etc.)
    s = _normalize_sector(s_raw)
    for candidate in SECTOR_PRESETS_BY_SLUG.values():
        tokens = candidate.get("match_tokens")
        if isinstance(tokens, list) and any(isinstance(t, str) and t and t in s for t in tokens):
            return candidate

    # 3) Unknown sector: treat as "Other" but preserve user label in name generation.
    other = SECTOR_PRESETS_BY_SLUG.get(_slugify("Other"))
    if isinstance(other, dict):
        return other
    return {
        "kind": "generic",
        "display_name": "Other",
        "name_templates": ["{company}"],
        "service_titles": [],
        "seed_keywords": ["drammen", "service", "lokal", "kvalitet", "nærhet"],
        "bookingFormType": "standard",
        "personRole": "Ansatt",
        "match_tokens": [],
    }


def _make_business_name(sector: Optional[str], *, neighborhood: str) -> str:
    preset = _sector_preset(sector)
    template = random.choice(preset["name_templates"]) if preset["name_templates"] else "{company}"

    # Build a stable base company string.
    company = f"{fake.company()} {fake.company_suffix()}".strip()
    last = fake.last_name()

    name = template.format(company=company, last=last, neighborhood=neighborhood)
    # If user provided a custom sector and we're in generic mode, append it in a readable way.
    if preset.get("kind") == "generic" and sector:
        return f"{name} – {sector}".strip()
    return name.strip()

# --- THE GENERATOR ---
def generate_simulation(config: GenerationConfig):
    if config.append:
        try:
            with open(config.output_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            if not isinstance(data, dict):
                data = {}
        except FileNotFoundError:
            data = {}
        except Exception:
            data = {}
    else:
        data = {}

    data.setdefault("users", [])
    data.setdefault("companies", [])
    data.setdefault("stores", [])
    data.setdefault("persons", [])
    data.setdefault("services", [])
    if config.include_categories:
        data.setdefault("categories", [])

        # Only add categories if empty or missing (so append mode doesn't duplicate).
        if not data["categories"]:
            now = _now_utc()
            for c in _category_definitions():
                cat = CategoryModel(
                    id=f"cat_{c['slug']}",
                    name=c["name"],
                    slug=c["slug"],
                    icon=_category_icon_for_slug(c["slug"]),
                    createdAt=now,
                    updatedAt=now,
                )
                data["categories"].append(_safe_model_dump(cat))

    # 0. Customers (optional)
    if config.customers > 0:
        now = _now_utc()
        for i in range(config.customers):
            if config.verbose and (i % 50 == 0):
                print(f"👥 Customers: {i}/{config.customers}")
            cust = OwnerModel(
                name=fake.name(),
                email=fake.email(),
                phone=fake.phone_number() if hasattr(fake, "phone_number") else None,
                photoUrl=f"https://picsum.photos/seed/{uuid.uuid4().hex[:8]}/256/256",
                role="customer",
                isOnboarded=True,
                createdAt=now,
                updatedAt=now,
            )
            data["users"].append(_safe_model_dump(cust))

    # If user requested customers-only, skip business generation entirely.
    if config.customers_only:
        with open(config.output_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"🔥 Successfully generated seed data in {config.output_path}")
        return

    owners_total = config.owners
    for owner_index in range(owners_total):
        if config.verbose:
            print(f"👤 Owner {owner_index + 1}/{owners_total}")
    
        now = _now_utc()

        # 1. Parent: Owner
        owner = OwnerModel(
            name=fake.name(),
            email=fake.email(),
            phone=fake.phone_number() if hasattr(fake, "phone_number") else None,
            photoUrl=f"https://picsum.photos/seed/{uuid.uuid4().hex[:8]}/256/256",
            role="business",
            createdAt=now,
            updatedAt=now,
        )
        owner_index_in_list = len(data["users"])
        data["users"].append(_safe_model_dump(owner))

        # 2. Child: Companies
        companies_count = random.randint(config.companies_min, config.companies_max)
        for company_index in range(companies_count):
            sector_for_company = config.sector or _random_allowed_sector_name()

            # Use the first store location neighborhood as a naming hint.
            neighborhood_hint = random.choice(DRAMMEN_LOCATIONS)["neighborhood"]
            biz_name = _make_business_name(sector_for_company, neighborhood=neighborhood_hint)
            if config.use_ollama:
                ai_data = brainstorm_business(
                    biz_name,
                    sector=sector_for_company,
                    use_stream=config.ollama_stream,
                    show_progress=config.verbose,
                )
                # Ensure category-relevant keywords for filter/search testing.
                preset = _sector_preset(sector_for_company)
                ai_data = _normalize_ai_data(ai_data, seed_keywords=list(preset.get("seed_keywords") or []))
            else:
                preset = _sector_preset(sector_for_company)
                ai_data = _normalize_ai_data(None, seed_keywords=list(preset.get("seed_keywords") or []))

            category_label = _category_label_from_sector(sector_for_company)
            company = CompanyModel(
                ownerId=owner.id,
                ownerEmail=owner.email,
                name=biz_name,
                description=ai_data["description"],
                website=fake.url() if hasattr(fake, "url") else None,
                email=fake.company_email() if hasattr(fake, "company_email") else None,
                phone=fake.phone_number() if hasattr(fake, "phone_number") else None,
                logoUrl=f"https://picsum.photos/seed/{uuid.uuid4().hex[:8]}/512/512",

                onboardingStatus="complete",
                createdAt=now,
                updatedAt=now,
                managerIds=[owner.id],
                memberIds=[owner.id],
            )
            data["companies"].append(_safe_model_dump(company))

            # Update owner's memberships (so switch-company UI has data)
            owner_dump = data["users"][owner_index_in_list]
            owner_dump.setdefault("companyMemberships", [])
            owner_dump.setdefault("companyMembershipIds", [])
            owner_dump["companyMemberships"].append(
                _safe_model_dump(UserCompanyMembershipModel(companyId=company.id, role="owner", assignedAt=now))
            )
            owner_dump["companyMembershipIds"].append(company.id)
            owner_dump["updatedAt"] = now.isoformat()
            if config.verbose:
                print(f"  🏢 Company {company_index + 1}/{companies_count}: {biz_name}")

            # 3. Grandchild: Stores per Company
            stores_count = random.randint(config.stores_min, config.stores_max)
            for store_index in range(stores_count):
                loc = random.choice(DRAMMEN_LOCATIONS)
                zip_code = loc.get("zip") or _drammen_postcode(str(loc.get("neighborhood") or "Drammen"))
                store_id = f"store_{uuid.uuid4().hex[:6]}"
                store_name = f"{company.name} - {loc['neighborhood']}"
                booking_form_type = _booking_form_type_from_sector(sector_for_company)
                # Derive storeType from sector
                sector_kind = preset.get("kind", "generic")
                store_type = "restaurant" if sector_kind in ("restaurant", "fast-food", "cafe", "bakery") else "store"
                store = StoreModel(
                    id=store_id,
                    companyId=company.id, 
                    name=store_name,
                    slug=_slugify(store_name),
                    address=fake.street_address(),
                    zip=zip_code,
                    city="Drammen",
                    country="NO",
                    gmapCoord=_store_gmap_coord(store_id),
                    about=ai_data["description"],
                    images=_store_image_urls(store_id),
                    openingSchedule=_opening_schedule_default(),
                    timezone="Europe/Oslo",
                    storeType=store_type,
                    bookingFormType=booking_form_type,
                    category=category_label,
                    isPublished=True,
                    isActive=True,
                    createdAt=now,
                    updatedAt=now,
                )
                data["stores"].append(_safe_model_dump(store))
                if config.verbose:
                    print(f"    🏬 Store {store_index + 1}/{stores_count}: {store.name}")

                # 4. Great-Grandchild: Staff
                staff_ids = []
                create_staff = False
                if config.staff_mode == "resource":
                    create_staff = True
                elif config.staff_mode == "facility":
                    create_staff = False
                else:
                    create_staff = random.random() < config.staff_probability

                if create_staff:
                    persons_count = random.randint(config.persons_min, config.persons_max)
                    for _ in range(persons_count):
                        p_id = f"pers_{uuid.uuid4().hex[:6]}"
                        p = PersonModel(
                            id=p_id,
                            storeId=store.id,
                            name=fake.name(),
                            role=_person_role_from_sector(sector_for_company),
                            groups=["staff"],
                            imageUrl=f"https://picsum.photos/seed/{p_id}/256/256",
                            isBookable=True,
                        )
                        data["persons"].append(_safe_model_dump(p))
                        staff_ids.append(p.id)

                # 5. Services
                preset = _sector_preset(sector_for_company)
                titles: List[str] = list(preset.get("service_titles") or [])
                service_type = [_category_label_from_sector(sector_for_company)]
                for i in range(config.services_per_store):
                    if titles:
                        title = titles[i % len(titles)]
                    else:
                        title = f"Behandling {i+1}"

                    svc = ServiceModel(
                        storeId=store.id,
                        personId=random.choice(staff_ids) if staff_ids else None,
                        title=title,
                        description=ai_data["description"],
                        serviceType=service_type,
                        duration=random.choice(list(config.duration_options)),
                        price=random.randint(config.price_min, config.price_max),
                        keywords=ai_data["keywords"],
                        bufferTime=0,
                        capacity=1,
                        currency="NOK",
                        isActive=True,
                    )
                    data["services"].append(_safe_model_dump(svc))

    # Save to file
    with open(config.output_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"🔥 Successfully generated seed data in {config.output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate a Drammen Digital Twin seed JSON.")
    parser.add_argument("owners", nargs="?", type=int, help="Number of BUSINESS owners to create")
    parser.add_argument("--menu", action="store_true", help="Open interactive menu")

    parser.add_argument("--customers", type=int, default=0, help="Number of CUSTOMER users to create")
    parser.add_argument("--customers-only", action="store_true", help="Generate only customer users (no companies/stores)")

    parser.add_argument("--companies-min", type=int, default=1)
    parser.add_argument("--companies-max", type=int, default=3)
    parser.add_argument("--stores-min", type=int, default=1)
    parser.add_argument("--stores-max", type=int, default=2)

    parser.add_argument("--sector", type=str, default=None, help="Sector/category hint, e.g. 'Hair salons'")

    parser.add_argument("--staff-mode", choices=["auto", "resource", "facility"], default="auto")
    parser.add_argument("--staff-probability", type=float, default=0.5, help="0.0 to 1.0 (only used in auto mode)")
    parser.add_argument("--persons-min", type=int, default=1)
    parser.add_argument("--persons-max", type=int, default=3)

    parser.add_argument("--services-per-store", type=int, default=3)
    parser.add_argument("--durations", type=str, default="30,45,60,90", help="Comma-separated minutes")
    parser.add_argument("--price-min", type=int, default=500)
    parser.add_argument("--price-max", type=int, default=2000)

    parser.add_argument("--out", type=str, default="drammen_seed.json")
    parser.add_argument("--append", action="store_true")

    parser.add_argument("--include-categories", action="store_true", help="Include a 'categories' array in output JSON")

    parser.add_argument("--no-ollama", action="store_true")
    parser.add_argument("--ollama-stream", action="store_true", help="Show streaming progress (dots)")
    parser.add_argument("--no-progress", action="store_true", help="Disable progress prints")

    args = parser.parse_args()

    if args.menu:
        config = run_menu()
    else:
        owners = args.owners if args.owners is not None else 1
        durations: List[int] = []
        for part in (args.durations or "").split(","):
            part = part.strip()
            if not part:
                continue
            try:
                durations.append(int(part))
            except ValueError:
                continue
        duration_options = tuple([d for d in durations if d > 0]) or (30, 45, 60, 90)

        config = GenerationConfig(
            owners=max(0, owners),
            customers=max(0, args.customers),
            customers_only=bool(args.customers_only),
            companies_min=max(0, args.companies_min),
            companies_max=max(max(0, args.companies_min), args.companies_max),
            stores_min=max(0, args.stores_min),
            stores_max=max(max(0, args.stores_min), args.stores_max),
            sector=(args.sector.strip() if isinstance(args.sector, str) and args.sector.strip() else None),
            staff_mode=args.staff_mode,
            staff_probability=max(0.0, min(1.0, args.staff_probability)),
            persons_min=max(0, args.persons_min),
            persons_max=max(max(0, args.persons_min), args.persons_max),
            services_per_store=max(0, args.services_per_store),
            duration_options=duration_options,
            price_min=max(0, args.price_min),
            price_max=max(max(0, args.price_min), args.price_max),
            output_path=args.out,
            append=args.append,
            include_categories=bool(args.include_categories),
            use_ollama=not args.no_ollama,
            ollama_stream=args.ollama_stream,
            verbose=not args.no_progress,
        )

    generate_simulation(config)