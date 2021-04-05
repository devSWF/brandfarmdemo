import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/fm_screens/plan/fm_plan_screen.dart';
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
            CalendarBar(),
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
                    return (index == 0)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _commonList(index: index),
                              Divider(
                                height: 24,
                                thickness: 1,
                                color: Color(0x4D000000),
                                endIndent: 24,
                              ),
                              _individualList(index: index),
                              Divider(
                                height: 24,
                                thickness: 1,
                                color: Color(0x4D000000),
                                endIndent: 24,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _individualList(index: index),
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

  Widget _individualList({int index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.zero,
              height: 14,
              width: 10,
              color: Util().getColorByIndex(index: index),
              child: Center(
                child: Text(
                  '${cat[index]}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 11,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(list.length, (indexx) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${list[indexx]}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Util().getColorByIndex(index: index),
                      ),
                ),
              ],
            );
          }),
        )
      ],
    );
  }

  Widget _commonList({int index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.zero,
              height: 28,
              width: 10,
              color: Util().getColorByIndex(index: 100),
              child: Center(
                child: Text(
                  '공통',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 11,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(list.length, (indexx) {
            return Column(
              children: [
                Text(
                  '${list[indexx]}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Util().getColorByIndex(index: 100),
                      ),
                ),
              ],
            );
          }),
        )
      ],
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
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldList(),
        SizedBox(
          width: 5,
        ),
        Stack(
          children: [
            HorizontalViewCalendar(),
            Positioned(
              left: 6,
              right: 211,
              top: 43,
              child: Container(
                height: 10,
                width: 293,
                color: Color(0xFF15B85B),
                child: FittedBox(
                  child: Text(
                    '씨뿌리기',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 211,
              right: 6,
              top: 58,
              child: Container(
                height: 10,
                color: Color(0xFFF7685B),
                child: FittedBox(
                  child: Text(
                    '씨뿌리기',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 6,
              right: 6,
              top: 73,
              child: Container(
                height: 10,
                color: Color(0xFFA532CD),
                child: FittedBox(
                  child: Text(
                    '덩굴채찍',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 108,
              right: 6,
              top: 88,
              child: Container(
                height: 10,
                color: Color(0xFFF4C708),
                child: FittedBox(
                  child: Text(
                    '솔라빔',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 221,
              right: 223,
              top: 115,
              child: Container(
                height: 12,
                color: Colors.white,
                child: FittedBox(
                  child: Text(
                    '...그외 4개 일정',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 10,
                          color: Color(0xB3000000),
                        ),
                  ),
                ),
              ),
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
class FieldList extends StatefulWidget {
  @override
  _FieldListState createState() => _FieldListState();
}

class _FieldListState extends State<FieldList> {
  List fieldName = [
    '필드A',
    '필드B',
    '필드C',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(fieldName.length, (index) {
        return (index == 0)
            ? Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 14,
                      width: 29,
                      child: FieldBadge(
                        index: 100,
                        name: '공통',
                      )),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                      height: 14,
                      width: 29,
                      child: FieldBadge(
                        index: index,
                        name: fieldName[index],
                      )),
                  SizedBox(
                    height: 6,
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                      height: 14,
                      width: 29,
                      child: FieldBadge(
                        index: index,
                        name: fieldName[index],
                      )),
                  SizedBox(
                    height: 6,
                  ),
                ],
              );
      }),
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
class HorizontalViewCalendar extends StatefulWidget {
  @override
  _HorizontalViewCalendarState createState() => _HorizontalViewCalendarState();
}

class _HorizontalViewCalendarState extends State<HorizontalViewCalendar> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        String date = getDate(index: index, date: now);
        return (index == 2)
            ? Container(
                padding: EdgeInsets.all(6),
                width: 102,
                height: 149,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Color(0xFF15B85B),
                  ),
                ),
                child: Text(
                  '${date}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w200,
                        fontSize: 15,
                        color: Color(0xFF15B85B),
                      ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(6),
                width: 103,
                height: 131,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFD8D8D8),
                  ),
                ),
                child: Text(
                  '${date}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w200,
                        fontSize: 15,
                        color: Colors.black,
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
class Util {
  Color getColorByIndex({int index}) {
    switch (index) {
      case 0:
        {
          return Color(0xFFF7685B);
        }
        break;
      case 1:
        {
          return Color(0xFFA532CD);
        }
        break;
      case 2:
        {
          return Color(0xFFF4C708);
        }
        break;
      default:
        {
          return Color(0xFF15B85B);
        }
        break;
    }
  }
}
