/**
 * Staff Schema Test Suite
 *
 * Tests for StaffMember, StaffCapability, StaffStatus,
 * and the Create/Update input schemas.
 */
import { describe, it, expect } from "vitest";
import {
  StaffCapabilitySchema,
  StaffStatusSchema,
  StaffMemberSchema,
  CreateStaffMemberSchema,
  UpdateStaffMemberSchema,
  ALL_STAFF_CAPABILITIES,
  type StaffCapability,
  type StaffStatus,
} from "../src/staff";

// ---------------------
// Helpers
// ---------------------

const now = new Date();

function validStaffMember() {
  return {
    id: "staff-001",
    companyId: "company-001",
    email: "alice@example.com",
    displayName: "Alice Nordmann",
    storeIds: ["store-a", "store-b"],
    position: "Senior Stylist",
    defaultCapabilities: ["can_manage_bookings", "can_manage_schedule"],
    storeCapabilities: {},
    isBookable: true,
    status: "active",
    createdAt: now,
    updatedAt: now,
  };
}

// ---------------------
// Tests
// ---------------------

describe("StaffCapabilitySchema", () => {
  const validCapabilities: StaffCapability[] = [
    "can_manage_bookings",
    "can_view_all_bookings",
    "can_manage_schedule",
    "can_manage_services",
    "can_manage_staff",
    "can_view_financials",
    "can_manage_media",
    "can_manage_events",
    "can_manage_settings",
  ];

  it("should parse all 9 valid capabilities", () => {
    for (const cap of validCapabilities) {
      expect(StaffCapabilitySchema.parse(cap)).toBe(cap);
    }
  });

  it("should list all capabilities via ALL_STAFF_CAPABILITIES", () => {
    expect(ALL_STAFF_CAPABILITIES).toHaveLength(9);
    expect(ALL_STAFF_CAPABILITIES).toEqual(validCapabilities);
  });

  it("should reject invalid capability values", () => {
    expect(() => StaffCapabilitySchema.parse("can_fly")).toThrow();
    expect(() => StaffCapabilitySchema.parse("")).toThrow();
    expect(() => StaffCapabilitySchema.parse(42)).toThrow();
  });
});

describe("StaffStatusSchema", () => {
  const validStatuses: StaffStatus[] = [
    "invited",
    "active",
    "suspended",
    "removed",
  ];

  it("should parse all 4 valid statuses", () => {
    for (const status of validStatuses) {
      expect(StaffStatusSchema.parse(status)).toBe(status);
    }
  });

  it("should reject invalid status values", () => {
    expect(() => StaffStatusSchema.parse("fired")).toThrow();
    expect(() => StaffStatusSchema.parse("")).toThrow();
  });
});

