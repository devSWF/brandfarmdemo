import 'package:BrandFarm/blocs/fm_notification/bloc.dart';
import 'package:BrandFarm/models/notification/notification_model.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WriteNoticeScreen extends StatefulWidget {
  @override
  _WriteNoticeScreenState createState() => _WriteNoticeScreenState();
}

class _WriteNoticeScreenState extends State<WriteNoticeScreen> {
  FMNotificationBloc _fmNotificationBloc;
  GlobalKey _fieldCategoryButtonkey = GlobalKey();
  GlobalKey _noticeTypekey = GlobalKey();
  double _fieldMenuHeight = 0.0;
  double _fieldMenuWidth = 0.0;
  double _fieldButtonSizeDX = 0.0;
  double _fieldButtonSizeDY = 0.0;

  double _noticeTypeHeight = 0.0;
  double _noticeTypeWidth = 0.0;
  double _noticeButtonSizeDX = 0.0;
  double _noticeButtonSizeDY = 0.0;

  bool isFieldCatSelected = false;
  bool isNoticeTypeSelected = false;

  int fieldCategoryIndex = 0;
  List<String> noticeTypeList = ['일반', '중요',];
  int noticeTypeIndex = 0;

  String noticeType;
  TextEditingController _titleController;
  TextEditingController _noticeController;
  FocusNode _titleNode;
  FocusNode _noticeNode;
  String _title;
  String _notice;
  bool canPost;
  bool isScheduled;

  @override
  void initState() {
    super.initState();
    _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
    _titleController = TextEditingController();
    _noticeController = TextEditingController();
    _titleNode = FocusNode();
    _noticeNode = FocusNode();
    _title = '';
    _notice = '';
    noticeType = '일반';
    isScheduled = false;
  }

  void _afterLayout() {
    _getSize();
    _getPosition();
  }

  void _getSize() {
    final RenderBox renderBoxField = _fieldCategoryButtonkey.currentContext.findRenderObject();
    final RenderBox renderBoxNotice = _noticeTypekey.currentContext.findRenderObject();
    final fieldSize = renderBoxField.size;
    final noticeSize = renderBoxNotice.size;
    setState(() {
      _fieldMenuHeight = fieldSize.height;
      _fieldMenuWidth = fieldSize.width;
      _noticeTypeHeight = noticeSize.height;
      _noticeTypeWidth = noticeSize.width;
    });
    // print('field: ${fieldSize} // notice: ${noticeSize}');
  }

  void _getPosition() {
    final RenderBox renderBoxField = _fieldCategoryButtonkey.currentContext.findRenderObject();
    final RenderBox renderBoxNotice = _noticeTypekey.currentContext.findRenderObject();
    final fieldPosition = renderBoxField.localToGlobal(Offset.zero);
    final noticePosition = renderBoxNotice.localToGlobal(Offset.zero);
    setState(() {
      _fieldButtonSizeDX = fieldPosition.dx;
      _fieldButtonSizeDY = fieldPosition.dy;
      _noticeButtonSizeDX = noticePosition.dx;
      _noticeButtonSizeDY = noticePosition.dy;
    });
    // print('field: ${fieldPosition} // notice: ${noticePosition}');
  }

