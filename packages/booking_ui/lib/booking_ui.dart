/// Shared booking flow UI for DittoDatto.
///
/// Provides a 5-step booking journey:
/// 1. Service Selection (real data)
/// 2. Staff Selection (mock for now)
/// 3. Date & Time Selection (mock for now)
/// 4. Review & Confirm
/// 5. Payment (placeholder)
library;

export 'src/models/booking_state.dart';
export 'src/models/mock_staff.dart';
export 'src/models/mock_time_slot.dart';
export 'src/widgets/booking_flow_page.dart';
export 'src/widgets/booking_step_indicator.dart';
