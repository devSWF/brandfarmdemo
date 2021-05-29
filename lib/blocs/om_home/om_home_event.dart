import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OMHomeEvent extends Equatable {
  const OMHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadOMHome extends OMHomeEvent {}

class SetPageIndex extends OMHomeEvent {
  final int index;

  const SetPageIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetPageIndex {
    index: $index,
  }''';
}

class SetSubPageIndex extends OMHomeEvent {
  final int index;

  const SetSubPageIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetSubPageIndex {
    index: $index,
  }''';
}

class SetSelectedIndex extends OMHomeEvent {
  final int index;

  const SetSelectedIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetSelectedIndex {
    index: $index,
  }''';
}

class CheckAsRead extends OMHomeEvent {
  final int index;

  const CheckAsRead({
    @required this.index,
  });

  @override
  String toString() => '''CheckAsRead {
    index: $index,
  }''';
}

class GetRecentUpdates extends OMHomeEvent {}

class GetFarmListForOMHome extends OMHomeEvent {}

class SetFcmToken extends OMHomeEvent {}

class ChangeCurrFarmIndex extends OMHomeEvent {
  final int index;

  const ChangeCurrFarmIndex({
    @required this.index,
  });

  @override
  String toString() => '''ChangeCurrFarmIndex {
    index: $index,
  }''';
}
