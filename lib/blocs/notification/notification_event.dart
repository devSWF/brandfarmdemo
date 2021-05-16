import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationEvent extends Equatable{
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotification extends NotificationEvent{}

class GetNotificationList extends NotificationEvent {}

class CheckAsRead extends NotificationEvent {
  final NotificationNotice obj;

  const CheckAsRead({
    @required this.obj,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'CheckAsRead { obj : $obj}';
}

class GetJournalNotificationInitials extends NotificationEvent {
  final NotificationNotice obj;

  const GetJournalNotificationInitials({
    @required this.obj,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'GetJournalNotificationInitials { obj : $obj}';
}

class GetIssueNotificationInitials extends NotificationEvent {
  final NotificationNotice obj;

  const GetIssueNotificationInitials({
    @required this.obj,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'GetIssueNotificationInitials { obj : $obj}';
}

class GetPlanNotificationInitials extends NotificationEvent {
  final NotificationNotice obj;

  const GetPlanNotificationInitials({
    @required this.obj,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'GetPlanNotificationInitials { obj : $obj}';
}

class SetExpansionState extends NotificationEvent {
  final int index;

  const SetExpansionState({
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'SetExpansionState { index: $index}';
}

// class PostNotification extends NotificationEvent{
//   final NotificationNotice obj;
//
//   const PostNotification({
//     @required this.obj,
//   });
//
//   @override
//   String toString() => '''PostNotification {
//     obj: $obj,
//   }''';
// }
