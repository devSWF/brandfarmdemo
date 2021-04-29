import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeEvent extends Equatable{
  const HomeEvent();

  @override
  List<Object> get props => [];
}
class NextMonthClicked extends HomeEvent{
  @override
  String toString() => 'NextMonthClicked';
}

class PrevMonthClicked extends HomeEvent{
  @override
  String toString() => 'PrevMonthClicked';
}

class DateClicked extends HomeEvent{
  final int SelectedDay;
  const DateClicked({@required this.SelectedDay});

  @override
  String toString() => 'DateClicked { SelectedDate: $SelectedDay}';
}

class BottomNavBarClicked extends HomeEvent{
  final int index;
  const BottomNavBarClicked({@required this.index});

  @override
  String toString() => 'BottomNavBarClicked { index: $index';
}

class GetHomePlanList extends HomeEvent {}

class SortPlanList extends HomeEvent {}

class CheckNotificationUpdates extends HomeEvent {}
class UpdateNotificationState extends HomeEvent {}

class CheckPlanUpdates extends HomeEvent {}
class UpdatePlanState extends HomeEvent {}