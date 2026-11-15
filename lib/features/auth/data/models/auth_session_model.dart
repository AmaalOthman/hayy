import 'broker_model.dart';

/// `POST /auth/otp/verify` body:
/// `{"accessToken": "...", "refreshToken": "...", "broker": {...}}`.
class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.broker,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      AuthSessionModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        broker: BrokerModel.fromJson(json['broker'] as Map<String, dynamic>),
      );

  final String accessToken;
  final String refreshToken;
  final BrokerModel broker;
}
