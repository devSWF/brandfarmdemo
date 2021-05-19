import 'package:BrandFarm/blocs/om_home/bloc.dart';
import 'package:BrandFarm/empty_screen.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
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

  @override
  void initState() {
    super.initState();
    _omHomeBloc = BlocProvider.of<OMHomeBloc>(context);
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
            if(constraints.maxWidth >= 1150){
              return Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                appBar: _appBar(context: context, constraints: constraints),
                body: _big(context: context, theme: theme, state: state),
              );
            } else{
              return Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                appBar: _appBar(context: context, constraints: constraints),
                // body: _small(context: context, theme: theme, state: state),
                body: _big(context: context, theme: theme, state: state),
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
                      _appBarNotificationIcon(),
                      SizedBox(
                        width: 25,
                      ),
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

  // Widget _small({BuildContext context, ThemeData theme, OMHomeState state}) {
  //   return Row(
  //     children: [
  //       _smallDrawer(context: context, theme: theme, state: state),
  //       Expanded(
  //         child: MultiBlocProvider(
  //           providers: [
  //             BlocProvider.value(
  //               value: _fmPurchaseBloc,
  //             ),
  //             BlocProvider.value(
  //               value: _fmPlanBloc,
  //             ),
  //             BlocProvider.value(
  //               value: _omHomeBloc,
  //             ),
  //             BlocProvider.value(
  //               value: _fmNotificationBloc,
  //             ),
  //           ],
  //           child: GetPage(
  //             index: state.pageIndex,
  //             subIndex: state.subPageIndex,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
              // BlocProvider.value(
              //   value: _fmPlanBloc,
              // ),
              BlocProvider.value(
                value: _omHomeBloc,
              ),
              // BlocProvider.value(
              //   value: _fmNotificationBloc,
              // ),
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
    FMHomeUpdateState isThereNewNotice = FMHomeUpdateState(state: true, num: 1);
    FMHomeUpdateState isThereNewPlan = FMHomeUpdateState(state: true, num: 1);
    FMHomeUpdateState isThereNewPurchase = FMHomeUpdateState(state: true,num: 1);
    FMHomeUpdateState isThereNewJournal = FMHomeUpdateState(state: true,num: 1);
    FMHomeUpdateState isThereNewIssue = FMHomeUpdateState(state: true,num: 1);
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
                        color: (state.pageIndex == 1)
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
                        color: Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.person_outline,
                        color: (state.pageIndex == 1)
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
                      _omHomeBloc.add(SetPageIndex(index: 4));
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
                        color: (state.pageIndex == 1)
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
                          color: (state.pageIndex == 4)
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
                (state.pageIndex == 4)
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _omHomeBloc.add(SetPageIndex(index: 4));
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
                          _omHomeBloc.add(SetPageIndex(index: 4));
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
                )
                    : Container(),
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
                        color:
                        (isThereNewJournal.state || isThereNewIssue.state)
                            ? Colors.red
                            : Colors.transparent,
                        size: 6,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.article_outlined,
                        color: (state.pageIndex == 1)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
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
                      SizedBox(
                        width: 20,
                      ),
                      ((isThereNewJournal.num + isThereNewIssue.num) > 0)
                          ? Text(
                        '+${isThereNewJournal.num + isThereNewIssue.num}',
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
                            '일지목록',
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
                            '보고서 작성',
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
  Future<void> _showLogoutDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EmptyScreen();
        }
    );
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
  // FMPlanBloc _fmPlanBloc;
  OMHomeBloc _omHomeBloc;
  // FMNotificationBloc _fmNotificationBloc;

  @override
  void initState() {
    super.initState();
    // _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    // _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    _omHomeBloc = BlocProvider.of<OMHomeBloc>(context);
    // _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      // case 1:
      //   {
      //     return BlocProvider.value(
      //       value: _fmNotificationBloc,
      //       child: FMNotificationScreen(),
      //     ); // 공지사항
      //   }
      //   break;
      // case 2:
      //   {
      //     return BlocProvider.value(
      //       value: _fmPlanBloc,
      //       child: FMPlanScreen(),
      //     );
      //   }
      //   break;
      // case 3:
      //   {
      //     return BlocProvider<FMContactBloc>(
      //       create: (BuildContext context) => FMContactBloc(),
      //       child: FMContactScreen(),
      //     ); // 연락처
      //   }
      //   break;
      // case 4:
      //   {
      //     if (widget.subIndex == 1) {
      //       return BlocProvider.value(
      //         value: _fmPurchaseBloc,
      //         child: FMPurchaseScreen(),
      //       );
      //     } else if (widget.subIndex == 2) {
      //       return BlocProvider.value(
      //         value: _fmPurchaseBloc,
      //         child: FMRequestPurchaseScreen(),
      //       );
      //     } else {
      //       return EmptyScreen();
      //     }
      //   }
      //   break;
      // case 5:
      //   {
      //     if (widget.subIndex == 1) {
      //       return MultiBlocProvider(
      //         providers: [
      //           BlocProvider<FMJournalBloc>(
      //             create: (BuildContext context) => FMJournalBloc(),
      //           ),
      //           BlocProvider<FMIssueBloc>(
      //             create: (BuildContext context) => FMIssueBloc(),
      //           ),
      //         ],
      //         child: FMJournalScreen(),
      //       );
      //     } else if (widget.subIndex == 2) {
      //       return EmptyScreen();
      //     } else {
      //       return EmptyScreen();
      //     }
      //   }
      //   break;
    // case 6:
    //   {
    //     return EmptyScreen(); // 설정 화면
    //   }
    //   break;
      default:
        return EmptyScreen();
        // {
        //   return MultiBlocProvider(
        //     providers: [
        //       BlocProvider.value(
        //         value: _fmPlanBloc,
        //       ),
        //       BlocProvider.value(
        //         value: _omHomeBloc,
        //       ),
        //       BlocProvider.value(
        //         value: _fmNotificationBloc,
        //       ),
        //     ],
        //     child: HomeBody(),
        //   );
        // }
        break;
    }
  }
}