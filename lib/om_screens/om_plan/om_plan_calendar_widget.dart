import 'package:BrandFarm/blocs/om_plan/om_plan_bloc.dart';
import 'package:BrandFarm/om_screens/om_plan/om_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OMPlanCalendarWidget extends StatefulWidget {
  @override
  _OMPlanCalendarWidgetState createState() => _OMPlanCalendarWidgetState();
}

class _OMPlanCalendarWidgetState extends State<OMPlanCalendarWidget> {
  OMPlanBloc _omPlanBloc;

  @override
  void initState() {
    super.initState();
    _omPlanBloc = BlocProvider.of<OMPlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider.value(
        value: _omPlanBloc,
        child: OMCalendar(),
      ),
    );
  }
}
