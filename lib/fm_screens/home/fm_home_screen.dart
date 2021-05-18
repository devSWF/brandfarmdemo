import 'dart:ui';

import 'package:BrandFarm/blocs/fm_contact/fm_contact_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/blocs/fm_issue/fm_issue_bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_bloc.dart';
import 'package:BrandFarm/blocs/fm_notification/bloc.dart';
import 'package:BrandFarm/blocs/purchase/bloc.dart';
import 'package:BrandFarm/blocs/plan/plan_bloc.dart';
import 'package:BrandFarm/blocs/plan/plan_event.dart';
import 'package:BrandFarm/blocs/purchase/purchase_bloc.dart';
import 'package:BrandFarm/empty_screen.dart';
import 'package:BrandFarm/fm_screens/contact/fm_contact_screen.dart';
import 'package:BrandFarm/fm_screens/home/fm_logout_screen.dart';
import 'package:BrandFarm/fm_screens/journal/fm_journal_screen.dart';
import 'package:BrandFarm/fm_screens/notification/fm_notification_screen.dart';
import 'package:BrandFarm/fm_screens/plan/fm_plan_screen.dart';
import 'package:BrandFarm/fm_screens/purchase/fm_purchase_screen.dart';
import 'package:BrandFarm/fm_screens/purchase/fm_request_purchase_screen.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:BrandFarm/widgets/fm_home/home_body.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FMHomeScreen extends StatefulWidget {
  @override
  _FMHomeScreenState createState() => _FMHomeScreenState();
}

class _FMHomeScreenState extends State<FMHomeScreen> {
  PurchaseBloc _fmPurchaseBloc;
  PlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;
  FMNotificationBloc _fmNotificationBloc;
  bool isVisible;
  bool showDrawer;

  @override
  void initState() {
    super.initState();
    getSettings().then((settings) => print('User granted permission: ${settings.authorizationStatus}'));
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    _fmHomeBloc.add(LoadFMHome());
    _fmHomeBloc.add(SetFcmToken());
    _fmHomeBloc.add(GetFieldListForFMHome());
    _fmHomeBloc.add(GetRecentUpdates());
    _fmPurchaseBloc = BlocProvider.of<PurchaseBloc>(context);
    _fmPurchaseBloc.add(GetFieldListForFMPurchase());
    _fmPlanBloc = BlocProvider.of<PlanBloc>(context);
    _fmPlanBloc.add(GetFieldListForFMPlan());
    _fmPlanBloc.add(GetPlanList());
    _fmPlanBloc.add(GetShortDetailList());
    _fmPlanBloc.add(GetSortedDetailList());
    _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
    _fmNotificationBloc.add(GetFieldList());
    _fmNotificationBloc.add(GetNotificationList());
    isVisible = true;
    showDrawer = true;
  }

