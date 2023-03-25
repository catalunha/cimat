import 'package:flutter/foundation.dart';

import '../../../../core/models/user_profile_model.dart';

enum UserProfileAccessStateStatus { initial, loading, success, error }

class UserProfileAccessState {
  final UserProfileAccessStateStatus status;
  final String? error;
  final List<String> routes;
  final UserProfileModel userProfileModel;
  UserProfileAccessState({
    required this.status,
    this.error,
    required this.routes,
    required this.userProfileModel,
  });
  UserProfileAccessState.initial(this.userProfileModel)
      : status = UserProfileAccessStateStatus.initial,
        error = '',
        routes = userProfileModel.routes ?? [];

  UserProfileAccessState copyWith({
    UserProfileAccessStateStatus? status,
    String? error,
    List<String>? routes,
    UserProfileModel? userProfileModel,
  }) {
    return UserProfileAccessState(
      status: status ?? this.status,
      error: error ?? this.error,
      routes: routes ?? this.routes,
      userProfileModel: userProfileModel ?? this.userProfileModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileAccessState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.routes, routes) &&
        other.userProfileModel == userProfileModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        routes.hashCode ^
        userProfileModel.hashCode;
  }
}
