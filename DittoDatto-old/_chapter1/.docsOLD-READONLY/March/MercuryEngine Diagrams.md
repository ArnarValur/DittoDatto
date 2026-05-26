Mapping out the MercuryEngine with UML (Unified Modeling Language) is a fantastic way to visualize the architecture, especially as the system grows to handle standard bookings, table reservations, and event ticketing.

Because you are working in a modern TypeScript/serverless environment, the best way to draw this up is using **Mermaid.js**. It is a text-based diagramming tool that uses standard markdown (which means it will render right here in this chat, as well as in GitHub, Notion, or Obsidian).

Here are the three most useful UML diagrams to represent the MercuryEngine based on your code.

### 1. Component Diagram (System Architecture)

This diagram shows the high-level structure. It illustrates how your entry point (`index.ts`) exposes Cloud Functions and delegates work to your three core domain modules, which then interact with Firestore.

```mermaid
graph TD
    Client[Client App / Web] -->|HTTP Calls| Index[MercuryEngine index.ts]
    
    subgraph Firebase Cloud Functions
        Index -->|mercury_getSlots\nmercury_createHold| BookingApp[Standard Booking Module]
        Index -->|mercury_getReservationAvailability| TableApp[Table Reservations Module]
        Index -->|mercury_getTicketAvailability| TicketApp[Ticketing Module]
        
        subgraph Booking Module
            Calc[calculator.ts\n'Time Tetris']
            Data[data.ts]
            Avail[staff & resource\navailability.ts]
            Mutate[hold.ts & booking.ts]
            
            Calc --> Data
            Calc --> Avail
        end
        
        subgraph Reservations Module
            ResAvail[availability.ts]
            ResCalc[calculator.ts]
            ResBook[booking.ts]
            
            ResAvail --> ResCalc
            ResBook --> ResCalc
        end
    end
    
    Data --> FS[(Firestore)]
    Mutate --> FS
    ResAvail --> FS
    ResBook --> FS
    TicketApp --> FS
```

### 2. Sequence Diagram (The "Time Tetris" Algorithm)

Sequence diagrams are perfect for mapping out complex logic over time. This diagram visualizes the exact flow of `mercury_getSlots` as it moves through `calculator.ts`, fetches parallel data, and applies your 4-gate validation (Policy, Clashes, Staff, Resources).

```mermaid
sequenceDiagram
    autonumber
    participant App as Client App
    participant Index as index.ts
    participant Calc as calculator.ts
    participant Data as data.ts
    participant DB as Firestore
    participant Rules as Availability Rules

    App->>Index: Call mercury_getSlots(store, date, services)
    Index->>Calc: calculateSlots()
    
    Calc->>Data: fetchAvailabilityData()
    Data->>DB: Promise.all(Store, Bookings, Holds, Staff, Resources)
    DB-->>Data: Return Snapshots
    Data-->>Calc: Formatted Availability Data
    
    Calc->>Calc: 1. Apply BookingPolicy (max days, notice time)
    Calc->>Calc: 2. Filter Store Opening Hours
    
    loop Every Time Step (e.g., 15 mins)
        Calc->>Rules: 3. Collision Check (Existing Bookings/Holds)
        alt isClashing == false
            Calc->>Rules: 4. Check Staff Schedule & Blocks
            Calc->>Rules: 5. Check Resource Requirements
            alt Staff & Resource OK
                Rules-->>Calc: Valid Slot
                Calc->>Calc: Push to slots[] array
            end
        end
    end
    
    Calc-->>Index: string[] ["09:00", "09:15", ...]
    Index-->>App: Return { availableSlots }
```

### 3. State Machine Diagram (The Booking Lifecycle)

Because you are using a "Hold" pattern with a 10-minute TTL (Time-to-Live) to prevent double-booking, a State diagram is the best way to show how a time slot moves from available to permanently booked.

```mermaid
stateDiagram-v2
    [*] --> Available : calculateSlots() finds empty slot
    
    Available --> Held : createHold() (Atomic Write)
    Held --> Available : TTL Expires (10 mins) or User Cancels
    
    Held --> Confirmed : createBookingFromHold() + Payment Success
    
    state Held {
        [*] --> ValidatingPolicy
        ValidatingPolicy --> WritingIdempotentKey : StoreId_Date_Time
        WritingIdempotentKey --> ActiveHold : Transaction Success
    }
    
    state Confirmed {
        [*] --> FetchingSnapshots
        FetchingSnapshots --> WritingReceipt : Save Prices/Titles
        WritingReceipt --> DeletingHold
    }
    
    Confirmed --> [*]
```

