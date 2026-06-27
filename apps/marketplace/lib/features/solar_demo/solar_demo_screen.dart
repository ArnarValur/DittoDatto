import 'dart:ui';

import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'solar_providers.dart';
import 'star_field_painter.dart';

/// Solar Theme demo screen — atmospheric gradient + star field + debug panel.
///
/// Shows the solar engine running live over Drammen with a time slider
/// for manual override. This is the Flutter port of the Nuxt SolarTheme
/// app.vue debug experience.
class SolarDemoScreen extends ConsumerWidget {
  const SolarDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solar = ref.watch(solarStateProvider);
    final stars = ref.watch(projectedStarsProvider);
    final override = ref.watch(solarTimeOverrideProvider);
    final isManual = override != null;

    // Current slider value — real time or manual
    final sliderMinutes = override ??
        (DateTime.now().hour * 60 + DateTime.now().minute);

    // Atmospheric HSL color
    final skyColor = HSLColor.fromAHSL(
      1.0,
      solar.hue,
      solar.saturation / 100,
      solar.lightness / 100,
    ).toColor();

    // Darker version for gradient bottom
    final deepColor = HSLColor.fromAHSL(
      1.0,
      solar.hue,
      (solar.saturation / 100).clamp(0.0, 1.0),
      (solar.lightness / 200).clamp(0.02, 0.3),
    ).toColor();

    final textColor = solar.isDark ? Colors.white : Colors.black;
    final subtleText = solar.isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [skyColor, deepColor],
          ),
        ),
        child: Stack(
          children: [
            // Star field layer
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: solar.starOpacity,
                duration: const Duration(seconds: 2),
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: StarFieldPainter(stars: stars),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),

            // Content layer
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(DittoSpacing.lg),
                child: Column(
                  children: [
                    const Spacer(),

                    // Debug card
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: (solar.isDark ? Colors.black : Colors.white)
                            .withValues(alpha: 0.15),
                        borderRadius: DittoBorderRadius.largeAll,
                        border: Border.all(
                          color: textColor.withValues(alpha: 0.15),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: DittoBorderRadius.largeAll,
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(DittoSpacing.lg),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Solar Theme',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Drammen (59.74, 10.20)',
                                          style: TextStyle(
                                            color: subtleText,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _PhaseBadge(
                                      phase: solar.phase,
                                      textColor: textColor,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: DittoSpacing.lg),

                                // Metrics grid
                                Container(
                                  padding: const EdgeInsets.all(
                                      DittoSpacing.base),
                                  decoration: BoxDecoration(
                                    color: textColor
                                        .withValues(alpha: 0.05),
                                    borderRadius:
                                        DittoBorderRadius.mediumAll,
                                  ),
                                  child: Row(
                                    children: [
                                      _Metric(
                                        label: 'Altitude',
                                        value:
                                            '${solar.altitude.toStringAsFixed(1)}°',
                                        textColor: textColor,
                                        subtleColor: subtleText,
                                      ),
                                      _Metric(
                                        label: 'Lightness',
                                        value:
                                            '${solar.lightness.toStringAsFixed(0)}%',
                                        textColor: textColor,
                                        subtleColor: subtleText,
                                      ),
                                      _Metric(
                                        label: 'Hue',
                                        value:
                                            '${solar.hue.toStringAsFixed(0)}°',
                                        textColor: textColor,
                                        subtleColor: subtleText,
                                      ),
                                      _Metric(
                                        label: 'Stars',
                                        value: '${stars.length}',
                                        textColor: textColor,
                                        subtleColor: subtleText,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: DittoSpacing.lg),

                                // Time display
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _formatMinutes(sliderMinutes),
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 32,
                                        fontWeight: FontWeight.w200,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      isManual
                                          ? 'MANUAL CONTROL'
                                          : 'LIVE SYNC',
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 2,
                                        color: subtleText,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: DittoSpacing.sm),

                                // Time slider
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor:
                                        textColor.withValues(alpha: 0.3),
                                    inactiveTrackColor:
                                        textColor.withValues(alpha: 0.1),
                                    thumbColor: textColor,
                                    overlayColor:
                                        textColor.withValues(alpha: 0.1),
                                    trackHeight: 2,
                                  ),
                                  child: Slider(
                                    value: sliderMinutes.toDouble(),
                                    min: 0,
                                    max: 1439,
                                    onChanged: (value) {
                                      ref
                                          .read(solarTimeOverrideProvider
                                              .notifier)
                                          .set(value.toInt());
                                    },
                                  ),
                                ),

                                // Time labels
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: DittoSpacing.sm),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('00:00',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: subtleText,
                                              fontFamily: 'monospace')),
                                      Text('12:00',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: subtleText,
                                              fontFamily: 'monospace')),
                                      Text('23:59',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: subtleText,
                                              fontFamily: 'monospace')),
                                    ],
                                  ),
                                ),

                                // Reset button
                                if (isManual) ...[
                                  const SizedBox(height: DittoSpacing.md),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        ref
                                            .read(
                                                solarTimeOverrideProvider
                                                    .notifier)
                                            .clear();
                                      },
                                      child: Text(
                                        'Return to Now',
                                        style: TextStyle(
                                          color:
                                              textColor.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: DittoSpacing.xl),

                    // Footer
                    Text(
                      'Merkurial Studio — SolarTheme Flutter v0.1',
                      style: TextStyle(
                        fontSize: 11,
                        color: subtleText.withValues(alpha: 0.5),
                      ),
                    ),

                    const SizedBox(height: DittoSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatMinutes(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}

/// Phase badge pill.
class _PhaseBadge extends StatelessWidget {
  final SolarPhase phase;
  final Color textColor;

  const _PhaseBadge({required this.phase, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.md,
        vertical: DittoSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.1),
        borderRadius: DittoBorderRadius.smallAll,
        border: Border.all(
          color: textColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        phase.label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Single metric cell in the grid.
class _Metric extends Expanded {
  _Metric({
    required String label,
    required String value,
    required Color textColor,
    required Color subtleColor,
  }) : super(
          child: Column(
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: subtleColor,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
}
