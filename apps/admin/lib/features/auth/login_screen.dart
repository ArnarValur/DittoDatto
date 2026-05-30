import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'auth_provider.dart';

/// Login screen per PRD v1.0 requirements.
///
/// Design specs:
/// - Lock icon (no branding text)
/// - Email field + password field + Sign In button
/// - Moody Blue dark theme (maximum opacity)
/// - **No error feedback on auth failure** — silent fail for security
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    // Tell the browser the autofill context is complete so it stops
    // re-prompting to save already-saved credentials.
    TextInput.finishAutofillContext();
    // No error handling here — per PRD, auth failure is silent.
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);
    final isLoading = authAsync.isLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DittoSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lock icon — no branding text per PRD
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: DittoColors.moodyBlue.withValues(alpha: 0.15),
                      borderRadius: DittoBorderRadius.largeAll,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 36,
                      color: DittoColors.moodyBlue,
                    ),
                  ),

                  const SizedBox(height: DittoSpacing.xl),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DittoSpacing.base),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    enabled: !isLoading,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),

                  const SizedBox(height: DittoSpacing.lg),

                  // Sign In button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign In'),
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
