/**
 * Norwegian Public Holidays
 *
 * Static list of recurring Norwegian public holidays.
 * Used by MercuryEngine to exclude slots on public holidays
 * (unless the store explicitly marks itself as open on that day).
 *
 * Format: { month (1-indexed), day, name (Norwegian), nameEn }
 * For moveable holidays (Easter, Ascension, Whit), use the helper function.
 *
 * Reference: https://www.timeanddate.com/holidays/norway/
 */

export interface NorwegianHoliday {
  date: string;  // "YYYY-MM-DD"
  name: string;  // Norwegian name
  nameEn: string;
}

// --- Fixed holidays (same date every year) ---

const FIXED_HOLIDAYS: Array<{ month: number; day: number; name: string; nameEn: string }> = [
  { month: 1,  day: 1,  name: "Første nyttårsdag",        nameEn: "New Year's Day" },
  { month: 5,  day: 1,  name: "Arbeidernes dag",          nameEn: "Labour Day" },
  { month: 5,  day: 17, name: "Grunnlovsdag",             nameEn: "Constitution Day" },
  { month: 12, day: 25, name: "Første juledag",           nameEn: "Christmas Day" },
  { month: 12, day: 26, name: "Andre juledag",            nameEn: "St. Stephen's Day" },
];

// --- Easter-based holidays (moveable) ---

/**
 * Calculate Easter Sunday using the Anonymous Gregorian algorithm.
 * Returns the date of Easter Sunday for the given year.
 */
function getEasterSunday(year: number): Date {
  const a = year % 19;
  const b = Math.floor(year / 100);
  const c = year % 100;
  const d = Math.floor(b / 4);
  const e = b % 4;
  const f = Math.floor((b + 8) / 25);
  const g = Math.floor((b - f + 1) / 3);
  const h = (19 * a + b - d - g + 15) % 30;
  const i = Math.floor(c / 4);
  const k = c % 4;
  const l = (32 + 2 * e + 2 * i - h - k) % 7;
  const m = Math.floor((a + 11 * h + 22 * l) / 451);
  const month = Math.floor((h + l - 7 * m + 114) / 31);
  const day = ((h + l - 7 * m + 114) % 31) + 1;
  return new Date(year, month - 1, day);
}

function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

function formatDate(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const d = String(date.getDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

/**
 * Get all Norwegian public holidays for a given year.
 * Includes both fixed and moveable (Easter-based) holidays.
 */
export function getNorwegianHolidays(year: number): NorwegianHoliday[] {
  const holidays: NorwegianHoliday[] = [];

  // Fixed holidays
  for (const h of FIXED_HOLIDAYS) {
    holidays.push({
      date: `${year}-${String(h.month).padStart(2, "0")}-${String(h.day).padStart(2, "0")}`,
      name: h.name,
      nameEn: h.nameEn,
    });
  }

  // Easter-based holidays
  const easter = getEasterSunday(year);
  const easterBased: Array<{ offset: number; name: string; nameEn: string }> = [
    { offset: -3,  name: "Skjærtorsdag",              nameEn: "Maundy Thursday" },
    { offset: -2,  name: "Langfredag",                 nameEn: "Good Friday" },
    { offset: 0,   name: "Første påskedag",            nameEn: "Easter Sunday" },
    { offset: 1,   name: "Andre påskedag",             nameEn: "Easter Monday" },
    { offset: 39,  name: "Kristi himmelfartsdag",      nameEn: "Ascension Day" },
    { offset: 49,  name: "Første pinsedag",            nameEn: "Whit Sunday" },
    { offset: 50,  name: "Andre pinsedag",             nameEn: "Whit Monday" },
  ];

  for (const h of easterBased) {
    const date = addDays(easter, h.offset);
    holidays.push({
      date: formatDate(date),
      name: h.name,
      nameEn: h.nameEn,
    });
  }

  // Sort by date
  holidays.sort((a, b) => a.date.localeCompare(b.date));

  return holidays;
}

/**
 * Check if a specific date string ("YYYY-MM-DD") is a Norwegian public holiday.
 */
export function isNorwegianHoliday(dateStr: string): boolean {
  const year = parseInt(dateStr.substring(0, 4), 10);
  const holidays = getNorwegianHolidays(year);
  return holidays.some((h) => h.date === dateStr);
}
