import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Contact section displaying phone, email, and website as tappable items.
///
/// Renders as a [SliverToBoxAdapter] inside an outlined card.
/// Hidden entirely when all contact fields are null.
/// Each item is displayed as a [ListTile] with an appropriate leading icon.
class EstablishmentContactSection extends StatelessWidget {
  const EstablishmentContactSection({
    required this.data,
    super.key,
  });

  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    if (!data.hasContactInfo) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
        child: Card.outlined(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  DittoSpacing.base,
                  DittoSpacing.base,
                  DittoSpacing.base,
                  DittoSpacing.xs,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.contact_mail_outlined,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: DittoSpacing.sm),
                    Text(
                      'Kontakt',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (data.phone != null)
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(data.phone!),
                  dense: true,
                ),
              if (data.email != null)
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text(data.email!),
                  dense: true,
                ),
              if (data.website != null)
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(data.website!),
                  dense: true,
                ),
              const SizedBox(height: DittoSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }
}
