import 'dart:convert';

import 'package:flutter/foundation.dart';

// Perfil de usuario
class UserProfileModel {
  final String id;
  final String email;
  final String? nickname;
  final String? name;
  final String? cpf;
  final String? register; //numero de pm
  final String? phone;
  final String? photo;
  final List<String>? routes; //admin, reserva, operador, relatorio
  final List<String>? restrictions; // constar ItemModel.groups
  final bool isActive;

  UserProfileModel({
    required this.id,
    required this.email,
    this.nickname,
    this.name,
    this.cpf,
    this.phone,
    this.photo,
    this.register,
    this.routes,
    this.restrictions,
    required this.isActive,
  });

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? name,
    String? cpf,
    String? phone,
    String? photo,
    String? register,
    List<String>? routes,
    List<String>? restrictions,
    bool? isActive,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      register: register ?? this.register,
      routes: routes ?? this.routes,
      restrictions: restrictions ?? this.restrictions,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    if (nickname != null) {
      result.addAll({'nickname': nickname});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (cpf != null) {
      result.addAll({'cpf': cpf});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (photo != null) {
      result.addAll({'photo': photo});
    }
    if (register != null) {
      result.addAll({'register': register});
    }
    if (routes != null) {
      result.addAll({'routes': routes});
    }
    if (restrictions != null) {
      result.addAll({'restrictions': restrictions});
    }
    result.addAll({'isActive': isActive});

    return result;
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      nickname: map['nickname'],
      name: map['name'],
      cpf: map['cpf'],
      phone: map['phone'],
      photo: map['photo'],
      register: map['register'],
      routes: List<String>.from(map['routes']),
      restrictions: List<String>.from(map['restrictions']),
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfileModel(id: $id, email: $email, nickname: $nickname, name: $name, cpf: $cpf, phone: $phone, photo: $photo, register: $register, routes: $routes, restrictions: $restrictions, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileModel &&
        other.id == id &&
        other.email == email &&
        other.nickname == nickname &&
        other.name == name &&
        other.cpf == cpf &&
        other.phone == phone &&
        other.photo == photo &&
        other.register == register &&
        listEquals(other.routes, routes) &&
        listEquals(other.restrictions, restrictions) &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        nickname.hashCode ^
        name.hashCode ^
        cpf.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        register.hashCode ^
        routes.hashCode ^
        restrictions.hashCode ^
        isActive.hashCode;
  }
}
