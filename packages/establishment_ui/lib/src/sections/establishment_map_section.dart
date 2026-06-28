import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/establishment_data.dart';

/// Read-only map section showing the establishment's location.
///
/// Renders an OpenStreetMap tile layer with a single marker at the
/// establishment's coordinates. Only renders when [data.hasLocation]
/// is `true` — otherwise returns an empty sliver.
///
/// Used in:
/// - **EstablishmentPage** (shared) — "Finn oss" map
/// - Tapping the map opens external maps app (future enhancement)
class EstablishmentMapSection extends StatelessWidget {
  const EstablishmentMapSection({
    required this.data,
    this.height = 200.0,
    this.isWide = false,
    super.key,
  });

  /// The establishment data containing coordinates.
  final EstablishmentData data;

  /// Height of the map container.
  final double height;

  /// Whether the viewport is wide (tablet/desktop).
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    if (!data.hasLocation) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final point = LatLng(data.latitude!, data.longitude!);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.base,
          vertical: DittoSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: DittoSpacing.xs),
                Text(
                  'Finn oss',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DittoSpacing.sm),

            // Map container
            ClipRRect(
              borderRadius: BorderRadius.circular(DittoSpacing.sm),
              child: SizedBox(
                height: height,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: point,
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    // OpenStreetMap tile layer
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'no.dittodatto.app',
                    ),
                    // Establishment marker
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: point,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: colorScheme.primary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Address text below map
            const SizedBox(height: DittoSpacing.xs),
            Text(
              data.addressLine,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
