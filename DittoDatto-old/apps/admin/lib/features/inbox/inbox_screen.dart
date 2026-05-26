import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Inbox screen — stub for future MasterDatto messaging.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.inbox_rounded, size: 20, color: AppColors.moodyBlue),
            const SizedBox(width: 10),
            const Text('Inbox'),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 48, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'Inbox',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'MasterDatto messaging — coming soon',
              style: TextStyle(fontSize: 14, color: Colors.white30),
            ),
          ],
        ),
      ),
    );
  }
}
