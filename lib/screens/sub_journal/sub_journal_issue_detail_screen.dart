import 'package:BrandFarm/blocs/comment/bloc.dart';
import 'package:BrandFarm/blocs/journal/bloc.dart';
import 'package:BrandFarm/blocs/journal_issue_modify/bloc.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_issue_modify_screen.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:BrandFarm/widgets/loading/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SubJournalIssueDetailScreen extends StatefulWidget {
  SubJournalIssueDetailScreen({
    Key key,
    this.issueListOptions,
    this.issueOrder,
  }) : super(key: key);

  final String issueListOptions;
  final int issueOrder;

  @override
  _SubJournalIssueDetailScreenState createState() =>
      _SubJournalIssueDetailScreenState();
}

class _SubJournalIssueDetailScreenState
    extends State<SubJournalIssueDetailScreen> {
  /////////////////////////////////////////////////////////////////////////////
  TextEditingController _textEditingController;
  ScrollController _scrollController;
  JournalBloc _journalBloc;
  CommentBloc _commentBloc;

  //////////////////////////////////////////////////////////////////////////////
  double height;
  bool _isVisible = true;
  String comment = '';
  FocusNode myfocusNode;
  bool _isClear = true;
  bool _isSubCommentClicked = false;
  int indx = 0;
  String cmtid = '';

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _journalBloc = BlocProvider.of<JournalBloc>(context);
    _commentBloc = BlocProvider.of<CommentBloc>(context);
    Future.delayed(Duration.zero, () {
      height = MediaQuery.of(context).size.height / 2;
      print(height);
    });
    myfocusNode = FocusNode();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      if (_textEditingController.text.length > 0) {
        setState(() {
          _isClear = false;
        });
      } else {
        setState(() {
          _isClear = true;
        });
      }
    });
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _bottomCommentSection();
    });
  }

  void _bottomCommentSection() {
    if (_scrollController.offset > height) {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
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
            if (this.mounted) {
              setState(() {
                _isVisible = true;
              });
            }
          }
        }
      }
    } else {
      setState(() {
        _isVisible = true;
      });
    }
  }

  @override
  void dispose() {
    myfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalBloc, JournalState>(
      listener: (context, state) {},
      cubit: _journalBloc,
      builder: (context, state) {
        return BlocConsumer<CommentBloc, CommentState>(
          listener: (context, cstate) {},
          builder: (context, cstate) {
            return (cstate.isLoading)
                ? Loading()
                : Scaffold(
                    appBar: _appBar(context: context, state: state),
                    body: Stack(
                      children: [
                        _issueBody(
                          context: context,
                          state: state,
                          cstate: cstate,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          // alignment: Alignment(0,1),
                          alignment:
                              _isVisible ? Alignment(0, 1) : Alignment(0, 1.5),
                          child: _writeComment(
                            context: context,
                            cstate: cstate,
                            state: state,
                          ),
                        ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }

  Widget _appBar({BuildContext context, JournalState state}) {
    return AppBar(
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        '${state.selectedIssue.title}',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (BuildContext context) =>
                                JournalIssueModifyBloc()..add(ModifyLoading()),
                          ),
                          BlocProvider.value(
                            value: _journalBloc,
                          ),
                        ],
                        child: SubJournalIssueModifyScreen(),
                      )),
            );
          },
          child: Text(
            '편집',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _issueBody(
      {BuildContext context, JournalState state, CommentState cstate}) {
    List pic = state.imageList
        .where((element) => element.issid == state.selectedIssue.issid)
        .toList();
    return GestureDetector(
      onTap: () {
        myfocusNode.unfocus();
        _textEditingController.clear();
        setState(() {
          _isSubCommentClicked = false;
        });
      },
      child: ListView(
        shrinkWrap: true,
        controller: _scrollController,
        children: [
          SizedBox(
            height: 13,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Container(
              height: 150,
              padding: EdgeInsets.fromLTRB(46, 23, 46, 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 1,
                  color: Color(0x30000000),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 26,
                        child: Text('날짜',
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Color(0x70000000),
                                    )),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Text(
                        '${DateFormat('yMMMMEEEEd', 'ko').format(DateTime.fromMicrosecondsSinceEpoch(state.selectedIssue.date.microsecondsSinceEpoch))}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 52,
                        child: Text('카테고리',
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Color(0x70000000),
                                    )),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        getCategoryInfo(category: state.selectedIssue.category),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Color(0xFF219653),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 52,
                        child: Text('이슈상태',
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Color(0x70000000),
                                    )),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      DepartmentBadge(
                          department: getIssueState(
                              state: state.selectedIssue.issueState)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              state.selectedIssue.contents,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          (pic.isNotEmpty)
              ? Divider(
                  height: 0,
                  thickness: 1,
                  color: Color(0x20000000),
                )
              : Container(),
          (pic.isNotEmpty)
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          (pic.isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    children: [
                      Text(
                        '사진',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Text(
                        '${pic.length}',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF15B85B),
                            ),
                      ),
                    ],
                  ),
                )
              : Container(),
          (pic.isNotEmpty)
              ? SizedBox(
                  height: 9,
                )
              : Container(),
          (pic.isNotEmpty)
              ? _addPictureBar(context: context, pic: pic)
              : Container(),
          (pic.isNotEmpty)
              ? SizedBox(
                  height: 17,
                )
              : Container(),
          (cstate.comments.isNotEmpty)
              ? Divider(
                  height: 0,
                  thickness: 1,
                  color: Color(0x20000000),
                )
              : Container(),
          (cstate.comments.isNotEmpty)
              ? SizedBox(
                  height: 20,
                )
              : Container(),
          (cstate.comments.isNotEmpty)
              ? _comment(context: context, state: cstate)
              : Container(),
          (cstate.comments.isNotEmpty)
              ? SizedBox(
                  height: 91,
                )
              : Container(),
        ],
      ),
    );
  }

  String getCategoryInfo({int category}) {
    switch (category) {
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
      default:
        {
          return '--';
        }
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
      default:
        {
          return '--';
        }
        break;
    }
  }

  Widget _addPictureBar({
    BuildContext context,
    List pic,
  }) {
    return Container(
      height: 74,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: pic.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              SizedBox(
                width: defaultPadding,
              ),
              _image(
                context: context,
                url: pic[index].url,
              ),
              (index == pic.length - 1)
                  ? SizedBox(
                      width: defaultPadding,
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Widget _image({BuildContext context, String url}) {
    return Container(
      height: 74.0,
      width: 74.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            url,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _comment({BuildContext context, CommentState state}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(state.comments.length, (index) {
          return Column(
            children: [
              commentTile(context: context, state: state, index: index),
              SizedBox(
                height: 20,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget commentTile({BuildContext context, CommentState state, int index}) {
    List<SubComment> subComments = state.subComments
        .where((cmt) => cmt.cmtid == state.comments[index].cmtid)
        .toList();
    List<User> subCommentsUser = [];
    subComments.forEach((subComment) {
      subCommentsUser.add(state.subCommentsUser
          .firstWhere((element) => element.uid == subComment.uid));
    });

    String time = getTime(date: state.comments[index].date);
    print('commentsUserUrl = ${state.commentsUser.length}');
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                  radius: 18.0,
                  backgroundImage: (state.commentsUser.isEmpty ||
                          state.commentsUser[index].imgUrl == '')
                      ? AssetImage('assets/profile.png')
                      : NetworkImage(state.commentsUser[index].imgUrl)),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    state.comments[index].name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  // SizedBox(
                  //   height: 3,
                  // ),
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
                    state.comments[index].comment,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 11,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isSubCommentClicked = true;
                            cmtid = state.comments[index].cmtid;
                            indx = index;
                            myfocusNode.requestFocus();
                          });
                        },
                        child: Text(
                          '답글 달기',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 22,
                      ),
                      (state.comments[index].isExpanded)
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  // isExpanded = false;
                                  _commentBloc.add(CloseComment(index: index));
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '답글 숨기기',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                  ),
                                  Container(
                                      width: 14,
                                      height: 14,
                                      child: FittedBox(
                                          child: Icon(
                                        Icons.arrow_drop_up_outlined,
                                        color: Colors.grey,
                                      ))),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ],
          ),
          (subComments.isNotEmpty)
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          (subComments.isNotEmpty && !state.comments[index].isExpanded)
              ? Row(
                  children: [
                    SizedBox(
                      width: 77,
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // isExpanded = true;
                            _commentBloc.add(ExpandComment(index: index));
                          });
                        },
                        child: Text('답글 ${subComments.length}개 펼치기',
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ),
                  ],
                )
              : Container(),
          (state.comments[index].isExpanded)
              ? showSubComments(
                  context: context,
                  scmts: subComments,
                  subCommentsUser: subCommentsUser)
              : Container(),
        ],
      ),
    );
  }

  Widget showSubComments(
      {BuildContext context,
      List<SubComment> scmts,
      List<User> subCommentsUser}) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(scmts.length, (index) {
          return Column(
            children: [
              subComment(
                  context: context,
                  scmts: scmts,
                  index: index,
                  subCommentsUser: subCommentsUser),
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

  Widget subComment(
      {BuildContext context,
      List<SubComment> scmts,
      int index,
      List<User> subCommentsUser}) {
    String time = getTime(date: scmts[index].date);
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.subdirectory_arrow_right_outlined,
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              radius: 18.0,
              backgroundImage: (subCommentsUser[index].imgUrl == '' ||
                      subCommentsUser.isEmpty)
                  ? AssetImage('assets/profile.png')
                  : NetworkImage(subCommentsUser[index].imgUrl)),
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

  Widget _writeComment(
      {BuildContext context, CommentState cstate, JournalState state}) {
    return Wrap(
      children: [
        (_isSubCommentClicked)
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                height: 44,
                color: Color(0xFFEDEDED),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${cstate.comments[indx].name}님에게 답글 남기는 중. . .'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSubCommentClicked = false;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: (myfocusNode.hasFocus) ? 65 : 91,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 1, color: Color(0x30000000)),
              )),
          child: Column(
            children: [
              SizedBox(
                height: 9,
              ),
              Row(
                children: [
                  CircleAvatar(
                      radius: 23.0,
                      backgroundImage: (UserUtil.getUser().imgUrl.isEmpty ||
                              UserUtil.getUser().imgUrl == '--')
                          ? AssetImage('assets/profile.png')
                          : NetworkImage(UserUtil.getUser().imgUrl)),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: Theme(
                      child: TextField(
                        controller: _textEditingController,
                        focusNode: myfocusNode,
                        onTap: () {
                          myfocusNode.requestFocus();
                        },
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                          hintText: '댓글 달기...',
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                comment = _textEditingController.text;
                              });
                              if (_isSubCommentClicked) {
                                _commentBloc.add(AddSubComment(
                                  from: 'issue',
                                  id: state.selectedIssue.issid,
                                  comment: comment,
                                  cmtid: cmtid,
                                ));
                                _journalBloc.add(SetUpdatedDateIssue(
                                  id: state.selectedIssue.issid,
                                ));
                              } else {
                                _commentBloc.add(AddComment(
                                  from: 'issue',
                                  id: state.selectedIssue.issid,
                                  comment: comment,
                                ));
                                _journalBloc.add(AddIssueComment(
                                  id: state.selectedIssue.issid,
                                ));
                              }
                              setState(() {
                                _isSubCommentClicked = false;
                              });
                              _commentBloc.add(LoadComment());
                              _commentBloc.add(GetComment(
                                  id: state.selectedIssue.issid,
                                  from: 'issid'));
                              _textEditingController.clear();
                            },
                            child: Container(
                                width: 30,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '게시',
                                      style: (_isClear)
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: Colors.grey,
                                              )
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: Color(0xFF15B833),
                                              ),
                                    ))),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        ),
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Color(0xFF15B85B),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
