part of 'user_profile_edit_bloc.dart';

abstract class UserProfileEditEvent {}

class UserProfileEditEventSendXFile extends UserProfileEditEvent {
  final XFile? xfile;
  UserProfileEditEventSendXFile({
    required this.xfile,
  });
}

class UserProfileEditEventFormSubmitted extends UserProfileEditEvent {
  final String nickname;
  final String name;
  final String register;
  final String phone;
  UserProfileEditEventFormSubmitted({
    required this.nickname,
    required this.name,
    required this.register,
    required this.phone,
  });

  UserProfileEditEventFormSubmitted copyWith({
    String? nickname,
    String? name,
    String? register,
    String? phone,
  }) {
    return UserProfileEditEventFormSubmitted(
      nickname: nickname ?? this.nickname,
      name: name ?? this.name,
      register: register ?? this.register,
      phone: phone ?? this.phone,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileEditEventFormSubmitted &&
        other.nickname == nickname &&
        other.name == name &&
        other.register == register &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return nickname.hashCode ^
        name.hashCode ^
        register.hashCode ^
        phone.hashCode;
  }
}
