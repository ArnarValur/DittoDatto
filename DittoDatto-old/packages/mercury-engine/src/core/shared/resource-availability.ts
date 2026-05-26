// packages/functions/src/MercuryEngine/resource-availability.ts
// Core Domain: Booking Context - Resource Availability Check
// Analog of staff-availability.ts but for physical resources.
//
// Design: For each required resource group, find >= 1 bookable resource
// not occupied in the time window. If ALL required groups have an available
// resource, the slot is bookable from a resource perspective.

import { Resource, ResourceGroup, Booking, Hold } from "@dittodatto/shared-types";

/**
 * Occupied interval in minutes from midnight.
 */
interface OccupiedInterval {
  start: number;
  end: number;
  resourceId?: string; // If the booking is tied to a specific resource
}

/**
 * Check if resources are available for a given slot.
 *
 * @param resources - All bookable resources for the store
 * @param resourceGroups - All resource groups for the store
 * @param requiredGroupIds - Resource group IDs required by the service
 * @param slotStart - Start of the slot (minutes from midnight)
 * @param slotEnd - End of the slot (minutes from midnight)
 * @param occupiedIntervals - All occupied intervals (from bookings + holds)
 * @returns Object with availability status and assigned resources
 */
export function getAvailableResourcesForSlot(
  resources: Resource[],
  resourceGroups: ResourceGroup[],
  requiredGroupIds: string[],
  slotStart: number,
  slotEnd: number,
  occupiedIntervals: OccupiedInterval[],
): { available: boolean; assignedResources: Resource[] } {
  // No resource requirements → always available
  if (!requiredGroupIds || requiredGroupIds.length === 0) {
    return { available: true, assignedResources: [] };
  }

  const assignedResources: Resource[] = [];
  const usedResourceIds = new Set<string>();

  // Check each required group — all must have >= 1 available resource
  for (const groupId of requiredGroupIds) {
    const groupResources = resources.filter(
      (r) => r.resourceGroupId === groupId && r.isBookable,
    );

    // Sort by priority (high > normal > low), then by capacity (smallest first = best-fit)
    // This prevents resource fragmentation: small resources get used before big ones
    const priorityOrder: Record<string, number> = { high: 0, normal: 1, low: 2 };
    groupResources.sort((a, b) => {
      const pa = priorityOrder[a.priority] ?? 1;
      const pb = priorityOrder[b.priority] ?? 1;
      if (pa !== pb) return pa - pb;
      return (a.maxCapacity ?? 0) - (b.maxCapacity ?? 0); // smallest first
    });

    let foundResource: Resource | null = null;

    for (const resource of groupResources) {
      // Skip already-assigned resources (one resource per group per slot)
      if (usedResourceIds.has(resource.id)) continue;

      // Check if this resource is occupied during the slot
      const isOccupied = occupiedIntervals.some((occ) => {
        // Only check intervals tied to this specific resource
        if (occ.resourceId && occ.resourceId !== resource.id) return false;
        // If interval has no resourceId, it's a general occupation — skip for resource check
        if (!occ.resourceId) return false;
        // Overlap: (StartA < EndB) && (EndA > StartB)
        return slotStart < occ.end && slotEnd > occ.start;
      });

      if (!isOccupied || resource.allowOverlapping) {
        foundResource = resource;
        break;
      }
    }

    if (!foundResource) {
      // This required group has no available resource → slot is not bookable
      return { available: false, assignedResources: [] };
    }

    assignedResources.push(foundResource);
    usedResourceIds.add(foundResource.id);
  }

  return { available: true, assignedResources };
}
