import 'package:BrandFarm/blocs/comment/bloc.dart';
import 'package:BrandFarm/blocs/journal/bloc.dart';
import 'package:BrandFarm/blocs/journal_create/bloc.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_edit_screen.dart';
import 'package:BrandFarm/screens/sub_journal/tableWidget/tableWidgets.dart';
import 'package:BrandFarm/utils/column_builder.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:BrandFarm/widgets/loading/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SubJournalDetailScreen extends StatefulWidget {

  @override
  _SubJournalDetailScreenState createState() => _SubJournalDetailScreenState();
}

class _SubJournalDetailScreenState extends State<SubJournalDetailScreen> {
  TextEditingController _textEditingController;
  ScrollController _scrollController;
  CommentBloc _commentBloc;
  JournalBloc _journalBloc;

  //////////////////////////////////////////////////////////////////////////////
  double height;
  bool _isVisible = true;
  String comment = '';
  FocusNode myfocusNode;
  bool _isClear = true;
  bool _isSubCommentClicked = false;
  int indx = 0;
  String cmtid = '';
  int numOfComments;

  List<ImagePicture> _pic = [];

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
      listener: (context, state) {

      },
      builder: (context, state) {
        if (state.imageList.isNotEmpty) {
          _pic = state.imageList
              .where((element) => element.jid ==state.selectedJournal.jid)
              .toList();
        }
        return BlocBuilder<CommentBloc, CommentState>(
          builder: (context, cstate) {
            return (cstate.isLoading)
                ? Loading()
                : Scaffold(
                    appBar: _appBar(context: context, state: state),
                    body: Stack(
                      children: [
                        _journalBody(
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
                            commentState: cstate,
                            state: state,
                          ),
                        ),
                      ],
                    ));
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
        '${state.selectedJournal.title}',
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
                    builder: (BuildContext context) =>
                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (BuildContext context)=>
                              JournalCreateBloc()..add(WidgetListLoaded(widgets: state.selectedJournal.widgets))
                                ..add(JournalInitialized(
                                existJournal: state.selectedJournal,
                                existImage: _pic,
                              ))..add(ModifyLoading()),
                            ),
                            BlocProvider.value(
                              value: _journalBloc,
                            ),
                          ],
                          child: SubJournalEditScreen(),
                        )
                ));
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

  Widget _journalBody(
      {BuildContext context, JournalState state, CommentState cstate}) {
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
          _journalDate(context: context, state: state),
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
          _infoContainer(context: context,state: state),
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
                    '${_pic.length}',
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
          _pic.isEmpty ? Container() : _addPictureBar(context: context),
          _pic.isEmpty
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
          _record(context: context, state: state),
          SizedBox(
            height: 55,
          ),
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

  Widget _journalDate({BuildContext context, JournalState state}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
          child: Text(
              '${DateFormat('yMMMMEEEEd', 'ko').format(state.selectedJournal.date.toDate())}',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontSize: 16.0, color: Theme.of(context).primaryColor))),
    );
  }

  Widget _infoContainer({BuildContext context, JournalState state}) {
    Journal selectedJournal = state.selectedJournal;
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

  Widget _addPictureBar({
    BuildContext context,
  }) {
    return Container(
      height: 74,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _pic.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              SizedBox(
                width: defaultPadding,
              ),
              _image(
                context: context,
                url: _pic[index].url,
              ),
              (index == _pic.length - 1)
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

  Widget _record({BuildContext context, JournalState state}) {
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
            state.selectedJournal.content,
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

  Widget commentTile({BuildContext context, CommentState state, int index}){
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
                  backgroundImage:
                  (state.commentsUser.isEmpty ||
                          state.commentsUser[index].imgUrl == '')
                      ?
                  AssetImage('assets/profile.png')
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

  Widget _writeComment({BuildContext context, CommentState commentState, JournalState state}) {
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
                    Text('${commentState.comments[indx].name}님에게 답글 남기는 중. . .'),
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
                                  from: 'journal',
                                  id: state.selectedJournal.jid,
                                  comment: comment,
                                  cmtid: cmtid,
                                ));
                              } else {
                                _commentBloc.add(AddComment(
                                  from: 'journal',
                                  id: state.selectedJournal.jid,
                                  comment: comment,
                                ));
                                // setState(() {
                                //   numOfComments += 1;
                                // });
                                _journalBloc.add(AddJournalComment(
                                    id: state.selectedJournal.jid));
                              }
                              setState(() {
                                _isSubCommentClicked = false;
                              });
                              _commentBloc.add(LoadComment());
                              _commentBloc.add(GetComment(id: state.selectedJournal.jid, from: 'jid'));
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
