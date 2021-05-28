import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OMPlanEvent extends Equatable {
  const OMPlanEvent();

  @override
  List<Object> get props => [];
}

class LoadOMPlan extends OMPlanEvent {}

class GetFarmListForOMPlan extends OMPlanEvent {}

class GetPlanList extends OMPlanEvent {}

class PostNewPlan extends OMPlanEvent {}

class SetWaitingPlan extends OMPlanEvent {
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

class SetDate extends OMPlanEvent {
  final DateTime date;

  const SetDate({
    @required this.date,
  });

  @override
  String toString() => '''SetDate {
    date: $date,
  }''';
}

class SetSelectedFarm extends OMPlanEvent {
  final int selectedFarm;

  const SetSelectedFarm({
    @required this.selectedFarm,
  });

  @override
  String toString() => '''SetSelectedFarm {
    selectedFarm: $selectedFarm,
  }''';
}

class SetStartDate extends OMPlanEvent {
  final DateTime startDate;

  const SetStartDate({
    @required this.startDate,
  });

  @override
  String toString() => '''SetStartDate {
    startDate: $startDate,
  }''';
}

class SetEndDate extends OMPlanEvent {
  final DateTime endDate;

  const SetEndDate({
    @required this.endDate,
  });

  @override
  String toString() => '''SetEndDate {
    endDate: $endDate,
  }''';
}

class CheckConfirmState extends OMPlanEvent {
  final bool confirmState;

  const CheckConfirmState({
    @required this.confirmState,
  });

  @override
  String toString() => '''CheckConfirmState {
    confirmState: $confirmState,
  }''';
}

class SetCalendarIndex extends OMPlanEvent {
  final int index;

  const SetCalendarIndex({
    @required this.index,
  });

  @override
  String toString() => '''SetCalendarIndex {
    index: $index,
  }''';
}
