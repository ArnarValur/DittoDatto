import 'package:flutter/material.dart';

import '../models/booking_state.dart';

/// Step 5: Payment placeholder — visual-only.
///
/// Renders the payment form layout from the Stitch design with all
/// inputs disabled and a "Betaling kommer snart" message.
class PaymentPlaceholderStep extends StatelessWidget {
  const PaymentPlaceholderStep({
    super.key,
    required this.state,
  });

  final BookingState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Betaling',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Fullfør bestillingen med betalingsinformasjon.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Total amount card.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTALT BELØP',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Kr ${state.totalPrice.toStringAsFixed(0)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Card form (disabled).
          _buildDisabledField(
            context,
            label: 'Kortnummer',
            hint: '0000 0000 0000 0000',
            prefixIcon: Icons.credit_card,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDisabledField(
                  context,
                  label: 'Utløpsdato',
                  hint: 'MM/ÅÅ',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDisabledField(
                  context,
                  label: 'CVV',
                  hint: '123',
                  suffixIcon: Icons.info_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDisabledField(
            context,
            label: 'Navn på kort',
            hint: 'Ola Nordmann',
          ),
          const SizedBox(height: 24),

          // Secure payment badge.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sikker betaling',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Betalingsinformasjonen din er kryptert og behandles sikkert.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pay button (disabled) with "coming soon" message.
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.lock, size: 18),
                  label: Text(
                    'Betal Kr ${state.totalPrice.toStringAsFixed(0)}',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '💳 Betaling kommer snart',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledField(
    BuildContext context, {
    required String label,
    required String hint,
    IconData? prefixIcon,
    IconData? suffixIcon,
  }) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
