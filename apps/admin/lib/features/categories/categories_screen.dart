import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Categories screen — Phase 4 will implement full CRUD data table.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_rounded,
            size: 64,
            color: DittoColors.moodyBlue,
          ),
          SizedBox(height: DittoSpacing.base),
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: DittoSpacing.sm),
          Text(
            'Category management — coming in Phase 4',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
