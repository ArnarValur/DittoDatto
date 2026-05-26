// import { httpsCallable } from "firebase/functions";
// import type {
//   UserFavorite,
// } from "@dittodatto/shared-types";

// const LOCAL_STORAGE_KEY = "dd_favorites_cache_v1";

// type FavoriteType = "store" | "person";

// const isClient = () => typeof window !== "undefined";

// const sanitizeFavorites = (items: UserFavorite[]): UserFavorite[] => {
//   const map = new Map<string, UserFavorite>();
//   for (const item of items || []) {
//     if (!item?.id || !item.type) continue;
//     const key = `${item.type}:${item.id}`;
//     map.set(key, {
//       ...item,
//       addedAt: item.addedAt || new Date().toISOString(),
//     });
//   }
//   return Array.from(map.values());
// };

// const readCachedFavorites = (): UserFavorite[] => {
//   if (!isClient()) return [];
//   try {
//     const raw = window.localStorage.getItem(LOCAL_STORAGE_KEY);
//     if (!raw) return [];
//     const parsed = JSON.parse(raw);
//     return sanitizeFavorites(Array.isArray(parsed) ? parsed : []);
//   } catch (error) {
//     console.warn("Failed to read cached favorites", error);
//     return [];
//   }
// };

// const writeCachedFavorites = (entries: UserFavorite[]) => {
//   if (!isClient()) return;
//   try {
//     window.localStorage.setItem(
//       LOCAL_STORAGE_KEY,
//       JSON.stringify(sanitizeFavorites(entries))
//     );
//   } catch (error) {
//     console.warn("Failed to persist cached favorites", error);
//   }
// };

// const mergeFavoritesForCache = (
//   incoming: UserFavorite[],
//   type?: FavoriteType
// ) => {
//   if (!incoming?.length) return;
//   const sanitized = sanitizeFavorites(incoming);
//   if (!type) {
//     writeCachedFavorites(sanitized);
//     return;
//   }

//   const current = readCachedFavorites();
//   const preserved = current.filter((item) => item.type !== type);
//   writeCachedFavorites([...preserved, ...sanitized]);
// };

// const updateCachedFavorites = (
//   updater: (items: UserFavorite[]) => UserFavorite[]
// ) => {
//   const current = readCachedFavorites();
//   writeCachedFavorites(updater(current));
// };

// export const useFavorites = () => {
//   const favorites = useState<UserFavorite[]>("user_favorites", () => []);
//   const loading = useState<boolean>("favorites_loading", () => false);
//   const fallbackActive = useState<boolean>(
//     "favorites_fallback_active",
//     () => false
//   );
//   const fallbackNotified = useState<boolean>(
//     "favorites_fallback_notified",
//     () => false
//   );
//   const toast = useAppToast();

//   const filterByType = (items: UserFavorite[], type?: FavoriteType) => {
//     if (!type) return items;
//     return items.filter((item) => item.type === type);
//   };

//   const handleFallback = async (type?: FavoriteType) => {
//     // In dev mode, fall back to cached favorites if Firebase is unavailable
//     if (!process.dev) return false;

//     const cached = readCachedFavorites();
//     if (!cached.length) return false;

//     favorites.value = filterByType(cached, type);
//     fallbackActive.value = true;

//     if (!fallbackNotified.value) {
//       toast.add({
//         title: "Favorites unavailable",
//         description:
//           "Firebase Functions are offline. Showing locally cached favorites instead.",
//         color: "warning",
//       });
//       fallbackNotified.value = true;
//     }
//     return true;
//   };

