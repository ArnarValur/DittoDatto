# DittoDatto Platform

## dittodatto.no

    ./apps/web/public-marketplace/

    This is the frontpage of DittoDatto.
    Here public guests and registered user can browse and look for services and look for appointments and book them.

    Data comes from Firestore.
    Authentication (Login/Signup) is from Firebase Authentication.

## portal.dittodatto.no

    ./apps/web/business-portal/

    This is the business portal of DittoDatto.
    Here business users can manage their company, stores, staff and bookings.

    Data comes from Firestore.
    Authentication (Login/Signup) is from Firebase Authentication.
    Some business users can create Establishments, Services, Staff (Users), Events, Bookings, etc.

## panel.dittodatto.no (change subdomain into something else than admin for security sake)

    ./apps/web/admin-panel/

    This is the admin panel of DittoDatto.
    Here the admin/owner can manage the platform, users, establishments, services, staff, events, bookings, etc.
    Authentication is via Firebase Authentication, no signup.