describe("StaffMemberSchema", () => {
  it("should parse a valid full staff member", () => {
    const data = validStaffMember();
    const result = StaffMemberSchema.parse(data);

    expect(result.id).toBe("staff-001");
    expect(result.companyId).toBe("company-001");
    expect(result.email).toBe("alice@example.com");
    expect(result.displayName).toBe("Alice Nordmann");
    expect(result.storeIds).toEqual(["store-a", "store-b"]);
    expect(result.isBookable).toBe(true);
    expect(result.status).toBe("active");
  });

  it("should apply correct defaults", () => {
    const minimal = {
      id: "staff-002",
      companyId: "company-001",
      email: "bob@example.com",
      displayName: "Bob",
      createdAt: now,
      updatedAt: now,
    };
    const result = StaffMemberSchema.parse(minimal);

    expect(result.status).toBe("invited");
    expect(result.storeIds).toEqual([]);
    expect(result.isBookable).toBe(false);
    expect(result.defaultCapabilities).toEqual([]);
    expect(result.storeCapabilities).toEqual({});
  });

  it("should accept optional userId (linked after sign-in)", () => {
    const data = { ...validStaffMember(), userId: "uid-firebase-123" };
    const result = StaffMemberSchema.parse(data);
    expect(result.userId).toBe("uid-firebase-123");
  });

  it("should accept optional avatarUrl", () => {
    const data = {
      ...validStaffMember(),
      avatarUrl: "https://cdn.example.com/avatar.jpg",
    };
    const result = StaffMemberSchema.parse(data);
    expect(result.avatarUrl).toBe("https://cdn.example.com/avatar.jpg");
  });

  it("should reject invalid email", () => {
    const data = { ...validStaffMember(), email: "not-an-email" };
    expect(() => StaffMemberSchema.parse(data)).toThrow();
  });

  it("should reject empty displayName", () => {
    const data = { ...validStaffMember(), displayName: "" };
    expect(() => StaffMemberSchema.parse(data)).toThrow();
  });

  it("should reject invalid avatarUrl", () => {
    const data = { ...validStaffMember(), avatarUrl: "not-a-url" };
    expect(() => StaffMemberSchema.parse(data)).toThrow();
  });

  it("should accept per-store capabilities", () => {
    const data = {
      ...validStaffMember(),
      storeCapabilities: {
        "store-a": ["can_manage_bookings", "can_manage_media"],
        "store-b": ["can_manage_schedule"],
      },
    };
    const result = StaffMemberSchema.parse(data);
    expect(result.storeCapabilities["store-a"]).toHaveLength(2);
    expect(result.storeCapabilities["store-b"]).toHaveLength(1);
  });

  it("should accept weeklyShifts with multi-block shifts", () => {
    const weeklyShifts = {
      mon: { isWorking: true, blocks: [{ start: "09:00", end: "13:00", label: "Morning" }, { start: "14:00", end: "18:00", label: "Afternoon" }] },
      tue: { isWorking: true, blocks: [{ start: "09:00", end: "17:00" }] },
      wed: { isWorking: true, blocks: [{ start: "09:00", end: "17:00" }] },
      thu: { isWorking: true, blocks: [{ start: "09:00", end: "17:00" }] },
      fri: { isWorking: true, blocks: [{ start: "09:00", end: "17:00" }] },
      sat: { isWorking: false, blocks: [] },
      sun: { isWorking: false, blocks: [] },
    };
    const data = { ...validStaffMember(), weeklyShifts };
    const result = StaffMemberSchema.parse(data);
    expect(result.weeklyShifts?.mon.isWorking).toBe(true);
    expect(result.weeklyShifts?.mon.blocks).toHaveLength(2);
    expect(result.weeklyShifts?.sat.isWorking).toBe(false);
  });

  it("should accept dateOverrides", () => {
    const dateOverrides = [
      { date: "2026-03-15", type: "off" as const, reason: "Annual leave" },
      { date: "2026-03-20", type: "custom" as const, blocks: [{ start: "10:00", end: "14:00" }] },
      { date: "2026-03-25", type: "sick" as const },
    ];
    const data = { ...validStaffMember(), dateOverrides };
    const result = StaffMemberSchema.parse(data);
    expect(result.dateOverrides).toHaveLength(3);
    expect(result.dateOverrides[0].type).toBe("off");
    expect(result.dateOverrides[1].blocks).toHaveLength(1);
  });

  it("should accept Firestore-style timestamps", () => {
    const data = {
      ...validStaffMember(),
      createdAt: { seconds: 1707600000, nanoseconds: 0 },
      updatedAt: { seconds: 1707600000, nanoseconds: 0 },
    };
    const result = StaffMemberSchema.parse(data);
    expect(result.createdAt).toEqual({ seconds: 1707600000, nanoseconds: 0 });
  });
});

describe("CreateStaffMemberSchema", () => {
  it("should parse valid creation input (omits server-set fields)", () => {
    const input = {
      email: "charlie@example.com",
      displayName: "Charlie Hansen",
      storeIds: ["store-a"],
      position: "Barista",
      defaultCapabilities: ["can_manage_bookings"],
    };
    const result = CreateStaffMemberSchema.parse(input);

    expect(result.email).toBe("charlie@example.com");
    expect(result.displayName).toBe("Charlie Hansen");
    expect(result.status).toBe("invited");
  });

  it("should NOT require id, companyId, userId, or timestamps", () => {
    const input = {
      email: "minimal@example.com",
      displayName: "Minimal",
    };
    // Should not throw — these fields are omitted from the schema
    const result = CreateStaffMemberSchema.parse(input);
    expect(result.email).toBe("minimal@example.com");
  });

  it("should still require email and displayName", () => {
    expect(() => CreateStaffMemberSchema.parse({})).toThrow();
    expect(() =>
      CreateStaffMemberSchema.parse({ email: "a@b.com" })
    ).toThrow();
    expect(() =>
      CreateStaffMemberSchema.parse({ displayName: "X" })
    ).toThrow();
  });
});

describe("UpdateStaffMemberSchema", () => {
  it("should require id", () => {
    expect(() => UpdateStaffMemberSchema.parse({})).toThrow();
    expect(() =>
      UpdateStaffMemberSchema.parse({ displayName: "Updated" })
    ).toThrow();
  });

  it("should allow partial updates with id", () => {
    const result = UpdateStaffMemberSchema.parse({
      id: "staff-001",
      position: "Lead Stylist",
    });
    expect(result.id).toBe("staff-001");
    expect(result.position).toBe("Lead Stylist");
    expect(result.email).toBeUndefined();
  });

  it("should allow updating status", () => {
    const result = UpdateStaffMemberSchema.parse({
      id: "staff-001",
      status: "suspended",
    });
    expect(result.status).toBe("suspended");
  });

  it("should allow updating capabilities", () => {
    const result = UpdateStaffMemberSchema.parse({
      id: "staff-001",
      defaultCapabilities: [
        "can_manage_bookings",
        "can_manage_services",
        "can_manage_media",
      ],
    });
    expect(result.defaultCapabilities).toHaveLength(3);
  });
});
