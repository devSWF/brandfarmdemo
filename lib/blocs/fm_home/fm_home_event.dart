
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