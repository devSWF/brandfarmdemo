
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OMHomeEvent extends Equatable{
  const OMHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadOMHome extends OMHomeEvent{}

class SetPageIndex extends OMHomeEvent{
  final int index;

  const SetPageIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetPageIndex {
    index: $index,
  }''';
}

class SetSubPageIndex extends OMHomeEvent{
  final int index;

  const SetSubPageIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetSubPageIndex {
    index: $index,
  }''';
}