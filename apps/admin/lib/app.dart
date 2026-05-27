import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

/// Root application widget for the DittoDatto Admin Panel.
class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'DittoDatto Admin',
      debugShowCheckedModeBanner: false,
      theme: DittoTheme.dark,
      routerConfig: router,
    );
  }
}
