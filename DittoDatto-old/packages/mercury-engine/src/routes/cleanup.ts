/**
 * Cleanup Routes for MercuryEngine
 * 
 * System endpoints for maintenance tasks like expired hold cleanup.
 * Protected by internal API key (intended for Cloud Scheduler/cron).
 */

import { Hono } from 'hono'
import { db } from '../config/firebase.js'
import { requireInternalKey } from '../middleware/auth.js'

const app = new Hono()

/**
 * DELETE /cleanup/holds/expired
 * Remove expired holds from the database
 * PROTECTED: Requires internal API key
 */
app.delete('/holds/expired', requireInternalKey, async (c) => {
    try {
        const now = new Date().toISOString()
        
        // Query for expired holds
        const expiredHoldsSnapshot = await db
            .collection('holds')
            .where('expiresAt', '<=', now)
            .get()

        if (expiredHoldsSnapshot.empty) {
            return c.json({
                success: true,
                deletedCount: 0,
                message: 'No expired holds found'
            })
        }

        // Batch delete (max 500 at a time)
        const batch = db.batch()
        let count = 0

        expiredHoldsSnapshot.docs.forEach((doc) => {
            batch.delete(doc.ref)
            count++
        })

        await batch.commit()

        console.log(`Cleanup: Deleted ${count} expired holds`)

        return c.json({
            success: true,
            deletedCount: count,
            message: `Deleted ${count} expired hold(s)`
        })
    } catch (error: any) {
        console.error('Error cleaning up expired holds:', error)
        return c.json({
            success: false,
            error: 'Failed to clean up expired holds'
        }, 500)
    }
})

/**
 * GET /cleanup/stats
 * Get cleanup statistics (for monitoring)
 */
app.get('/stats', async (c) => {
    try {
        const now = new Date().toISOString()

        const [totalHolds, expiredHolds] = await Promise.all([
            db.collection('holds').count().get(),
            db.collection('holds').where('expiresAt', '<=', now).count().get(),
        ])

        return c.json({
            totalHolds: totalHolds.data().count,
            expiredHolds: expiredHolds.data().count,
            timestamp: now,
        })
    } catch (error: any) {
        console.error('Error fetching cleanup stats:', error)
        return c.json({
            error: 'Failed to fetch stats'
        }, 500)
    }
})

export default app
