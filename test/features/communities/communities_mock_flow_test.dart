import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/network/api_client.dart';
import 'package:hayy/core/network/mock/mock_api_adapter.dart';
import 'package:hayy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:hayy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hayy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hayy/features/communities/data/datasources/communities_remote_datasource.dart';
import 'package:hayy/features/communities/data/repositories/communities_repository_impl.dart';
import 'package:hayy/features/communities/domain/entities/community.dart';
import 'package:hayy/features/communities/domain/entities/community_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fakes.dart';

void main() {
  late CommunitiesRepositoryImpl repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = FakeStorage();
    final api = ApiClient.create(
      storage: storage,
      onSessionExpired: () {},
      adapter: MockApiAdapter(latency: Duration.zero),
    );
    await AuthRepositoryImpl(
      remote: AuthRemoteDataSource(api),
      local: AuthLocalDataSource(storage),
    ).verifyOtp(phone: '+971501234567', code: MockApiAdapter.validOtp);
    repo = CommunitiesRepositoryImpl(CommunitiesRemoteDataSource(api));
  });

  test('catalogue has 100+ communities and filters combine', () async {
    final all = (await repo.search(const CommunityFilter())).valueOrNull!;
    expect(all.length, greaterThanOrEqualTo(100));

    final marinaRentals = (await repo.search(const CommunityFilter(
      query: 'marina',
      transaction: TransactionType.rental,
    )))
        .valueOrNull!;
    expect(marinaRentals, hasLength(2)); // residential + commercial
    expect(marinaRentals.every((c) => c.areaName == 'Dubai Marina'), isTrue);
    expect(marinaRentals.every((c) => c.transaction == TransactionType.rental),
        isTrue);
  });

  test('join, mute and leave', () async {
    expect((await repo.getSubscribed()).valueOrNull, isEmpty);

    final marina = (await repo.search(const CommunityFilter(
      query: 'Dubai Marina',
      transaction: TransactionType.rental,
      use: PropertyUse.residential,
    )))
        .valueOrNull!
        .single;
    expect(marina.isSubscribed, isFalse);

    expect((await repo.subscribe(marina.id)).isOk, isTrue);
    var mine = (await repo.getSubscribed()).valueOrNull!;
    expect(mine.single.id, marina.id);
    expect(mine.single.isSubscribed, isTrue);

    expect((await repo.setMuted(marina.id, muted: true)).isOk, isTrue);
    mine = (await repo.getSubscribed()).valueOrNull!;
    expect(mine.single.isMuted, isTrue);

    expect((await repo.unsubscribe(marina.id)).isOk, isTrue);
    expect((await repo.getSubscribed()).valueOrNull, isEmpty);
  });

  test('unknown community is a 404 failure', () async {
    expect((await repo.subscribe('nowhere')).isOk, isFalse);
  });
}
