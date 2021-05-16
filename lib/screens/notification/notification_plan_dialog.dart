import 'package:BrandFarm/blocs/notification/notification_bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_event.dart';
import 'package:BrandFarm/blocs/notification/notification_state.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationPlanDialog extends StatefulWidget {
  final NotificationNotice obj;

  const NotificationPlanDialog({Key key, @required this.obj}) : super(key: key);

  @override
  _NotificationPlanDialogState createState() => _NotificationPlanDialogState();
}

class _NotificationPlanDialogState extends State<NotificationPlanDialog> {
  NotificationBloc _notificationBloc;
  NotificationNotice obj;

  @override
  void initState() {
    super.initState();
    obj = widget.obj;
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    if (!widget.obj.isReadBySFM) {
      _notificationBloc.add(CheckAsRead(obj: obj));
    }
    if (obj != null) {
      _notificationBloc.add(GetPlanNotificationInitials(obj: obj));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.plan == null)
            ? Scaffold(
                backgroundColor: Color(0x4D000000),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                backgroundColor: Color(0xB3000000),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 314,
                        padding: EdgeInsets.fromLTRB(20, 13, 15, 16),
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
                                      state.plan.startDate, state.plan.endDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
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
                                            department: obj.department))),
                                SizedBox(
                                  width: 5,
                                ),
                                Center(
                                    child: Text(
                                  '${state.plan.title}',
                                  style: Theme.of(context).textTheme.headline5,
                                )),
                              ],
                            ),
                            // SizedBox(height: 25,),
                            Text(
                              '${state.plan.content}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.w300),
                            ),
                            // SizedBox(height: 19,),
                            Text(
                              '${getTime(date: obj.postedDate)} - ${from(obj.department)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .overline
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13,
                                      color: Color(0xFF737373)),
                            ),
                            // SizedBox(height: 32,),
                            Center(
                              child: Container(
                                width: 113,
                                height: 41,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Color(0xFF6FEA98),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Text(
                                    '확인',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
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
                    ),
                  ),
                ),
              );
      },
    );
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

  String from(String department) {
    return (department == 'farm') ? '농장매니저' : '오피스매니저';
  }
}
