import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:BrandFarm/widgets/fm_home/nav_pages/issue.dart';
import 'package:BrandFarm/widgets/fm_home/nav_pages/journal.dart';
import 'package:BrandFarm/widgets/fm_home/nav_pages/notice.dart';
import 'package:BrandFarm/widgets/fm_home/nav_pages/plan.dart';
import 'package:BrandFarm/widgets/fm_home/nav_pages/purchase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Comments extends StatefulWidget {
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;
  final VoidCallback onPressed3;
  final VoidCallback onPressed4;
  final VoidCallback onPressed5;

  const Comments(
      {Key key,
      this.onPressed1,
      this.onPressed2,
      this.onPressed3,
      this.onPressed4,
      this.onPressed5})
      : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  FMHomeBloc _fmHomeBloc;
  VoidCallback onPressed1;
  VoidCallback onPressed2;
  VoidCallback onPressed3;
  VoidCallback onPressed4;
  VoidCallback onPressed5;

  @override
  void initState() {
    super.initState();
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    onPressed1 = widget.onPressed1;
    onPressed2 = widget.onPressed2;
    onPressed3 = widget.onPressed3;
    onPressed4 = widget.onPressed4;
    onPressed5 = widget.onPressed5;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMHomeBloc, FMHomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.isLoading)
            ? Row(
                children: [
                  Container(
                      width: 814,
                      child: Center(child: CircularProgressIndicator())),
                ],
              )
            : (state.recentUpdateList.isNotEmpty)
                ? Row(
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16, 26, 18, 0),
                          // height: 1000,
                          width: 814,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 31,
                                  ),
                                  Text(
                                    '최근 업데이트',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '+${10}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF15B85B),
                                        ),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 40,
                                thickness: 1,
                                color: Color(0xFFDFDFDF),
                              ),
                              Column(
                                children: List.generate(10, (index) {
                                  if (state.recentUpdateList[index].notice !=
                                      null) {
                                    return _notice(state, index);
                                  } else if (state
                                          .recentUpdateList[index].plan !=
                                      null) {
                                    return _plan(state, index);
                                  } else if (state
                                          .recentUpdateList[index].purchase !=
                                      null) {
                                    return _purchase(state, index);
                                  } else if (state
                                          .recentUpdateList[index].journal !=
                                      null) {
                                    return _journal(state, index);
                                  } else if (state
                                          .recentUpdateList[index].issue !=
                                      null) {
                                    return _issue(state, index);
                                    // } else if(state.recentUpdateList[index].comment != null) {
                                    //   return Container();
                                    // } else if(state.recentUpdateList[index].subComment != null) {
                                    //   return Container();
                                  } else {
                                    return Container();
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : _emptyScreen();
      },
    );
  }

  Widget _emptyScreen() {
    return Row(
      children: [
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 26, 18, 0),
            // height: 1000,
            width: 814,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 31,
                    ),
                    Text(
                      '최근 업데이트',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
                Divider(
                  height: 40,
                  thickness: 1,
                  color: Color(0xFFDFDFDF),
                ),
                Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.category,
                          color: Colors.grey[300],
                          size: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '최신 정보가 없습니다',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[300],
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  Future<void> _showNotificationDialog(FMHomeState state, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmHomeBloc,
            child: Notice(index: index, state: state),
          );
        });
  }

  Widget _notice(FMHomeState state, int index) {
    FMHomeRecentUpdates obj = state.recentUpdateList[index];
    // setUserInfo(obj.user.uid, 1);
    String date =
        '${obj.date.toDate().year}년 ${obj.date.toDate().month}월 ${obj.date.toDate().day}일';
    return (obj.notice != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 31,
                        child: (obj.notice.isReadByFM)
                            ? Text(
                                '확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Color(0xFF15B85B),
                                    ),
                              )
                            : Text(
                                '미확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                              ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (obj.notice.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(
                                    obj.notice.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${obj.notice.name}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        '님이',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      InkResponse(
                        // onTap: onPressed1,
                        onTap: () async {
                          await _showNotificationDialog(state, index);
                        },
                        child: Text(
                          '${date}의 기록',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2489FF),
                              ),
                        ),
                      ),
                      Text(
                        '에 공지사항을 남겼습니다',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${getTime(date: state.recentUpdateList[index].date)}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Color(0xFF828282),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 60,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              ),
            ],
          )
        : CircularProgressIndicator();
  }

  Future<void> _showPlanDialog(FMHomeState state, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmHomeBloc,
            child: Plan(index: index, state: state),
          );
        });
  }

  Widget _plan(FMHomeState state, int index) {
    FMHomeRecentUpdates obj = state.recentUpdateList[index];
    // setUserInfo(obj.user.uid, 2);
    String date =
        '${obj.date.toDate().year}년 ${obj.date.toDate().month}월 ${obj.date.toDate().day}일';
    return (obj.plan != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 31,
                        child: (obj.plan.isReadByFM)
                            ? Text(
                                '확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Color(0xFF15B85B),
                                    ),
                              )
                            : Text(
                                '미확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                              ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (obj.plan.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(obj.plan.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${obj.plan.name}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        '님이',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      InkResponse(
                        // onTap: onPressed2,
                        onTap: () async {
                          await _showPlanDialog(state, index);
                        },
                        child: Text(
                          '${date}의 기록',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2489FF),
                              ),
                        ),
                      ),
                      Text(
                        '에 영농계획을 남겼습니다',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${getTime(date: state.recentUpdateList[index].date)}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Color(0xFF828282),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 60,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              ),
            ],
          )
        : CircularProgressIndicator();
  }

  Future<void> _showPurchaseDialog(FMHomeState state, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmHomeBloc,
            child: Purchase(index: index, state: state),
          );
        });
  }

  Widget _purchase(FMHomeState state, int index) {
    FMHomeRecentUpdates obj = state.recentUpdateList[index];
    // setUserInfo(obj.user.uid, 3);
    String date =
        '${obj.date.toDate().year}년 ${obj.date.toDate().month}월 ${obj.date.toDate().day}일';
    return (obj.purchase != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 31,
                        child: (!obj.purchase.isThereUpdates)
                            ? Text(
                                '확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Color(0xFF15B85B),
                                    ),
                              )
                            : Text(
                                '미확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                              ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (obj.user.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(obj.user.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${obj.user.name}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        '님이',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      InkResponse(
                        // onTap: onPressed3,
                        onTap: () async {
                          await _showPurchaseDialog(state, index);
                        },
                        child: Text(
                          '${date}의 기록',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2489FF),
                              ),
                        ),
                      ),
                      Text(
                        '에 구매요청을 남겼습니다',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${getTime(date: state.recentUpdateList[index].date)}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Color(0xFF828282),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 60,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              ),
            ],
          )
        : CircularProgressIndicator();
  }

  Future<void> _showJournalDialog(FMHomeState state, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmHomeBloc,
            child: Journal(index: index, state: state),
          );
        });
  }

  Widget _journal(FMHomeState state, int index) {
    FMHomeRecentUpdates obj = state.recentUpdateList[index];
    // setUserInfo(obj.user.uid, 4);
    String date =
        '${obj.date.toDate().year}년 ${obj.date.toDate().month}월 ${obj.date.toDate().day}일';
    return (obj.journal != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 31,
                        child: (obj.journal.isReadByFM)
                            ? Text(
                                '확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Color(0xFF15B85B),
                                    ),
                              )
                            : Text(
                                '미확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                              ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (obj.user.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(obj.user.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${obj.user.name}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        '님이',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      InkResponse(
                        onTap: () async {
                          await _showJournalDialog(state, index);
                        },
                        child: Text(
                          '${date}의 기록',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2489FF),
                              ),
                        ),
                      ),
                      Text(
                        '에 성장일지을 남겼습니다',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${getTime(date: state.recentUpdateList[index].date)}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Color(0xFF828282),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 60,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              ),
            ],
          )
        : CircularProgressIndicator();
  }

  Future<void> _showIssueDialog(FMHomeState state, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmHomeBloc,
            child: Issue(state: state, index: index),
          );
        });
  }

  Widget _issue(FMHomeState state, int index) {
    FMHomeRecentUpdates obj = state.recentUpdateList[index];
    // setUserInfo(obj.user.uid, 5);
    String date =
        '${obj.date.toDate().year}년 ${obj.date.toDate().month}월 ${obj.date.toDate().day}일';
    return (obj.issue != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 31,
                        child: (obj.issue.isReadByFM)
                            ? Text(
                                '확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Color(0xFF15B85B),
                                    ),
                              )
                            : Text(
                                '미확인',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                              ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (obj.user.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(obj.user.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${obj.user.name}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        '님이',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      InkResponse(
                        // onTap: onPressed5,
                        onTap: () async {
                          await _showIssueDialog(state, index);
                        },
                        child: Text(
                          '${date}의 기록',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2489FF),
                              ),
                        ),
                      ),
                      Text(
                        '에 이슈일지을 남겼습니다',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${getTime(date: state.recentUpdateList[index].date)}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Color(0xFF828282),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 60,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              ),
            ],
          )
        : CircularProgressIndicator();
  }
}
