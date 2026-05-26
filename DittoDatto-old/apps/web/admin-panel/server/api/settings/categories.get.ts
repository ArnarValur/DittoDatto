import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const page = Number(query.page) || 1
  const pageSize = Number(query.pageSize) || 20
  const search = query.search as string

  const db = getFirestore()
  const collectionRef = db.collection('categories')
  let queryRef = collectionRef.orderBy('slug', 'asc')

  // Simple search filtering
  if (search) {
    const searchLower = search.toLowerCase()
    const end = searchLower.replace(/.$/, c => String.fromCharCode(c.charCodeAt(0) + 1))
    queryRef = collectionRef
      .where('slug', '>=', searchLower)
      .where('slug', '<', end)
      .orderBy('slug', 'asc')
  }

  const snapshot = await queryRef
    .limit(pageSize)
    .offset((page - 1) * pageSize)
    .get()

  const countSnapshot = await collectionRef.count().get()

  const categories = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }))

  return {
    categories,
    total: countSnapshot.data().count,
    page,
    pageSize,
    hasNextPage: (page * pageSize) < countSnapshot.data().count
  }
})
