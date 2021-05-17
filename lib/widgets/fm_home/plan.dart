import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/plan/plan_bloc.dart';
import 'package:BrandFarm/blocs/plan/plan_event.dart';
import 'package:BrandFarm/blocs/plan/plan_state.dart';
import 'package:BrandFarm/utils/todays_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Plan extends StatefulWidget {
  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  PlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;
  ScrollController _scrollController;
  DateTime now = DateTime.now();

  // List list = [
  //   '씨뿌리기 (4/5 ~ 4/7)',
  //   '솔라빔 (4/5 ~ 4/7)',
  //   '잎날가르기 (4/5 ~ 4/7)',
  // ];
  // List cat = [
  //   'A',
  //   'B',
  //   'C',
  // ];

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<PlanBloc>(context);
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanBloc, PlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            _listByDate(),
            SizedBox(
              width: 1,
            ),
            _todo(state),
          ],
        );
      },
    );
  }

  Widget _listByDate() {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(14, 17, 0, 0),
        height: 212,
        width: 571,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: _fmPlanBloc,
                ),
                BlocProvider.value(
                  value: _fmHomeBloc,
                ),
              ],
              child: DateBar(),
            ),
            SizedBox(
              height: 7,
            ),
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: _fmPlanBloc,
                ),
              ],
              child: CalendarBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todo(PlanState state) {
    String date = (state.fmHomeCalendarDateList[state.selectedIndex]
            .isAtSameMomentAs(DateTime.utc(now.year, now.month, now.day)))
        ? '오늘'
        : '${state.fmHomeCalendarDateList[state.selectedIndex].month}/${state.fmHomeCalendarDateList[state.selectedIndex].day}';
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 17, 6, 0),
        height: 212,
        width: 243,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${date}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
            ),
            SizedBox(
              height: 19,
            ),
            Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: Container(
                height: 150,
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  children: List.generate(
                      state.sortedList[state.selectedIndex].length, (field) {
                    return Column(
                      children: List.generate(
                          state.sortedList[state.selectedIndex][field].length,
                          (index) {
                        int planIndex = state.todoPlanListShort.indexWhere(
                            (element) =>
                                element.planID ==
                                state
                                    .sortedList[state.selectedIndex][field]
                                        [index]
                                    .planID);
                        DateTime sDate = state
                            .todoPlanListShort[planIndex].startDate
                            .toDate();
                        DateTime eDate =
                            state.todoPlanListShort[planIndex].endDate.toDate();
                        return (index == 0)
                            ? Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: Util().getColorByIndex(index: field),
                                    child: Center(
                                      child: Text(
                                        '${state.fieldList[field].name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 195,
                                            child: Text(
                                              '${state.sortedList[state.selectedIndex][field][index].content} (${DateFormat('M/d').format(sDate)} ~ ${DateFormat('M/d').format(eDate)})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Util().getColorByIndex(
                                                        index: field),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      (index == state.sortedList[state.selectedIndex][field].length - 1)
                                          ? divider()
                                          : SizedBox(height: 8,),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 195,
                                  child: Text(
                                    '${state.sortedList[state.selectedIndex][field][index].content} (${DateFormat('M/d').format(sDate)} ~ ${DateFormat('M/d').format(eDate)})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Util().getColorByIndex(
                                          index: field),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            (index == state.sortedList[state.selectedIndex][field].length - 1)
                                ? divider()
                                : SizedBox(height: 8,),
                          ],
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(
      height: 24,
      thickness: 1,
      color: Color(0x4D000000),
      endIndent: 24,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class DateBar extends StatefulWidget {
  @override
  _DateBarState createState() => _DateBarState();
}

class _DateBarState extends State<DateBar> {
  PlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<PlanBloc>(context);
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 34,
            ),
            Text(
              '${now.year}년 ${now.month}월 ${now.day}일 ${daysOfWeek(index: now.weekday)}',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                _fmHomeBloc.add(SetPageIndex(index: 2));
                _fmHomeBloc.add(SetSubPageIndex(index: 1));
                _fmHomeBloc.add(SetSelectedIndex(index: 2));
              },
              child: Text(
                '전체 영농계획 보기',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 12,
                      color: Color(0x80000000),
                    ),
              ),
            ),
            SizedBox(
              width: 13,
            ),
          ],
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class CalendarBar extends StatefulWidget {
  @override
  _CalendarBarState createState() => _CalendarBarState();
}

class _CalendarBarState extends State<CalendarBar> {
  PlanBloc _fmPlanBloc;
  DateTime now = DateTime.now();

  // int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<PlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanBloc, PlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: _fmPlanBloc,
                ),
              ],
              child: FieldList(),
            ),
            SizedBox(
              width: 5,
            ),
            _CalendarBody(state),
          ],
        );
      },
    );
  }

  Widget _CalendarBody(PlanState state) {
    return Stack(
      children: [
        _horizontalViewCalendar(state),
        Positioned(top: 0, left: 0, right: 0, child: _highlightPlan(state)),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _horizontalViewCalendarFront(state)),
      ],
    );
  }

  Widget _highlightPlan(PlanState state) {
    return Row(
      children: List.generate(state.sortedList.length, (row) {
        return Container(
                padding: EdgeInsets.zero,
                width: (state.selectedIndex == row) ? 102 : 103,
                height: (state.selectedIndex == row) ? 149 : 131,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(
                  //   width: (selectedIndex == row) ? 2 : 1,
                  //   color: Colors.transparent,
                  // ),
                ),
                child: Column(
                  children: List.generate(state.sortedList[row].length, (index) {
                    return Column(
                      children: [
                        (index == 0) ? SizedBox(
                          height: (state.selectedIndex == row) ? 39 : 30,
                        ) : Container(),
                        Column(
                          children: [
                            Container(
                              height: 10,
                              width: (state.selectedIndex == row) ? 160 : 140,
                              color: (state.sortedList[row][index].length > 0)
                                  ? Util().getColorByIndex(index: index)
                                  : Colors.transparent,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              );
      }),
    );
  }

  Widget _horizontalViewCalendarFront(PlanState state) {
    return Row(
      children: List.generate(5, (index) {
        // String date = getDate(index: index, date: now);
        return InkResponse(
          onTap: () {
            _fmPlanBloc.add(SetCalendarIndex(index: index));
          },
          child: Container(
            padding: EdgeInsets.all(6),
            width: (state.selectedIndex == index) ? 102 : 103,
            height: (state.selectedIndex == index) ? 149 : 131,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: (state.selectedIndex == index) ? 2 : 1,
                color: (state.selectedIndex == index)
                    ? Color(0xFF15B85B)
                    : Colors.transparent,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _horizontalViewCalendar(PlanState state) {
    return Row(
      children: List.generate(5, (index) {
        String date = getDate(index: index, date: now);
        return Container(
          padding: EdgeInsets.all(6),
          width: (state.selectedIndex == index) ? 102 : 103,
          height: (state.selectedIndex == index) ? 149 : 131,
          decoration: BoxDecoration(
            color: (state.selectedIndex == index)
                ? Colors.white
                : Color(0xFFF3F3F3),
            border: Border.all(
              width: (state.selectedIndex == index) ? 2 : 1,
              color: (state.selectedIndex == index)
                  ? Colors.transparent
                  : Color(0xFFD8D8D8),
            ),
          ),
          child: Text(
            '${date}',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w200,
                  fontSize: 15,
                  color: (state.selectedIndex == index)
                      ? Color(0xFF15B85B)
                      : Colors.black,
                ),
          ),
        );
      }),
    );
  }

  String getDate({int index, DateTime date}) {
    switch (index) {
      case 0:
        {
          DateTime dt = date.subtract(Duration(days: 2));
          return '${dt.month}/${dt.day}';
        }
        break;
      case 1:
        {
          DateTime dt = date.subtract(Duration(days: 1));
          return '${dt.month}/${dt.day}';
        }
        break;
      case 2:
        {
          return '${date.month}/${date.day}';
        }
        break;
      case 3:
        {
          DateTime dt = date.add(Duration(days: 1));
          return '${dt.month}/${dt.day}';
        }
        break;
      case 4:
        {
          DateTime dt = date.add(Duration(days: 2));
          return '${dt.month}/${dt.day}';
        }
        break;
      default:
        {
          return '?/?';
        }
        break;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class FieldList extends StatefulWidget {
  @override
  _FieldListState createState() => _FieldListState();
}

class _FieldListState extends State<FieldList> {
  PlanBloc _fmPlanBloc;

  // List fieldName = [
  //   '필드A',
  //   '필드B',
  //   '필드C',
  // ];

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<PlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanBloc, PlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: List.generate(state.fieldList.length, (index) {
            return Column(
              children: [
                (index == 0)
                    ? SizedBox(
                        height: 10,
                      )
                    : Container(),
                Container(
                    height: 14,
                    width: 29,
                    child: FieldBadge(
                      index: index,
                      name: (index == 0) ? '공통' : state.fieldList[index].name,
                    )),
                SizedBox(
                  height: 6,
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class FieldBadge extends StatefulWidget {
  final int index;
  final String name;

  FieldBadge({
    Key key,
    this.index,
    this.name,
  }) : super(key: key);

  @override
  _FieldBadgeState createState() => _FieldBadgeState();
}

class _FieldBadgeState extends State<FieldBadge> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(1, 1, 4, 1),
      color: Util().getColorByIndex(index: widget.index),
      child: Text(
        '${widget.name}',
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: 10,
              color: Colors.white,
            ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class Util {
  Color getColorByIndex({int index}) {
    switch (index) {
      case 1:
        {
          return Colors.orange;
        }
        break;
      case 2:
        {
          return Colors.yellow;
        }
        break;
      case 3:
        {
          return Colors.blue;
        }
        break;
      case 4:
        {
          return Colors.purple;
        }
        break;
      default:
        {
          return Colors.green;
        }
        break;
    }
  }
}
