# Search Keyword Capture Pipeline in DittoDatto

This document explains how the DittoBar search capture works and the best practices for robust search intelligence.

## Current Lifecycle in DittoDatto

1. **The "Pause" (Debounce):**
   We do not capture every single keystroke. When a user types `c` -> `a` -> `t` -> `s`, we have a timer set for **300 milliseconds**.
   If the user types the next letter before 300ms is up, the timer resets. The moment the user stops typing for 300ms, the system says "Okay, they are probably done for now" and updates the `debouncedQuery` variable.

2. **The Minimum Length:**
   If the user types only 1 letter (like "c" or "a") and pauses, we ignore it (`val.length < 2`). This stops the database from filling up with useless one-letter queries.

3. **The Logging Event:**
   When the 300ms timer finishes, a watcher triggers:
   1. The search query runs and yields result counters (so we know if the user found what they were looking for).
   2. It fires a fire-and-forget background Cloud Function (`analytics_logSearchEvent`) with the query string.

4. **The Click-Through:**
   If the user actually clicks on a store or category from the dropdown, a _second_ event is fired. This logs the query again but includes `selectedResult` payload so we can attribute searches to final destinations.

---

## Best Practices for Search Intelligence

**1. Lowercase & Normalize Queries**
Users are messy and will make identical semantic searches syntax-different:

- "Hair salon"
- "hair salon "
- "HAIR SALON"
  Before doing analytics or saving the canonical query, best practice is to `.toLowerCase().trim()` the query string.

**2. Keep the Raw String**
Always keep the exact text the user typed in a separate field (e.g., `rawQuery`). Why? Because typos are incredibly valuable. If 500 people search for "haridresser" instead of "hairdresser", you know you need to add "haridresser" as a hidden search tag to hair salons.

**3. AI Summarization > Manual Noun Extraction**
Extracting nouns, cleaning stop-words ("I", "need", "a"), and stemming ("bookings" -> "book") used to be required to make pie charts. When integrating an AI like Datto, the easiest industry approach is to save the full raw query on every document. You simply pass the AI an array of your top raw search strings and request: _"Summarize the core services our customers are looking for."_

AI thrives on messy human queries. You preserve the intent and context (adjectives like "cheap", "luxury") by avoiding manual tokenization and just leveraging Cloud Functions for basic normalization mapping alongside raw ingestion.
