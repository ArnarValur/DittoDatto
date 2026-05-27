import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Dashboard screen — Phase 3 will implement stat cards and pull-to-refresh.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.dashboard_rounded,
            size: 64,
            color: DittoColors.moodyBlue,
          ),
          SizedBox(height: DittoSpacing.base),
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: DittoSpacing.sm),
          Text(
            'Stats and overview — coming in Phase 3',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
