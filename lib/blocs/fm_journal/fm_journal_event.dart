import 'package:BrandFarm/models/field_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FMJournalEvent extends Equatable{
  const FMJournalEvent();

  @override
  List<Object> get props => [];
}

class LoadFMJournalList extends FMJournalEvent {}

class ReloadFMJournal extends FMJournalEvent {}

class ChangeListOrder extends FMJournalEvent {
  final String order;

  const ChangeListOrder({
    @required this.order,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''ChangeListOrder { 
    order : $order,
  }''';
}

class ChangeScreen extends FMJournalEvent {
  final int navTo;
  final int index;

  const ChangeScreen({
    @required this.navTo,
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''ChangeScreen { 
    navTo : $navTo, 
    index : $index, 
  }''';
}

class ChangeSwitchState extends FMJournalEvent {}

class GetFieldList extends FMJournalEvent {}

class SetField extends FMJournalEvent {
  final Field field;

  const SetField({
    @required this.field,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'SetField { field : $field}';
}

class SetJourYear extends FMJournalEvent {
  final String year;

  const SetJourYear({
    @required this.year,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'SetJourYear { year : $year}';
}

class SetJourMonth extends FMJournalEvent {
  final String month;

  const SetJourMonth({
    @required this.month,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'SetJourMonth { month : $month}';
}

class SetFieldButtonSize extends FMJournalEvent {
  final double height;
  final double width;

  const SetFieldButtonSize({
    @required this.height,
    @required this.width,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetFieldButtonSize { 
    height : $height,
    width : $width,
  }''';
}

class SetFieldButtonPosition extends FMJournalEvent {
  final double x;
  final double y;

  const SetFieldButtonPosition({
    @required this.x,
    @required this.y,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetFieldButtonPosition { 
    x : $x,
    y : $y,
  }''';
}

class UpdateFieldButtonState extends FMJournalEvent {}

class GetJournalList extends FMJournalEvent {}

class SetJournal extends FMJournalEvent {}