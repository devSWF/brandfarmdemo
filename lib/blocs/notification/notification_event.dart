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
