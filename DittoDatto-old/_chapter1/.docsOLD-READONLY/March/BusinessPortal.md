# Business Portal

1. Staff Invite process.
   arnarvalur@avj.info <- Only a super_admin user for admin-panel
   arnarvalurjonsson@gmail.com <- Business User who created all the demo companies and their stuff.
   anoupz@protonmail.com <- Was a normal user from yesterday, and this user for invited a a staff through the staff panel, and I noticed this bug: I wrote the email anoupz@protonmail.com and I wrote a name "Haru", but only to realise and remember that I already registered this user yesterday with the name Svenni Sveinsson, so his email is now a staff user, but has the name "Haru" but not Svenni Sveinsson, we either remove the Name input from the staff invite process, and user can write their own name when they continue with registration, OR if this email account already exists... then use the name behind the account instead of the BizUser writing a new name on it.

Otherwise it works, the anoupz@protonmail.com gets the invite email and things seem to work in localhost.

2. Staff "Schedule" on the Slidepanel under Staff is, bad UI/UX in my opinion but was made like that for simplicity when it was created. I want to take a look at the Gantt component from Hermes as see if we can fit it into an Accordion so we can make it easier for staff to determin their shifts and schedule.

---

## Resolved (Day 2)

- ✅ Staff invite Name field removed — invited person sets own name at registration
- ✅ Schedule moved from narrow slideover → full-width `/staff/:id` detail page
- ✅ CSS timeline grid replaces old dropdown-based schedule editor as primary view

## Backlog Ideas (Day 2 conversation)

### Shift History & Work Tracking
- Should we store shift history / past work weeks per staff member?
- Business owner needs overview: "who worked last week and how many hours"
- Could be a subcollection `companies/{id}/staff/{id}/shiftHistory` with weekly snapshots
- OR aggregate from bookings data — staff already linked to bookings

### Staff Dashboard — Week View
- Staff detail page = **shift config** (the permanent weekly pattern)
- Staff dashboard = **current week overview** (actual schedule with overrides applied)
- Show actual bookings mapped onto the shift timeline
- Allow staff to request shift swaps / add overrides from their own dashboard

### Testing Plan (Week 2)
- One staff member with full week plan
- Add date overrides (sick days, custom hours)
- Create bookings assigned to that staff
- Verify booking slots respect the schedule
- End-to-end real-world simulation
