import 'package:BrandFarm/blocs/comment/bloc.dart';
import 'package:BrandFarm/blocs/comment/comment_bloc.dart';
import 'package:BrandFarm/blocs/journal/bloc.dart';
import 'package:BrandFarm/blocs/journal_create/bloc.dart';
import 'package:BrandFarm/blocs/journal_issue_create/bloc.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_create_screen.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_detail_screen.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_issue_detail_screen.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_issue_create_screen.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/utils/todays_date.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:BrandFarm/widgets/loading/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class JournalListScreen extends StatefulWidget {
  JournalListScreen({Key key}) : super(key: key);

  @override
  _JournalListScreenState createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  List monthPicker = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];

  List yearPicker = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
    '2032',
    '2033',
  ];

  String selectedYear = '2021';
  String selectedMonth = '01';
  bool isDateSelected = false;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  static final _containerHeight = 65.0;

  var _fromTop = 0.0;
  var _allowReverse = true, _allowForward = true;
  var _prevOffset = 0.0;
  var _prevForwardOffset = -_containerHeight;
  var _prevReverseOffset = 0.0;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  JournalBloc _journalBloc;
  bool _isVisible = true;
  int _tab = 0;

  String fieldListOptions = '최신순';
  int order = 1;

  String issueListOptions = '전체';
  int issueState = 1;
  String issueListOrderOptions = '최신순';
  int issueOrder = 1;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ScrollController _scrollController;
  double scrollOffset = 0.0;
  int down = 0;
  int up = 0;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _journalBloc = BlocProvider.of<JournalBloc>(context);
    _journalBloc.add(GetInitialList());

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
      });
      // print('offset = ${_scrollController.offset}');
      _manageFab();
      _listenForScrollPosition();
      _manageTopContainer();
    });
  }

  void _manageFab() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible == true) {
        // print("**** ${_isVisible} up");
        if (this.mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      }
    } else {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isVisible == false) {
          // print("**** ${_isVisible} down");
          if (this.mounted) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    }
  }

  void _listenForScrollPosition() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (this.mounted) {
        if (down > 0) {
          if ((issueState == 1 && _tab == 1) ||
              (isDateSelected == false && _tab == 0)) {
            print('load more');
            _journalBloc.add(WaitForLoadMore());
            _journalBloc.add(LoadMore(tab: _tab));
            setState(() {
              down = 0;
            });
          } else {
            print('전체 보기에서만 가능');
          }
        } else {
          setState(() {
            down = 1;
          });
        }
      } else {
        print('state object is not in the tree');
      }
    }
    // if (_scrollController.offset <=
    //     _scrollController.position.minScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   if (this.mounted) {
    //     if (up > 0) {
    //       if ((issueState == 1 && _tab == 1) ||
    //           (isDateSelected == false && _tab == 0)) {
    //         print('refresh');
    //         _journalBloc.add(LoadJournal());
    //         _journalBloc.add(GetInitialList());
    //         setState(() {
    //           up = 0;
    //         });
    //       } else {
    //         print('전체 보기에서만 가능');
    //       }
    //     } else {
    //       setState(() {
    //         up = 1;
    //       });
    //     }
    //   } else {
    //     print('state object is not in the tree');
    //   }
    // }
    // if (_scrollController.offset >=
    //         _scrollController.position.maxScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   // scroll bottom
    //   if (this.mounted) {
    //     print('reach the bottom');
    //     setState(() {});
    //   } else {
    //     print('load more');
    //   }
    // }
    // if (_scrollController.offset <=
    //         _scrollController.position.minScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   // scroll top
    //
    //   if (this.mounted) {
    //     print('reach the top');
    //     setState(() {});
    //   } else {
    //     print('load previous');
    //   }
    // }
  }

  void _manageTopContainer() {
    double offset = _scrollController.offset;
    var direction = _scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.reverse) {
      _allowForward = true;
      if (_allowReverse) {
        _allowReverse = false;
        _prevOffset = offset;
        _prevForwardOffset = _fromTop;
      }

      var difference = offset - _prevOffset;
      _fromTop = _prevForwardOffset + difference;
      if (_fromTop > 0) _fromTop = -_containerHeight;
      // if (_fromTop < -_containerHeight) _fromTop = 0;
      // print(difference);
      // print('reverse');
    } else if (direction == ScrollDirection.forward) {
      _allowReverse = true;
      if (_allowForward) {
        _allowForward = false;
        _prevOffset = offset;
        _prevReverseOffset = _fromTop;
      }

      var difference = offset - _prevOffset;
      _fromTop = _prevReverseOffset + difference;
      if (_fromTop < -_containerHeight) _fromTop = 0;
      // if (_fromTop > 0) _fromTop = -_containerHeight;
      // print(difference);
      // print('forward');
    }
    // print('start');
    // print(_fromTop);
    // print(offset);
    // print(_prevOffset);
    // print(_prevForwardOffset);
    // print(_prevReverseOffset);
    // print('end');
    setState(
        () {}); // for simplicity I'm calling setState here, you can put bool values to only call setState when there is a genuine change in _fromTop
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        return (state.isLoading)
            ? Loading()
            : DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: _appBar(state: state, context: context),
                  body: TabBarView(
                    children: [
                      (isDateSelected)
                          ? Stack(
                              children: [
                                _listBySelectedDate(
                                    context: context, state: state),
                                Positioned(
                                  top: _fromTop,
                                  left: 0,
                                  right: 0,
                                  child: _optionContainer1(context: context),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                (order == 1)
                                    ? Column(
                                        children: [
                                          Expanded(
                                            child: _listByRecent(
                                                context: context, state: state),
                                          ),
                                          (state.isLoadingToGetMore)
                                              ? Container(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Container(),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Expanded(
                                            child: _listByOldest(
                                                context: context, state: state),
                                          ),
                                          (state.isLoadingToGetMore)
                                              ? Container(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                Positioned(
                                  top: _fromTop,
                                  left: 0,
                                  right: 0,
                                  child: _optionContainer1(context: context),
                                ),
                              ],
                            ),
                      (issueState == 1)
                          ? Stack(
                              children: [
                                (issueOrder == 1)
                                    ? Column(
                                        children: [
                                          Expanded(
                                              child: _issueList(
                                                  context: context,
                                                  state: state)),
                                          (state.isLoadingToGetMore)
                                              ? Container(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Container(),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Expanded(
                                            child: _reverseIssueList(
                                                context: context, state: state),
                                          ),
                                          (state.isLoadingToGetMore)
                                              ? Container(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                Positioned(
                                  top: _fromTop,
                                  left: 0,
                                  right: 0,
                                  child: _optionContainer2(context: context),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                (issueOrder == 1)
                                    ? _issueListByCategory(
                                        context: context, state: state)
                                    : _reverseIssueList(
                                        context: context, state: state),
                                Positioned(
                                  top: _fromTop,
                                  left: 0,
                                  right: 0,
                                  child: _optionContainer2(context: context),
                                ),
                              ],
                            ),
                    ],
                  ),
                  floatingActionButton: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    alignment: _isVisible ? Alignment(0, 1) : Alignment(0, 1.5),
                    child: Wrap(
                      children: [
                        FloatingActionButton.extended(
                          backgroundColor:
                              (_tab == 0) ? Color(0xFF15B833) : Colors.blue,
                          heroTag: 'journal',
                          label: Text(
                            '일지쓰기',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                          ),
                          icon: Image.asset(
                            'assets/Journal/memo.png',
                            height: 24,
                            width: 24,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_tab == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (BuildContext context) =>
                                                JournalCreateBloc(),
                                            child: SubJournalCreateScreen(),
                                          )));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (BuildContext context) =>
                                                JournalIssueCreateBloc(),
                                            child:
                                                SubJournalIssueCreateScreen(),
                                          ))).then((value) {
                                _journalBloc.add(LoadJournal());
                                _journalBloc.add(GetInitialList());
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                ),
              );
      },
    );
  }

  Widget _appBar({JournalState state, BuildContext context}) {
    return AppBar(
      // elevation: 3.0,
      leading: IconButton(
        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
        iconSize: 19.0,
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        '농장기록',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: Container(
          // color: Colors.yellow,
          // margin: EdgeInsets.only(bottom: 2),
          height: 62,
          decoration: BoxDecoration(
            color: Color(0x04000000),
            border: Border(
              top: BorderSide(width: 1, color: Colors.grey),
            ),
          ),
          child: TabBar(
            // indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            onTap: (index) {
              setState(() {
                _tab = index;
              });
            },
            indicator: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 2,
                  color: Color(0xFF15B833),
                ),
              ),
            ),
            // labelColor: Colors.yellow,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.w600),
            labelColor: Color(0xFF15B833),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF15B833),
            tabs: [
              Tab(
                  iconMargin: EdgeInsets.only(bottom: 4),
                  icon: Image.asset(
                    'assets/Journal/sprout.png',
                    width: 28,
                    height: 22,
                    color: (_tab == 0) ? Color(0xFF15B833) : Colors.grey,
                  ),
                  text: '성장기록'),
              Tab(
                  iconMargin: EdgeInsets.only(bottom: 4),
                  icon: Image.asset(
                    'assets/Journal/community.png',
                    width: 28,
                    height: 22,
                    color: (_tab == 1) ? Color(0xFF15B833) : Colors.grey,
                  ),
                  text: '이슈기록'),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBlur({BuildContext context}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 80,
              blurRadius: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionContainer1({BuildContext context}) {
    return Opacity(
      opacity: 1 - (-_fromTop / _containerHeight),
      child: Container(
        padding: EdgeInsets.fromLTRB(26, 0, 16, 0),
        height: _containerHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _showDatePicker(context: context);
              },
              child: Row(
                children: [
                  (isDateSelected)
                      ? Text(
                          '${selectedYear}년 ${selectedMonth}월',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                        )
                      : Text('전체', style: JournalListSearchBarStyle),
                  SizedBox(
                    width: 7,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
            ),
            Container(
              height: 31,
              width: 86,
              child: (isDateSelected)
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isDateSelected = false;
                        });
                      },
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(
                              '전체',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () {
                        _settingModalBottomSheet(context: context);
                      },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(fieldListOptions,
                                style: Theme.of(context).textTheme.bodyText2),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(Icons.keyboard_arrow_down_outlined),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionContainer2({BuildContext context}) {
    return Opacity(
      opacity: 1 - (-_fromTop / _containerHeight),
      child: Container(
        padding: EdgeInsets.fromLTRB(26, 0, 16, 0),
        height: _containerHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _showCategory(context: context);
              },
              child: Row(
                children: [
                  Text(issueListOptions, style: JournalListSearchBarStyle),
                  SizedBox(
                    width: 7,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
            ),
            Container(
              height: 31,
              width: 86,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  _settingModalBottomSheet2(context: context);
                },
                child: FittedBox(
                  child: Row(
                    children: [
                      Text(
                        issueListOrderOptions,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listByRecent({BuildContext context, JournalState state}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: (state.orderByRecent.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    color: Color(0xFFAEAEAE),
                    size: 86,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '기록이 없습니다',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 15,
                          color: Color(0xFFAEAEAE),
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.orderByRecent.length,
              itemBuilder: (context, index) {
                String monthBefore;
                String currentMonth;
                // String monthAfter;
                currentMonth = DateFormat('MM').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .orderByRecent[index].date.microsecondsSinceEpoch));
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 75,
                      ),
                      _firstOfList(
                          currentMonth: currentMonth,
                          state: state,
                          index: index,
                          items: state.orderByRecent),
                    ],
                  );
                } else {
                  monthBefore = DateFormat('MM').format(
                      DateTime.fromMicrosecondsSinceEpoch(state
                          .orderByRecent[index - 1]
                          .date
                          .microsecondsSinceEpoch));

                  // if (index + 1 < state.orderByRecent.length) {
                  //   monthAfter =
                  //       DateFormat('MM').format(state.orderByRecent[index + 1]);
                  // }

                  // if (currentMonth != monthAfter) {
                  //   end = 0;
                  // } else {
                  //   end = 1;
                  // }

                  if (currentMonth != monthBefore) {
                    return _firstOfList(
                        currentMonth: currentMonth,
                        state: state,
                        index: index,
                        items: state.orderByRecent);
                  } else {
                    return _customListTile(
                      date: int.parse(DateFormat('dd').format(
                          DateTime.fromMicrosecondsSinceEpoch(state
                              .orderByRecent[index]
                              .date
                              .microsecondsSinceEpoch))),
                      week: daysOfWeek(
                          index: DateTime.fromMicrosecondsSinceEpoch(state
                                  .orderByRecent[index]
                                  .date
                                  .microsecondsSinceEpoch)
                              .weekday),
                      list: state.orderByRecent,
                      index: index,
                      pic: state.imageList,
                    );
                  }
                }
              },
            ),
    );
  }

  Widget _listByOldest({BuildContext context, JournalState state}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: (state.orderByOldest.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    color: Color(0xFFAEAEAE),
                    size: 86,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '기록이 없습니다',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 15,
                          color: Color(0xFFAEAEAE),
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.orderByOldest.length,
              itemBuilder: (context, index) {
                String monthBefore;
                String currentMonth;
                // String monthAfter;
                currentMonth = DateFormat('MM').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .orderByOldest[index].date.microsecondsSinceEpoch));
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 75,
                      ),
                      _firstOfList(
                          currentMonth: currentMonth,
                          state: state,
                          index: index,
                          items: state.orderByOldest),
                    ],
                  );
                } else {
                  monthBefore = DateFormat('MM').format(
                      DateTime.fromMicrosecondsSinceEpoch(state
                          .orderByOldest[index - 1]
                          .date
                          .microsecondsSinceEpoch));

                  // if (index + 1 < state.orderByOldest.length) {
                  //   monthAfter =
                  //       DateFormat('MM').format(state.orderByOldest[index + 1]);
                  // }

                  // if (currentMonth != monthAfter) {
                  //   end = 0;
                  // } else {
                  //   end = 1;
                  // }

                  if (currentMonth != monthBefore) {
                    return _firstOfList(
                        currentMonth: currentMonth,
                        state: state,
                        index: index,
                        items: state.orderByOldest);
                  } else {
                    return _customListTile(
                      date: int.parse(DateFormat('dd').format(
                          DateTime.fromMicrosecondsSinceEpoch(state
                              .orderByOldest[index]
                              .date
                              .microsecondsSinceEpoch))),
                      week: daysOfWeek(
                          index: DateTime.fromMicrosecondsSinceEpoch(state
                                  .orderByOldest[index]
                                  .date
                                  .microsecondsSinceEpoch)
                              .weekday),
                      list: state.orderByOldest,
                      index: index,
                      pic: state.imageList,
                    );
                  }
                }
              },
            ),
    );
  }

  Widget _listBySelectedDate({BuildContext context, JournalState state}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: (state.listBySelection.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    color: Color(0xFFAEAEAE),
                    size: 86,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '기록이 없습니다',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 15,
                          color: Color(0xFFAEAEAE),
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.listBySelection.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 75,
                      ),
                      _customListTile(
                        date: int.parse(DateFormat('dd').format(
                            DateTime.fromMicrosecondsSinceEpoch(state
                                .listBySelection[index]
                                .date
                                .microsecondsSinceEpoch))),
                        week: daysOfWeek(
                            index: DateTime.fromMicrosecondsSinceEpoch(state
                                    .listBySelection[index]
                                    .date
                                    .microsecondsSinceEpoch)
                                .weekday),
                        list: state.listBySelection,
                        index: index,
                        pic: state.imageList,
                      ),
                    ],
                  );
                } else {
                  return _customListTile(
                    date: int.parse(DateFormat('dd').format(
                        DateTime.fromMicrosecondsSinceEpoch(state
                            .listBySelection[index]
                            .date
                            .microsecondsSinceEpoch))),
                    week: daysOfWeek(
                        index: DateTime.fromMicrosecondsSinceEpoch(state
                                .listBySelection[index]
                                .date
                                .microsecondsSinceEpoch)
                            .weekday),
                    list: state.listBySelection,
                    index: index,
                    pic: state.imageList,
                  );
                }
              },
            ),
    );
  }

  Widget _issueList({BuildContext context, JournalState state}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: (state.issueList.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    color: Color(0xFFAEAEAE),
                    size: 86,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '기록이 없습니다',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 15,
                          color: Color(0xFFAEAEAE),
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.issueList.length,
              itemBuilder: (context, index) {
                String year = DateFormat('yyyy').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        state.issueList[index].date.microsecondsSinceEpoch));
                String month = DateFormat('MM').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        state.issueList[index].date.microsecondsSinceEpoch));
                String day = DateFormat('dd').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        state.issueList[index].date.microsecondsSinceEpoch));
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 85,
                      ),
                      _issueListTile(
                        date: '${year}. ${month}. ${day}',
                        issueState: state.issueList[index].issueState,
                        list: state.issueList,
                        index: index,
                        pic: state.imageList,
                      ),
                    ],
                  );
                } else {
                  return _issueListTile(
                    date: '${year}. ${month}. ${day}',
                    issueState: state.issueList[index].issueState,
                    list: state.issueList,
                    index: index,
                    pic: state.imageList,
                  );
                }
              },
            ),
    );
  }

  Widget _issueListByCategory({BuildContext context, JournalState state}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: (state.issueListByCategorySelection.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    color: Color(0xFFAEAEAE),
                    size: 86,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '기록이 없습니다',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 15,
                          color: Color(0xFFAEAEAE),
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.issueListByCategorySelection.length,
              itemBuilder: (context, index) {
                String year = DateFormat('yyyy').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .issueListByCategorySelection[index]
                        .date
                        .microsecondsSinceEpoch));
                String month = DateFormat('MM').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .issueListByCategorySelection[index]
                        .date
                        .microsecondsSinceEpoch));
                String day = DateFormat('dd').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .issueListByCategorySelection[index]
                        .date
                        .microsecondsSinceEpoch));
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 85,
                      ),
                      _issueListTile(
                        date: '${year}. ${month}. ${day}',
                        issueState: state
                            .issueListByCategorySelection[index].issueState,
                        list: state.issueListByCategorySelection,
                        index: index,
                        pic: state.imageList,
                      ),
                    ],
                  );
                } else {
                  return _issueListTile(
                    date: '${year}. ${month}. ${day}',
                    issueState:
                        state.issueListByCategorySelection[index].issueState,
                    list: state.issueListByCategorySelection,
                    index: index,
                    pic: state.imageList,
                  );
                }
              },
            ),
    );
  }

  Widget _reverseIssueList({BuildContext context, JournalState state}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: (state.reverseIssueList.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    color: Color(0xFFAEAEAE),
                    size: 86,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '기록이 없습니다',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 15,
                          color: Color(0xFFAEAEAE),
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.reverseIssueList.length,
              itemBuilder: (context, index) {
                String year = DateFormat('yyyy').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .reverseIssueList[index].date.microsecondsSinceEpoch));
                String month = DateFormat('MM').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .reverseIssueList[index].date.microsecondsSinceEpoch));
                String day = DateFormat('dd').format(
                    DateTime.fromMicrosecondsSinceEpoch(state
                        .reverseIssueList[index].date.microsecondsSinceEpoch));
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 85,
                      ),
                      _issueListTile(
                        date: '${year}. ${month}. ${day}',
                        issueState: state.reverseIssueList[index].issueState,
                        list: state.reverseIssueList,
                        index: index,
                        pic: state.imageList,
                      ),
                    ],
                  );
                } else {
                  return _issueListTile(
                    date: '${year}. ${month}. ${day}',
                    issueState: state.reverseIssueList[index].issueState,
                    list: state.reverseIssueList,
                    index: index,
                    pic: state.imageList,
                  );
                }
              },
            ),
    );
  }

  String getIssueState({int state}) {
    switch (state) {
      case 1:
        {
          return 'todo';
        }
        break;
      case 2:
        {
          return 'doing';
        }
        break;
      case 3:
        {
          return 'done';
        }
        break;
      default:
        {
          return '--';
        }
        break;
    }
  }

  Widget _issueListTile(
      {String date,
      int issueState,
      List list,
      int index,
      List<ImagePicture> pic}) {
    String _issueState = getIssueState(state: issueState);
    List<ImagePicture> _pic =
        pic.where((element) => element.issid == list[index].issid).toList();
    return Container(
      height: 96,
      child: InkWell(
        onTap: () {
          _journalBloc.add(PassSelectedIssue(issue: list[index]));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: _journalBloc,
                        ),
                        BlocProvider<CommentBloc>(
                          create: (BuildContext context) => CommentBloc()
                            ..add(LoadComment())
                            ..add(GetComment(
                                id: list[index].issid, from: 'issid')),
                        ),
                      ],
                      child: SubJournalIssueDetailScreen(
                        issueListOptions: issueListOptions,
                        issueOrder: issueOrder,
                      ),
                    )),
          );
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: (_pic.isNotEmpty)
                      ? 278
                      : MediaQuery.of(context).size.width - 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DepartmentBadge(department: _issueState),
                          SizedBox(
                            width: 5,
                          ),
                          Text(list[index].title,
                              style: Theme.of(context).textTheme.bodyText1),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '[${list[index].comments}]',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Color(0xFF15B85B),
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        list[index].contents,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w200,
                              color: Color(0x70000000),
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w200,
                              color: Color(0x70000000),
                            ),
                      ),
                    ],
                  ),
                ),
                (_pic.isNotEmpty)
                    ? SizedBox(
                        width: 9,
                      )
                    : Container(),
                (_pic.isNotEmpty)
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            trailingIcon(pic: _pic),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 0,
              thickness: 1,
              // indent: 10,
              // endIndent: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _firstOfList(
      {String currentMonth, JournalState state, int index, List items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _monthWidget(
            month: currentMonth,
            year: DateFormat('yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
                items[index].date.microsecondsSinceEpoch)),
            state: state,
            index: index),
        _customListTile(
          date: int.parse(
            DateFormat('dd').format(DateTime.fromMicrosecondsSinceEpoch(
                items[index].date.microsecondsSinceEpoch)),
          ),
          week: daysOfWeek(
              index: DateTime.fromMicrosecondsSinceEpoch(
                      items[index].date.microsecondsSinceEpoch)
                  .weekday),
          list: items,
          index: index,
          pic: state.imageList,
        ),
      ],
    );
  }

  Widget _monthWidget(
      {String month, String year, JournalState state, int index}) {
    return Container(
      height: 52,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            '${year}년 ${month}월',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }

  Widget _customListTile(
      {int date, String week, List<Journal> list, int index, List pic}) {
    List<ImagePicture> _pic = [];
    if (pic.isNotEmpty) {
      _pic = pic.where((element) => element.jid == list[index].jid).toList();
    }
    return Container(
      child: InkWell(
        onTap: () {
          _journalBloc.add(PassSelectedJournal(journal: list[index]));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: _journalBloc,
                        ),
                        BlocProvider<CommentBloc>(
                          create: (BuildContext context) => CommentBloc()
                            ..add(LoadComment())
                            ..add(GetComment(id: list[index].jid, from: 'jid')),
                          // create: (BuildContext context) => CommentBloc()..add(LoadComment()),
                        ),
                      ],
                      child: SubJournalDetailScreen(),
                    )),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          leadingIcon(date: date, week: week),
                        ],
                      ),
                      SizedBox(
                        width: 19,
                      ),
                      titleNSubtitle(list: list, index: index),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            trailingIcon(pic: _pic),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget leadingIcon({int date, String week}) {
    return Container(
      child: FittedBox(
        child: Column(
          children: [
            Text(
              '$date',
              style: DateIconNumberStyle,
            ),
            Text(
              week,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0x80000000),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleNSubtitle({List<Journal> list, int index}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 192,
            child: Text(
              '${DateFormat('yMMMMd', 'ko').format(list[index].date.toDate())}일의 일지',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            // height: 36,
            width: 192,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${list[index].title}' ?? '--',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Color(0xB3000000),
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    '댓글',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0x4D000000),
                        ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '${list[index].comments}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0x4D000000),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget trailingIcon({List<ImagePicture> pic}) {
    return (pic.isNotEmpty)
        ? Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(pic[0].url),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.srcATop),
              ),
            ),
            child: Center(
              child: Text(
                '+${pic.length}',
                style: Theme.of(context).textTheme.headline3.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.background,
                    ),
              ),
            ),
          )
        : Container();
  }

  void _settingModalBottomSheet({BuildContext context}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return new Wrap(
            children: <Widget>[
              ListTile(
                  leading: Text(
                    '최신순',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 18,
                          fontWeight: (order == 1)
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color:
                              (order == 1) ? Color(0xFF219653) : Colors.black,
                        ),
                  ),
                  title: Text(''),
                  trailing: (order == 1)
                      ? Icon(
                          Icons.check,
                          color:
                              (order == 1) ? Color(0xFF219653) : Colors.black,
                        )
                      : Container(
                          height: 1,
                          width: 1,
                        ),
                  onTap: () => {
                        Navigator.pop(context),
                        setState(() {
                          fieldListOptions = '최신순';
                          order = 1;
                        }),
                      }),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              ListTile(
                leading: Text(
                  '오래된순',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 18,
                        fontWeight:
                            (order == 2) ? FontWeight.w600 : FontWeight.normal,
                        color: (order == 2) ? Color(0xFF219653) : Colors.black,
                      ),
                ),
                title: Text(''),
                trailing: (order == 2)
                    ? Icon(
                        Icons.check,
                        color: (order == 2) ? Color(0xFF219653) : Colors.black,
                      )
                    : Container(
                        height: 1,
                        width: 1,
                      ),
                onTap: () => {
                  Navigator.pop(context),
                  setState(() {
                    fieldListOptions = '오래된순';
                    order = 2;
                  }),
                },
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              SizedBox(
                height: 40,
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
            ],
          );
        });
  }

  void _settingModalBottomSheet2({BuildContext context}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return new Wrap(
            children: <Widget>[
              ListTile(
                  leading: Text(
                    '최신순',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 18,
                          fontWeight: (issueOrder == 1)
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: (issueOrder == 1)
                              ? Color(0xFF219653)
                              : Colors.black,
                        ),
                  ),
                  title: Text(''),
                  trailing: (issueOrder == 1)
                      ? Icon(
                          Icons.check,
                          color: (issueOrder == 1)
                              ? Color(0xFF219653)
                              : Colors.black,
                        )
                      : Container(
                          height: 1,
                          width: 1,
                        ),
                  onTap: () => {
                        Navigator.pop(context),
                        setState(() {
                          issueListOrderOptions = '최신순';
                          issueOrder = 1;
                        }),
                      }),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              ListTile(
                leading: Text(
                  '오래된순',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 18,
                        fontWeight: (issueOrder == 2)
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: (issueOrder == 2)
                            ? Color(0xFF219653)
                            : Colors.black,
                      ),
                ),
                title: Text(''),
                trailing: (issueOrder == 2)
                    ? Icon(
                        Icons.check,
                        color: (issueOrder == 2)
                            ? Color(0xFF219653)
                            : Colors.black,
                      )
                    : Container(
                        height: 1,
                        width: 1,
                      ),
                onTap: () => {
                  Navigator.pop(context),
                  setState(() {
                    issueListOrderOptions = '오래된순';
                    issueOrder = 2;
                  }),
                  _journalBloc.add(GetIssueListByTimeOrder(
                    issueListOption: issueListOptions,
                    issueListOrderOption: issueListOrderOptions,
                  )),
                },
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              SizedBox(
                height: 40,
              ),
            ],
          );
        });
  }

  void _showCategory({BuildContext context}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return new Wrap(
            children: <Widget>[
              ListTile(
                  leading: Text(
                    '전체',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 18,
                          fontWeight: (issueState == 1)
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: (issueState == 1)
                              ? Color(0xFF219653)
                              : Colors.black,
                        ),
                  ),
                  title: Text(''),
                  trailing: (issueState == 1)
                      ? Icon(
                          Icons.check,
                          color: (issueState == 1)
                              ? Color(0xFF219653)
                              : Colors.black,
                        )
                      : Container(
                          height: 1,
                          width: 1,
                        ),
                  onTap: () => {
                        setState(() {
                          issueListOptions = '전체';
                          issueState = 1;
                          issueListOrderOptions = '최신순';
                          issueOrder = 1;
                        }),
                        Navigator.pop(context),
                      }),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              ListTile(
                leading: Text(
                  '예상',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 18,
                        fontWeight: (issueState == 2)
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: (issueState == 2)
                            ? Color(0xFF219653)
                            : Colors.black,
                      ),
                ),
                title: Text(''),
                trailing: (issueState == 2)
                    ? Icon(
                        Icons.check,
                        color: (issueState == 2)
                            ? Color(0xFF219653)
                            : Colors.black,
                      )
                    : Container(
                        height: 1,
                        width: 1,
                      ),
                onTap: () => {
                  setState(() {
                    issueListOptions = '예상';
                    issueState = 2;
                    issueListOrderOptions = '최신순';
                    issueOrder = 1;
                  }),
                  _journalBloc.add(GetIssueListByCategory(issueState: 1)),
                  Navigator.pop(context),
                },
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              ListTile(
                leading: Text(
                  '진행',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 18,
                        fontWeight: (issueState == 3)
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: (issueState == 3)
                            ? Color(0xFF219653)
                            : Colors.black,
                      ),
                ),
                title: Text(''),
                trailing: (issueState == 3)
                    ? Icon(
                        Icons.check,
                        color: (issueState == 3)
                            ? Color(0xFF219653)
                            : Colors.black,
                      )
                    : Container(
                        height: 1,
                        width: 1,
                      ),
                onTap: () => {
                  setState(() {
                    issueListOptions = '진행';
                    issueState = 3;
                    issueListOrderOptions = '최신순';
                    issueOrder = 1;
                  }),
                  _journalBloc.add(GetIssueListByCategory(issueState: 2)),
                  Navigator.pop(context),
                },
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              ListTile(
                leading: Text(
                  '완료',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 18,
                        fontWeight: (issueState == 4)
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: (issueState == 4)
                            ? Color(0xFF219653)
                            : Colors.black,
                      ),
                ),
                title: Text(''),
                trailing: (issueState == 4)
                    ? Icon(
                        Icons.check,
                        color: (issueState == 4)
                            ? Color(0xFF219653)
                            : Colors.black,
                      )
                    : Container(
                        height: 1,
                        width: 1,
                      ),
                onTap: () => {
                  setState(() {
                    issueListOptions = '완료';
                    issueState = 4;
                    issueListOrderOptions = '최신순';
                    issueOrder = 1;
                  }),
                  _journalBloc.add(GetIssueListByCategory(issueState: 3)),
                  Navigator.pop(context),
                },
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: Color(0xFFE0E0E0),
                indent: defaultPadding,
                endIndent: defaultPadding,
              ),
              SizedBox(
                height: 40,
              ),
            ],
          );
        });
  }

  void _showDatePicker({BuildContext context}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 320,
            child: Column(
              children: [
                Container(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '취소',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 20,
                              ),
                        ),
                      ),
                      Text(
                        '날짜별 일지 목록',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          _journalBloc.add(LoadJournal());
                          _journalBloc.add(GetListBySelectedDate(
                              year: selectedYear, month: selectedMonth));
                          setState(() {
                            isDateSelected = true;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          '완료',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 20,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 215,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: CupertinoPicker(
                            scrollController:
                                FixedExtentScrollController(initialItem: 0),
                            itemExtent: 50,
                            backgroundColor: Colors.white,
                            looping: true,
                            useMagnifier: true,
                            magnification: 1.1,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedYear = getYear(index: index);
                              });
                              // print(selectedYear);
                            },
                            children: yearPicker.map((element) {
                              return Center(
                                child: Text(element),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: CupertinoPicker(
                            scrollController:
                                FixedExtentScrollController(initialItem: 0),
                            itemExtent: 50,
                            backgroundColor: Colors.white,
                            looping: true,
                            useMagnifier: true,
                            magnification: 1.1,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedMonth = getMonth(index: index);
                              });
                              // print(selectedMonth);
                            },
                            children: monthPicker.map((element) {
                              return Center(
                                child: Text(element),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          );
        });
  }

  String getYear({int index}) {
    return yearPicker[index];
  }

  String getMonth({int index}) {
    int month = index + 1;
    if (month < 10) {
      return '0' + month.toString();
    } else {
      return month.toString();
    }
  }

// String _weekOfMonth({DateTime date}) {
//   // get today's date
//   var now = date;
//
//   // set it to feb 10th for testing
//   //now = now.add(new Duration(days:7));
//
//   int today = now.weekday;
//
//   // ISO week date weeks start on monday
//   // so correct the day number
//   var dayNr = (today + 6) % 7;
//
//   // ISO 8601 states that week 1 is the week
//   // with the first thursday of that year.
//   // Set the target date to the thursday in the target week
//   var thisMonday = now.subtract(new Duration(days: (dayNr)));
//   var thisThursday = thisMonday.add(new Duration(days: 3));
//
//   // Set the target to the first thursday of the year
//   // First set the target to january first
//   var firstThursday = new DateTime(now.year, DateTime.january, 1);
//
//   if (firstThursday.weekday != (DateTime.thursday)) {
//     firstThursday = new DateTime(now.year, DateTime.january,
//         1 + ((4 - firstThursday.weekday) + 7) % 7);
//   }
//
//   // The weeknumber is the number of weeks between the
//   // first thursday of the year and the thursday in the target week
//   var x = thisThursday.millisecondsSinceEpoch -
//       firstThursday.millisecondsSinceEpoch;
//   var weekNumber = x.ceil() / 604800000; // 604800000 = 7 * 24 * 3600 * 1000
//
//   // print("Todays date: ${now}");
//   // print("Monday of this week: ${thisMonday}");
//   // print("Thursday of this week: ${thisThursday}");
//   // print("First Thursday of this year: ${firstThursday}");
//   // print("This week is week #${weekNumber.ceil()}");
//
//   if (weekNumber.ceil() > 4) {
//     int tmp = weekNumber.ceil() % 4;
//     if (tmp == 0) {
//       return '4';
//     }
//     return '${tmp}';
//   } else {
//     return '${weekNumber.ceil()}';
//   }
//   // return '${weekNumber.ceil()}';
// }
}
