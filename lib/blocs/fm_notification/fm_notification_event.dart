import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FMNotificationEvent extends Equatable{
  const FMNotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadFMNotification extends FMNotificationEvent{}

class GetFieldList extends FMNotificationEvent {}

class SetField extends FMNotificationEvent {
  final Field field;

  const SetField({
    @required this.field,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'SetField { field : $field}';
}

class PostNotification extends FMNotificationEvent{
  final NotificationNotice obj;

  const PostNotification({
    @required this.obj,
  });

  @override
  String toString() => '''PostNotification { 
    obj: $obj,
  }''';
}

class SetNotificationListOrder extends FMNotificationEvent {
  final int columnIndex;

  const SetNotificationListOrder({
    @required this.columnIndex,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetNotificationListOrder { 
    columnIndex : $columnIndex,
  }''';
}

class SetNotification extends FMNotificationEvent {
  final NotificationNotice notice;

  const SetNotification({
    @required this.notice,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetNotification { 
    notice : $notice,
  }''';
}

class UpdateNotDropdownMenuState extends FMNotificationEvent {}

class UpdateNotMenuIndex extends FMNotificationEvent {
  final int menuIndex;

  const UpdateNotMenuIndex({
    @required this.menuIndex,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdateNotMenuIndex { 
    menuIndex : $menuIndex,
  }''';
}

class GetNotificationListBySearch extends FMNotificationEvent {
  final String word;

  const GetNotificationListBySearch({
    @required this.word,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''GetNotificationListBySearch { 
    word : $word,
  }''';
}

class GetNotificationList extends FMNotificationEvent {}

class ShowTotalList extends FMNotificationEvent {}

class SetNoticeAsRead extends FMNotificationEvent {
  final int index;

  const SetNoticeAsRead({
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetNoticeAsRead { 
    index : $index,
  }''';
}