  Future<NotificationSettings> getSettings() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // print('User granted permission: ${settings.authorizationStatus}');
    return settings;
  }

  void getMessage() {
    // app이 <foreground>열려있일때 실행
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return _webScreen(context: context, theme: theme);
  }

  Widget _webScreen({BuildContext context, ThemeData theme}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocConsumer<FMHomeBloc, FMHomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (constraints.maxWidth >= 1150) {
              return Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                appBar: _appBar(context: context, constraints: constraints),
                body: _big(context: context, theme: theme, state: state),
              );
            } else {
              return Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                appBar: _appBar(context: context, constraints: constraints),
                body: _small(context: context, theme: theme, state: state),
              );
            }
          },
        );
      },
    );
  }

  Widget _appBar({BuildContext context, BoxConstraints constraints}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        elevation: 1,
        title: Row(
          children: [
            Image.asset('assets/fm_home_logo.png'),
            SizedBox(
              width: 118,
            ),
            (constraints.maxWidth >= 1150)
                ? _appBarNotification(context: context)
                : Container(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      _appBarNotificationIcon(),
                      SizedBox(width: 25,),
                      _appBarProfile(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarNotification({BuildContext context}) {
    return BlocConsumer<FMNotificationBloc, FMNotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
          return (state.notificationList.isNotEmpty)
              ? InkResponse(
                onTap: (){
                  _fmHomeBloc.add(SetPageIndex(index: 1));
                  _fmHomeBloc.add(SetSubPageIndex(index: 1));
                },
                child: Container(
                  height: 28,
                  width: 777,
                  padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(width: 1, color: Color(0xFFBCBCBC)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (state.notificationList[0].type == '중요')
                          ? Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFFDD015),
                              size: 20,)
                          : Image.asset('assets/megaphone.png',
                              scale: 20,),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        '${state.notificationList[0].content}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget _appBarNotificationIcon() {
    return Container(
      height: 50,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: FittedBox(
          child: Stack(
            children: [
              Container(
                // height: 42,
                // width: 42,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications_none, size: 28, color: Color(0x80000000),),
              ),
              Positioned(top: 0, right: 0, child: _notificationBadge()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationBadge() {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          child: Text('1',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
        ),
      ),
    );
  }

  Widget _appBarProfile() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: FittedBox(
        child: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
            image: DecorationImage(
              image: (UserUtil.getUser().imgUrl.length > 0)
                  ? CachedNetworkImageProvider(UserUtil.getUser().imgUrl)
                  : AssetImage('assets/profile.png'),
              fit: BoxFit.fill
            )
          ),
        ),
      ),
    );
  }

  Widget _small({BuildContext context, ThemeData theme, FMHomeState state}) {
    return Row(
      children: [
        _smallDrawer(context: context, theme: theme, state: state),
        Expanded(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _fmPurchaseBloc,
              ),
              BlocProvider.value(
                value: _fmPlanBloc,
              ),
              BlocProvider.value(
                value: _fmHomeBloc,
              ),
              BlocProvider.value(
                value: _fmNotificationBloc,
              ),
            ],
            child: GetPage(
              index: state.pageIndex,
              subIndex: state.subPageIndex,
            ),
          ),
        ),
      ],
    );
  }

  Widget _big({BuildContext context, ThemeData theme, FMHomeState state}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _drawer(context: context, theme: theme, state: state),
        Expanded(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _fmPurchaseBloc,
              ),
              BlocProvider.value(
                value: _fmPlanBloc,
              ),
              BlocProvider.value(
                value: _fmHomeBloc,
              ),
              BlocProvider.value(
                value: _fmNotificationBloc,
              ),
            ],
            child: GetPage(
              index: state.pageIndex,
              subIndex: state.subPageIndex,
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawer({BuildContext context, ThemeData theme, FMHomeState state}) {
    FMHomeUpdateState isThereNewNotice = _getUpdateState(state, 1);
    FMHomeUpdateState isThereNewPlan = _getUpdateState(state, 2);
    FMHomeUpdateState isThereNewPurchase = _getUpdateState(state, 3);
    FMHomeUpdateState isThereNewJournal = _getUpdateState(state, 4);
    FMHomeUpdateState isThereNewIssue = _getUpdateState(state, 5);
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFFEEEEEE),
      ),
      child: Container(
        width: 240,
        child: Drawer(
          elevation: 3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _fmHomeBloc.add(SetPageIndex(index: 0));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.widgets_outlined,
                        color:
                        (state.pageIndex == 0) ? Color(0xFF15B85B) : Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 16,),
                      Text(
                        'Dashboard',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: (state.pageIndex == 0)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _fmHomeBloc.add(SetPageIndex(index: 1));
                    });
                  },
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewNotice.state) ? Colors.red : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.view_agenda_outlined,
                        color:
                        (state.pageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 16,),
                      Text(
                        '공지사항',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: (state.pageIndex == 1)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                        ),
                      ),
                      SizedBox(width: 20,),
                      (isThereNewNotice.num > 0)
                          ? Text('+${isThereNewNotice.num}',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.red,
                          ),) : Container(),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _fmHomeBloc.add(SetPageIndex(index: 2));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewPlan.state) ? Colors.red : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.calendar_today_outlined,
                        color:
                        (state.pageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 16,),
                      Text(
                        '영농계획',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: (state.pageIndex == 2)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                        ),
                      ),
                      SizedBox(width: 20,),
                      (isThereNewPlan.num > 0)
                          ? Text('+${isThereNewPlan.num}',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.red,
                        ),) : Container(),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _fmHomeBloc.add(SetPageIndex(index: 3));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.person_outline,
                        color:
                        (state.pageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 16,),
                      Text(
                        '연락처',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: (state.pageIndex == 3)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _fmHomeBloc.add(SetPageIndex(index: 4));
                      _fmHomeBloc.add(SetSubPageIndex(index: 1));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewPurchase.state) ? Colors.red : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.chat_bubble_outline,
                        color:
                        (state.pageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 16,),
                      Text(
                        '구매요청',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: (state.pageIndex == 4)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                        ),
                      ),
                      SizedBox(width: 20,),
                      (isThereNewPurchase.num > 0)
                          ? Text('+${isThereNewPurchase.num}',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.red,
                        ),) : Container(),
                    ],
                  ),
                ),
                (state.pageIndex == 4) ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _fmHomeBloc.add(SetPageIndex(index: 4));
                          _fmHomeBloc.add(SetSubPageIndex(index: 1));
                        });
                      },
                      title: Row(
                        children: [
                          SizedBox(
                            width: 76,
                          ),
                          Text(
                            '구매목록',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 13,
                              color: (state.pageIndex == 4 &&
                                  state.subPageIndex == 1)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          _fmHomeBloc.add(SetPageIndex(index: 4));
                          _fmHomeBloc.add(SetSubPageIndex(index: 2));
                        });
                      },
                      title: Row(
                        children: [
                          SizedBox(
                            width: 76,
                          ),
                          Text(
                            '구매요청하기',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 13,
                              color: (state.pageIndex == 4 &&
                                  state.subPageIndex == 2)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ) : Container(),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _fmHomeBloc.add(SetPageIndex(index: 5));
                      _fmHomeBloc.add(SetSubPageIndex(index: 1));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewJournal.state || isThereNewIssue.state) ? Colors.red : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.article_outlined,
                        color:
                        (state.pageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 16,),
                      Text(
                        '일지',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: (state.pageIndex == 5)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                        ),
                      ),
                      SizedBox(width: 20,),
                      ((isThereNewJournal.num + isThereNewIssue.num) > 0)
                          ? Text('+${isThereNewJournal.num + isThereNewIssue.num}',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.red,
                        ),) : Container(),
                    ],
                  ),
                ),
                (state.pageIndex == 5) ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _fmHomeBloc.add(SetPageIndex(index: 5));
                          _fmHomeBloc.add(SetSubPageIndex(index: 1));
                        });
                      },
                      title: Row(
                        children: [
                          SizedBox(
                            width: 76,
                          ),
                          Text(
                            '일지목록',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 13,
                              color: (state.pageIndex == 5 &&
                                  state.subPageIndex == 1)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          _fmHomeBloc.add(SetPageIndex(index: 5));
                          _fmHomeBloc.add(SetSubPageIndex(index: 2));
                        });
                      },
                      title: Row(
                        children: [
                          SizedBox(
                            width: 76,
                          ),
                          Text(
                            '보고서 작성',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 13,
                              color: (state.pageIndex == 5 &&
                                  state.subPageIndex == 2)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ) : Container(),
                Divider(
                  height: 50,
                  thickness: 1,
                  color: Color(0x1A000000),
                  endIndent: defaultPadding,
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () async {
                    setState(() {
                      _fmHomeBloc.add(SetPageIndex(index: 6));
                    });
                    await _showLogoutDialog();
                    // BlocProvider.of<AuthenticationBloc>(context).add(
                    //   AuthenticationLoggedOut(),
                    // );
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.logout,
                        color: (state.pageIndex == 6) ? Color(0xFF15B85B) : Colors.black,
                        size: 18,
                      ),
                      SizedBox(width: 16,),
                      Text(
                        '로그아웃',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: (state.pageIndex == 6)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FMLogoutScreen();
        }
    );
  }

  Widget _smallDrawer({BuildContext context, ThemeData theme, FMHomeState state}) {
    FMHomeUpdateState isThereNewNotice = _getUpdateState(state, 1);
    FMHomeUpdateState isThereNewPlan = _getUpdateState(state, 2);
    FMHomeUpdateState isThereNewPurchase = _getUpdateState(state, 3);
    FMHomeUpdateState isThereNewJournal = _getUpdateState(state, 4);
    FMHomeUpdateState isThereNewIssue = _getUpdateState(state, 5);
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFFEEEEEE),
      ),
      child: Container(
        width: 90,
        child: Drawer(
          elevation: 3,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      _fmHomeBloc.add(SetPageIndex(index: 0));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.widgets_outlined,
                          color:
                          (state.pageIndex == 0) ? Color(0xFF15B85B) : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      _fmHomeBloc.add(SetPageIndex(index: 1));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: (isThereNewNotice.state) ? Colors.red : Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.view_agenda_outlined,
                          color:
                          (state.pageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      _fmHomeBloc.add(SetPageIndex(index: 2));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: (isThereNewPlan.state) ? Colors.red : Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.calendar_today_outlined,
                          color:
                          (state.pageIndex == 2) ? Color(0xFF15B85B) : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      _fmHomeBloc.add(SetPageIndex(index: 3));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.person_outline,
                          color:
                          (state.pageIndex == 3) ? Color(0xFF15B85B) : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      _fmHomeBloc.add(SetPageIndex(index: 4));
                      _fmHomeBloc.add(SetSubPageIndex(index: 1));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: (isThereNewPurchase.state) ? Colors.red : Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.chat_bubble_outline,
                          color:
                          (state.pageIndex == 4) ? Color(0xFF15B85B) : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  (state.pageIndex == 4)
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          _fmHomeBloc.add(SetPageIndex(index: 4));
                          _fmHomeBloc.add(SetSubPageIndex(index: 1));
                        },
                        icon: Icon(
                          Icons.circle,
                          color:
                          (state.pageIndex == 4 && state.subPageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                          size: 6,
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          _fmHomeBloc.add(SetPageIndex(index: 4));
                          _fmHomeBloc.add(SetSubPageIndex(index: 2));
                        },
                        icon: Icon(
                          Icons.circle,
                          color:
                          (state.pageIndex == 4 && state.subPageIndex == 2) ? Color(0xFF15B85B) : Colors.black,
                          size: 6,
                        ),
                      ),
                    ],
                  ) : Container(),
                  SizedBox(height: 30,),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      _fmHomeBloc.add(SetPageIndex(index: 5));
                      _fmHomeBloc.add(SetSubPageIndex(index: 1));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: (isThereNewJournal.state || isThereNewIssue.state) ? Colors.red : Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.article_outlined,
                          color:
                          (state.pageIndex == 5) ? Color(0xFF15B85B) : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  (state.pageIndex == 5)
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          _fmHomeBloc.add(SetPageIndex(index: 5));
                          _fmHomeBloc.add(SetSubPageIndex(index: 1));
                        },
                        icon: Icon(
                          Icons.circle,
                          color:
                          (state.pageIndex == 5 && state.subPageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                          size: 6,
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          _fmHomeBloc.add(SetPageIndex(index: 5));
                          _fmHomeBloc.add(SetSubPageIndex(index: 2));
                        },
                        icon: Icon(
                          Icons.circle,
                          color:
                          (state.pageIndex == 5 && state.subPageIndex == 2) ? Color(0xFF15B85B) : Colors.black,
                          size: 6,
                        ),
                      ),
                    ],
                  ) : Container(),
                  Divider(
                    height: 50,
                    thickness: 1,
                    color: Color(0x1A000000),
                    // endIndent: defaultPadding,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      _fmHomeBloc.add(SetPageIndex(index: 6));
                      await _showLogoutDialog();
                      // BlocProvider.of<AuthenticationBloc>(context).add(
                      //   AuthenticationLoggedOut(),
                      // );
                      // Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.logout,
                          color:
                          (state.pageIndex == 6) ? Color(0xFF15B85B) : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FMHomeUpdateState _getUpdateState(FMHomeState state, int from) {
    switch(from) {
      case 1 : {
        List<NotificationNotice> notice = state.notice.where((element) {
          return element.isReadByFM == false;
        }).toList();
        if(notice.length > 0) {
          return FMHomeUpdateState(state: true, num: notice.length);
        } else {
          return FMHomeUpdateState(state: false, num: notice.length);
        }
      } break;
      case 2 : {
        List<Plan> plan = state.plan.where((element) {
          return element.isReadByFM == false;
        }).toList();
        if(plan.length > 0) {
          return FMHomeUpdateState(state: true, num: plan.length);
        } else {
          return FMHomeUpdateState(state: false, num: plan.length);
        }
      } break;
      case 3 : {
        List<Purchase> purchase = state.purchase.where((element) {
          return element.isThereUpdates == true;
        }).toList();
        if(purchase.length > 0) {
          return FMHomeUpdateState(state: true, num: purchase.length);
        } else {
          return FMHomeUpdateState(state: false, num: purchase.length);
        }
      } break;
      case 4 : {
        List<Journal> journal = state.journal.where((element) {
          return element.isReadByFM == false;
        }).toList();
        if(journal.length > 0) {
          return FMHomeUpdateState(state: true, num: journal.length);
        } else {
          return FMHomeUpdateState(state: false, num: journal.length);
        }
      } break;
      case 5 : {
        List<SubJournalIssue> issue = state.issue.where((element) {
          return element.isReadByFM == false;
        }).toList();
        if(issue.length > 0) {
          return FMHomeUpdateState(state: true, num: issue.length);
        } else {
          return FMHomeUpdateState(state: false, num: issue.length);
        }
      } break;
      default : {
        return FMHomeUpdateState(state: false, num: 0);
      }
    }
  }
}

