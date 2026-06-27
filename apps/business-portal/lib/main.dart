import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';

/// Whether Firebase initialized successfully.
/// Media uploads check this — false means Storage is unavailable.
bool firebaseInitialized = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    firebaseInitialized = true;
  } catch (e) {
    debugPrint('⚠️ Firebase init failed (media uploads disabled): $e');
  }
  runApp(const ProviderScope(child: PortalApp()));
}
