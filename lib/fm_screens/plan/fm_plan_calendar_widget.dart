import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/widgets/fm_shared_widgets/fm_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMPlanCalendarWidget extends StatefulWidget {
  @override
  _FMPlanCalendarWidgetState createState() => _FMPlanCalendarWidgetState();
}

class _FMPlanCalendarWidgetState extends State<FMPlanCalendarWidget> {
  FMPlanBloc _fmPlanBloc;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider.value(
        value: _fmPlanBloc,
        child: FMCalendar(),
      ),
    );
  }
}
