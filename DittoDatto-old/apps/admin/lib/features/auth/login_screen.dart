import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import 'auth_provider.dart';
import 'server_config_provider.dart';

/// Login screen — email + password + server URL preset.
///
/// Maps to ADR-0011 §2 (Login): "Lock icon, two fields, one button. Nothing else."
/// Plus the server URL selector from §5.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    ref.read(authProvider.notifier).login(
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final serverUrl = ref.watch(serverUrlProvider);
    final isLoading = authState is AuthLoading;

    // Show error snackbar on auth error
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo / Lock icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.moodyBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 36,
                    color: AppColors.moodyBlue,
                  ),
                ),
                const SizedBox(height: 40),

                // Server URL preset dropdown
                _ServerUrlSelector(
                  currentUrl: serverUrl.valueOrNull ?? serverPresets.first.url,
                  onChanged: (url) {
                    ref.read(serverUrlProvider.notifier).setUrl(url);
                  },
                ),
                const SizedBox(height: 24),

                // Email field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onSubmitted: (_) => _handleLogin(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 48,
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
    );
  }
}

/// Server URL preset selector widget.
class _ServerUrlSelector extends StatelessWidget {
  const _ServerUrlSelector({
    required this.currentUrl,
    required this.onChanged,
  });

  final String currentUrl;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    // Check if current URL matches a preset
    final matchingPreset = serverPresets.where((p) => p.url == currentUrl);
    final isCustom = matchingPreset.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: isCustom ? null : currentUrl,
          hint: Text(
            'Custom: $currentUrl',
            style: const TextStyle(fontSize: 13, color: Colors.white54),
          ),
          isExpanded: true,
          dropdownColor: AppColors.surfaceContainerHigh,
          icon: const Icon(Icons.dns_outlined, size: 18),
          items: serverPresets.map((preset) {
            return DropdownMenuItem<String>(
              value: preset.url,
              child: Row(
                children: [
                  Icon(
                    _presetIcon(preset.label),
                    size: 16,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    preset.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      preset.url,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }

  IconData _presetIcon(String label) {
    if (label.contains('Saturn')) return Icons.rocket_launch_outlined;
    if (label.contains('Dev')) return Icons.computer_outlined;
    return Icons.dns_outlined;
  }
}
