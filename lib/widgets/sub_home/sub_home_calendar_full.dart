import 'package:BrandFarm/blocs/home/bloc.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SubHomeCalendarFull extends StatefulWidget {
  @override
  _SubHomeCalendarFullState createState() => _SubHomeCalendarFullState();
}

class _SubHomeCalendarFullState extends State<SubHomeCalendarFull> {
  HomeBloc _homeBloc;
  DateTime now;
  DateTime fixedNow;
  int currentDay;
  int daysInMonth;
  int daysInPrevMonth;
  int firstWeekDayOfMonth;
  int lastWeekDayOfMonth;
  int prevSelectedIndex;
  String year;
  String month;
  String fixedYear;
  String fixedmonth;
  String selectedDay;
  List<PickDate> monthList = [];
  List<String> weekDay = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  int occurrence = 0;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    now = DateTime.now();
    fixedNow = DateTime(now.year, now.month, now.day);
    currentDay = int.parse(DateFormat('d').format(fixedNow));
    fixedYear = DateFormat('yyyy').format(fixedNow);
    fixedmonth = DateFormat('M').format(fixedNow);
    getMonth(now: now);
    monthList.forEach((month) {
      print('sdfadsfasdfasdflasdkfjalskdjf');
      if (month.date.isAtSameMomentAs(fixedNow)) {
        int index = monthList.indexOf(month);
        PickDate pd = PickDate(
            date: month.date,
            isPicked: !month.isPicked,
          isPrev: month.isPrev,
          isNext: month.isNext,
          isNow: !month.isNow,
        );
        setState(() {
          prevSelectedIndex = index;
          monthList.removeAt(index);
          monthList.insert(index, pd);
          occurrence += 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('닫기',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),),
              ),
              centerTitle: true,
              title: Text('캘린더', style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.black,
              ),),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _year(context: context),
                    _month(context: context),
                    _weekDayName(context: context),
                    _days(context: context),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    plans(context: context, state: state),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }

  Widget _year({BuildContext context}) {
    return Center(
      child: Text(
        year,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(0x70333333),
        ),
      ),
    );
  }

