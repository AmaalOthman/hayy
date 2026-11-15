import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_session_model.dart';
import '../models/broker_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
    (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)));

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._api);
  final ApiClient _api;

  Future<void> sendOtp(String phone) async {
    await _api.post<dynamic>(
      ApiEndpoints.sendOtp,
      data: {'phone': phone},
      auth: false,
    );
  }

  Future<AuthSessionModel> verifyOtp(String phone, String code) async {
    final json = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.verifyOtp,
      data: {'phone': phone, 'code': code},
      auth: false,
    );
    return AuthSessionModel.fromJson(json);
  }

  Future<BrokerModel> getMe() async =>
      BrokerModel.fromJson(await _api.get<Map<String, dynamic>>(ApiEndpoints.me));

  Future<void> logout() async {
    await _api.post<dynamic>(ApiEndpoints.logout);
  }
}
