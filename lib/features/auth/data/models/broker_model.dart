import '../../domain/entities/auth_session.dart';

/// `GET /me` body: `{"id": "...", "phone": "+971...", "status": "pending"}`.
class BrokerModel {
  const BrokerModel({
    required this.id,
    required this.phone,
    required this.status,
  });

  factory BrokerModel.fromJson(Map<String, dynamic> json) => BrokerModel(
        id: json['id'].toString(),
        phone: json['phone'] as String,
        status: BrokerStatus.fromJson(json['status'] as String?),
      );

  final String id;
  final String phone;
  final BrokerStatus status;

  AuthSession toEntity() =>
      AuthSession(brokerId: id, phone: phone, status: status);
}
