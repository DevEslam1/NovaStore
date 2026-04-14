import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool isGuest;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.isGuest = false,
  });

  @override
  List<Object?> get props => [id, email, name, photoUrl, isGuest];
}
