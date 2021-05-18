
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PlanEvent extends Equatable{
  const PlanEvent();

  @override
  List<Object> get props => [];
}

class LoadFMPlan extends PlanEvent{}

class GetFieldListForFMPlan extends PlanEvent {}

class GetPlanList extends PlanEvent {}

class PostNewPlan extends PlanEvent {}

class SetWaitingPlan extends PlanEvent {
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

class SetDate extends PlanEvent{
  final DateTime date;

  const SetDate({
    @required this.date,
  });

  @override
  String toString() => '''SetDate {
    date: $date,
  }''';
}

class SetSelectedField extends PlanEvent{
  final int selectedField;

  const SetSelectedField({
    @required this.selectedField,
  });

  @override
  String toString() => '''SetSelectedField {
    selectedField: $selectedField,
  }''';
}

class SetStartDate extends PlanEvent{
  final DateTime startDate;

  const SetStartDate({
    @required this.startDate,
  });

  @override
  String toString() => '''SetStartDate {
    startDate: $startDate,
  }''';
}

class SetEndDate extends PlanEvent{
  final DateTime endDate;

  const SetEndDate({
    @required this.endDate,
  });

  @override
  String toString() => '''SetEndDate {
    endDate: $endDate,
  }''';
}

class CheckConfirmState extends PlanEvent{
  final bool confirmState;

  const CheckConfirmState({
    @required this.confirmState,
  });

  @override
  String toString() => '''CheckConfirmState {
    confirmState: $confirmState,
  }''';
}

class GetShortDetailList extends PlanEvent{}

class GetSortedDetailList extends PlanEvent{}

class SetCalendarIndex extends PlanEvent{
  final int index;

  const SetCalendarIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetCalendarIndex {
    index: $index,
  }''';
}