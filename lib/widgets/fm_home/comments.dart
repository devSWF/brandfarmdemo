import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/plan/plan_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/fm_home/fm_home_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  FMHomeBloc _fmHomeBloc;
  User noticeUser;
  User planUser;
  User purchaseUser;
  User journalUser;
  User issueUser;
  User commentUser;
  User subCommentUser;

  @override
  void initState() {
    super.initState();
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    _fmHomeBloc.add(GetRecentUpdates());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMHomeBloc, FMHomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.recentUpdateList.isNotEmpty)
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
                          // Column(
                          //   children: List.generate(10, (index) {
                          //     if (state.recentUpdateList[index].notice !=
                          //         null) {
                          //       return _notice(state, index);
                          //     } else if (state.recentUpdateList[index].plan !=
                          //         null) {
                          //       return _plan(state, index);
                          //     } else if (state
                          //             .recentUpdateList[index].purchase !=
                          //         null) {
                          //       // return _purchase(state, index);
                          //       return Container();
                          //     } else if (state
                          //             .recentUpdateList[index].journal !=
                          //         null) {
                          //       return _journal(state, index);
                          //     } else if (state.recentUpdateList[index].issue !=
                          //         null) {
                          //       return _issue(state, index);
                          //       // } else if(state.recentUpdateList[index].comment != null) {
                          //       //   return Container();
                          //       // } else if(state.recentUpdateList[index].subComment != null) {
                          //       //   return Container();
                          //     } else {
                          //       return Container();
                          //     }
                          //   }),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : LinearProgressIndicator();
      },
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

  Future<User> getUserInfo(String uid) async {
    User obj;
    obj = await FMHomeRepository().getDetailUserInfo(uid);
    return obj;
  }

  void setUserInfo(String uid, int from) async {
    User obj;
    obj = await getUserInfo(uid);
    switch (from) {
      case 1:
        {
          setState(() {
            noticeUser = obj;
          });
        }
        break;
      case 2:
        {
          setState(() {
            planUser = obj;
          });
        }
        break;
      case 3:
        {
          setState(() {
            purchaseUser = obj;
          });
        }
        break;
      case 4:
        {
          setState(() {
            journalUser = obj;
          });
        }
        break;
      case 5:
        {
          setState(() {
            issueUser = obj;
          });
        }
        break;
    }
  }

  Widget _notice(FMHomeState state, int index) {
    NotificationNotice obj = state.recentUpdateList[index].notice;
    setUserInfo(obj.uid, 1);
    String date =
        '${obj.postedDate.toDate().year}년 ${obj.postedDate.toDate().month}월 ${obj.postedDate.toDate().day}일';
    return (noticeUser != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 31,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (noticeUser.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(
                                    noticeUser.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${noticeUser.name}',
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
                      Text(
                        '${date}의 기록',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2489FF),
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

  Widget _plan(FMHomeState state, int index) {
    FMPlan obj = state.recentUpdateList[index].plan;
    setUserInfo(obj.uid, 2);
    String date =
        '${obj.postedDate.toDate().year}년 ${obj.postedDate.toDate().month}월 ${obj.postedDate.toDate().day}일';
    return (planUser != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 31,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (planUser.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(
                                planUser.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${planUser.name}',
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
                      Text(
                        '${date}의 기록',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2489FF),
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

  // Widget _purchase(FMHomeState state, int index) {
  //   FMPurchase obj = state.recentUpdateList[index].purchase;
  //   setUserInfo(obj., 3);
  //   String date =
  //       '${obj.postedDate.toDate().year}년 ${obj.postedDate.toDate().month}월 ${obj.postedDate.toDate().day}일';
  //   return (planUser != null)
  //       ? Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               SizedBox(
  //                 width: 31,
  //               ),
  //               Container(
  //                 width: 37,
  //                 height: 37,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: CircleAvatar(
  //                     radius: 19.0,
  //                     backgroundImage: (noticeUser.imgUrl.isEmpty)
  //                         ? AssetImage('assets/profile.png')
  //                         : CachedNetworkImageProvider(
  //                         noticeUser.imgUrl)),
  //               ),
  //               SizedBox(
  //                 width: 8,
  //               ),
  //               Text(
  //                 '${noticeUser.name}',
  //                 style: Theme.of(context).textTheme.bodyText2.copyWith(
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               Text(
  //                 '님이',
  //                 style: Theme.of(context).textTheme.bodyText2.copyWith(
  //                   fontWeight: FontWeight.w400,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 6,
  //               ),
  //               Text(
  //                 '${date}의 기록',
  //                 style: Theme.of(context).textTheme.bodyText2.copyWith(
  //                   fontWeight: FontWeight.w400,
  //                   color: Color(0xFF2489FF),
  //                 ),
  //               ),
  //               Text(
  //                 '에 공지사항을 남겼습니다',
  //                 style: Theme.of(context).textTheme.bodyText2.copyWith(
  //                   fontWeight: FontWeight.w400,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Row(
  //             children: [
  //               Text(
  //                 '${getTime(date: state.recentUpdateList[index].date)}',
  //                 style: Theme.of(context).textTheme.bodyText2.copyWith(
  //                   color: Color(0xFF828282),
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 15,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 18,
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //       Divider(
  //         height: 60,
  //         thickness: 1,
  //         color: Color(0xFFDFDFDF),
  //       ),
  //     ],
  //   )
  //       : CircularProgressIndicator();
  // }

  Widget _journal(FMHomeState state, int index) {
    Journal obj = state.recentUpdateList[index].journal;
    setUserInfo(obj.uid, 4);
    String date =
        '${obj.date.toDate().year}년 ${obj.date.toDate().month}월 ${obj.date.toDate().day}일';
    return (journalUser != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 31,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (journalUser.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(
                                journalUser.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${journalUser.name}',
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
                      Text(
                        '${date}의 기록',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2489FF),
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

  Widget _issue(FMHomeState state, int index) {
    SubJournalIssue obj = state.recentUpdateList[index].issue;
    setUserInfo(obj.uid, 5);
    String date =
        '${obj.date.toDate().year}년 ${obj.date.toDate().month}월 ${obj.date.toDate().day}일';
    return (issueUser != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 31,
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            radius: 19.0,
                            backgroundImage: (issueUser.imgUrl.isEmpty)
                                ? AssetImage('assets/profile.png')
                                : CachedNetworkImageProvider(
                                issueUser.imgUrl)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${issueUser.name}',
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
                      Text(
                        '${date}의 기록',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2489FF),
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
}
