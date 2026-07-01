import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import 'social_link.dart';

/// Social links editor section for the establishment edit view.
///
/// Allows adding/removing social links with platform dropdown + URL field.
/// Known platforms (facebook, instagram, snapchat, tiktok) show brand icons.
class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({
    super.key,
    required this.links,
    required this.onLinksChanged,
  });

  final List<SocialLink> links;
  final ValueChanged<List<SocialLink>> onLinksChanged;

  void _addLink() {
    onLinksChanged([...links, const SocialLink(platform: 'facebook', url: '')]);
  }

  void _removeLink(int index) {
    final updated = List<SocialLink>.from(links)..removeAt(index);
    onLinksChanged(updated);
  }

  void _updateLink(int index, SocialLink updated) {
    final list = List<SocialLink>.from(links);
    list[index] = updated;
    onLinksChanged(list);
  }

  static const _platformOptions = [
    'facebook',
    'instagram',
    'snapchat',
    'tiktok',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < links.length; i++) ...[
          _SocialLinkRow(
            link: links[i],
            onPlatformChanged: (platform) => _updateLink(
              i,
              links[i].copyWith(platform: platform),
            ),
            onUrlChanged: (url) => _updateLink(
              i,
              links[i].copyWith(url: url),
            ),
            onRemove: () => _removeLink(i),
            theme: theme,
          ),
          if (i < links.length - 1)
            const SizedBox(height: DittoSpacing.sm),
        ],
        const SizedBox(height: DittoSpacing.base),
        OutlinedButton.icon(
          onPressed: _addLink,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Legg til lenke'),
        ),
      ],
    );
  }
}

class _SocialLinkRow extends StatelessWidget {
  const _SocialLinkRow({
    required this.link,
    required this.onPlatformChanged,
    required this.onUrlChanged,
    required this.onRemove,
    required this.theme,
  });

  final SocialLink link;
  final ValueChanged<String> onPlatformChanged;
  final ValueChanged<String> onUrlChanged;
  final VoidCallback onRemove;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isKnown = SocialLink.knownPlatforms.contains(link.platform);
    final displayPlatform = isKnown ? link.platform : 'other';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Platform dropdown
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<String>(
            initialValue: displayPlatform,
            decoration: const InputDecoration(
              labelText: 'Plattform',
              isDense: true,
            ),
            items: SocialLinksSection._platformOptions
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          SocialLink.iconForPlatform(p == 'other' ? '' : p),
                          size: 18,
                        ),
                        const SizedBox(width: DittoSpacing.xs),
                        Text(
                          p == 'other'
                              ? 'Annet'
                              : SocialLink.labelForPlatform(p),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onPlatformChanged(value == 'other' ? '' : value);
              }
            },
          ),
        ),
        const SizedBox(width: DittoSpacing.sm),

        // Custom platform name (only when "other" is selected)
        if (!isKnown) ...[
          SizedBox(
            width: 120,
            child: TextFormField(
              initialValue: link.platform,
              decoration: const InputDecoration(
                labelText: 'Navn',
                isDense: true,
                hintText: 'f.eks. LinkedIn',
              ),
              onChanged: onPlatformChanged,
            ),
          ),
          const SizedBox(width: DittoSpacing.sm),
        ],

        // URL field
        Expanded(
          child: TextFormField(
            initialValue: link.url,
            decoration: InputDecoration(
              labelText: 'URL',
              isDense: true,
              hintText: isKnown
                  ? 'https://${link.platform}.com/...'
                  : 'https://...',
            ),
            keyboardType: TextInputType.url,
            onChanged: onUrlChanged,
          ),
        ),
        const SizedBox(width: DittoSpacing.xs),

        // Remove button
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 18,
            color: theme.colorScheme.error,
          ),
          tooltip: 'Fjern',
          onPressed: onRemove,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
