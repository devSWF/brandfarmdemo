import 'package:BrandFarm/blocs/om_home/bloc.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Plan extends StatefulWidget {
  int index;
  OMHomeState state;
  Plan({Key key, this.index, this.state}) : super(key: key);

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  OMHomeBloc _omHomeBloc;

  @override
  void initState() {
    super.initState();
    _omHomeBloc = BlocProvider.of<OMHomeBloc>(context);
    if (!widget.state.recentUpdateList[widget.index].plan.isReadByFM) {
      _omHomeBloc.add(CheckAsRead(index: widget.index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 349,
        width: 452,
        padding: EdgeInsets.fromLTRB(25, 16, 25, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    height: 56,
                    width: 56,
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.lightGreen,
                      size: 56,
                    ))),
            // SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getPeriod(
                      widget
                          .state.recentUpdateList[widget.index].plan.startDate,
                      widget.state.recentUpdateList[widget.index].plan.endDate),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                    width: 30,
                    height: 19,
                    child: FittedBox(
                        child: DepartmentBadge(
                            department: getDepartment(widget.state
                                .recentUpdateList[widget.index].plan.from)))),
                SizedBox(
                  width: 5,
                ),
                Center(
                    child: Text(
                  '${widget.state.recentUpdateList[widget.index].plan.title}',
                  style: Theme.of(context).textTheme.headline5,
                )),
              ],
            ),
            // SizedBox(height: 25,),
            Text(
              '${widget.state.recentUpdateList[widget.index].plan.content}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w300),
            ),
            // SizedBox(height: 19,),
            Text(
              '${getTime(date: widget.state.recentUpdateList[widget.index].plan.postedDate)} - ${from(widget.state.recentUpdateList[widget.index].plan.from)}',
              style: Theme.of(context).textTheme.overline.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: Color(0xFF737373)),
            ),
            // SizedBox(height: 32,),
            Center(
              child: Container(
                width: 113,
                height: 41,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6FEA98),
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
            ),
          ],
        ),
      ),
    );
  }

  String getDepartment(int from) {
    return (from == 2) ? 'farm' : 'office';
  }

  String getPeriod(Timestamp sd, Timestamp ed) {
    String startDate = DateFormat("yyyy-MM-dd").format(sd.toDate());
    String endDate = DateFormat("yyyy-MM-dd").format(ed.toDate());

    return '${startDate} ~ ${endDate}';
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

  String from(int num) {
    return (num == 2) ? '농장매니저' : '오피스매니저';
  }
}
