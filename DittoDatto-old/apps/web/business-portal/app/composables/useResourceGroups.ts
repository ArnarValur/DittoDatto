import type { ResourceGroup } from "@dittodatto/shared-types";

/**
 * useResourceGroups — reactive Firestore collection of Resource Groups for a store.
 *
 * Firestore path: companies/{companyId}/stores/{storeId}/resourceGroups
 */
export function useResourceGroups() {
  const { companyId } = useCompany();
  const firestore = useFirestore();

  const allResourceGroups = ref<ResourceGroup[]>([]);
  const loading = ref(true);

  async function fetchGroups(cid?: string | null) {
    const id = cid ?? companyId.value;
    if (!id) {
      allResourceGroups.value = [];
      loading.value = false;
      return;
    }

    loading.value = true;

    try {
      const { collection, getDocs } = await import("firebase/firestore");

      const storesSnap = await getDocs(
        collection(firestore, "companies", id, "stores"),
      );

      const groups: ResourceGroup[] = [];
      for (const storeDoc of storesSnap.docs) {
        const groupsSnap = await getDocs(
          collection(
            firestore,
            "companies",
            id,
            "stores",
            storeDoc.id,
            "resourceGroups",
          ),
        );
        for (const doc of groupsSnap.docs) {
          groups.push({ id: doc.id, ...doc.data() } as ResourceGroup);
        }
      }

      allResourceGroups.value = groups.sort(
        (a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0),
      );
    } catch (e) {
      console.error(
        "[useResourceGroups] Failed to fetch resource groups:",
        e,
      );
      allResourceGroups.value = [];
    } finally {
      loading.value = false;
    }
  }

  watch(companyId, (cid) => fetchGroups(cid), { immediate: true });

  function groupsByStore(storeId: string): ResourceGroup[] {
    return allResourceGroups.value.filter((g) => g.storeId === storeId);
  }

  return {
    allResourceGroups,
    loading,
    fetchGroups,
    groupsByStore,
  };
}
