import 'package:BrandFarm/blocs/notification/notification_bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_state.dart';
import 'package:BrandFarm/screens/notification/notification_dialog_screen.dart';
import 'package:BrandFarm/screens/notification/notification_issue_detail.dart';
import 'package:BrandFarm/screens/notification/notification_journal_detail.dart';
import 'package:BrandFarm/screens/notification/notification_plan_dialog.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    // _notificationBloc.add(GetNotificationList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              padding: EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),
              icon: Icon(
                Icons.arrow_back_ios,
                // color: Color(0xFF37949B),
                color: Colors.black,
                size: 29,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text(
              '알림',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              (state.importantList.isNotEmpty)
                  ? Column(
                      children:
                          List.generate(state.importantList.length, (index) {
                        return Column(
                          children: [
                            _fixedCustomListTile(state: state, index: index),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        );
                      }),
                    )
                  : Container(),
              (state.generalList.isNotEmpty)
                  ? Column(
                      children:
                          List.generate(state.generalList.length, (index) {
                        return Column(
                          children: [
                            _customListTile(state: state, index: index),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        );
                      }),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget _fixedCustomListTile({NotificationState state, int index}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFF8DB),
        border: Border(
          top: BorderSide(width: 1, color: Color(0xFFEBEBEB)),
          bottom: BorderSide(width: 1, color: Color(0xFFEBEBEB)),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (context, a1, a2) => BlocProvider.value(
                      value: _notificationBloc,
                      child: NotificationDialogScreen(
                        obj: state.importantList[index],
                      ),
                    ),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
                opaque: false),
          );
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.fromLTRB(12, 13, 13, 0),
              height: 93,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 46,
                            color: Color(0xFFFDD015),
                          )),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 240,
                        child: Row(
                          children: [
                            Container(
                                height: 13,
                                width: 21,
                                child: FittedBox(
                                    child: DepartmentBadge(
                                        department: state
                                            .importantList[index].department))),
                            SizedBox(
                              width: 2,
                            ),
                            Center(
                                child: Text(
                              '${state.importantList[index].title}',
                              // style: Theme.of(context).textTheme.overline.copyWith(fontSize: 15),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        width: 240,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.importantList[index].content}',
                              // style: Theme.of(context).textTheme.overline.copyWith(fontWeight: FontWeight.normal),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 55,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${getTime(date: state.importantList[index].scheduledDate)}',
                              // style: Theme.of(context).textTheme.overline.copyWith(fontWeight: FontWeight.normal),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Color(0xFF737373),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customListTile({NotificationState state, int index}) {
    return Container(
      decoration: BoxDecoration(
        color: (state.generalList[index].isReadBySFM)
            ? Color(0xFFEBEBEB)
            : Colors.white,
        border: Border(
          top: BorderSide(width: 1, color: Color(0xFFEBEBEB)),
          bottom: BorderSide(width: 1, color: Color(0xFFEBEBEB)),
        ),
      ),
      child: InkWell(
        onTap: () {
          if(state.generalList[index].planid.isNotEmpty){
            Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => BlocProvider.value(
                    value: _notificationBloc,
                    child: NotificationPlanDialog(
                      obj: state.generalList[index],
                    ),
                  ),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                  opaque: false),
            );
          } else if(state.generalList[index].jid.isNotEmpty && state.generalList[index].issid.contains('--')){
            Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => BlocProvider.value(
                    value: _notificationBloc,
                    child: NotificationJournalDetail(
                      obj: state.generalList[index],
                    ),
                  ),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                  opaque: false),
            );
          } else if (state.generalList[index].issid.isNotEmpty && state.generalList[index].jid.contains('--')) {
            Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => BlocProvider.value(
                    value: _notificationBloc,
                    child: NotificationIssueDetail(
                      obj: state.generalList[index],
                    ),
                  ),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                  opaque: false),
            );
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => BlocProvider.value(
                    value: _notificationBloc,
                    child: NotificationDialogScreen(
                      obj: state.generalList[index],
                    ),
                  ),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                  opaque: false),
            );
          }
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 13, 13, 0),
              height: 93,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (!state.generalList[index].isReadBySFM)
                          ? Badge(
                              position:
                                  BadgePosition.topStart(top: 0, start: 0),
                              shape: BadgeShape.circle,
                              child: Container(
                                  width: 48,
                                  height: 48,
                                  child: Center(
                                      child: (state.generalList[index].planid
                                              .isNotEmpty)
                                          ? Icon(
                                              Icons.calendar_today,
                                              size: 38,
                                              color: Colors.lightGreen,
                                            )
                                          : (state.generalList[index].issid
                                                      .isNotEmpty ||
                                                  state.generalList[index].jid
                                                      .isNotEmpty)
                                              ? Icon(
                                                  Icons.comment,
                                                  size: 38,
                                                  color: Colors.blue,
                                                )
                                              : Image.asset(
                                                  'assets/megaphone.png',
                                                  width: 38,
                                                  height: 38,
                                                ))),
                              padding: EdgeInsets.all(4.5),
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              child: Center(
                                  child: (state
                                          .generalList[index].planid.isNotEmpty)
                                      ? Icon(
                                          Icons.calendar_today,
                                          size: 38,
                                          color: Colors.lightGreen,
                                        )
                                      : (state.generalList[index].issid
                                                  .isNotEmpty ||
                                              state.generalList[index].jid
                                                  .isNotEmpty)
                                          ? Icon(
                                              Icons.comment,
                                              size: 38,
                                              color: Colors.blue,
                                            )
                                          : Image.asset(
                                              'assets/megaphone.png',
                                              width: 38,
                                              height: 38,
                                            ))),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 240,
                        child: Row(
                          children: [
                            Container(
                                height: 13,
                                width: 21,
                                child: FittedBox(
                                    child: DepartmentBadge(
                                        department: state
                                            .generalList[index].department))),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              '${state.generalList[index].title}',
                              // style: Theme.of(context).textTheme.overline.copyWith(fontSize: 15,),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        // height: 36,
                        width: 240,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.generalList[index].content}',
                              // style: Theme.of(context).textTheme.overline.copyWith(fontWeight: FontWeight.normal),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 55,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${getTime(date: state.generalList[index].scheduledDate)}',
                              // style: Theme.of(context).textTheme.overline.copyWith(fontWeight: FontWeight.normal),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Color(0xFF737373),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
}
