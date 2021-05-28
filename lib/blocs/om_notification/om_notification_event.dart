import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class OMNotificationEvent extends Equatable {
  const OMNotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadOMNotification extends OMNotificationEvent {}

class GetFarmList extends OMNotificationEvent {}

class SetFarm extends OMNotificationEvent {
  final Farm farm;

  const SetFarm({
    @required this.farm,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'SetFarm { farm : $farm}';
}

class PostNotification extends OMNotificationEvent {
  final NotificationNotice obj;

  const PostNotification({
    @required this.obj,
  });

  @override
  String toString() => '''PostNotification { 
    obj: $obj,
  }''';
}

class SetNotificationListOrder extends OMNotificationEvent {
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

class SetNotification extends OMNotificationEvent {
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

class UpdateNotDropdownMenuState extends OMNotificationEvent {}

class UpdateNotMenuIndex extends OMNotificationEvent {
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

class GetNotificationListBySearch extends OMNotificationEvent {
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

class GetNotificationList extends OMNotificationEvent {}

class ShowTotalList extends OMNotificationEvent {}

class SetNoticeAsRead extends OMNotificationEvent {
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

class PushPlanNotification extends OMNotificationEvent {
  final OMPlan plan;

  const PushPlanNotification({
    @required this.plan,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''PushPlanNotification { 
    plan : $plan,
  }''';
}

class PushSCommentNotification extends OMNotificationEvent {
  final SubComment scmt;

  const PushSCommentNotification({
    @required this.scmt,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''PushSCommentNotification { 
    scmt : $scmt,
  }''';
}

class PostCommentNotification extends OMNotificationEvent {
  final Comment cmt;

  const PostCommentNotification({
    @required this.cmt,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''PostCommentNotification { 
    cmt : $cmt,
  }''';
}

class PostIssueCommentNotice extends OMNotificationEvent {
  final Comment cmt;

  const PostIssueCommentNotice({
    @required this.cmt,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''PostIssueCommentNotice { 
    cmt : $cmt,
  }''';
}

class PostIssueSCommentNotice extends OMNotificationEvent {
  final SubComment scmt;

  const PostIssueSCommentNotice({
    @required this.scmt,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''PostIssueSCommentNotice { 
    scmt : $scmt,
  }''';
}
