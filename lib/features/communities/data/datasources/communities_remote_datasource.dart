import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/community_filter.dart';
import '../models/community_model.dart';

final communitiesRemoteDataSourceProvider =
    Provider<CommunitiesRemoteDataSource>(
        (ref) => CommunitiesRemoteDataSource(ref.watch(apiClientProvider)));

class CommunitiesRemoteDataSource {
  const CommunitiesRemoteDataSource(this._api);
  final ApiClient _api;

  Future<List<Community>> getSubscribed() async => CommunityModel.listFromJson(
      await _api.get<Map<String, dynamic>>(ApiEndpoints.subscribedCommunities));

  Future<List<Community>> search(CommunityFilter filter) async =>
      CommunityModel.listFromJson(await _api.get<Map<String, dynamic>>(
          ApiEndpoints.communities,
          query: filter.toQuery()));

  Future<void> subscribe(String id) async {
    await _api.put<dynamic>(ApiEndpoints.subscription(id));
  }

  Future<void> unsubscribe(String id) async {
    await _api.delete<dynamic>(ApiEndpoints.subscription(id));
  }

  Future<void> setMuted(String id, {required bool muted}) async {
    await _api.put<dynamic>(ApiEndpoints.mute(id), data: {'muted': muted});
  }
}
