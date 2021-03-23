import 'package:BrandFarm/widgets/fm_shared_widgets/fm_calendar.dart';
import 'package:flutter/material.dart';

class FMPlanCalendarWidget extends StatefulWidget {
  @override
  _FMPlanCalendarWidgetState createState() => _FMPlanCalendarWidgetState();
}

class _FMPlanCalendarWidgetState extends State<FMPlanCalendarWidget> {

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: FMCalendar(
        // onTap: (){},

      ),
    );
  }
}
