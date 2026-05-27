import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Companies screen — Phase 4 will implement paginated data table.
class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.business_rounded,
            size: 64,
            color: DittoColors.moodyBlue,
          ),
          SizedBox(height: DittoSpacing.base),
          Text(
            'Companies',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: DittoSpacing.sm),
          Text(
            'Company management — coming in Phase 4',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
