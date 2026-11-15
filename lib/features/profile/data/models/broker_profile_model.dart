import '../../domain/entities/broker_profile.dart';

class BrokerProfileModel extends BrokerProfile {
  const BrokerProfileModel({
    required super.id,
    required super.phone,
    super.fullName,
    super.agencyName,
    super.whatsappNumber,
    super.photoUrl,
  });

  factory BrokerProfileModel.fromJson(Map<String, dynamic> json) =>
      BrokerProfileModel(
        id: json['id'].toString(),
        phone: json['phone'] as String,
        fullName: json['fullName'] as String?,
        agencyName: json['agencyName'] as String?,
        whatsappNumber: json['whatsappNumber'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );
}
