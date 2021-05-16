import 'package:BrandFarm/blocs/notification/notification_bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_event.dart';
import 'package:BrandFarm/blocs/notification/notification_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/notification/notification_repository.dart';
import 'package:BrandFarm/screens/sub_journal/tableWidget/tableWidgets.dart';
import 'package:BrandFarm/utils/column_builder.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationJournalDetail extends StatefulWidget {
  final NotificationNotice obj;

  const NotificationJournalDetail({Key key, @required this.obj}) : super(key: key);

  @override
  _NotificationJournalDetailState createState() => _NotificationJournalDetailState();
}

class _NotificationJournalDetailState extends State<NotificationJournalDetail> {
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
      _notificationBloc.add(GetJournalNotificationInitials(obj: obj));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.jObj == null)
            ? Scaffold(
                backgroundColor: Color(0x4D000000),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: _appBar(state: state),
                body: _journalBody(
                  state: state
                ));
      },
    );
  }

  Widget _appBar({NotificationState state}) {
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
        '${state.jObj.title ?? ''}',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: Colors.black,
        ),
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

  Widget _journalBody({NotificationState state}) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        TextEditingController().clear();
      },
      child: ListView(
        children: [
          SizedBox(
            height: 24,
          ),
          _journalDate(state: state),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
                child: Text('일일 활동내역',
                    style: Theme.of(context).textTheme.headline5)),
          ),
          SizedBox(
            height: 15,
          ),
          _infoContainer(state: state),
          SizedBox(
            height: 31,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              child: Row(
                children: [
                  Text('사진', style: Theme.of(context).textTheme.headline5),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '${state.piclist.length}',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Color(0xFF219653)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          state.piclist.isEmpty ? Container() : _addPictureBar(state: state),
          state.piclist.isEmpty
              ? Container()
              : SizedBox(
            height: defaultPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '과정 기록',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          _record(state: state),
          SizedBox(
            height: 55,
          ),
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
              ? _comment(state: state)
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

  Widget _journalDate({NotificationState state}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
          child: Text(
              '${DateFormat('yMMMMEEEEd', 'ko').format(state.jObj.date.toDate())}',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontSize: 16.0, color: Theme.of(context).primaryColor))),
    );
  }

  Widget _infoContainer({NotificationState state}) {
    Journal selectedJournal = state.jObj;
    return ColumnBuilder(
        itemBuilder: (context, listIndex) {
          return Column(
            children: <Widget>[
              if (selectedJournal.widgets[listIndex].name == "출하정보")
                ShipmentTable(
                    "출하정보",
                    selectedJournal
                        .shipment[selectedJournal.widgets[listIndex].index]
                        .shipmentPlant,
                    selectedJournal
                        .shipment[selectedJournal.widgets[listIndex].index]
                        .shipmentPath,
                    selectedJournal
                        .shipment[selectedJournal.widgets[listIndex].index]
                        .shipmentUnitSelect,
                    selectedJournal
                        .shipment[selectedJournal.widgets[listIndex].index]
                        .shipmentUnit
                        .toString(),
                    selectedJournal
                        .shipment[selectedJournal.widgets[listIndex].index]
                        .shipmentAmount
                        .toString(),
                    selectedJournal
                        .shipment[selectedJournal.widgets[listIndex].index]
                        .shipmentGrade,
                    selectedJournal
                        .shipment[selectedJournal.widgets[listIndex].index]
                        .shipmentPrice
                        .toString()),
              if (selectedJournal.widgets[listIndex].name == "비료정보")
                FertilizerTable(
                    "비료정보",
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerMethod,
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerArea
                        .toString(),
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerAreaUnit,
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerMaterialName,
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerMaterialUse,
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerMaterialUnit,
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerWater,
                    selectedJournal
                        .fertilize[selectedJournal.widgets[listIndex].index]
                        .fertilizerWaterUnit),
              if (selectedJournal.widgets[listIndex].name == "농약정보")
                FertilizerTable(
                    "농약정보",
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideMethod,
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideArea
                        .toString(),
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideAreaUnit,
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideMaterialName,
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideMaterialUse,
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideMaterialUnit,
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideWater,
                    selectedJournal
                        .pesticide[selectedJournal.widgets[listIndex].index]
                        .pesticideWaterUnit),
              if (selectedJournal.widgets[listIndex].name == "병,해충정보")
                PestTable(
                    "병,해충정보",
                    selectedJournal
                        .pest[selectedJournal.widgets[listIndex].index]
                        .pestKind,
                    selectedJournal
                        .pest[selectedJournal.widgets[listIndex].index]
                        .spreadDegree
                        .toString(),
                    selectedJournal
                        .pest[selectedJournal.widgets[listIndex].index]
                        .spreadDegreeUnit),
              if (selectedJournal.widgets[listIndex].name == "정식정보")
                PlantingTable(
                    "정식정보",
                    selectedJournal
                        .planting[selectedJournal.widgets[listIndex].index]
                        .plantingArea
                        .toString(),
                    selectedJournal
                        .planting[selectedJournal.widgets[listIndex].index]
                        .plantingAreaUnit,
                    selectedJournal
                        .planting[selectedJournal.widgets[listIndex].index]
                        .plantingCount,
                    selectedJournal
                        .planting[selectedJournal.widgets[listIndex].index]
                        .plantingPrice
                        .toString()),
              if (selectedJournal.widgets[listIndex].name == "파종정보")
                SeedingTable(
                    "파종정보",
                    selectedJournal
                        .seeding[selectedJournal.widgets[listIndex].index]
                        .seedingArea
                        .toString(),
                    selectedJournal
                        .seeding[selectedJournal.widgets[listIndex].index]
                        .seedingAreaUnit,
                    selectedJournal
                        .seeding[selectedJournal.widgets[listIndex].index]
                        .seedingAmount
                        .toString(),
                    selectedJournal
                        .seeding[selectedJournal.widgets[listIndex].index]
                        .seedingAmountUnit),
              if (selectedJournal.widgets[listIndex].name == "제초정보")
                WeedingTable(
                    "제초정보",
                    selectedJournal
                        .weeding[selectedJournal.widgets[listIndex].index]
                        .weedingProgress
                        .toString(),
                    selectedJournal
                        .weeding[selectedJournal.widgets[listIndex].index]
                        .weedingUnit),
              if (selectedJournal.widgets[listIndex].name == "관수정보")
                WateringTable(
                    "관수정보",
                    selectedJournal
                        .watering[selectedJournal.widgets[listIndex].index]
                        .wateringArea
                        .toString(),
                    selectedJournal
                        .watering[selectedJournal.widgets[listIndex].index]
                        .wateringAreaUnit,
                    selectedJournal
                        .watering[selectedJournal.widgets[listIndex].index]
                        .wateringAmount
                        .toString(),
                    selectedJournal
                        .watering[selectedJournal.widgets[listIndex].index]
                        .wateringAmountUnit),
              if (selectedJournal.widgets[listIndex].name == "인력투입정보")
                WorkForceTable(
                    "인력투입정보",
                    selectedJournal
                        .workforce[selectedJournal.widgets[listIndex].index]
                        .workforceNum
                        .toString(),
                    selectedJournal
                        .workforce[selectedJournal.widgets[listIndex].index]
                        .workforcePrice
                        .toString()),
              if (selectedJournal.widgets[listIndex].name == "경운정보")
                FarmingTable(
                  "경운정보",
                  selectedJournal
                      .farming[selectedJournal.widgets[listIndex].index]
                      .farmingArea
                      .toString(),
                  selectedJournal
                      .farming[selectedJournal.widgets[listIndex].index]
                      .farmingAreaUnit,
                  selectedJournal
                      .farming[selectedJournal.widgets[listIndex].index]
                      .farmingMethod,
                  selectedJournal
                      .farming[selectedJournal.widgets[listIndex].index]
                      .farmingMethodUnit,
                ),
            ],
          );
        },
        itemCount: selectedJournal.widgets.length);
  }

  Widget _addPictureBar({NotificationState state}) {
    return Container(
      height: 74,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: state.piclist.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              SizedBox(
                width: defaultPadding,
              ),
              _image(
                url: state.piclist[index].url,
              ),
              (index == state.piclist.length - 1)
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

  Widget _image({String url}) {
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

  Widget _record({NotificationState state}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 11, 19, 11),
          child: Text(
            state.jObj.content,
            style: TextStyle(
              fontSize: 16,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _comment({NotificationState state}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(state.clist.length, (index) {
          return Column(
            children: [
              commentTile(state: state, index: index),
              SizedBox(
                height: 20,
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<User> getUser(String uid) async {
    User user;
    user = await NotificationRepository().getUserInfo(uid);
    return user;
  }

  Widget commentTile({NotificationState state, int index}){
    List<SubComment> subComments = state.sclist
        .where((comment) => comment.cmtid == state.clist[index].cmtid)
        .toList();
    List<User> subCommentsUser = [];
    List<User> commentsUser = [];
    Future.wait(subComments.map((subComment) async {
      subCommentsUser.add(await getUser(subComment.uid));
    }));

    String time = getTime(date: state.clist[index].date);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 18.0,
                  backgroundImage:
                  (commentsUser.isEmpty ||
                      commentsUser[index].imgUrl == '')
                      ?
                  AssetImage('assets/profile.png')
                      : NetworkImage(commentsUser[index].imgUrl)),
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
            children: [
              SizedBox(
                width: 77,
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    _notificationBloc.add(SetExpansionState(index: index));
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
        List<User> subCommentsUser}){
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
