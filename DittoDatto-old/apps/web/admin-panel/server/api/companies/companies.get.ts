// apps/admin-panel/server/api/companies/companies.get.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const page = Number(query.page) || 1
  const pageSize = Number(query.pageSize) || 20
  const search = query.search as string

  const db = getFirestore()
  const collectionRef = db.collection('companies')
  const queryRef = collectionRef.orderBy('createdAt', 'desc') // Default sort

  // Basic Search Implementation (Firestore is limited here without Typesense/Algolia)
  // For MVP, we assume client-side filtering or exact ID match if search is provided
  // Or utilize the "keywords" array if you implemented it.
  if (search) {
    // For now, let's just log it. Real search requires an external index or specific "where" clauses.
    console.log('Search requested:', search)
  }

  // Pagination (Offset approach for Admin Panels is acceptable for < 10k records)
  // For production > 10k, use cursor-based (startAfter).
  const snapshot = await queryRef
    .limit(pageSize)
    .offset((page - 1) * pageSize)
    .get()

  // Get Total Count (Aggregation Query)
  const countSnapshot = await collectionRef.count().get()

  const companies = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }))

  return {
    companies,
    total: countSnapshot.data().count,
    page,
    pageSize,
    hasNextPage: (page * pageSize) < countSnapshot.data().count
  }
})
