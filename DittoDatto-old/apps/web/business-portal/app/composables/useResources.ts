import type { Resource } from "@dittodatto/shared-types";

/**
 * useResources — reactive Firestore collection of Resources for a store.
 *
 * Firestore path: companies/{companyId}/stores/{storeId}/resources
 */
export function useResources() {
  const { companyId } = useCompany();
  const firestore = useFirestore();

  // All resources across all stores for this company
  const allResources = ref<Resource[]>([]);
  const loading = ref(true);

  async function fetchResources(cid?: string | null) {
    const id = cid ?? companyId.value;
    if (!id) {
      allResources.value = [];
      loading.value = false;
      return;
    }

    loading.value = true;

    try {
      const { collection, getDocs } = await import("firebase/firestore");

      const storesSnap = await getDocs(
        collection(firestore, "companies", id, "stores"),
      );

      const resources: Resource[] = [];
      for (const storeDoc of storesSnap.docs) {
        const resourcesSnap = await getDocs(
          collection(
            firestore,
            "companies",
            id,
            "stores",
            storeDoc.id,
            "resources",
          ),
        );
        for (const doc of resourcesSnap.docs) {
          resources.push({ id: doc.id, ...doc.data() } as Resource);
        }
      }

      allResources.value = resources;
    } catch (e) {
      console.error("[useResources] Failed to fetch resources:", e);
      allResources.value = [];
    } finally {
      loading.value = false;
    }
  }

  // Watch for company changes and fetch resources
  watch(companyId, (cid) => fetchResources(cid), { immediate: true });

  // Filter helpers
  function resourcesByStore(storeId: string): Resource[] {
    return allResources.value.filter((r) => r.storeId === storeId);
  }

  function resourcesByGroup(groupId: string): Resource[] {
    return allResources.value.filter((r) => r.resourceGroupId === groupId);
  }

  function resourcesByType(type: Resource["type"]): Resource[] {
    return allResources.value.filter((r) => r.type === type);
  }

  function bookableResources(storeId: string): Resource[] {
    return allResources.value.filter(
      (r) => r.storeId === storeId && r.isBookable,
    );
  }

  function addonResources(storeId: string): Resource[] {
    return allResources.value.filter(
      (r) => r.storeId === storeId && r.type === "addon",
    );
  }

  function tableResources(storeId: string): Resource[] {
    return allResources.value.filter(
      (r) => r.storeId === storeId && r.type === "table" && r.isBookable,
    );
  }

  return {
    allResources,
    loading,
    fetchResources,
    resourcesByStore,
    resourcesByGroup,
    resourcesByType,
    bookableResources,
    addonResources,
    tableResources,
  };
}