class GetPage extends StatefulWidget {
  final int index;
  final int subIndex;

  GetPage({
    Key key,
    this.index,
    this.subIndex,
  }) : super(key: key);

  @override
  _GetPageState createState() => _GetPageState();
}

class _GetPageState extends State<GetPage> {
  PurchaseBloc _fmPurchaseBloc;
  PlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;
  FMNotificationBloc _fmNotificationBloc;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<PurchaseBloc>(context);
    _fmPlanBloc = BlocProvider.of<PlanBloc>(context);
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 1:
        {
          return BlocProvider.value(
            value: _fmNotificationBloc,
            child: FMNotificationScreen(),
          ); // 공지사항
        }
        break;
      case 2:
        {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _fmPlanBloc,
              ),
              BlocProvider.value(
                value: _fmNotificationBloc,
              ),
            ],
            child: FMPlanScreen(),
          );
        }
        break;
      case 3:
        {
          return BlocProvider<FMContactBloc>(
            create: (BuildContext context) => FMContactBloc(),
            child: FMContactScreen(),
          ); // 연락처
        }
        break;
      case 4:
        {
          if (widget.subIndex == 1) {
            return BlocProvider.value(
              value: _fmPurchaseBloc,
              child: FMPurchaseScreen(),
            );
          } else if (widget.subIndex == 2) {
            return BlocProvider.value(
              value: _fmPurchaseBloc,
              child: FMRequestPurchaseScreen(),
            );
          } else {
            return EmptyScreen();
          }
        }
        break;
      case 5:
        {
          if (widget.subIndex == 1) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<FMJournalBloc>(
                  create: (BuildContext context) => FMJournalBloc(),
                ),
                BlocProvider<FMIssueBloc>(
                  create: (BuildContext context) => FMIssueBloc(),
                ),
                BlocProvider.value(
                    value: _fmNotificationBloc,
                ),
              ],
              child: FMJournalScreen(),
            );
          } else if (widget.subIndex == 2) {
            return EmptyScreen();
          } else {
            return EmptyScreen();
          }
        }
        break;
      // case 6:
      //   {
      //     return EmptyScreen(); // 설정 화면
      //   }
      //   break;
      default:
        {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _fmPlanBloc,
              ),
              BlocProvider.value(
                value: _fmHomeBloc,
              ),
              BlocProvider.value(
                value: _fmNotificationBloc,
              ),
            ],
            child: HomeBody(),
          );
        }
        break;
    }
  }
}
