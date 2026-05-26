import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

void main() {
  group('User model', () {
    test('deserializes from JSON', () {
      final json = {
        'id': 'users:abc123',
        'vipps_sub': 'vipps_12345',
        'name': 'Arnar Valur',
        'email': 'arnar@merkurial-studio.com',
        'phone': '92913093',
        'role': 'super_admin',
        'company_slug': 'merkurial-studio',
      };

      final user = User.fromJson(json);

      expect(user.id, 'users:abc123');
      expect(user.vippsSub, 'vipps_12345');
      expect(user.name, 'Arnar Valur');
      expect(user.email, 'arnar@merkurial-studio.com');
      expect(user.role, ActorRole.superAdmin);
      expect(user.companySlug, 'merkurial-studio');
    });

    test('serializes to JSON', () {
      const user = User(
        vippsSub: 'vipps_12345',
        name: 'Test User',
        email: 'test@example.com',
        role: ActorRole.operator,
      );

      final json = user.toJson();

      expect(json['vipps_sub'], 'vipps_12345');
      expect(json['name'], 'Test User');
      expect(json['role'], ActorRole.operator);
    });
  });

  group('Company model', () {
    test('deserializes from JSON with nested objects', () {
      final json = {
        'id': 'company:ms',
        'owner_id': 'users:abc123',
        'owner_email': 'arnar@merkurial-studio.com',
        'name': 'Merkurial Studio',
        'slug': 'merkurial-studio',
        'tier': 'premium',
        'onboarding_status': 'complete',
        'enabled_features': {
          'table_reservation': false,
          'ai_assistance': true,
          'ticket_system': false,
          'event_system': false,
        },
        'store_policy': {
          'max_stores': 3,
          'can_create_own_stores': true,
        },
        'db_slug': 'merkurial-studio',
      };

      final company = Company.fromJson(json);

      expect(company.name, 'Merkurial Studio');
      expect(company.tier, CompanyTier.premium);
      expect(company.onboardingStatus, OnboardingStatus.complete);
      expect(company.enabledFeatures.aiAssistance, true);
      expect(company.storePolicy.maxStores, 3);
    });
  });

  group('Category model', () {
    test('round-trips through JSON', () {
      const category = Category(
        name: 'Hair Salon',
        slug: 'hair-salon',
        description: 'Professional hair services',
        icon: 'content_cut',
        count: 42,
      );

      final json = category.toJson();
      final restored = Category.fromJson(json);

      expect(restored.name, 'Hair Salon');
      expect(restored.slug, 'hair-salon');
      expect(restored.count, 42);
    });
  });

  group('TokenResponse model', () {
    test('deserializes from engine response', () {
      final json = {
        'access_token': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.test',
        'token_type': 'bearer',
        'expires_in': 604800,
      };

      final response = TokenResponse.fromJson(json);

      expect(response.accessToken, startsWith('eyJ'));
      expect(response.tokenType, 'bearer');
      expect(response.expiresIn, 604800);
    });
  });

  group('AdminStats model', () {
    test('deserializes from engine response', () {
      final json = {
        'user_count': 5,
        'company_count': 2,
        'category_count': 12,
        'engine_healthy': true,
      };

      final stats = AdminStats.fromJson(json);

      expect(stats.userCount, 5);
      expect(stats.companyCount, 2);
      expect(stats.categoryCount, 12);
      expect(stats.engineHealthy, true);
    });
  });

  group('PaginatedResponse', () {
    test('deserializes with typed factory', () {
      final json = {
        'items': [
          {
            'id': 'users:1',
            'vipps_sub': 'v1',
            'name': 'User 1',
            'email': 'u1@test.com',
            'role': 'business',
          },
          {
            'id': 'users:2',
            'vipps_sub': 'v2',
            'name': 'User 2',
            'email': 'u2@test.com',
            'role': 'admin',
          },
        ],
        'total': 25,
        'limit': 10,
        'offset': 0,
      };

      final page = PaginatedResponse.fromJson(json, User.fromJson);

      expect(page.items.length, 2);
      expect(page.total, 25);
      expect(page.items[0].name, 'User 1');
      expect(page.items[1].role, ActorRole.admin);
    });
  });

  group('ActorRole enum', () {
    test('serializes to SurrealDB string values', () {
      expect(ActorRole.operator.toJson(), 'business');
      expect(ActorRole.admin.toJson(), 'admin');
      expect(ActorRole.superAdmin.toJson(), 'super_admin');
    });

    test('deserializes from SurrealDB string values', () {
      expect(ActorRole.fromJson('business'), ActorRole.operator);
      expect(ActorRole.fromJson('super_admin'), ActorRole.superAdmin);
    });
  });
}
