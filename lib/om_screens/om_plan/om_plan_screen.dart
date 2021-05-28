import 'package:BrandFarm/blocs/om_notification/om_notification_bloc.dart';
import 'package:BrandFarm/blocs/om_plan/om_plan_bloc.dart';
import 'package:BrandFarm/blocs/om_plan/om_plan_event.dart';
import 'package:BrandFarm/blocs/om_plan/om_plan_state.dart';
import 'package:BrandFarm/om_screens/om_plan/om_add_plan.dart';
import 'package:BrandFarm/om_screens/om_plan/om_plan_calendar_widget.dart';
import 'package:BrandFarm/om_screens/om_plan/om_plan_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OMPlanScreen extends StatefulWidget {
  @override
  _OMPlanScreenState createState() => _OMPlanScreenState();
}

class _OMPlanScreenState extends State<OMPlanScreen> {
  OMPlanBloc _omPlanBloc;
  OMNotificationBloc _omNotificationBloc;

  // for test
  // List<String> forTest = List.generate(4, (index) {
  //   if (index == 0) {
  //     return '전체일정';
  //   } else {
  //     return '필드${index}';
  //   }
  // });

  // int _selectedField = 0;

  @override
  void initState() {
    super.initState();
    _omPlanBloc = BlocProvider.of<OMPlanBloc>(context);
    _omNotificationBloc = BlocProvider.of<OMNotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OMPlanBloc, OMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          body: ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 814,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(32, 27, 21, 0),
                        child: Column(
                          children: [
                            _fieldSelectionMenu(state: state),
                            SizedBox(
                              height: 43,
                            ),
                            BlocProvider.value(
                              value: _omPlanBloc,
                              child: OMPlanCalendarWidget(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 253,
                        height: 361,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 17, 19, 0),
                        child: BlocProvider.value(
                          value: _omPlanBloc,
                          child: OMPlanDetailScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fieldSelectionMenu({OMPlanState state}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            Container(
              width: 84 * state.farmList.length.toDouble(),
              height: 28,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              left: (state.selectedFarm == 0)
                  ? 0
                  : (state.selectedFarm == 1)
                      ? 84
                      : (state.selectedFarm == 2)
                          ? 168
                          : 252,
              child: Container(
                width: 84,
                height: 28,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: (state.selectedFarm == 0)
                      ? Color(0xFF15B85B)
                      : (state.selectedFarm == 1)
                          ? Colors.orange
                          : (state.selectedFarm == 2)
                              ? Colors.yellow
                              : (state.selectedFarm == 3)
                                  ? Colors.blue
                                  : Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Container(
              width: 84 * state.farmList.length.toDouble(),
              height: 28,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  state.farmList.length,
                  (index) => Row(
                    children: [
                      InkResponse(
                        onTap: () {
                          // setState(() {
                          //   _selectedField = index;
                          // });
                          _omPlanBloc.add(SetSelectedFarm(selectedFarm: index));
                        },
                        child: Container(
                          width: 84,
                          height: 28,
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: Text(
                              '${state.farmList[index].name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: 15,
                                    fontWeight: (state.selectedFarm == index)
                                        ? FontWeight.w600
                                        : FontWeight.w300, // normal
                                    color: (state.selectedFarm == index)
                                        ? Colors.white
                                        : Color(
                                            0x4D000000), // Color(0x4D000000) or white
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        IconButton(
          onPressed: () async {
            await _showAddPlanDialog();
          },
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Future<void> _showAddPlanDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _omPlanBloc,
              ),
              BlocProvider.value(
                value: _omNotificationBloc,
              ),
            ],
            child: OMAddPlan(),
          );
        });
  }
}
