import 'package:equatable/equatable.dart';

class BrokerProfile extends Equatable {
  const BrokerProfile({
    required this.id,
    required this.phone,
    this.fullName,
    this.agencyName,
    this.whatsappNumber,
    this.photoUrl,
  });

  final String id;

  final String phone;

  final String? fullName;
  final String? agencyName;

  final String? whatsappNumber;
  final String? photoUrl;

  @override
  List<Object?> get props =>
      [id, phone, fullName, agencyName, whatsappNumber, photoUrl];
}

class ProfileUpdate extends Equatable {
  const ProfileUpdate({
    required this.fullName,
    required this.agencyName,
    required this.whatsappNumber,
    this.photoPath,
  });

  final String fullName;
  final String agencyName;
  final String whatsappNumber;

  final String? photoPath;

  @override
  List<Object?> get props => [fullName, agencyName, whatsappNumber, photoPath];
}
