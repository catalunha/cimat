abstract class UserProfileAccessEvent {}

class UserProfileAccessEventFormSubmitted extends UserProfileAccessEvent {
  final bool isActive;
  final String restrictions;
  UserProfileAccessEventFormSubmitted({
    required this.isActive,
    required this.restrictions,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileAccessEventFormSubmitted &&
        other.isActive == isActive &&
        other.restrictions == restrictions;
  }

  @override
  int get hashCode => isActive.hashCode ^ restrictions.hashCode;
}

class UserProfileAccessEventUpdateRoute extends UserProfileAccessEvent {
  final String route;
  UserProfileAccessEventUpdateRoute({
    required this.route,
  });
}
