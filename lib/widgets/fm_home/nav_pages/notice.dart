import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Notice extends StatefulWidget {
  int index;
  FMHomeState state;
  Notice({Key key, @required this.index, this.state}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  FMHomeBloc _fmHomeBloc;

  @override
  void initState() {
    super.initState();
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    if (!widget.state.recentUpdateList[widget.index].issue.isReadByFM) {
      _fmHomeBloc.add(CheckAsRead(index: widget.index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Container(
          height: 349, // 349
          width: 452, // 452
          padding: EdgeInsets.fromLTRB(25, 16, 25, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      height: 56,
                      width: 56,
                      child: (widget.state.recentUpdateList[widget.index].notice.type != '일반')
                          ? Icon(
                        Icons.error_outline_rounded,
                        size: 56,
                        color: Color(0xFFFDD015),
                      )
                          : Image.asset('assets/megaphone.png'))),
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(
                      width: 30,
                      height: 19,
                      child: FittedBox(
                          child:
                          DepartmentBadge(department: widget.state.recentUpdateList[widget.index].notice.department))),
                  SizedBox(
                    width: 5,
                  ),
                  Center(
                      child: Text(
                        '${widget.state.recentUpdateList[widget.index].notice.title}',
                        style: Theme.of(context).textTheme.headline5,
                      )),
                ],
              ),
              SizedBox(height: 25,),
              Text(
                '${widget.state.recentUpdateList[widget.index].notice.content}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 19,),
              Text(
                '${getTime(date: widget.state.recentUpdateList[widget.index].notice.scheduledDate)} - ${from(widget.state.recentUpdateList[widget.index].notice.department)}',
                style: Theme.of(context).textTheme.overline.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: Color(0xFF737373)),
              ),
              SizedBox(height: 32,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 113,
                          height: 41,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF15B85B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: Text(
                              '확인',
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTime({Timestamp date}) {
    DateTime now = DateTime.now();
    DateTime _date =
    DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    int diffDays = now.difference(_date).inDays;
    if (diffDays < 1) {
      int diffHours = now.difference(_date).inHours;
      if (diffHours < 1) {
        int diffMinutes = now.difference(_date).inMinutes;
        if (diffMinutes < 1) {
          int diffSeconds = now.difference(_date).inSeconds;
          return '${diffSeconds}초 전';
        } else {
          return '${diffMinutes}분 전';
        }
      } else {
        return '${diffHours}시간 전';
      }
    } else if (diffDays >= 1 && diffDays <= 365) {
      int monthNow = int.parse(DateFormat('MM').format(now));
      int monthBefore = int.parse(DateFormat('MM').format(
          DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)));
      int diffMonths = monthNow - monthBefore;
      if (diffMonths == 0) {
        return '${diffDays}일 전';
      } else {
        return '${diffMonths}달 전';
      }
    } else {
      double tmp = diffDays / 365;
      int diffYears = tmp.toInt();
      return '${diffYears}년 전';
    }
  }

  String from(String department) {
    return (department == 'farm') ? '농장매니저' : '오피스매니저';
  }
}
