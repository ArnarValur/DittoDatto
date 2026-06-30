import 'package:flutter/material.dart';

/// 5-step horizontal progress indicator matching the Stitch Step 1 design.
///
/// Numbered circles connected by lines. Completed steps show a checkmark,
/// the active step is filled (brand color), future steps are grey outline.
/// Label appears only under the active step.
///
/// Tapping a completed step navigates back to it.
class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  /// Current active step (0-indexed).
  final int currentStep;

  /// Called when a completed step circle is tapped.
  /// Only fires for steps < currentStep.
  final ValueChanged<int> onStepTapped;

  static const _stepLabels = [
    'Service',
    'Staff',
    'Time',
    'Review',
    'Payment',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(9, (index) {
              // Even indexes = circles (0,2,4,6,8 → steps 0,1,2,3,4)
              // Odd indexes = connecting lines (1,3,5,7)
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                return _buildStepCircle(
                  context,
                  stepIndex: stepIndex,
                  colorScheme: colorScheme,
                );
              } else {
                final beforeStep = index ~/ 2;
                return _buildConnector(
                  isCompleted: beforeStep < currentStep,
                  colorScheme: colorScheme,
                );
              }
            }),
          ),
          const SizedBox(height: 6),
          // Label under active step only.
          Row(
            children: List.generate(5, (stepIndex) {
              return Expanded(
                child: stepIndex == currentStep
                    ? Text(
                        _stepLabels[stepIndex],
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(
    BuildContext context, {
    required int stepIndex,
    required ColorScheme colorScheme,
  }) {
    final isCompleted = stepIndex < currentStep;
    final isActive = stepIndex == currentStep;

    const double size = 32;

    Widget circle;

    if (isCompleted) {
      circle = GestureDetector(
        onTap: () => onStepTapped(stepIndex),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary,
          ),
          child: Icon(
            Icons.check,
            size: 18,
            color: colorScheme.onPrimary,
          ),
        ),
      );
    } else if (isActive) {
      circle = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary,
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      );
    } else {
      // Future step — grey outline.
      circle = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: TextStyle(
              color: colorScheme.outlineVariant,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return circle;
  }

  Widget _buildConnector({
    required bool isCompleted,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        color: isCompleted
            ? colorScheme.primary
            : colorScheme.outlineVariant.withValues(alpha: 0.4),
      ),
    );
  }
}
