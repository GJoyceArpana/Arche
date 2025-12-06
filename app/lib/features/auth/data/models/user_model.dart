import 'package:app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullname,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return UserModel(
      id: (user?['id'] ?? user?['_id'] ?? json['id'] ?? json['_id'] ?? '')
          .toString(),
      token: (json['token'] ?? '').toString(),
      fullname: (user?['fullname'] ?? json['fullname'] ?? '').toString(),
      email: (user?['email'] ?? json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullname': fullname, 'email': email, 'token': token};
  }
}