  @override
  Widget build(BuildContext context) {
    if (_title.isNotEmpty && _notice.isNotEmpty) {
      setState(() {
        canPost = true;
      });
    } else {
      setState(() {
        canPost = false;
      });
    }
    return BlocConsumer<FMNotificationBloc, FMNotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _afterLayout();
        });
        return (state.field.name.isNotEmpty)
            ? Stack(
              children: [
                AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      height: 398,
                      width: 493,
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '공지사항 작성하기',
                                style:
                                    Theme.of(context).textTheme.bodyText1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                              ),
                              SizedBox(
                                width: 148,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  height: 28,
                                  thickness: 1,
                                  color: Color(0xFFE1E1E1),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 51,
                                      width: 51,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            (UserUtil.getUser().imgUrl.isNotEmpty)
                                                ? CachedNetworkImageProvider(
                                                    UserUtil.getUser().imgUrl)
                                                : AssetImage('assets/profile.png'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          UserUtil.getUser().name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            _selectFieldCategory(state),
                                            // _selectField(state),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            _selectNoticeType(state),
                                            // _noticeType(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 21,
                                ),
                                _writeTitle(),
                                SizedBox(
                                  height: 12,
                                ),
                                _writeNotice(),
                                SizedBox(
                                  height: 10,
                                ),
                                _completeButton(state),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                (isNoticeTypeSelected)
                    ? _noticeTypeMenu(state) : Container(),
                (isFieldCatSelected)
                    ? _fieldCategoryMenu(state) : Container(),
              ],
            )
            : Container();
      },
    );
  }

  // Widget _selectField(FMNotificationState state) {
  //   return DropdownBelow(
  //     value: state.field,
  //     items: state.fieldList.map<DropdownMenuItem<Field>>((Field value) {
  //       return DropdownMenuItem<Field>(
  //         value: value,
  //         child: Text(value.name),
  //       );
  //     }).toList(),
  //     itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
  //           color: Color(0xFF6F6F6F),
  //         ),
  //     itemWidth: 93,
  //     boxPadding: EdgeInsets.symmetric(horizontal: 8),
  //     boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
  //           color: Color(0xFF6F6F6F),
  //         ),
  //     boxWidth: 93,
  //     boxHeight: 24,
  //     onChanged: (Field value) {
  //       setState(() {
  //         _fmNotificationBloc.add(SetField(field: value));
  //       });
  //     },
  //   );
  // }

  Widget _selectFieldCategory(FMNotificationState state) {
    return OutlinedButton(
      key: _fieldCategoryButtonkey,
      onPressed: () {
        setState(() {
          isFieldCatSelected = !isFieldCatSelected;
        });
      },
      child: Row(
        children: [
          Text(
            '${state.fieldList[fieldCategoryIndex].name}',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.black,
            ),
          ),
          SizedBox(width: 6,),
          Icon(Icons.arrow_drop_down, color: Colors.black,),
        ],
      ),
    );
  }

  Widget _fieldCategoryMenu(FMNotificationState state) {
    return Positioned(
      top: _fieldButtonSizeDY + _fieldMenuHeight,
      left: _fieldButtonSizeDX,
      width: _fieldMenuWidth,
      child: Material(
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              state.fieldList.length,
                  (index) => InkWell(
                onTap: () {
                  setState(() {
                    fieldCategoryIndex = index;
                    isFieldCatSelected = !isFieldCatSelected;
                  });
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8,),
                        Text(
                          '${state.fieldList[index].name}',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _selectNoticeType(FMNotificationState state) {
    return OutlinedButton(
      key: _noticeTypekey,
      onPressed: () {
        setState(() {
          isNoticeTypeSelected = !isNoticeTypeSelected;
        });
      },
      child: Row(
        children: [
          Text(
            '${noticeTypeList[noticeTypeIndex]}',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.black,
            ),
          ),
          SizedBox(width: 6,),
          Icon(Icons.arrow_drop_down, color: Colors.black,),
        ],
      ),
    );
  }

  Widget _noticeTypeMenu(FMNotificationState state) {
    return Positioned(
      top: _noticeButtonSizeDY + _noticeTypeHeight,
      left: _noticeButtonSizeDX,
      width: _noticeTypeWidth,
      child: Material(
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              noticeTypeList.length,
                  (index) => InkWell(
                onTap: () {
                  setState(() {
                    noticeTypeIndex = index;
                    isNoticeTypeSelected = !isNoticeTypeSelected;
                  });
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8,),
                        Text(
                          '${noticeTypeList[index]}',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  // Widget _noticeType() {
  //   return DropdownBelow(
  //     value: noticeType,
  //     items: <String>['일반', '중요'].map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //     itemTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
  //           color: Color(0xFF6F6F6F),
  //         ),
  //     itemWidth: 93,
  //     boxPadding: EdgeInsets.symmetric(horizontal: 8),
  //     boxTextstyle: Theme.of(context).textTheme.bodyText2.copyWith(
  //           color: Color(0xFF6F6F6F),
  //         ),
  //     boxWidth: 93,
  //     boxHeight: 24,
  //     onChanged: (String value) {
  //       setState(() {
  //         noticeType = value;
  //       });
  //     },
  //   );
  // }

  Widget _writeTitle() {
    return Container(
      height: 32,
      width: 451,
      padding: EdgeInsets.fromLTRB(8, 7, 0, 0),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextField(
        controller: _titleController,
        focusNode: _titleNode,
        onTap: () {
          _titleNode.requestFocus();
        },
        onChanged: (text) {
          setState(() {
            _title = text;
          });
        },
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '제목을 입력해주세요',
          hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 18,
                color: Color(0xFFA8A8A8),
              ),
        ),
      ),
    );
  }

  Widget _writeNotice() {
    return Container(
      height: 151,
      width: 451,
      padding: EdgeInsets.fromLTRB(8, 7, 0, 0),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextField(
        controller: _noticeController,
        focusNode: _noticeNode,
        onTap: () {
          _noticeNode.requestFocus();
        },
        onChanged: (text) {
          setState(() {
            _notice = text;
          });
        },
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
        minLines: null,
        maxLines: 5,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '공지사항 내용을 입력해주세요',
          hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 18,
                color: Color(0xFFA8A8A8),
              ),
        ),
      ),
    );
  }

  Widget _completeButton(FMNotificationState state) {
    return InkResponse(
      onTap: () {
        if (canPost) {
          if (isScheduled) {
            ;
          } else {
            _fmNotificationBloc.add(PostNotification(
                obj: NotificationNotice(
              no: '',
              uid: UserUtil.getUser().uid,
              name: UserUtil.getUser().name,
              imgUrl: UserUtil.getUser().imgUrl,
              fid: state.fieldList[fieldCategoryIndex].fid,
              farmid: state.farm.farmID,
              title: _title,
              content: _notice,
              postedDate: Timestamp.now(),
              scheduledDate: Timestamp.now(),
              isReadByFM: true,
              isReadByOffice: false,
              isReadBySFM: false,
              notid: '',
              type: noticeTypeList[noticeTypeIndex],
              department: 'farm',
            )));
            Navigator.pop(context);
          }
        }
      },
      child: Container(
        height: 35,
        width: 451,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: (canPost) ? Color(0xFF15B85B) : Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            '게시',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: (canPost) ? Colors.white : Color(0xFFA8A8A8),
                ),
          ),
        ),
      ),
    );
  }
}
