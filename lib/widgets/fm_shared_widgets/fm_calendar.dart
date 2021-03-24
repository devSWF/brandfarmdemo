import 'package:flutter/material.dart';

class FMCalendar extends StatefulWidget {
  // const FMCalendar({Key key, this.onTap}) : super(key: key);
  //
  // // final GestureTapCallback? onTap;
  // final GestureTapCallback onTap;

  @override
  _FMCalendarState createState() => _FMCalendarState();
}

class _FMCalendarState extends State<FMCalendar> {
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
    monthList = getMonth(date: now);
    year = now.year;
    month = now.month;
    selectedIndex = monthList.indexWhere(
        (element) => element.date == DateTime(now.year, now.month, now.day));
    DateTime today = monthList[selectedIndex].date;
    monthList.removeAt(selectedIndex);
    monthList.insert(selectedIndex,
        CalendarDate(date: today, isSelected: true));
  }

  List<CalendarDate> getMonth({DateTime date}) {
    int daysInCurrentMonth = DateTime(date.year, date.month + 1, 0).day;
    int daysInPrevMonth = DateTime(date.year, date.month, 0).day;

    // 1 means monday; 7 ,means sunday
    int firstWeekDayOfMonth = DateTime(date.year, date.month, 1).weekday;
    int lastWeekDayOfMonth =
        DateTime(date.year, date.month, daysInCurrentMonth).weekday;
    print('firstWeekDayOfMonth: ${firstWeekDayOfMonth} // daysInPrevMonth: ${daysInPrevMonth}');
    print('lastWeekDayOfMonth: ${lastWeekDayOfMonth}');
    print('daysInCurrentMonth: ${daysInCurrentMonth}');

    // get previous month
    List<CalendarDate> prevMonthList;
    if(firstWeekDayOfMonth < 7) {
      List<CalendarDate> prev = List.generate(
          firstWeekDayOfMonth,
          (index) => CalendarDate(
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
          (index) => CalendarDate(
              date: DateTime(date.year, date.month + 1, index + 1)));
    } else {
      nextMonthList = List.generate(
          6,
          (index) => CalendarDate(
              date: DateTime(date.year, date.month + 1, index + 1)));
    }
    // get current month
    List<CalendarDate> currMonthList = List.generate(
        daysInCurrentMonth,
        (index) =>
            CalendarDate(date: DateTime(date.year, date.month, index + 1)));
    // get total month list
    List<CalendarDate> monthList;
    if(firstWeekDayOfMonth < 7){
      monthList = [
        ...prevMonthList,
        ...currMonthList,
        ...nextMonthList
      ];
    } else {
      monthList = [
        ...currMonthList,
        ...nextMonthList
      ];
    }

    return monthList;
  }

  @override
  Widget build(BuildContext context) {
    return _calendarBody();
  }

  Widget _calendarBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${year}',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
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
              style: Theme.of(context).textTheme.bodyText2.copyWith(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              List.generate(weekDays.length, (index) => Text(weekDays[index])),
        ),
        Stack(
          children: [
            Table(
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
                    (index2) => InkResponse(
                      onTap: () {
                        if (selectedIndex == 100) {
                          setState(() {
                            // update selected date
                            CalendarDate curr = CalendarDate(
                              date: monthList[index2 + current].date,
                              isSelected:
                                  !monthList[index2 + current].isSelected,
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
                              isSelected:
                                  !monthList[index2 + current].isSelected,
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
                          child:
                              Text('${monthList[index2 + current].date.day}'),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
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
