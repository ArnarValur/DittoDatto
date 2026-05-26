---
title: "PostIT: Prediction Department — Scout Agents"
type: "postit"
status: "concept"
date: "2026-05-02"
session: 4
domain: "Agentic"
tags:
  - "agents"
  - "prediction"
  - "scouts"
  - "v1-5"
---

# PostIt: Prediction Department — Scout Agents

## Concept

When DittoDatto expands to a new city/area, don't wait for businesses to onboard or users to search. Deploy a **Research Duo** — specialized scout agents that proactively map the business landscape.

## How It Works

1. **Area activation:** Admin (or Datto) designates a new target area (e.g., "Kongsberg")
2. **Scout agents crawl public sources:** Google Maps, Proff.no, 1881.no, Gule Sider
3. **For each discovered business:** Create a **candidate node** in the graph
   - Not a full establishment — a "scouted" node with `onboarding.status = "scouted"`
   - Contains: name, address, category (inferred), coordinates, source URL
4. **Candidate nodes become sales leads:** "We found 12 massage studios in Kongsberg — none on DittoDatto yet"
5. **When a business onboards:** The candidate node resolves into a full establishment node

## Relationship to Zero-Result Signals

Two sources of demand intelligence:
- **Reactive (SearchEvents):** Users searched for X but no result exists → ghost demand node
- **Proactive (Scouts):** Agents found business Y exists but isn't onboarded → candidate supply node

When candidate supply meets ghost demand → high-priority sales lead.

## Not Spying

Scout agents only access public directory information. Same data anyone can see on Google Maps or Proff.no. The intelligence isn't in the data — it's in the **correlation** between supply (what exists) and demand (what users search for).

## Grill Questions (for future session)

1. Which public sources to crawl? Legal constraints?
2. How to categorize businesses automatically from directory listings?
3. How often to re-scan areas?
4. How to present candidate nodes in the Admin Panel analytics dashboard?
5. Can the Research Duo use local LLMs on Saturn for classification?
