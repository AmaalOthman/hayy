import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/broker_profile.dart';
import '../models/broker_profile_model.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
    (ref) => ProfileRemoteDataSource(ref.watch(apiClientProvider)));

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._api);
  final ApiClient _api;

  Future<BrokerProfileModel> getProfile() async => BrokerProfileModel.fromJson(
      await _api.get<Map<String, dynamic>>(ApiEndpoints.me));

  Future<BrokerProfileModel> updateProfile(ProfileUpdate update) async {
    final photo = update.photoPath;
    final form = FormData.fromMap({
      'fullName': update.fullName,
      'agencyName': update.agencyName,
      'whatsappNumber': update.whatsappNumber,
      // Read through XFile: works for file paths and for web blob: URLs.
      if (photo != null)
        'photo': MultipartFile.fromBytes(
          await XFile(photo).readAsBytes(),
          filename: 'profile.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        ),
    });
    return BrokerProfileModel.fromJson(
        await _api.put<Map<String, dynamic>>(ApiEndpoints.me, data: form));
  }
}
