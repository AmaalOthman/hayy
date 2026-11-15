import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/broker_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

final getProfileProvider =
    Provider<GetProfile>((ref) => GetProfile(ref.watch(profileRepositoryProvider)));
final updateProfileProvider = Provider<UpdateProfile>(
    (ref) => UpdateProfile(ref.watch(profileRepositoryProvider)));

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, BrokerProfile>(
        ProfileController.new);

class ProfileController extends AsyncNotifier<BrokerProfile> {
  @override
  Future<BrokerProfile> build() async {
    ref.watch(authControllerProvider
        .select((s) => s is Authenticated ? s.session.brokerId : null));

    return switch (await ref.read(getProfileProvider)(const NoParams())) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  Future<Failure?> save(ProfileUpdate update) async {
    final result = await ref.read(updateProfileProvider)(update);
    if (result case Ok(:final value)) state = AsyncData(value);
    return result.failureOrNull;
  }
}
