import 'package:equatable/equatable.dart';

/// Admin approval state. Only approved brokers can post (brokers-only network).
enum BrokerStatus {
  pending,
  approved,
  suspended;

  /// Unknown values fall back to pending, the safest state.
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
  });

  final String brokerId;
  final String phone;
  final BrokerStatus status;

  bool get isApproved => status == BrokerStatus.approved;

  @override
  List<Object?> get props => [brokerId, phone, status];
}
