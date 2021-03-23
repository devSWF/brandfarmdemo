import 'package:flutter/material.dart';

class FMSmallCalendar extends StatefulWidget {
  int category;

  FMSmallCalendar({Key key, this.category}) : super(key: key);

  @override
  _FMSmallCalendarState createState() => _FMSmallCalendarState();
}

class _FMSmallCalendarState extends State<FMSmallCalendar> {
  String title;
  int year;
  int month;

  @override
  void initState() {
    super.initState();
    if (widget.category == 1) {
      title = '시작';
    } else {
      title = '종료';
    }
    year = DateTime.now().year;
    month = DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 454,
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
            onPressed: () {},
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
            onPressed: () {},
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
    );
  }
}
