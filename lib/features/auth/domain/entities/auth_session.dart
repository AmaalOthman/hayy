import 'package:equatable/equatable.dart';

enum BrokerStatus {
  pending,
  approved,
  suspended;

  static BrokerStatus fromJson(String? value) => switch (value) {
        'approved' => approved,
        'suspended' => suspended,
        _ => pending,
      };
}

/// The signed-in broker, as far as routing cares.
class AuthSession extends Equatable {
  const AuthSession({
    required this.brokerId,
    required this.phone,
    required this.status,
    required this.hasProfile,
  });

  final String brokerId;
  final String phone;
  final BrokerStatus status;

  final bool hasProfile;

  bool get isApproved => status == BrokerStatus.approved;

  @override
  List<Object?> get props => [brokerId, phone, status, hasProfile];
}
