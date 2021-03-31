import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_event.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMSmallCalendar extends StatefulWidget {
  final int category;

  FMSmallCalendar({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  _FMSmallCalendarState createState() => _FMSmallCalendarState();
}

class _FMSmallCalendarState extends State<FMSmallCalendar> {
  FMPlanBloc _fmPlanBloc;
  DateTime now = DateTime.now();
  List<String> weekDays = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];
  String title;
  int year;
  int month;
  List<CalendarDate> monthList;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    if (widget.category == 1) {
      title = '시작';
    } else {
      title = '종료';
    }
    monthList = getMonth(date: now);
    year = now.year;
    month = now.month;
    selectedIndex = monthList.indexWhere(
        (element) => element.date == DateTime(now.year, now.month, now.day));
    DateTime today = monthList[selectedIndex].date;
    monthList.removeAt(selectedIndex);
    monthList.insert(
        selectedIndex,
        CalendarDate(
          date: today,
          isSelected: true,
          isPrev: monthList[selectedIndex].isPrev,
          isNext: monthList[selectedIndex].isNext,
        ));
    monthList.forEach((element) {
      print(element.date);
    });
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
          (index) => CalendarDate(
                date: DateTime(
                    date.year, date.month - 1, daysInPrevMonth - index),
                isSelected: false,
                isPrev: true,
                isNext: false,
              ));
      prevMonthList = List.from(prev.reversed);
    } else {
      ;
    }
    // get next month
    List<CalendarDate> nextMonthList;
    if (lastWeekDayOfMonth < 7) {
      nextMonthList = List.generate(
          6 - lastWeekDayOfMonth,
          (index) => CalendarDate(
                date: DateTime(date.year, date.month + 1, index + 1),
                isSelected: false,
                isPrev: false,
                isNext: true,
              ));
    } else {
      nextMonthList = List.generate(
          6,
          (index) => CalendarDate(
                date: DateTime(date.year, date.month + 1, index + 1),
                isSelected: false,
                isPrev: false,
                isNext: true,
              ));
    }
    // get current month
    List<CalendarDate> currMonthList = List.generate(
        daysInCurrentMonth,
        (index) => CalendarDate(
              date: DateTime(date.year, date.month, index + 1),
              isSelected: false,
              isPrev: false,
              isNext: false,
            ));
    // get total month list
    List<CalendarDate> monthList;
    if (firstWeekDayOfMonth < 7) {
      monthList = [...prevMonthList, ...currMonthList, ...nextMonthList];
    } else {
      monthList = [...currMonthList, ...nextMonthList];
    }

    // monthList.forEach((element) {print(element.date);});
    return monthList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 464,
            width: 493,
            padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleBar(),
                Divider(
                  height: 22,
                  thickness: 1,
                  color: Color(0xFFE1E1E1),
                ),
                SizedBox(
                  height: 10,
                ),
                _dateBar(),
                SizedBox(
                  height: 34,
                ),
                _smallCalendar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _titleBar() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            '${title}일 설정',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ))
      ],
    );
  }

  Widget _dateBar() {
    return Container(
      height: 50,
      width: 370,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Column(
            children: [
              Text(
                '${year}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Color(0xB3000000),
                    ),
              ),
              Text(
                '${month}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xFF333333),
                    ),
              ),
            ],
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
    );
  }

  Widget _smallCalendar() {
    return Container(
      height: 270,
      width: 401,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                weekDays.length,
                (index) => Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${weekDays[index]}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 15,
                                color: Color(0xFF219653),
                              ),
                        ),
                      ),
                    )),
          ),
          Column(
            children: List.generate(5, (col) {
              int current = (col == 0)
                  ? 0
                  : (col == 1)
                      ? 7
                      : (col == 2)
                          ? 14
                          : (col == 3)
                              ? 21
                              : 28;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    7,
                    (row) => InkResponse(
                          onDoubleTap: () async {
                            if(widget.category == 1) {
                              _fmPlanBloc.add(SetStartDate(startDate: monthList[row + current].date));
                              Navigator.pop(context);
                              await _showDatePicker(2);
                            } else {
                              _fmPlanBloc.add(SetEndDate(endDate: monthList[row + current].date));
                              Navigator.pop(context);
                            }
                          },
                          onTap: () {
                            if (selectedIndex == 100) {
                              setState(() {
                                // update selected date
                                CalendarDate curr = CalendarDate(
                                  date: monthList[row + current].date,
                                  isSelected:
                                      !monthList[row + current].isSelected,
                                  isPrev: monthList[row + current].isPrev,
                                  isNext: monthList[row + current].isNext,
                                );
                                monthList.removeAt(row + current);
                                monthList.insert(row + current, curr);
                                // update selected index
                                selectedIndex = row + current;
                              });
                            } else if (selectedIndex != row + current) {
                              // first check current index
                              setState(() {
                                // return previous selectedDate back to before
                                CalendarDate prev = CalendarDate(
                                  date: monthList[selectedIndex].date,
                                  isSelected:
                                      !monthList[selectedIndex].isSelected,
                                  isPrev: monthList[selectedIndex].isPrev,
                                  isNext: monthList[selectedIndex].isNext,
                                );
                                monthList.removeAt(selectedIndex);
                                monthList.insert(selectedIndex, prev);
                                // update selected date
                                CalendarDate curr = CalendarDate(
                                  date: monthList[row + current].date,
                                  isSelected:
                                      !monthList[row + current].isSelected,
                                  isPrev: monthList[row + current].isPrev,
                                  isNext: monthList[row + current].isNext,
                                );
                                monthList.removeAt(row + current);
                                monthList.insert(row + current, curr);
                                // update selected index
                                selectedIndex = row + current;
                              });
                            }
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (monthList[row + current].isSelected)
                                  ? Color(0xFF15B85B)
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                '${monthList[row + current].date.day}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color:
                                          ((monthList[row + current].isPrev &&
                                                      !monthList[row + current]
                                                          .isSelected) ||
                                                  (monthList[row + current]
                                                          .isNext &&
                                                      !monthList[row + current]
                                                          .isSelected))
                                              ? Color(0xFFE9E9E9)
                                              : (monthList[row + current]
                                                      .isSelected)
                                                  ? Colors.white
                                                  : Colors.black,
                                    ),
                              ),
                            ),
                          ),
                        )),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<DateTime> _showDatePicker(int category) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmPlanBloc,
            child: FMSmallCalendar(
              category: category,
            ),
          );
        });
  }
}

class CalendarDate {
  DateTime date;
  bool isSelected;
  bool isPrev;
  bool isNext;

  CalendarDate({
    @required this.date,
    @required this.isSelected,
    @required this.isPrev,
    @required this.isNext,
  });
}
