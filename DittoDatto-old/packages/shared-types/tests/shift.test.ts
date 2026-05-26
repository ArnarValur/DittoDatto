/**
 * Shift Schema Test Suite
 *
 * Tests for ShiftBlock, DayShift, WeeklyShift, and DateOverride schemas.
 */
import { describe, it, expect } from "vitest";
import {
  ShiftBlockSchema,
  DayShiftSchema,
  WeeklyShiftSchema,
  DateOverrideSchema,
  DateOverrideTypeSchema,
} from "../src/shift";

// ---------------------
// ShiftBlockSchema
// ---------------------

describe("ShiftBlockSchema", () => {
  it("should parse a valid shift block", () => {
    const result = ShiftBlockSchema.parse({ start: "09:00", end: "13:00" });
    expect(result.start).toBe("09:00");
    expect(result.end).toBe("13:00");
    expect(result.label).toBeUndefined();
  });

  it("should accept optional label", () => {
    const result = ShiftBlockSchema.parse({
      start: "09:00",
      end: "13:00",
      label: "Morning",
    });
    expect(result.label).toBe("Morning");
  });

  it("should reject invalid time formats", () => {
    expect(() => ShiftBlockSchema.parse({ start: "9:00", end: "13:00" })).toThrow();
    expect(() => ShiftBlockSchema.parse({ start: "09:00", end: "1pm" })).toThrow();
    expect(() => ShiftBlockSchema.parse({ start: "09:00:00", end: "13:00" })).toThrow();
  });

  it("should reject missing fields", () => {
    expect(() => ShiftBlockSchema.parse({ start: "09:00" })).toThrow();
    expect(() => ShiftBlockSchema.parse({ end: "13:00" })).toThrow();
    expect(() => ShiftBlockSchema.parse({})).toThrow();
  });
});

// ---------------------
// DayShiftSchema
// ---------------------

describe("DayShiftSchema", () => {
  it("should parse a working day with blocks", () => {
    const result = DayShiftSchema.parse({
      isWorking: true,
      blocks: [
        { start: "09:00", end: "13:00" },
        { start: "14:00", end: "18:00" },
      ],
    });
    expect(result.isWorking).toBe(true);
    expect(result.blocks).toHaveLength(2);
  });

  it("should parse a day off with empty blocks", () => {
    const result = DayShiftSchema.parse({ isWorking: false, blocks: [] });
    expect(result.isWorking).toBe(false);
    expect(result.blocks).toEqual([]);
  });

  it("should default blocks to empty array", () => {
    const result = DayShiftSchema.parse({ isWorking: false });
    expect(result.blocks).toEqual([]);
  });
});

// ---------------------
// WeeklyShiftSchema
// ---------------------

describe("WeeklyShiftSchema", () => {
  function fullWeek() {
    const workDay = { isWorking: true, blocks: [{ start: "09:00", end: "17:00" }] };
    const offDay = { isWorking: false, blocks: [] };
    return {
      mon: workDay,
      tue: workDay,
      wed: workDay,
      thu: workDay,
      fri: workDay,
      sat: offDay,
      sun: offDay,
    };
  }

  it("should parse a valid full weekly schedule", () => {
    const result = WeeklyShiftSchema.parse(fullWeek());
    expect(result.mon.isWorking).toBe(true);
    expect(result.sat.isWorking).toBe(false);
    expect(result.fri.blocks).toHaveLength(1);
  });

  it("should support multi-block days (break times)", () => {
    const week = fullWeek();
    week.mon = {
      isWorking: true,
      blocks: [
        { start: "09:00", end: "12:00" },
        { start: "13:00", end: "17:00" },
      ],
    };
    const result = WeeklyShiftSchema.parse(week);
    expect(result.mon.blocks).toHaveLength(2);
    expect(result.mon.blocks[0].end).toBe("12:00");
    expect(result.mon.blocks[1].start).toBe("13:00");
  });

  it("should reject missing days", () => {
    const partial = { mon: { isWorking: true, blocks: [] } };
    expect(() => WeeklyShiftSchema.parse(partial)).toThrow();
  });
});

// ---------------------
// DateOverrideSchema
// ---------------------

describe("DateOverrideSchema", () => {
  it("should parse a day off override", () => {
    const result = DateOverrideSchema.parse({
      date: "2026-03-15",
      type: "off",
      reason: "Annual leave",
    });
    expect(result.date).toBe("2026-03-15");
    expect(result.type).toBe("off");
    expect(result.reason).toBe("Annual leave");
  });

  it("should parse a sick day without reason", () => {
    const result = DateOverrideSchema.parse({
      date: "2026-04-01",
      type: "sick",
    });
    expect(result.type).toBe("sick");
    expect(result.reason).toBeUndefined();
  });

  it("should parse a custom override with blocks", () => {
    const result = DateOverrideSchema.parse({
      date: "2026-05-10",
      type: "custom",
      reason: "Half day",
      blocks: [{ start: "09:00", end: "13:00" }],
    });
    expect(result.type).toBe("custom");
    expect(result.blocks).toHaveLength(1);
  });

  it("should reject invalid date format", () => {
    expect(() =>
      DateOverrideSchema.parse({ date: "March 15", type: "off" })
    ).toThrow();
    expect(() =>
      DateOverrideSchema.parse({ date: "15-03-2026", type: "off" })
    ).toThrow();
  });

  it("should reject invalid type", () => {
    expect(() =>
      DateOverrideSchema.parse({ date: "2026-03-15", type: "vacation" })
    ).toThrow();
  });
});

describe("DateOverrideTypeSchema", () => {
  it("should accept all valid types", () => {
    expect(DateOverrideTypeSchema.parse("off")).toBe("off");
    expect(DateOverrideTypeSchema.parse("sick")).toBe("sick");
    expect(DateOverrideTypeSchema.parse("custom")).toBe("custom");
  });
});
