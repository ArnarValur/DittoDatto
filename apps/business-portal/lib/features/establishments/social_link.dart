import 'package:flutter/material.dart';

/// A social media or external link on an Establishment.
///
/// Maps to the SurrealDB `social_links` array:
/// ```sql
/// DEFINE FIELD social_links          ON establishment TYPE option<array<object>>;
/// DEFINE FIELD social_links[*].platform ON establishment TYPE string;
/// DEFINE FIELD social_links[*].url      ON establishment TYPE string;
/// ```
///
/// See ADR-0028: Social links flexible array.
class SocialLink {
  const SocialLink({
    required this.platform,
    required this.url,
  });

  /// Platform identifier (lowercase). Known platforms have first-class icons.
  final String platform;

  /// Full URL to the profile/page.
  final String url;

  /// Known platforms with first-class icon support in v1.
  static const knownPlatforms = {'facebook', 'instagram', 'snapchat', 'tiktok'};

  /// Whether this link uses a known platform.
  bool get isKnownPlatform => knownPlatforms.contains(platform);

  /// Get the appropriate icon for this social link's platform.
  IconData get icon => iconForPlatform(platform);

  /// Get an icon for a given platform string.
  static IconData iconForPlatform(String platform) => switch (platform) {
        'facebook' => Icons.facebook_rounded,
        'instagram' => Icons.camera_alt_rounded,
        'snapchat' => Icons.chat_bubble_rounded,
        'tiktok' => Icons.music_note_rounded,
        _ => Icons.link_rounded,
      };

  /// Norwegian display label for a platform.
  static String labelForPlatform(String platform) => switch (platform) {
        'facebook' => 'Facebook',
        'instagram' => 'Instagram',
        'snapchat' => 'Snapchat',
        'tiktok' => 'TikTok',
        _ => platform.isNotEmpty
            ? '${platform[0].toUpperCase()}${platform.substring(1)}'
            : 'Lenke',
      };

  /// Parse from SurrealDB JSON.
  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  /// Serialize to JSON for SurrealDB.
  Map<String, dynamic> toJson() => {
        'platform': platform,
        'url': url,
      };

  /// Create a copy with overrides.
  SocialLink copyWith({
    String? platform,
    String? url,
  }) {
    return SocialLink(
      platform: platform ?? this.platform,
      url: url ?? this.url,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialLink &&
          platform == other.platform &&
          url == other.url;

  @override
  int get hashCode => Object.hash(platform, url);

  @override
  String toString() => 'SocialLink($platform: $url)';
}

/// Parse a list of social links from SurrealDB JSON.
List<SocialLink> parseSocialLinks(dynamic json) {
  if (json is! List) return const [];
  return json
      .whereType<Map<String, dynamic>>()
      .map(SocialLink.fromJson)
      .toList();
}

/// Serialize a list of social links to JSON for SurrealDB.
List<Map<String, dynamic>> serializeSocialLinks(List<SocialLink> links) {
  return links.map((link) => link.toJson()).toList();
}
