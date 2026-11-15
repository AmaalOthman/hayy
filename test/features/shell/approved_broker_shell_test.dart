import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/services/secure_storage_service.dart';
import 'package:hayy/hayy_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fakes.dart';

/// An approved broker with one joined community opens the app:
/// splash → shell with the communities list, then the Search tab.
void main() {
  const phone = '+971501234567';

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'mock_api_db': jsonEncode({
        'brokers': {
          phone: {
            'id': 'b1',
            'phone': phone,
            'status': 'approved',
            'fullName': 'Mona Ali',
            'agencyName': 'Marina Homes',
            'whatsappNumber': phone,
            'profileCompletedAt': 1,
            'subscriptions': ['dubai-marina-rental-residential'],
          },
        },
      }),
    });
  });

  testWidgets('lands on communities and switches tabs', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        secureStorageServiceProvider.overrideWithValue(FakeStorage(
          access: 'mock-access.$phone',
          refresh: 'mock-refresh.$phone',
        )),
      ],
      child: const HayyApp(),
    ));
    await tester.pumpAndSettle();

    // Shell with the bottom bar and the joined community.
    expect(find.text('Brokers community'), findsOneWidget);
    expect(find.text('Dubai Marina'), findsOneWidget);
    expect(find.text('Rental · Residential'), findsOneWidget);
    for (final tab in ['Communities', 'Search', 'New post', 'My posts', 'Profile']) {
      expect(find.text(tab), findsWidgets);
    }

    // Search tab lists the whole catalogue with Join / Joined.
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('Explore communities'), findsOneWidget);
    expect(find.text('104 communities across Dubai'), findsOneWidget);
    expect(find.text('Joined'), findsWidgets);

    // Profile tab shows the broker.
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Mona Ali'), findsOneWidget);
    expect(find.text('Marina Homes'), findsWidgets);
  });
}
