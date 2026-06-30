import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/features/favorites/favorite_model.dart';

void main() {
  group('Favorite', () {
    group('fromJson', () {
      test('deserializes all fields from SurrealDB record', () {
        final json = {
          'id': 'favorite:abc123',
          'user': 'user:xyz789',
          'target_id': 'establishment:house-of-the-north',
          'target_type': 'store',
          'added_at': '2026-06-30T10:00:00Z',
        };

        final fav = Favorite.fromJson(json);

        expect(fav.id, 'favorite:abc123');
        expect(fav.user, 'user:xyz789');
        expect(fav.targetId, 'establishment:house-of-the-north');
        expect(fav.targetType, 'store');
        expect(fav.addedAt, DateTime.utc(2026, 6, 30, 10));
      });

      test('handles SurrealDB structured ID format', () {
        final json = {
          'id': {'tb': 'favorite', 'id': 'abc123'},
          'user': {'tb': 'user', 'id': 'xyz789'},
          'target_id': 'establishment:test',
          'target_type': 'store',
          'added_at': '2026-06-30T10:00:00Z',
        };

        final fav = Favorite.fromJson(json);

        expect(fav.id, 'favorite:abc123');
        expect(fav.user, 'user:xyz789');
      });

      test('handles null optional fields gracefully', () {
        final json = {
          'id': null,
          'user': 'user:xyz',
          'target_id': 'establishment:test',
          'target_type': 'store',
        };

        final fav = Favorite.fromJson(json);

        expect(fav.id, isNull);
        expect(fav.addedAt, isNull);
      });

      test('defaults target_type to store when missing', () {
        final json = {
          'user': 'user:xyz',
          'target_id': 'establishment:test',
        };

        final fav = Favorite.fromJson(json);

        expect(fav.targetType, 'store');
      });
    });

    group('toJson', () {
      test('serializes for CREATE (omits id and added_at)', () {
        const fav = Favorite(
          user: 'user:xyz',
          targetId: 'establishment:house-of-the-north',
          targetType: 'store',
        );

        final json = fav.toJson();

        expect(json, {
          'target_id': 'establishment:house-of-the-north',
          'target_type': 'store',
        });
        expect(json.containsKey('id'), isFalse);
        expect(json.containsKey('user'), isFalse);
        expect(json.containsKey('added_at'), isFalse);
      });

      test('serializes person target type', () {
        const fav = Favorite(
          user: 'user:xyz',
          targetId: 'staff:john',
          targetType: 'person',
        );

        expect(fav.toJson()['target_type'], 'person');
      });
    });

    group('equality', () {
      test('equal when same targetId and targetType', () {
        const a = Favorite(
          user: 'user:1',
          targetId: 'establishment:test',
        );
        const b = Favorite(
          user: 'user:2', // different user
          targetId: 'establishment:test',
        );

        expect(a, equals(b));
        expect(a.hashCode, b.hashCode);
      });

      test('not equal when different targetId', () {
        const a = Favorite(
          user: 'user:1',
          targetId: 'establishment:a',
        );
        const b = Favorite(
          user: 'user:1',
          targetId: 'establishment:b',
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('round-trip', () {
      test('fromJson → toJson preserves data fields', () {
        final json = {
          'id': 'favorite:abc',
          'user': 'user:xyz',
          'target_id': 'establishment:test',
          'target_type': 'store',
          'added_at': '2026-06-30T10:00:00Z',
        };

        final fav = Favorite.fromJson(json);
        final output = fav.toJson();

        expect(output['target_id'], json['target_id']);
        expect(output['target_type'], json['target_type']);
      });
    });
  });
}
