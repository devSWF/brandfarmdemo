import 'package:BrandFarm/blocs/notification/notification_bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_event.dart';
import 'package:BrandFarm/blocs/notification/notification_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/widgets/department_badge.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationIssueDetail extends StatefulWidget {
  final NotificationNotice obj;

  const NotificationIssueDetail({Key key, @required this.obj}) : super(key: key);

  @override
  _NotificationIssueDetailState createState() => _NotificationIssueDetailState();
}

class _NotificationIssueDetailState extends State<NotificationIssueDetail> {
  NotificationBloc _notificationBloc;
  NotificationNotice obj;

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    obj = widget.obj;
    if(!widget.obj.isReadBySFM){
      _notificationBloc.add(CheckAsRead(obj: obj));
    }
    if(obj != null) {
      _notificationBloc.add(GetIssueNotificationInitials(obj: obj));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.iObj == null)
            ? Scaffold(
                backgroundColor: Color(0x4D000000),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: _appBar(state),
                body: _issueBody(state),
              );
      },
    );
  }

  Widget _appBar(NotificationState state) {
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
        '${state.iObj.title}',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _issueBody(NotificationState state) {
    List pic = state.piclist
        .where((element) => element.issid == state.iObj.issid)
        .toList();
    return GestureDetector(
      onTap: () {},
      child: ListView(
        shrinkWrap: true,
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
                        '${DateFormat('yMMMMEEEEd', 'ko').format(DateTime.fromMicrosecondsSinceEpoch(state.iObj.date.microsecondsSinceEpoch))}',
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
                        getCategoryInfo(category: state.iObj.category),
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
                              state: state.iObj.issueState)),
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
              state.iObj.contents,
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
              ? _addPictureBar(pic)
              : Container(),
          (pic.isNotEmpty)
              ? SizedBox(
            height: 17,
          )
              : Container(),
          (state.clist.isNotEmpty)
              ? Divider(
            height: 0,
            thickness: 1,
            color: Color(0x20000000),
          )
              : Container(),
          (state.clist.isNotEmpty)
              ? SizedBox(
            height: 20,
          )
              : Container(),
          (state.clist.isNotEmpty)
              ? _comment(state)
              : Container(),
          (state.clist.isNotEmpty)
              ? SizedBox(
            height: 20,
          )
              : Container(),
          Row(
            children: [
              SizedBox(width: 16,),
              Text('수정/추가는 일지 목록을 이용해 주세요',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
            ],
          ),
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

  Widget _addPictureBar(List pic) {
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
              _image(pic[index].url,),
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

  Widget _image(String url) {
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

  Widget _comment(NotificationState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(state.clist.length, (index) {
          return Column(
            children: [
              commentTile(state, index),
              SizedBox(
                height: 20,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget commentTile(NotificationState state, int index) {
    List<SubComment> subComments = state.sclist
        .where((cmt) => cmt.cmtid == state.clist[index].cmtid)
        .toList();
    List<User> subCommentsUser = [];
    subComments.forEach((subComment) {
      subCommentsUser.add(state.scommentUser
          .firstWhere((element) => element.uid == subComment.uid));
    });

    String time = getTime(date: state.clist[index].date);
    print('commentsUserUrl = ${state.commentUser.length}');
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 18.0,
                  backgroundImage: (state.commentUser.isEmpty ||
                      state.commentUser[index].imgUrl == '')
                      ? AssetImage('assets/profile.png')
                      : NetworkImage(state.commentUser[index].imgUrl)),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        state.clist[index].name,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 7,
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
                    height: 3,
                  ),
                  Row(
                    children: [
                      Text(
                        state.clist[index].comment,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
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
          (subComments.isNotEmpty)
              ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 45,
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // isExpanded = true;
                      _notificationBloc.add(SetExpansionState(index: index));
                    });
                  },
                  child: (!state.clist[index].isExpanded)
                      ? Text('답글 ${subComments.length}개 펼치기',
                      style: Theme.of(context).textTheme.bodyText2)
                      : Text('답글 ${subComments.length}개 숨기기',
                      style: Theme.of(context).textTheme.bodyText2),
                ),
              ),
            ],
          )
              : Container(),
          (state.clist[index].isExpanded)
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
}
