import 'package:BrandFarm/blocs/fm_notification/fm_notification_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_event.dart';
import 'package:BrandFarm/fm_screens/plan/fm_add_plan.dart';
import 'package:BrandFarm/fm_screens/plan/fm_plan_calendar_widget.dart';
import 'package:BrandFarm/fm_screens/plan/fm_plan_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMPlanScreen extends StatefulWidget {
  @override
  _FMPlanScreenState createState() => _FMPlanScreenState();
}

class _FMPlanScreenState extends State<FMPlanScreen> {
  FMPlanBloc _fmPlanBloc;
  FMNotificationBloc _fmNotificationBloc;

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
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          body: Padding(
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
                        value: _fmPlanBloc,
                        child: FMPlanCalendarWidget(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  width: 253,
                  height: 361,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 17, 19, 0),
                  child: BlocProvider.value(
                    value: _fmPlanBloc,
                    child: FMPlanDetailScreen(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fieldSelectionMenu({FMPlanState state}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            Container(
              width: 84 * state.fieldList.length.toDouble(),
              height: 28,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              left: (state.selectedField == 0)
                  ? 0
                  : (state.selectedField == 1)
                      ? 84
                      : (state.selectedField == 2)
                          ? 168
                          : 252,
              child: Container(
                width: 84,
                height: 28,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: (state.selectedField == 0)
                      ? Color(0xFF15B85B)
                      : (state.selectedField == 1)
                      ? Colors.orange
                      : (state.selectedField == 2)
                      ? Colors.yellow
                      : (state.selectedField == 3)
                      ? Colors.blue
                      : Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Container(
              width: 84 * state.fieldList.length.toDouble(),
              height: 28,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  state.fieldList.length,
                  (index) => Row(
                    children: [
                      InkResponse(
                        onTap: () {
                          // setState(() {
                          //   _selectedField = index;
                          // });
                          _fmPlanBloc.add(SetSelectedField(selectedField: index));
                        },
                        child: Container(
                          width: 84,
                          height: 28,
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: Text(
                              '${state.fieldList[index].name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: 15,
                                    fontWeight: (state.selectedField == index)
                                        ? FontWeight.w600
                                        : FontWeight.w300, // normal
                                    color: (state.selectedField == index)
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
                value: _fmPlanBloc,
              ),
              BlocProvider.value(
                value: _fmNotificationBloc,
              ),
            ],
            child: FMAddPlan(),
          );
        });
  }
}
