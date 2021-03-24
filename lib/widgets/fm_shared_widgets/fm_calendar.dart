import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMCalendar extends StatefulWidget {
  @override
  _FMCalendarState createState() => _FMCalendarState();
}

class _FMCalendarState extends State<FMCalendar> {
  FMPlanBloc _fmPlanBloc;
  List<Color> colorList = [
    Color(0xFF15B85B),
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];
  DateTime now = DateTime.now();
  List<String> weekDays = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  List<CalendarDate> monthList;
  int year;
  int month;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    monthList = getMonth(date: now);
    year = now.year;
    month = now.month;
    selectedIndex = monthList.indexWhere(
            (element) =>
        element.date == DateTime(now.year, now.month, now.day));
    DateTime today = monthList[selectedIndex].date;
    monthList.removeAt(selectedIndex);
    monthList.insert(
        selectedIndex, CalendarDate(date: today, isSelected: true));
  }

  List<CalendarDate> getMonth({DateTime date}) {
    int daysInCurrentMonth = DateTime(date.year, date.month + 1, 0).day;
    int daysInPrevMonth = DateTime(date.year, date.month, 0).day;

    // 1 means monday; 7 ,means sunday
    int firstWeekDayOfMonth = DateTime(date.year, date.month, 1).weekday;
    int lastWeekDayOfMonth =
        DateTime(date.year, date.month, daysInCurrentMonth).weekday;
    print(
        'firstWeekDayOfMonth: ${firstWeekDayOfMonth} // daysInPrevMonth: ${daysInPrevMonth}');
    print('lastWeekDayOfMonth: ${lastWeekDayOfMonth}');
    print('daysInCurrentMonth: ${daysInCurrentMonth}');

    // get previous month
    List<CalendarDate> prevMonthList;
    if (firstWeekDayOfMonth < 7) {
      List<CalendarDate> prev = List.generate(
          firstWeekDayOfMonth,
              (index) =>
              CalendarDate(
                  date: DateTime(
                      date.year, date.month - 1, daysInPrevMonth - index)));
      prevMonthList = List.from(prev.reversed);
    } else {
      ;
    }
    // get next month
    List<CalendarDate> nextMonthList;
    if (lastWeekDayOfMonth < 7) {
      nextMonthList = List.generate(
          6 - lastWeekDayOfMonth,
              (index) =>
              CalendarDate(
                  date: DateTime(date.year, date.month + 1, index + 1)));
    } else {
      nextMonthList = List.generate(
          6,
              (index) =>
              CalendarDate(
                  date: DateTime(date.year, date.month + 1, index + 1)));
    }
    // get current month
    List<CalendarDate> currMonthList = List.generate(
        daysInCurrentMonth,
            (index) =>
            CalendarDate(date: DateTime(date.year, date.month, index + 1)));
    // get total month list
    List<CalendarDate> monthList;
    if (firstWeekDayOfMonth < 7) {
      monthList = [...prevMonthList, ...currMonthList, ...nextMonthList];
    } else {
      monthList = [...currMonthList, ...nextMonthList];
    }

    return monthList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return _calendarBody(state);
      },
    );
  }

  Widget _calendarBody(FMPlanState state) {
    List<List<FMPlan>> pListByField = sortPlanListByField(state);
    List<List<List<CalendarPlan>>> pListByDate =
    sortPlanListByDate(pListByField);
    List<CalendarPlan> plist = getPlanList(pListByDate);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${year}',
          style: Theme
              .of(context)
              .textTheme
              .bodyText2
              .copyWith(
            color: Color(0xB3000000),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                List<CalendarDate> mList =
                getMonth(date: DateTime(year, month - 1, 1));
                setState(() {
                  monthList = mList;
                  year = DateTime(year, month - 1, 1).year;
                  month = DateTime(year, month - 1, 1).month;
                  selectedIndex = 100;
                });
                print('year: ${year} // month: ${month}');
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF219653),
              ),
            ),
            Text(
              '${month}월',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            IconButton(
              onPressed: () {
                List<CalendarDate> mList =
                getMonth(date: DateTime(year, month + 1, 1));
                setState(() {
                  monthList = mList;
                  year = DateTime(year, month + 1, 1).year;
                  month = DateTime(year, month + 1, 1).month;
                  selectedIndex = 100;
                });
                print('year: ${year} // month: ${month}');
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF219653),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
          List.generate(weekDays.length, (index) => Text(weekDays[index])),
        ),
        SizedBox(
          height: 20,
        ),
        Stack(
          children: [
            _tableBody(state),
            // Positioned(top: 0, right: 0, left: 0, child: _planBody(state, plist)),
          ],
        ),
      ],
    );
  }

  List<List<FMPlan>> sortPlanListByField(FMPlanState state) {
    List<List<FMPlan>> pListOfLists =
    List.generate(state.fieldList.length, (col) {
      List<FMPlan> plist = state.planList.where((element) {
        if (col == 0) {
          return element.farmID == state.farm.farmID && element.fid.isEmpty;
        } else {
          return element.fid == state.fieldList[col].fid;
        }
      }).toList();
      return plist;
    });
    return pListOfLists;
  }

  List<List<List<CalendarPlan>>> sortPlanListByDate(
      List<List<FMPlan>> listByField) {
    List<List<List<CalendarPlan>>> pListByDate =
    List.generate(listByField.length, (col) {
      int length = listByField[col].length;
      List<List<CalendarPlan>> plist = List.generate(length, (row) {
        DateTime startDate = listByField[col][row].startDate.toDate();
        DateTime endDate = listByField[col][row].endDate.toDate();
        int period = endDate
            .difference(startDate)
            .inDays + 1;
        return List.generate(
            period,
                (index) =>
                CalendarPlan(
                  date: DateTime(
                      startDate.year, startDate.month, startDate.day + index),
                  title: listByField[col][row].title,
                  content: listByField[col][row].content,
                  farmID: listByField[col][row].farmID,
                  fid: listByField[col][row].fid,
                  planID: listByField[col][row].planID,
                ));
      });
      return plist;
    });
    // print(pListByDate);
    return pListByDate;
  }

  List<CalendarPlan> getPlanList(List<List<List<CalendarPlan>>> listByDate) {
    List<CalendarPlan> plist = [];
    // List<List<CalendarPlan>> col = [];
    // List<CalendarPlan> row = [];
    for (int a = 0; a < listByDate.length; a++) {
      // col = listByDate[a];
      for (int b = 0; b < listByDate[a].length; b++) {
        // row = col[i];
        for (int c = 0; c < listByDate[a][b].length; c++) {
          if (plist.isEmpty) {
            plist.insert(0, listByDate[a][b][c]);
          } else {
            plist.add(listByDate[a][b][c]);
          }
        }
      }
    }
    // print(plist);
    return plist;
  }

  Widget _tableBody(FMPlanState state) {
    return Table(
      // border: TableBorder.all(width: 1, color: Color(0xFFD8D8D8)),
      children: List.generate(5, (index1) {
        int current = (index1 == 0)
            ? 0
            : (index1 == 1)
            ? 7
            : (index1 == 2)
            ? 14
            : (index1 == 3)
            ? 21
            : 28;
        return TableRow(
          children: List.generate(
            7,
                (index2) =>
                InkResponse(
                  onTap: () {
                    if (selectedIndex == 100) {
                      setState(() {
                        // update selected date
                        CalendarDate curr = CalendarDate(
                          date: monthList[index2 + current].date,
                          isSelected: !monthList[index2 + current].isSelected,
                        );
                        monthList.removeAt(index2 + current);
                        monthList.insert(index2 + current, curr);
                        // update selected index
                        selectedIndex = index2 + current;
                      });
                    } else if (selectedIndex != index2 + current) {
                      // first check current index
                      setState(() {
                        // return previous selectedDate back to before
                        CalendarDate prev = CalendarDate(
                          date: monthList[selectedIndex].date,
                          isSelected: !monthList[selectedIndex].isSelected,
                        );
                        monthList.removeAt(selectedIndex);
                        monthList.insert(selectedIndex, prev);
                        // update selected date
                        CalendarDate curr = CalendarDate(
                          date: monthList[index2 + current].date,
                          isSelected: !monthList[index2 + current].isSelected,
                        );
                        monthList.removeAt(index2 + current);
                        monthList.insert(index2 + current, curr);
                        // update selected index
                        selectedIndex = index2 + current;
                      });
                    }
                  },
                  child: Container(
                    width: 96,
                    height: 71,
                    decoration: BoxDecoration(
                      color: (monthList[index2 + current].date ==
                          DateTime(now.year, now.month, now.day))
                          ? Colors.grey[200]
                          : Colors.white,
                      border: Border.all(
                          width: (monthList[index2 + current].isSelected)
                              ? 2
                              : 1,
                          color: (monthList[index2 + current].isSelected)
                              ? Color(0xFF15B85B)
                              : Color(0xFFD8D8D8)),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 3, 3, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text('${monthList[index2 + current].date.day}'),
                    ),
                  ),
                ),
          ),
        );
      }),
    );
  }

  Widget _planBody(FMPlanState state, List<CalendarPlan> plist) {
    return Table(
      // border: TableBorder.all(width: 1, color: Color(0xFFD8D8D8)),
      children: List.generate(5, (index1) {
        int current = (index1 == 0)
            ? 0
            : (index1 == 1)
            ? 7
            : (index1 == 2)
            ? 14
            : (index1 == 3)
            ? 21
            : 28;
        return TableRow(
          children: List.generate(
            7,
                (index2) {
              int all = plist.indexWhere((element) =>
              element.fid.isEmpty && element.date.isAtSameMomentAs(
                  monthList[index2 + current].date));
              int f1 = plist.indexWhere((element) =>
              element.fid == state.fieldList[1].fid &&
                  element.date.isAtSameMomentAs(
                      monthList[index2 + current].date));
              int f2 = plist.indexWhere((element) =>
              element.fid == state.fieldList[2].fid &&
                  element.date.isAtSameMomentAs(
                      monthList[index2 + current].date));
              // int f3 = plist.indexWhere((element) =>
              // element.fid == state.fieldList[3].fid &&
              //     element.date.isAtSameMomentAs(
              //         monthList[index2 + current].date));
              // int f4 = plist.indexWhere((element) =>
              // element.fid == state.fieldList[4].fid &&
              //     element.date.isAtSameMomentAs(
              //         monthList[index2 + current].date));
              return Container(
                width: 96,
                height: 71,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Column(
                  children: [
                    (state.fieldList.length >= 1) ? Column(
                      children: [
                        (true) ? Container(
                          height: 5,
                          width: 130,
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                        ) : Container(),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ) : Container(),
                    (state.fieldList.length >= 2) ? Column(
                      children: [
                        Container(
                          height: 5,
                          width: 130,
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ) : Container(),
                    (state.fieldList.length >= 3) ? Column(
                      children: [
                        Container(
                          height: 5,
                          width: 130,
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ) : Container(),
                    (state.fieldList.length >= 4) ? Column(
                      children: [
                        Container(
                          height: 5,
                          width: 130,
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ) : Container(),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class CalendarDate {
  DateTime date;
  bool isSelected;

  CalendarDate({
    this.date,
    this.isSelected = false,
  });
}

class CalendarPlan {
  DateTime date;
  String title;
  String content;
  String farmID;
  String fid;
  String planID;

  CalendarPlan({
    this.date,
    this.title,
    this.content,
    this.farmID,
    this.fid,
    this.planID,
  });
}
