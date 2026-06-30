import 'package:booking_ui/booking_ui.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-screen booking flow for the Marketplace.
///
/// Receives [EstablishmentData] via GoRouter extra. Renders the
/// [BookingFlowPage] from `booking_ui` package and pops when closed.
class BookingScreen extends StatelessWidget {
  const BookingScreen({
    super.key,
    required this.data,
  });

  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    return BookingFlowPage(
      establishmentData: data,
      onClose: () => context.pop(),
    );
  }
}