### How to use these for your documentation:

1. **Copy the code blocks** starting with ` ```mermaid ` and ending with ` ``` `.
    
2. **Paste them** into a markdown file in your codebase (like a `README.md` or an architecture document).
    
3. If you want to tweak the colors, layout, or add new flows (like mapping out the Ticketing module once you start working on it more), you can paste these directly into the **[Mermaid Live Editor](https://mermaid.live/)** to edit them visually in real-time, Arnar.
    

Would you like to map out the Table Reservations flow next, or do these cover the specific engine logic you were looking to visualize?


---



Being a visual learner makes complete sense, especially when dealing with complex transactional logic like a booking engine. Having these generated right here gives you a perfect reference point to look at while you build out the strict UML in Gaphor.

Here are the Mermaid.js equivalents for the Table Reservations module based on your codebase.

### 1. Class Diagram (Data Model)

This diagram maps out the relationships between the Store, its configuration, the bookable Experiences, and the final Reservation document.

```mermaid
classDiagram
    class Store {
        +String id
        +Object openingSchedule
        +ReservationConfig reservationConfig
    }
    
    class ReservationConfig {
        +Number totalCapacity
        +Number defaultDuration
        +Number maxGuestsPerReservation
        +Boolean autoConfirm
    }
    
    class Experience {
        +String id
        +Boolean isActive
        +Number duration
        +Object operatingWindow
    }
    
    class Reservation {
        +String id
        +String customerName
        +Number guestCount
        +Date date
        +String time
        +Number duration
        +String status
    }

    Store *-- ReservationConfig : contains
    Store "1" o-- "*" Experience : offers
    Store "1" -- "*" Reservation : has
    Experience "1" -- "*" Reservation : booked for
```

### 2. Sequence Diagram (Transactional Booking Flow)

This visualizes the atomic transaction inside your `mercury_createReservation` function. It ensures that by the time a slot is verified as available, it is immediately locked in the same database operation to prevent double-booking.

```mermaid
sequenceDiagram
    autonumber
    actor Client
    participant API as index.ts
    participant Booking as reservations/booking.ts
    participant Calc as reservations/calculator.ts
    participant DB as Firestore (Transaction)

    Client->>API: mercury_createReservation(guestCount, date, time)
    API->>Booking: createReservation()
    Booking->>DB: runTransaction()
    
    DB->>DB: Get Store & ReservationConfig
    Booking->>Booking: Verify guestCount <= maxGuestsPerReservation
    
    DB->>DB: Get Existing Reservations for Date
    
    Booking->>Calc: calculateSlotAvailability(...)
    Calc->>Calc: Find overlapping reservations
    Calc->>Calc: Sum guestCount of overlaps
    Calc-->>Booking: Returns { available: true }
    
    Booking->>DB: Set New Reservation (status: pending/confirmed)
    DB-->>Booking: Transaction Success
    
    Booking-->>API: reservationId
    API-->>Client: { status: "success", reservationId }
```

### 3. Activity Diagram / Flowchart (Capacity Calculator)

This illustrates the internal logic of the `calculateSlotAvailability` function. It shows how the engine calculates physical table space based on the size of the party and overlapping reservation durations.

```mermaid
flowchart TD
    Start([Start: calculateSlotAvailability]) --> CalcTime[Calculate slotStart and slotEnd]
    CalcTime --> Filter[Filter active reservations for the date]
    
    Filter --> CheckOverlap{Do reservation times<br/>overlap with slot?}
    CheckOverlap -- Yes --> AddToList[Add to overlapping list]
    CheckOverlap -- No --> Ignore[Ignore]
    
    AddToList --> SumGuests[Sum guestCount of overlapping reservations]
    Ignore --> SumGuests
    
    SumGuests --> CalcRemaining[Calculate: remaining = totalCapacity - currentGuests]
    
    CalcRemaining --> HasSpace{Is remaining >= partySize?}
    HasSpace -- Yes --> ReturnTrue([Return available: true])
    HasSpace -- No --> ReturnFalse([Return available: false, reason: Capacity exceeded])
```

