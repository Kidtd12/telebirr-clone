class UserModel {
  final String id;
  final String phoneNumber;
  final String fullName;
  final bool isPhoneVerified;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.isPhoneVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      isPhoneVerified: json['isPhoneVerified'] == true,
    );
  }
}