//   const fetchFavorites = async (type?: FavoriteType) => {
//     try {
//       loading.value = true;
//       const functions = useCallableFunctions();
//       const listFavorites = httpsCallable<
//         ListFavoritesRequest,
//         ListFavoritesResponse
//       >(functions, "listFavorites");
//       const result = await listFavorites({ type });
//       favorites.value = result.data.favorites;
//       mergeFavoritesForCache(result.data.favorites, type);
//       fallbackActive.value = false;
//     } catch (e: any) {
//       console.error("Failed to fetch favorites", e);
//       const handled = await handleFallback(type);
//       if (!handled) {
//         toast.add({
//           title: "Failed to load favorites",
//           description: e.message || "Unknown error",
//           color: "error",
//         });
//       }
//     } finally {
//       loading.value = false;
//     }
//   };

//   const addFavorite = async (id: string, type: FavoriteType) => {
//     const upsertFavorite = (favorite: UserFavorite) => {
//       const existingIndex = favorites.value.findIndex(
//         (item) => item.id === favorite.id && item.type === favorite.type
//       );
//       if (existingIndex === -1) {
//         favorites.value = [...favorites.value, favorite];
//       } else {
//         favorites.value.splice(existingIndex, 1, favorite);
//       }
//     };

//     const addLocally = () => {
//       const favorite: UserFavorite = {
//         id,
//         type,
//         addedAt: new Date().toISOString(),
//       };
//       updateCachedFavorites((items) => {
//         const filtered = items.filter(
//           (item) => !(item.id === favorite.id && item.type === favorite.type)
//         );
//         return [...filtered, favorite];
//       });
//       upsertFavorite(favorite);
//       fallbackActive.value = true;
//       toast.add({
//         title: "Saved locally",
//         description:
//           "Favorites service is offline, storing locally until it returns.",
//         color: "warning",
//       });
//     };

//     try {
//       loading.value = true;
//       const functions = useCallableFunctions();
//       const addFav = httpsCallable<AddFavoriteRequest, AddFavoriteResponse>(
//         functions,
//         "addFavorite"
//       );
//       const result = await addFav({ id, type });

//       if (result.data.success) {
//         upsertFavorite(result.data.favorite);
//         mergeFavoritesForCache([result.data.favorite], type);
//         toast.add({ title: "Added to favorites", color: "success" });
//         fallbackActive.value = false;
//       }
//     } catch (e: any) {
//       console.error("Failed to add favorite", e);
//       if (process.dev) {
//         addLocally();
//       } else {
//         toast.add({
//           title: "Failed to add favorite",
//           description: e.message || "Unknown error",
//           color: "error",
//         });
//       }
//     } finally {
//       loading.value = false;
//     }
//   };

//   const removeFavorite = async (id: string) => {
//     const removeFromState = () => {
//       favorites.value = favorites.value.filter((f) => f.id !== id);
//     };

//     const removeLocally = () => {
//       let removed = false;
//       updateCachedFavorites((items) => {
//         const filtered = items.filter((item) => {
//           const shouldKeep = item.id !== id;
//           if (!shouldKeep) removed = true;
//           return shouldKeep;
//         });
//         return filtered;
//       });
//       if (removed) {
//         removeFromState();
//         toast.add({
//           title: "Removed locally",
//           description: "Favorites service is offline, change stored locally.",
//           color: "warning",
//         });
//       }
//       return removed;
//     };

//     try {
//       loading.value = true;
//       const functions = useCallableFunctions();
//       const removeFav = httpsCallable<
//         RemoveFavoriteRequest,
//         RemoveFavoriteResponse
//       >(functions, "removeFavorite");
//       await removeFav({ id });

//       removeFromState();
//       updateCachedFavorites((items) => items.filter((item) => item.id !== id));
//       toast.add({ title: "Removed from favorites", color: "success" });
//       fallbackActive.value = false;
//     } catch (e: any) {
//       console.error("Failed to remove favorite", e);
//       if (!(process.dev && removeLocally())) {
//         toast.add({
//           title: "Failed to remove favorite",
//           description: e.message || "Unknown error",
//           color: "error",
//         });
//       }
//     } finally {
//       loading.value = false;
//     }
//   };

//   return {
//     favorites,
//     loading,
//     fetchFavorites,
//     addFavorite,
//     removeFavorite,
//   };
// };
