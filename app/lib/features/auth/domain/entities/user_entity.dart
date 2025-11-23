class UserEntity{
  final String id;
  final String email;
  final String fullname;
  final String token;
  
  UserEntity({required this.id, required this.fullname, required this.email, this.token = ''});

}