
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FMPlanEvent extends Equatable{
  const FMPlanEvent();

  @override
  List<Object> get props => [];
}

class LoadFMPlan extends FMPlanEvent{}

class GetFieldListForFMPlan extends FMPlanEvent {}

class GetPlanList extends FMPlanEvent {}

class PostNewPlan extends FMPlanEvent {}

class SetWaitingPlan extends FMPlanEvent {
  final WaitingConfirmation wPlan;

  const SetWaitingPlan({
    @required this.wPlan,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetWaitingPlan { 
    wPlan : $wPlan,
  }''';
}

class SetDate extends FMPlanEvent{
  final DateTime date;

  const SetDate({
    @required this.date,
  });

  @override
  String toString() => '''SetDate {
    date: $date,
  }''';
}

class SetSelectedField extends FMPlanEvent{
  final int selectedField;

  const SetSelectedField({
    @required this.selectedField,
  });

  @override
  String toString() => '''SetSelectedField {
    selectedField: $selectedField,
  }''';
}

class SetStartDate extends FMPlanEvent{
  final DateTime startDate;

  const SetStartDate({
    @required this.startDate,
  });

  @override
  String toString() => '''SetStartDate {
    startDate: $startDate,
  }''';
}

class SetEndDate extends FMPlanEvent{
  final DateTime endDate;

  const SetEndDate({
    @required this.endDate,
  });

  @override
  String toString() => '''SetEndDate {
    endDate: $endDate,
  }''';
}

class CheckConfirmState extends FMPlanEvent{
  final bool confirmState;

  const CheckConfirmState({
    @required this.confirmState,
  });

  @override
  String toString() => '''CheckConfirmState {
    confirmState: $confirmState,
  }''';
}

class GetShortDetailList extends FMPlanEvent{}

class GetSortedDetailList extends FMPlanEvent{}

class SetCalendarIndex extends FMPlanEvent{
  final int index;

  const SetCalendarIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetCalendarIndex {
    index: $index,
  }''';
}