import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/utils/todays_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Plan extends StatefulWidget {
  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  FMPlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;
  ScrollController _scrollController;
  DateTime now = DateTime.now();
  List list = [
    '씨뿌리기 (4/5 ~ 4/7)',
    '솔라빔 (4/5 ~ 4/7)',
    '잎날가르기 (4/5 ~ 4/7)',
  ];
  List cat = [
    'A',
    'B',
    'C',
  ];

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _listByDate(),
        SizedBox(
          width: 1,
        ),
        _todo(),
      ],
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

  Widget _todo() {
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
              '오늘',
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
                  children: List.generate(cat.length, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(),
                        Divider(
                          height: 24,
                          thickness: 1,
                          color: Color(0x4D000000),
                          endIndent: 24,
                        ),
                      ],
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
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class DateBar extends StatefulWidget {
  @override
  _DateBarState createState() => _DateBarState();
}

class _DateBarState extends State<DateBar> {
  FMPlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
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
  FMPlanBloc _fmPlanBloc;
  DateTime now = DateTime.now();
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
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

  Widget _CalendarBody(FMPlanState state) {
    return Stack(
      children: [
        _horizontalViewCalendar(),
        Positioned(top: 0, left: 0, right: 0, child: _highlightPlan(state)),
        Positioned(
            top: 0, left: 0, right: 0, child: _horizontalViewCalendarFront()),
      ],
    );
  }

  List<List<FMPlan>> getSortedList(List<FMPlan> plist, List<Field> fList) {
    List<List<FMPlan>> sList = [];
    List<FMPlan> listByFid1 = (fList.isNotEmpty)
        ? plist.where((element) => element.fid == fList[0].fid).toList()
        : [];
    List<FMPlan> listByFid2 = (fList.length >= 2)
        ? plist.where((element) => element.fid == fList[1].fid).toList()
        : [];
    List<FMPlan> listByFid3 = (fList.length >= 3)
        ? plist.where((element) => element.fid == fList[2].fid).toList()
        : [];
    List<FMPlan> listByFid4 = (fList.length >= 4)
        ? plist.where((element) => element.fid == fList[3].fid).toList()
        : [];
    List<FMPlan> listByFid5 = (fList.length >= 5)
        ? plist.where((element) => element.fid == fList[4].fid).toList()
        : [];

    switch (fList.length) {
      case 1:
        {
          sList.insert(0, listByFid1);
        }
        break;
      case 2:
        {
          sList.insert(0, listByFid1);
          sList.add(listByFid2);
        }
        break;
      case 3:
        {
          sList.insert(0, listByFid1);
          sList.add(listByFid2);
          sList.add(listByFid3);
        }
        break;
      case 4:
        {
          sList.insert(0, listByFid1);
          sList.add(listByFid2);
          sList.add(listByFid3);
          sList.add(listByFid4);
        }
        break;
      case 5:
        {
          sList.insert(0, listByFid1);
          sList.add(listByFid2);
          sList.add(listByFid3);
          sList.add(listByFid4);
          sList.add(listByFid5);
        }
        break;
    }
    return sList;
  }

  Widget _highlightPlan(FMPlanState state) {
    List<List<FMPlan>> sortedList =
        getSortedList(state.detailListShort, state.fieldList);
    return Row(
      children: List.generate(5, (row) {
        return Container(
          padding: EdgeInsets.zero,
          width: (selectedIndex == row) ? 102 : 103,
          height: (selectedIndex == row) ? 149 : 131,
          decoration: BoxDecoration(
            color: Colors.transparent,
            // border: Border.all(
            //   width: (selectedIndex == row) ? 2 : 1,
            //   color: Colors.transparent,
            // ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: (selectedIndex == row) ? 39 : 30,
              ),
              (sortedList.length > 0 && sortedList[0].isNotEmpty)
                  ? Column(
                      children: [
                        Container(
                          height: 10,
                          width: (selectedIndex == row) ? 160 : 140,
                          color: Util().getColorByIndex(index: 0),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : Container(),
              (sortedList.length >= 2 && sortedList[1].isNotEmpty)
                  ? Column(
                      children: [
                        Container(
                          height: 10,
                          width: (selectedIndex == row) ? 160 : 140,
                          color: Util().getColorByIndex(index: 1),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : Container(),
              (sortedList.length >= 3 && sortedList[2].isNotEmpty)
                  ? Column(
                      children: [
                        Container(
                          height: 10,
                          width: (selectedIndex == row) ? 160 : 140,
                          color: Util().getColorByIndex(index: 2),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : Container(),
              (sortedList.length >= 4 && sortedList[3].isNotEmpty)
                  ? Column(
                      children: [
                        Container(
                          height: 10,
                          width: (selectedIndex == row) ? 160 : 140,
                          color: Util().getColorByIndex(index: 3),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : Container(),
              (sortedList.length >= 5 && sortedList[4].isNotEmpty)
                  ? Column(
                      children: [
                        Container(
                          height: 10,
                          width: (selectedIndex == row) ? 160 : 140,
                          color: Util().getColorByIndex(index: 4),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        );
      }),
    );
  }

  Widget _horizontalViewCalendarFront() {
    return Row(
      children: List.generate(5, (index) {
        String date = getDate(index: index, date: now);
        return InkResponse(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            padding: EdgeInsets.all(6),
            width: (selectedIndex == index) ? 102 : 103,
            height: (selectedIndex == index) ? 149 : 131,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: (selectedIndex == index) ? 2 : 1,
                color: (selectedIndex == index)
                    ? Color(0xFF15B85B)
                    : Colors.transparent,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _horizontalViewCalendar() {
    return Row(
      children: List.generate(5, (index) {
        String date = getDate(index: index, date: now);
        return Container(
          padding: EdgeInsets.all(6),
          width: (selectedIndex == index) ? 102 : 103,
          height: (selectedIndex == index) ? 149 : 131,
          decoration: BoxDecoration(
            color: (selectedIndex == index) ? Colors.white : Color(0xFFF3F3F3),
            border: Border.all(
              width: (selectedIndex == index) ? 2 : 1,
              color: (selectedIndex == index)
                  ? Colors.transparent
                  : Color(0xFFD8D8D8),
            ),
          ),
          child: Text(
            '${date}',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w200,
                  fontSize: 15,
                  color: (selectedIndex == index)
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
  FMPlanBloc _fmPlanBloc;

  // List fieldName = [
  //   '필드A',
  //   '필드B',
  //   '필드C',
  // ];

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
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
