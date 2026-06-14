import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

/// Redesigned login screen — Stitch Enterprise Slate light mode.
///
/// Design specs (spec.md F2):
/// - Storefront icon in Moody Blue container
/// - Norwegian bokmål text throughout
/// - Password visibility toggle
/// - "Kontakt administrator for tilgang" footer
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
  bool _obscurePassword = true;

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DittoSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Storefront icon — per spec F2
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: DittoColors.moodyBlue.withValues(alpha: 0.12),
                        borderRadius: DittoBorderRadius.largeAll,
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        size: 36,
                        color: DittoColors.moodyBlue,
                      ),
                    ),

                    const SizedBox(height: DittoSpacing.lg),

                    // Heading — Norwegian
                    Text(
                      'Logg inn på DittoDatto',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: DittoSpacing.sm),

                    // Subtitle — Norwegian
                    Text(
                      'Velkommen tilbake. Skriv inn dine påloggingsdetaljer.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: DittoSpacing.xl),

                    // E-post field
                    TextFormField(
                      controller: _emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: 'E-post',
                        hintText: 'navn@bedrift.no',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Påkrevd';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DittoSpacing.base),

                    // Passord field with visibility toggle
                    TextFormField(
                      controller: _passwordController,
                      enabled: !isLoading,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: 'Passord',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Påkrevd';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _handleLogin(),
                    ),

                    const SizedBox(height: DittoSpacing.lg),

                    // Logg inn button
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
                                ),
                              )
                            : const Text('Logg inn →'),
                      ),
                    ),

                    const SizedBox(height: DittoSpacing.lg),

                    // Contact admin text
                    Text(
                      'Kontakt administrator for tilgang',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
