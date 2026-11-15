import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/services/secure_storage_service.dart';
import 'package:hayy/hayy_app.dart';

import 'helpers/fakes.dart';

void main() {
  testWidgets('signed-out user goes from splash to login', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        secureStorageServiceProvider.overrideWithValue(FakeStorage()),
      ],
      child: const HayyApp(),
    ));

    // Splash intro is playing.
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Welcome to Hayy'), findsNothing);

    // No stored tokens → after the intro the redirect lands on login.
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Hayy'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
