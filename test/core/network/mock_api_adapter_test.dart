import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/error/failures.dart';
import 'package:hayy/core/network/api_client.dart';
import 'package:hayy/core/network/mock/mock_api_adapter.dart';
import 'package:hayy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:hayy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hayy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hayy/features/auth/domain/entities/auth_session.dart';
import 'package:hayy/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:hayy/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:hayy/features/profile/domain/entities/broker_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fakes.dart';

/// Runs the real repositories against the mock backend: the same path the
/// app takes in a debug build before the API exists.
void main() {
  late FakeStorage storage;
  late AuthRepositoryImpl auth;
  late ProfileRepositoryImpl profile;

  void build({Duration approvalDelay = const Duration(hours: 1)}) {
    final api = ApiClient.create(
      storage: storage,
      onSessionExpired: () {},
      adapter: MockApiAdapter(
          latency: Duration.zero, approvalDelay: approvalDelay),
    );
    auth = AuthRepositoryImpl(
      remote: AuthRemoteDataSource(api),
      local: AuthLocalDataSource(storage),
    );
    profile = ProfileRepositoryImpl(ProfileRemoteDataSource(api));
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = FakeStorage();
    build();
  });

  const phone = '+971501234567';
  const update = ProfileUpdate(
    fullName: 'Mona Ali',
    agencyName: 'Marina Homes',
    whatsappNumber: phone,
  );

  test('wrong OTP is rejected with the backend message', () async {
    expect((await auth.sendOtp(phone)).isOk, isTrue);
    final result = await auth.verifyOtp(phone: phone, code: '000000');
    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(storage.access, isNull);
  });

  test('sign-up → profile → approval', () async {
    final session =
        (await auth.verifyOtp(phone: phone, code: MockApiAdapter.validOtp))
            .valueOrNull!;
    expect(session.hasProfile, isFalse);
    expect(session.status, BrokerStatus.pending);
    expect(storage.access, isNotNull);

    final saved = (await profile.updateProfile(update)).valueOrNull!;
    expect(saved.fullName, 'Mona Ali');
    expect(saved.whatsappNumber, phone);

    var current = (await auth.getCurrentSession()).valueOrNull!;
    expect(current.hasProfile, isTrue);
    expect(current.status, BrokerStatus.pending);

    // Same stored data, admin "approves" immediately.
    build(approvalDelay: Duration.zero);
    current = (await auth.getCurrentSession()).valueOrNull!;
    expect(current.status, BrokerStatus.approved);
  });

  test('numbers ending in 0000 are suspended', () async {
    final session = (await auth.verifyOtp(
            phone: '+971500000000', code: MockApiAdapter.validOtp))
        .valueOrNull!;
    expect(session.status, BrokerStatus.suspended);
  });

  test('photo is uploaded as multipart and returned as a URL', () async {
    await auth.verifyOtp(phone: phone, code: MockApiAdapter.validOtp);
    final file = File('${Directory.systemTemp.createTempSync().path}/p.jpg')
      ..writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 1, 2, 3]);

    final saved = (await profile.updateProfile(ProfileUpdate(
      fullName: update.fullName,
      agencyName: update.agencyName,
      whatsappNumber: phone,
      photoPath: file.path,
    )))
        .valueOrNull!;

    expect(saved.photoUrl, 'data:image/jpeg;base64,/9j/4AECAw==');
  });

  test('profile requires all fields', () async {
    await auth.verifyOtp(phone: phone, code: MockApiAdapter.validOtp);
    final result = await profile.updateProfile(const ProfileUpdate(
        fullName: ' ', agencyName: 'X', whatsappNumber: phone));
    expect(result.failureOrNull, isA<ValidationFailure>());
  });
}
