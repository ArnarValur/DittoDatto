import 'package:flutter/material.dart';

/// Placeholder shell — will be fully implemented in Task 2.3.
class PortalShell extends StatelessWidget {
  const PortalShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
