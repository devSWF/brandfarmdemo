
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FMHomeEvent extends Equatable{
  const FMHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadFMHome extends FMHomeEvent{}

class SetPageIndex extends FMHomeEvent{
  final int index;

  const SetPageIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetPageIndex {
    index: $index,
  }''';
}

class SetSubPageIndex extends FMHomeEvent{
  final int index;

  const SetSubPageIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetSubPageIndex {
    index: $index,
  }''';
}

class SetSelectedIndex extends FMHomeEvent{
  final int index;

  const SetSelectedIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetSelectedIndex {
    index: $index,
  }''';
}

class CheckAsRead extends FMHomeEvent{
  final int index;

  const CheckAsRead({
    @required this.index,
  });

  @override
  String toString() => '''CheckAsRead {
    index: $index,
  }''';
}

class GetRecentUpdates extends FMHomeEvent {}

class GetFieldListForFMHome extends FMHomeEvent {}
class SetFcmToken extends FMHomeEvent {}

class SetField extends FMHomeEvent{
  final int index;

  const SetField({
    @required this.index,
  });

  @override
  String toString() => '''SetField {
    index: $index,
  }''';
}

class GetPicture extends FMHomeEvent{
  final int index;

  const GetPicture({
    @required this.index,
  });

  @override
  String toString() => '''GetPicture {
    index: $index,
  }''';
}

class GetComment extends FMHomeEvent{
  final int index;

  const GetComment({
    @required this.index,
  });

  @override
  String toString() => '''GetComment {
    index: $index,
  }''';
}

class GetSComment extends FMHomeEvent{
  final int index;

  const GetSComment({
    @required this.index,
  });

  @override
  String toString() => '''GetSComment {
    index: $index,
  }''';
}

class GetUser extends FMHomeEvent{
  final int index;

  const GetUser({
    @required this.index,
  });

  @override
  String toString() => '''GetUser {
    index: $index,
  }''';
}

class ChangeExpandState extends FMHomeEvent {
  final int index;

  const ChangeExpandState({
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'ChangeExpandState { index : $index}';
}

class WriteComment extends FMHomeEvent {
  final String cmt;
  final int rpIndex;

  const WriteComment({
    @required this.cmt,
    @required this.rpIndex,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''WriteComment { 
    cmt : $cmt,
    rpIndex : $rpIndex,
  }''';
}

class ChangeWriteReplyState extends FMHomeEvent {
  final int index;

  const ChangeWriteReplyState({
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''ChangeWriteReplyState { 
  index : $index,
  }''';
}

class WriteReply extends FMHomeEvent {
  final String scmt;
  final int rpIndex;
  final int index;

  const WriteReply({
    @required this.scmt,
    @required this.rpIndex,
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''WriteReply { 
    scmt : $scmt,
    obj : $rpIndex,
    index : $index,
  }''';
}

class SendCommentNotice extends FMHomeEvent {
  final int index;

  const SendCommentNotice({
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SendCommentNotice { 
    index : $index,
  }''';
}

class SendSCommentNotice extends FMHomeEvent {
  final int index;

  const SendSCommentNotice({
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SendSCommentNotice { 
    index : $index,
  }''';
}