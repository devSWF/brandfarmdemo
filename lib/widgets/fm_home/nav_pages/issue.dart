import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/utils/todays_date.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Issue extends StatefulWidget {
  FMHomeState state;
  int index;

  Issue({
    Key key,
    this.state,
    this.index,
  }) : super(key: key);

  @override
  _IssueState createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  FMHomeBloc _fmHomeBloc;
  TextEditingController _textEditingController;
  TextEditingController _subTextEditingController;
  FocusNode _focusNode;
  FocusNode _subFocusNode;

  bool wroteComments;
  String date;
  String weekday;
  String comment;
  bool repeat;
  bool isComment;
  bool isSubComment;

  @override
  void initState() {
    super.initState();
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    if (!widget.state.recentUpdateList[widget.index].issue.isReadByFM) {
      _fmHomeBloc.add(CheckAsRead(index: widget.index));
    }
    _fmHomeBloc.add(SetField(index: widget.index));
    _fmHomeBloc.add(GetPicture(index: widget.index));
    _fmHomeBloc.add(GetComment(index: widget.index));
    _fmHomeBloc.add(GetSComment(index: widget.index));
    _fmHomeBloc.add(GetUser(index: widget.index));
    _textEditingController = TextEditingController();
    _subTextEditingController = TextEditingController();
    _focusNode = FocusNode();
    _subFocusNode = FocusNode();
    date = getDate(date: widget.state.recentUpdateList[widget.index].date);
    wroteComments = false;
    repeat = true;
    isComment = false;
    isSubComment = false;
  }

  String getDate({Timestamp date}) {
    DateTime dt =
        DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
    setState(() {
      weekday = daysOfWeek(index: dt.weekday);
    });
    return '${dt.year}년 ${dt.month}월 ${dt.day}일';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMHomeBloc, FMHomeState>(
      listener: (context, state) {
        if (repeat && isComment) {
          _fmHomeBloc.add(SendCommentNotice(index: widget.index));
          setState(() {
            repeat = false;
          });
        } else if (repeat && isSubComment) {
          _fmHomeBloc.add(SendSCommentNotice(index: widget.index));
          setState(() {
            repeat = false;
          });
        }
      },
      builder: (context, state) {
        return (state.user != null && state.field != null)
            ? AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: GestureDetector(
                  onTap: () {
                    _focusNode.unfocus();
                    _subFocusNode.unfocus();
                    _textEditingController.clear();
                    _subTextEditingController.clear();
                  },
                  child: Center(
                    child: Container(
                      width: 814,
                      padding: EdgeInsets.only(top: 39),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _title(state),
                                SizedBox(
                                  height: 31,
                                ),
                                Divider(
                                  height: 26,
                                  thickness: 1,
                                  color: Color(0xFFDFDFDF),
                                ),
                                _subtitle(state.field.name),
                                Divider(
                                  height: 26,
                                  thickness: 1,
                                  color: Color(0xFFDFDFDF),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                _infoCard(state),
                                SizedBox(
                                  height: 7,
                                ),
                                Divider(
                                  height: 48,
                                  thickness: 1,
                                  color: Color(0xFFDFDFDF),
                                ),
                              ],
                            ),
                          ),
                          _imageList(state),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  height: 60,
                                  thickness: 1,
                                  color: Color(0xFFDFDFDF),
                                ),
                                _contents(state, state.user, state.field.name),
                                SizedBox(
                                  height: 18,
                                ),
                                _showComments(state: state),
                                Divider(
                                  height: 44,
                                  thickness: 1,
                                  color: Color(0xFFDFDFDF),
                                ),
                                // _writeComment(state),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('이전'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Scaffold(body: LinearProgressIndicator());
      },
    );
  }

  Widget _title(FMHomeState state) {
    return Text(
      '${state.recentUpdateList[widget.index].issue.title}',
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
    );
  }

  Widget _subtitle(String fieldName) {
    return Text(
      '${date} / ${fieldName} / 이슈일지',
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Color(0x80000000),
          ),
    );
  }

  Widget _infoCard(FMHomeState state) {
    return Container(
      width: 343,
      height: 137,
      padding: EdgeInsets.fromLTRB(30, 23, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Color(0x4D000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '날짜',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Color(0xB3000000),
                    ),
              ),
              SizedBox(
                width: 14,
              ),
              Text(
                '${date} ${weekday}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 19,
          ),
          Row(
            children: [
              Text(
                '카테고리',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Color(0xB3000000),
                    ),
              ),
              SizedBox(
                width: 14,
              ),
              Text(
                '${getCategory(cat: state.recentUpdateList[widget.index].issue.category)}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF219653),
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 19,
          ),
          Row(
            children: [
              Text(
                '이슈상태',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Color(0xB3000000),
                    ),
              ),
              SizedBox(
                width: 14,
              ),
              Container(
                width: 32.22,
                height: 20,
                child: FittedBox(
                  child: DepartmentBadge(
                    department: getIssueState(
                        state: state
                            .recentUpdateList[widget.index].issue.issueState),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageList(FMHomeState state) {
    List<ImagePicture> pic = state.picture
        .where((element) =>
            state.recentUpdateList[widget.index].issue.issid == element.issid)
        .toList();
    return (pic.isNotEmpty)
        ? Column(
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Text(
                      '사진',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      '${pic.length}',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 18,
                            color: Color(0xFF15B85B),
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: List.generate(pic.length, (index) {
                  return Row(
                    children: [
                      (index == 0)
                          ? SizedBox(
                              width: 32,
                            )
                          : Container(),
                      Container(
                        width: 144,
                        height: 144,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(pic[index].url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  );
                }),
              ),
            ],
          )
        : Container();
  }

  Widget _contents(FMHomeState state, User detailUser, String fieldName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '상세내용',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Text(
          '${state.recentUpdateList[widget.index].issue.contents}',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.w300,
                color: Color(0xB3000000),
              ),
        ),
        SizedBox(
          height: 44,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 46,
              width: 46,
              child: CircleAvatar(
                backgroundImage: (detailUser.imgUrl.isNotEmpty)
                    ? NetworkImage(detailUser.imgUrl)
                    : AssetImage('assets/profile.png'),
                radius: 46,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${detailUser.name}',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Color(0x80000000),
                      ),
                ),
                Text(
                  '${fieldName}',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Color(0x80000000),
                      ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _showComments({FMHomeState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 31,
          width: 75,
          padding: EdgeInsets.fromLTRB(15, 7, 15, 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0x80000000)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: FittedBox(
            child: Text(
              '댓글 ${state.recentUpdateList[widget.index].issue.comments}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Color(0x80000000),
                  ),
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            state.clist.length,
            (index) => _commentTile(state: state, index: index),
          ),
        )
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

  Widget _commentTile({FMHomeState state, int index}) {
    List<SubComment> subComments = state.sclist
        .where((scmt) => scmt.cmtid == state.clist[index].cmtid)
        .toList();
    String time = getTime(date: state.clist[index].date);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                child: CircleAvatar(
                  backgroundImage: (state.clist[index].imgUrl.isNotEmpty)
                      ? CachedNetworkImageProvider(state.clist[index].imgUrl)
                      : AssetImage('assets/profile.png'),
                  radius: 46,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.clist[index].name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.clist[index].comment,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 11,
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         if (state.clist[index].isWriteSubCommentClicked) {
                  //           _subFocusNode.unfocus();
                  //           _subTextEditingController.clear();
                  //         }
                  //         setState(() {
                  //           _fmHomeBloc
                  //               .add(ChangeWriteReplyState(index: index));
                  //         });
                  //       },
                  //       child: (!state.clist[index].isWriteSubCommentClicked)
                  //           ? Text(
                  //               '답글 달기',
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyText2
                  //                   .copyWith(
                  //                     fontSize: 12,
                  //                     color: Colors.grey,
                  //                   ),
                  //             )
                  //           : Text(
                  //               '취소',
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyText2
                  //                   .copyWith(
                  //                     fontSize: 12,
                  //                     color: Colors.grey,
                  //                   ),
                  //             ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
          // (state.clist[index].isWriteSubCommentClicked)
          //     ? SizedBox(
          //         height: 10,
          //       )
          //     : Container(),
          // (state.clist[index].isWriteSubCommentClicked)
          //     ? Row(
          //         children: [
          //           SizedBox(
          //             width: 56,
          //           ),
          //           _writeReply(index: index, state: state),
          //         ],
          //       )
          //     : Container(),
          (subComments.isNotEmpty)
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          // (subComments.isNotEmpty)
          //     ? Row(
          //         children: [
          //           SizedBox(
          //             width: 56,
          //           ),
          //           Container(
          //             child: InkWell(
          //               onTap: () {
          //                 setState(() {
          //                   _fmHomeBloc.add(ChangeExpandState(index: index));
          //                 });
          //               },
          //               child: (!state.clist[index].isExpanded)
          //                   ? Text('--- 답글 ${subComments.length}개 펼치기',
          //                       style: Theme.of(context).textTheme.bodyText2)
          //                   : Text('--- 답글 ${subComments.length}개 숨기기',
          //                       style: Theme.of(context).textTheme.bodyText2),
          //             ),
          //           ),
          //         ],
          //       )
          //     : Container(),
          (state.clist[index].isExpanded)
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    showSubComments(scmts: subComments),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget showSubComments({List<SubComment> scmts}) {
    return Container(
      child: Column(
        children: List.generate(scmts.length, (index) {
          return Column(
            children: [
              subComment(scmts: scmts, index: index),
              (index != scmts.length - 1)
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
            ],
          );
        }),
      ),
    );
  }

  Widget subComment({
    List<SubComment> scmts,
    int index,
  }) {
    String time = getTime(date: scmts[index].date);
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 56,
          ),
          Container(
            height: 42,
            width: 42,
            child: CircleAvatar(
              radius: 42.0,
              backgroundImage: (scmts[index].imgUrl.isNotEmpty)
                  ? CachedNetworkImageProvider(scmts[index].imgUrl)
                  : AssetImage('assets/profile.png'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${scmts[index].name}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${time}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                '${scmts[index].scomment}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _writeComment(FMHomeState state) {
    return Container(
      height: 78,
      padding: EdgeInsets.fromLTRB(12, 12, 12, 24),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0x80000000)),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            child: CircleAvatar(
              backgroundImage: (UserUtil.getUser().imgUrl.isNotEmpty)
                  ? CachedNetworkImageProvider(UserUtil.getUser().imgUrl)
                  : AssetImage('assets/profile.png'),
              radius: 46,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _textEditingController,
              keyboardType: TextInputType.text,
              onTap: () {
                _focusNode.requestFocus();
              },
              onChanged: (text) {
                setState(() {
                  comment = text;
                });
              },
              onSubmitted: (text) {
                _fmHomeBloc.add(WriteComment(cmt: text, rpIndex: widget.index));
                setState(() {
                  repeat = true;
                  isComment = true;
                });
                _focusNode.unfocus();
                _textEditingController.clear();
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: '댓글을 남겨주세요',
                  hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Color(0x4D000000),
                      )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _writeReply({int index, FMHomeState state}) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            child: CircleAvatar(
              backgroundImage: (UserUtil.getUser().imgUrl.isNotEmpty)
                  ? CachedNetworkImageProvider(UserUtil.getUser().imgUrl)
                  : AssetImage('assets/profile.png'),
              radius: 42,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 589,
                child: TextField(
                  focusNode: _subFocusNode,
                  controller: _subTextEditingController,
                  keyboardType: TextInputType.text,
                  onTap: () {
                    _subFocusNode.requestFocus();
                  },
                  onChanged: (text) {
                    setState(() {
                      comment = text;
                    });
                  },
                  onSubmitted: (text) {
                    _fmHomeBloc.add(WriteReply(
                        scmt: text, rpIndex: widget.index, index: index));
                    setState(() {
                      repeat = true;
                      isSubComment = true;
                    });
                    _subFocusNode.unfocus();
                    _subTextEditingController.clear();
                  },
                  decoration: InputDecoration(
                      // border: InputBorder.none,
                      // contentPadding: EdgeInsets.zero,
                      // isDense: true,
                      hintText: '답글을 남겨주세요',
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Color(0x4D000000),
                          )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getCategory({int cat}) {
    switch (cat) {
      case 1:
        {
          return '작물';
        }
        break;
      case 2:
        {
          return '시설';
        }
        break;
      case 3:
        {
          return '기타';
        }
        break;
    }
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
    }
  }
}
