import 'dart:ui';

import 'package:BrandFarm/blocs/authentication/bloc.dart';
import 'package:BrandFarm/blocs/fm_contact/fm_contact_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/blocs/fm_issue/fm_issue_bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_event.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_bloc.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_event.dart';
import 'package:BrandFarm/empty_screen.dart';
import 'package:BrandFarm/fm_screens/contact/fm_contact_screen.dart';
import 'package:BrandFarm/fm_screens/journal/fm_journal_screen.dart';
import 'package:BrandFarm/fm_screens/plan/fm_plan_screen.dart';
import 'package:BrandFarm/fm_screens/purchase/fm_purchase_screen.dart';
import 'package:BrandFarm/fm_screens/purchase/fm_request_purchase_screen.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/widgets/fm_home/home_body.dart';
import 'package:BrandFarm/widgets/fm_shared_widgets/fm_expansiontile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMHomeScreen extends StatefulWidget {
  @override
  _FMHomeScreenState createState() => _FMHomeScreenState();
}

class _FMHomeScreenState extends State<FMHomeScreen> {
  FMPurchaseBloc _fmPurchaseBloc;
  FMPlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;
  bool isVisible;
  bool showDrawer;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    _fmPurchaseBloc.add(GetFieldListForFMPurchase());
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    _fmPlanBloc.add(GetFieldListForFMPlan());
    _fmPlanBloc.add(GetPlanList());
    _fmPlanBloc.add(GetShortDetailList());
    _fmPlanBloc.add(GetSortedDetailList());
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    isVisible = true;
    showDrawer = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return _webScreen(context: context, theme: theme);
  }

  Widget _webScreen({BuildContext context, ThemeData theme}) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: _appBar(context: context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocConsumer<FMHomeBloc, FMHomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (constraints.maxWidth >= 1000) {
                return _big(context: context, theme: theme, state: state);
              } else {
                return _small(context: context, theme: theme, state: state);
              }
            },
          );
        },
      ),
    );
  }

  Widget _appBar({BuildContext context}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        elevation: 1,
        title: Center(
          child: Row(
            children: [
              Image.asset('assets/fm_home_logo.png'),
              SizedBox(
                width: 114,
              ),
              _appBarNotification(context: context),
            ],
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

  Widget _small({BuildContext context, ThemeData theme, FMHomeState state}) {
    return Row(
      children: [
        _smallDrawer(context: context, state: state),
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
            ],
            child: GetPage(
              index: state.selectedIndex,
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
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFFEEEEEE),
      ),
      child: Drawer(
        elevation: 3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  setState(() {
                    _fmHomeBloc.add(SetPageIndex(index: 0));
                  });
                },
                leading: Icon(
                  Icons.widgets_outlined,
                  color:
                      (state.pageIndex == 0) ? Color(0xFF15B85B) : Colors.black,
                  size: 18,
                ),
                title: Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: (state.pageIndex == 0)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                      ),
                ),
              ),
              Theme(
                data: theme,
                child: MyExpansionTile(
                  onExpansionChanged: (value) {
                    if (value) {
                      setState(() {
                        _fmHomeBloc.add(SetPageIndex(index: 1));
                        _fmHomeBloc.add(SetSubPageIndex(index: 1));
                      });
                    }
                  },
                  leading: Icon(
                    Icons.view_agenda_outlined,
                    color:
                        (state.pageIndex == 1) ? Color(0xFF15B85B) : Colors.black,
                    size: 18,
                  ),
                  title: Text(
                    '공지사항',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: (state.pageIndex == 1)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                        ),
                  ),
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _fmHomeBloc.add(SetPageIndex(index: 1));
                          _fmHomeBloc.add(SetSubPageIndex(index: 1));
                        });
                      },
                      title: Row(
                        children: [
                          SizedBox(
                            width: 76,
                          ),
                          Text(
                            '테스트',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontSize: 13,
                                  color: (state.pageIndex == 1 &&
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
                          _fmHomeBloc.add(SetPageIndex(index: 1));
                          _fmHomeBloc.add(SetSubPageIndex(index: 2));
                        });
                      },
                      title: Row(
                        children: [
                          SizedBox(
                            width: 76,
                          ),
                          Text(
                            '테스트',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontSize: 13,
                                  color: (state.pageIndex == 1 &&
                                          state.subPageIndex == 2)
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
              ListTile(
                onTap: () {
                  setState(() {
                    _fmHomeBloc.add(SetPageIndex(index: 2));
                  });
                },
                leading: Icon(
                  Icons.calendar_today_outlined,
                  color:
                      (state.pageIndex == 2) ? Color(0xFF15B85B) : Colors.black,
                  size: 18,
                ),
                title: Text(
                  '영농계획',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: (state.pageIndex == 2)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                      ),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    _fmHomeBloc.add(SetPageIndex(index: 3));
                  });
                },
                leading: Icon(
                  Icons.person_outline,
                  color:
                      (state.pageIndex == 3) ? Color(0xFF15B85B) : Colors.black,
                  size: 18,
                ),
                title: Text(
                  '연락처',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: (state.pageIndex == 3)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                      ),
                ),
              ),
              Theme(
                data: theme,
                child: MyExpansionTile(
                  onExpansionChanged: (value) {
                    if (value) {
                      setState(() {
                        _fmHomeBloc.add(SetPageIndex(index: 4));
                        _fmHomeBloc.add(SetSubPageIndex(index: 1));
                      });
                    }
                  },
                  leading: Icon(
                    Icons.chat_bubble_outline,
                    color:
                        (state.pageIndex == 4) ? Color(0xFF15B85B) : Colors.black,
                    size: 18,
                  ),
                  title: Text(
                    '구매요청',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: (state.pageIndex == 4)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                        ),
                  ),
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
                ),
              ),
              Theme(
                data: theme,
                child: MyExpansionTile(
                  onExpansionChanged: (value) {
                    if (value) {
                      setState(() {
                        _fmHomeBloc.add(SetPageIndex(index: 5));
                        _fmHomeBloc.add(SetSubPageIndex(index: 1));
                      });
                    }
                  },
                  leading: Icon(
                    Icons.article_outlined,
                    color:
                        (state.pageIndex == 5) ? Color(0xFF15B85B) : Colors.black,
                    size: 18,
                  ),
                  title: Text(
                    '일지',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: (state.pageIndex == 5)
                              ? Color(0xFF15B85B)
                              : Colors.black,
                        ),
                  ),
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
                ),
              ),
              Divider(
                height: 50,
                thickness: 1,
                color: Color(0x1A000000),
                endIndent: defaultPadding,
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    _fmHomeBloc.add(SetPageIndex(index: 6));
                  });
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    AuthenticationLoggedOut(),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                leading: Icon(
                  Icons.logout,
                  color:
                      (state.pageIndex == 6) ? Color(0xFF15B85B) : Colors.black,
                  size: 18,
                ),
                title: Text(
                  '로그아웃',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: (state.pageIndex == 6)
                            ? Color(0xFF15B85B)
                            : Colors.black,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallDrawer({BuildContext context, FMHomeState state}) {
    return NavigationRail(
      selectedIndex: state.selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _fmHomeBloc.add(SetSelectedIndex(index: index));
        });
      },
      labelType: NavigationRailLabelType.none,
      destinations: [
        NavigationRailDestination(
          icon: Icon(
            Icons.widgets_outlined,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.notification_important_outlined,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('공지사항'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.mail_outline,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('영농계획'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.person_outline,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('연락처'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('구매요청'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.article_outlined,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('필드관리'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.more_horiz,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('설정'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.logout,
            color: Color(0xFFBDBDBD),
            size: 18,
          ),
          label: Text('로그아웃'),
        ),
      ],
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
  FMPurchaseBloc _fmPurchaseBloc;
  FMPlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 1:
        {
          return EmptyScreen(); // 공지사항
        }
        break;
      case 2:
        {
          return BlocProvider.value(
            value: _fmPlanBloc,
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
      case 6:
        {
          return EmptyScreen(); // 설정 화면
        }
        break;
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
            ],
            child: HomeBody(),
          );
        }
        break;
    }
  }
}