  Widget _month({BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            DateTime date = DateTime(now.year, now.month - 1, 1);
            setState(() {
              now = date;
            });
            print(date);
            getMonth(now: date);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF219653),
            size: 16,
          ),
        ),
        Text(
          '${month}월',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        IconButton(
          onPressed: () {
            DateTime date = DateTime(now.year, now.month + 1, 1);
            setState(() {
              now = date;
            });
            print(date);
            getMonth(now: date);
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF219653),
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _weekDayName({BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        7,
            (index) => Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              weekDay[index],
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(0xFF219653),
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _days({BuildContext context}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              7,
                  (index) => InkWell(
                onTap: () {
                  if (monthList[index].isPicked == false) {
                    pickDate(index: index);
                  }
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: (monthList[index].isPicked)
                        ? Color(0xFF15B85B)
                        : (monthList[index].isNow)
                        ? Colors.grey[200]
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${monthList[index].date.day}',
                      style: TextStyle(
                          color: (monthList[index].isPrev)
                              ? Color(0xFFE9E9E9)
                              : (monthList[index].isPicked)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              )),
        ),
        // SizedBox(
        //   height: defaultPadding,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              7,
                  (index) => InkWell(
                onTap: () {
                  if (monthList[index + 7].isPicked == false) {
                    pickDate(index: index + 7);
                  }
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: (monthList[index + 7].isPicked)
                        ? Color(0xFF15B85B)
                        : (monthList[index + 7].isNow)
                        ? Colors.grey[200]
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(
                        '${monthList[index + 7].date.day}',
                        style: TextStyle(
                            color: (monthList[index + 7].isPicked)
                                ? Colors.white
                                : Colors.black),
                      )),
                ),
              )),
        ),
        // SizedBox(
        //   height: defaultPadding,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              7,
                  (index) => InkWell(
                onTap: () {
                  if (monthList[index + 14].isPicked == false) {
                    pickDate(index: index + 14);
                  }
                },
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: (monthList[index + 14].isPicked)
                          ? Color(0xFF15B85B)
                          : (monthList[index + 14].isNow)
                          ? Colors.grey[200]
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text(
                          '${monthList[index + 14].date.day}',
                          style: TextStyle(
                              color: (monthList[index + 14].isPicked)
                                  ? Colors.white
                                  : Colors.black),
                        ))),
              )),
        ),
        // SizedBox(
        //   height: defaultPadding,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              7,
                  (index) => InkWell(
                onTap: () {
                  if (monthList[index + 21].isPicked == false) {
                    pickDate(index: index + 21);
                  }
                },
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: (monthList[index + 21].isPicked)
                          ? Color(0xFF15B85B)
                          : (monthList[index + 21].isNow)
                          ? Colors.grey[200]
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text(
                          '${monthList[index + 21].date.day}',
                          style: TextStyle(
                              color: (monthList[index + 21].isPicked)
                                  ? Colors.white
                                  : Colors.black),
                        ))),
              )),
        ),
        // SizedBox(
        //   height: defaultPadding,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              7,
                  (index) => InkWell(
                onTap: () {
                  if (monthList[index + 28].isPicked == false) {
                    pickDate(index: index + 28);
                  }
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: (monthList[index + 28].isPicked)
                        ? Color(0xFF15B85B)
                        : (monthList[index + 28].isNext)
                        ? Colors.white
                        : (monthList[index + 28].isNow)
                        ? Colors.grey[200]
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${monthList[index + 28].date.day}',
                      style: TextStyle(
                          color: (monthList[index + 28].isNext)
                              ? Color(0xFFE9E9E9)
                              : (monthList[index + 28].isPicked)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget plans({BuildContext context, HomeState state}) {
    DateTime selectedDate;
    for(int i=0; i<monthList.length; i++ ){
      if(monthList[i].isPicked){
        selectedDate = monthList[i].date;
        break;
      }
    };
    List<CalendarPlan> plist = state.planList.where((element) {
      return element.date.isAtSameMomentAs(selectedDate ?? DateTime.now());
    }).toList();
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: true,
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '일정',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 3,),
          Text(
            '${plist.length}',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF15B85B)),
          ),
        ],
      ),
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2.5,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: plist.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(11, 8, 6, 11),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(plist[index].content,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black,
                      ),),
                  ),
                  // (index != testPlans.length - 1)
                  //     ? SizedBox(height: 3,) : SizedBox(height: defaultPadding,),
                  SizedBox(height: 3,),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void pickDate({int index}) {
    PickDate prev;
    if (prevSelectedIndex != null) {
      prev = PickDate(
          date: monthList[prevSelectedIndex].date,
          isPicked: !monthList[prevSelectedIndex].isPicked,
        isPrev: monthList[prevSelectedIndex].isPrev,
        isNext: monthList[prevSelectedIndex].isNext,
        isNow: monthList[prevSelectedIndex].isNow,
      );
    }
    PickDate update = PickDate(
        date: monthList[index].date,
        isPicked: !monthList[index].isPicked,
      isPrev: monthList[index].isPrev,
      isNext: monthList[index].isNext,
      isNow: monthList[index].isNow,
    );
    setState(() {
      // prev
      if (prevSelectedIndex != null) {
        monthList.removeAt(prevSelectedIndex);
        monthList.insert(prevSelectedIndex, prev);
      }
      // update
      monthList.removeAt(index);
      monthList.insert(index, update);
      prevSelectedIndex = index;
    });
  }

  void getMonth({DateTime now}) {
    setState(() {
      prevSelectedIndex = null;
      monthList = [];
      daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      // 1 means monday; 7 ,means sunday
      firstWeekDayOfMonth = DateTime(now.year, now.month, 1).weekday;
      lastWeekDayOfMonth = DateTime(now.year, now.month, daysInMonth).weekday;
      year = DateFormat('yyyy').format(now);
      month = DateFormat('M').format(now);
      if (firstWeekDayOfMonth < 7) {
        daysInPrevMonth = DateTime(now.year, now.month, 0).day;
        for (int i = firstWeekDayOfMonth - 1; i >= 0; i--) {
          if (monthList.isEmpty) {
            monthList.insert(
                0, PickDate(
              date: DateTime(now.year, now.month - 1, daysInPrevMonth - i),
              isPicked: false,
              isPrev: true,
              isNext: false,
              isNow: false,));
          } else {
            monthList.add(PickDate(
              date: DateTime(now.year, now.month - 1, daysInPrevMonth - i),
              isPicked: false,
              isPrev: true,
              isNext: false,
              isNow: false,));
          }
        }
      }
      for (int i = 1; i <= daysInMonth; i++) {
        monthList.add(PickDate(
            date: DateTime(now.year, now.month, i),
            isPicked: false,
          isPrev: false,
          isNext: false,
          isNow: false,
        ));
      }
      if (lastWeekDayOfMonth < 6) {
        for (int i = 1; i < 6; i++) {
          monthList.add(
              PickDate(
                date: DateTime(now.year, now.month, i),
                isPicked: false,
                isPrev: false,
                isNext: true,
                isNow: false,
              )
          );
        }
      }
      if (lastWeekDayOfMonth > 6) {
        for (int i = 1; i < 7; i++) {
          monthList.add(PickDate(
            date: DateTime(now.year, now.month, i),
            isPicked: false,
            isPrev: false,
            isNext: true,
            isNow: false,
          ));
        }
      }
    });
  }
}

class PickDate {
  final DateTime date;
  final bool isPicked;
  final bool isPrev;
  final bool isNext;
  final bool isNow;

  PickDate({
    this.date,
    this.isPicked,
    this.isPrev,
    this.isNext,
    this.isNow,
  });
}
