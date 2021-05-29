import 'package:BrandFarm/blocs/om_home/bloc.dart';
import 'package:BrandFarm/blocs/om_notification/om_notification_bloc.dart';
import 'package:BrandFarm/blocs/om_notification/om_notification_event.dart';
import 'package:BrandFarm/blocs/om_plan/bloc.dart';
import 'package:BrandFarm/empty_screen.dart';
import 'package:BrandFarm/fm_screens/home/fm_logout_screen.dart';
import 'package:BrandFarm/models/om_home/om_home_model.dart';
import 'package:BrandFarm/models/om_notification/om_notification_model.dart';
import 'package:BrandFarm/models/om_plan/om_plan_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/om_screens/om_notification/om_notification_screen.dart';
import 'package:BrandFarm/om_screens/om_plan/om_plan_screen.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:BrandFarm/widgets/om_dashboard/om_dashboard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OMHomeScreen extends StatefulWidget {
  @override
  _OMHomeScreenState createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<OMHomeScreen> {
  OMHomeBloc _omHomeBloc;
  OMPlanBloc _omPlanBloc;
  OMNotificationBloc _omNotificationBloc;

  @override
  void initState() {
    super.initState();
    _omHomeBloc = BlocProvider.of<OMHomeBloc>(context);
    _omPlanBloc = BlocProvider.of<OMPlanBloc>(context);
    _omPlanBloc.add(GetFarmListForOMPlan());
    _omPlanBloc.add(GetPlanList());
    _omNotificationBloc = BlocProvider.of<OMNotificationBloc>(context);
    _omNotificationBloc.add(GetFarmList());
    _omNotificationBloc.add(GetNotificationList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return _webScreen(context: context, theme: theme);
  }

  Widget _webScreen({BuildContext context, ThemeData theme}) {
    return LayoutBuilder(builder: (context, constraints) {
      return BlocConsumer<OMHomeBloc, OMHomeState>(
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
                // body: _small(context: context, theme: theme, state: state),
                body: _small(context: context, theme: theme, state: state),
              );
            }
          });
    });
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
                      // _appBarNotificationIcon(),
                      // SizedBox(
                      //   width: 25,
                      // ),
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
                child: Icon(
                  Icons.notifications_none,
                  size: 28,
                  color: Color(0x80000000),
                ),
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
          child: Text(
            '1',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  Widget _appBarNotification({BuildContext context}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(width: 1, color: Color(0xFFBCBCBC)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFDD015),
          ),
          SizedBox(
            width: 13,
          ),
          Text(
            '날씨가 아직 춥습니다. 매니저분들 모두 농작물 관리에 주의해 주시길 바랍니다',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
          ),
        ],
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
                  fit: BoxFit.fill)),
        ),
      ),
    );
  }

  Widget _small({BuildContext context, ThemeData theme, OMHomeState state}) {
    return Row(
      children: [
        _smallDrawer(context: context, theme: theme, state: state),
        Expanded(
          child: MultiBlocProvider(
            providers: [
              // BlocProvider.value(
              //   value: _fmPurchaseBloc,
              // ),
              BlocProvider.value(
                value: _omPlanBloc,
              ),
              BlocProvider.value(
                value: _omHomeBloc,
              ),
              BlocProvider.value(
                value: _omNotificationBloc,
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

  Widget _big({BuildContext context, ThemeData theme, OMHomeState state}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _drawer(context: context, theme: theme, state: state),
        Expanded(
          child: MultiBlocProvider(
            providers: [
              // BlocProvider.value(
              //   value: _fmPurchaseBloc,
              // ),
              BlocProvider.value(
                value: _omPlanBloc,
              ),
              BlocProvider.value(
                value: _omHomeBloc,
              ),
              BlocProvider.value(
                value: _omNotificationBloc,
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

  Widget _drawer({BuildContext context, ThemeData theme, OMHomeState state}) {
    OMHomeUpdateState isThereNewNotice = _getUpdateState(state, 1);
    OMHomeUpdateState isThereNewPlan = _getUpdateState(state, 2);
    OMHomeUpdateState isThereNewPurchase = _getUpdateState(state, 3);
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
                      _omHomeBloc.add(SetPageIndex(index: 0));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.widgets_outlined,
                        color: (state.pageIndex == 0)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
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
                      _omHomeBloc.add(SetPageIndex(index: 1));
                    });
                  },
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewNotice.state)
                            ? Colors.red
                            : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.view_agenda_outlined,
                        color: (state.pageIndex == 1)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
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
                      SizedBox(
                        width: 20,
                      ),
                      (isThereNewNotice.num > 0)
                          ? Text(
                              '+${isThereNewNotice.num}',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _omHomeBloc.add(SetPageIndex(index: 2));
                    });
                  },
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewNotice.state)
                            ? Colors.red
                            : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: (state.pageIndex == 2)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
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
                      SizedBox(
                        width: 20,
                      ),
                      (isThereNewPlan.num > 0)
                          ? Text(
                              '+${isThereNewPlan.num}',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _omHomeBloc.add(SetPageIndex(index: 3));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewPlan.state)
                            ? Colors.red
                            : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.mail_outline_outlined,
                        color: (state.pageIndex == 3)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        '승인요청',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: (state.pageIndex == 3)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      (isThereNewPlan.num > 0)
                          ? Text(
                              '+${isThereNewPlan.num}',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  onTap: () {
                    setState(() {
                      _omHomeBloc.add(SetPageIndex(index: 4));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.person_outline,
                        color: (state.pageIndex == 4)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        '연락처',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: (state.pageIndex == 4)
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
                      _omHomeBloc.add(SetPageIndex(index: 5));
                      _omHomeBloc.add(SetSubPageIndex(index: 1));
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: (isThereNewPurchase.state)
                            ? Colors.red
                            : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.chat_bubble_outline,
                        color: (state.pageIndex == 5)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        '구매요청',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: (state.pageIndex == 5)
                                  ? Color(0xFF15B85B)
                                  : Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      (isThereNewPurchase.num > 0)
                          ? Text(
                              '+${isThereNewPurchase.num}',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                (state.pageIndex == 5)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                _omHomeBloc.add(SetPageIndex(index: 5));
                                _omHomeBloc.add(SetSubPageIndex(index: 1));
                              });
                            },
                            title: Row(
                              children: [
                                SizedBox(
                                  width: 76,
                                ),
                                Text(
                                  '구매목록',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
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
                                _omHomeBloc.add(SetPageIndex(index: 5));
                                _omHomeBloc.add(SetSubPageIndex(index: 2));
                              });
                            },
                            title: Row(
                              children: [
                                SizedBox(
                                  width: 76,
                                ),
                                Text(
                                  '구매요청하기',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
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
                      )
                    : Container(),
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
                      _omHomeBloc.add(SetPageIndex(index: 6));
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
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.logout,
                        color: (state.pageIndex == 6)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
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

  Widget _smallDrawer(
      {BuildContext context, ThemeData theme, OMHomeState state}) {
    OMHomeUpdateState isThereNewNotice = _getUpdateState(state, 1);
    OMHomeUpdateState isThereNewPlan = _getUpdateState(state, 2);
    OMHomeUpdateState isThereNewPurchase = _getUpdateState(state, 3);
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
                  SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _omHomeBloc.add(SetPageIndex(index: 0));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.widgets_outlined,
                          color: (state.pageIndex == 0)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _omHomeBloc.add(SetPageIndex(index: 1));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: (isThereNewNotice.state)
                              ? Colors.red
                              : Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.view_agenda_outlined,
                          color: (state.pageIndex == 1)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _omHomeBloc.add(SetPageIndex(index: 2));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: (isThereNewPlan.state)
                              ? Colors.red
                              : Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          color: (state.pageIndex == 2)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _omHomeBloc.add(SetPageIndex(index: 3));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.mail_outline_outlined,
                          color: (state.pageIndex == 3)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _omHomeBloc.add(SetPageIndex(index: 4));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.person_outline,
                          color: (state.pageIndex == 4)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _omHomeBloc.add(SetPageIndex(index: 5));
                      _omHomeBloc.add(SetSubPageIndex(index: 1));
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: (isThereNewPurchase.state)
                              ? Colors.red
                              : Colors.transparent,
                          size: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.chat_bubble_outline,
                          color: (state.pageIndex == 5)
                              ? Color(0xFF15B85B)
                              : Colors.black,
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
                              onPressed: () {
                                _omHomeBloc.add(SetPageIndex(index: 5));
                                _omHomeBloc.add(SetSubPageIndex(index: 1));
                              },
                              icon: Icon(
                                Icons.circle,
                                color: (state.pageIndex == 5 &&
                                        state.subPageIndex == 1)
                                    ? Color(0xFF15B85B)
                                    : Colors.black,
                                size: 6,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _omHomeBloc.add(SetPageIndex(index: 5));
                                _omHomeBloc.add(SetSubPageIndex(index: 2));
                              },
                              icon: Icon(
                                Icons.circle,
                                color: (state.pageIndex == 5 &&
                                        state.subPageIndex == 2)
                                    ? Color(0xFF15B85B)
                                    : Colors.black,
                                size: 6,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    height: 50,
                    thickness: 1,
                    color: Color(0x1A000000),
                    // endIndent: defaultPadding,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      _omHomeBloc.add(SetPageIndex(index: 6));
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
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.logout,
                          color: (state.pageIndex == 6)
                              ? Color(0xFF15B85B)
                              : Colors.black,
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

  Future<void> _showLogoutDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FMLogoutScreen();
        });
  }

  OMHomeUpdateState _getUpdateState(OMHomeState state, int from) {
    switch (from) {
      case 1:
        {
          List<OMNotificationNotice> notice = state.notice.where((element) {
            return element.isReadByFM == false;
          }).toList();
          if (notice.length > 0) {
            return OMHomeUpdateState(state: true, num: notice.length);
          } else {
            return OMHomeUpdateState(state: false, num: notice.length);
          }
        }
        break;
      case 2:
        {
          List<OMPlan> plan = state.plan.where((element) {
            return element.isReadByFM == false;
          }).toList();
          if (plan.length > 0) {
            return OMHomeUpdateState(state: true, num: plan.length);
          } else {
            return OMHomeUpdateState(state: false, num: plan.length);
          }
        }
        break;
      case 3:
        {
          List<Purchase> purchase = state.purchase.where((element) {
            return element.isThereUpdates == true;
          }).toList();
          if (purchase.length > 0) {
            return OMHomeUpdateState(state: true, num: purchase.length);
          } else {
            return OMHomeUpdateState(state: false, num: purchase.length);
          }
        }
        break;
      default:
        {
          return OMHomeUpdateState(state: false, num: 0);
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
  // FMPurchaseBloc _fmPurchaseBloc;
  OMPlanBloc _omPlanBloc;
  OMHomeBloc _omHomeBloc;
  OMNotificationBloc _omNotificationBloc;

  @override
  void initState() {
    super.initState();
    // _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    _omPlanBloc = BlocProvider.of<OMPlanBloc>(context);
    _omHomeBloc = BlocProvider.of<OMHomeBloc>(context);
    _omNotificationBloc = BlocProvider.of<OMNotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 1: // 공지사항
        {
          return BlocProvider.value(
            value: _omNotificationBloc,
            child: OMNotificationScreen(),
          ); // 공지사항
        }
        break;
      case 2: // 영농계획
        {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _omPlanBloc,
              ),
              BlocProvider.value(
                value: _omNotificationBloc,
              ),
            ],
            child: OMPlanScreen(),
          );
          // return EmptyScreen();
        }
        break;
      case 3: // 승인요청
        {
          // return BlocProvider<FMContactBloc>(
          //   create: (BuildContext context) => FMContactBloc(),
          //   child: FMContactScreen(),
          // );
          return EmptyScreen();
        }
        break;
      case 4: // 연락처
        {
          // return BlocProvider<FMContactBloc>(
          //   create: (BuildContext context) => FMContactBloc(),
          //   child: FMContactScreen(),
          // );
          return EmptyScreen();
        }
        break;
      case 5: // 구매요청
        {
          if (widget.subIndex == 1) {
            // return BlocProvider.value(
            //   value: _fmPurchaseBloc,
            //   child: FMPurchaseScreen(),
            // );
            return EmptyScreen();
          } else if (widget.subIndex == 2) {
            // return BlocProvider.value(
            //   value: _fmPurchaseBloc,
            //   child: FMRequestPurchaseScreen(),
            // );
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
      default: // DashBoard
        // return EmptyScreen();
        {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _omHomeBloc,
              ),
              BlocProvider.value(
                value: _omNotificationBloc,
              ),
            ],
            child: OMDashboard(),
          );
        }
        break;
    }
  }
}
