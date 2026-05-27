import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Inbox screen — Phase 5 will implement messaging UI.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: DittoColors.moodyBlue,
          ),
          SizedBox(height: DittoSpacing.base),
          Text(
            'Inbox',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: DittoSpacing.sm),
          Text(
            'Platform messaging — coming in Phase 5',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
