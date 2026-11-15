import '../../domain/entities/auth_session.dart';

class BrokerModel {
  const BrokerModel({
    required this.id,
    required this.phone,
    required this.status,
    required this.profileCompleted,
  });

  factory BrokerModel.fromJson(Map<String, dynamic> json) => BrokerModel(
        id: json['id'].toString(),
        phone: json['phone'] as String,
        status: BrokerStatus.fromJson(json['status'] as String?),
        // Fall back to the name if the backend doesn't send the flag.
        profileCompleted: json['profileCompleted'] as bool? ??
            ((json['fullName'] as String?)?.isNotEmpty ?? false),
      );

  final String id;
  final String phone;
  final BrokerStatus status;
  final bool profileCompleted;

  AuthSession toEntity() => AuthSession(
        brokerId: id,
        phone: phone,
        status: status,
        hasProfile: profileCompleted,
      );
}
