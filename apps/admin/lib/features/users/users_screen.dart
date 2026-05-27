import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Users screen — Phase 4 will implement paginated data table.
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_rounded,
            size: 64,
            color: DittoColors.moodyBlue,
          ),
          SizedBox(height: DittoSpacing.base),
          Text(
            'Users',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: DittoSpacing.sm),
          Text(
            'User management — coming in Phase 4',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
