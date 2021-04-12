import 'package:BrandFarm/blocs/journal/bloc.dart';
import 'package:BrandFarm/blocs/journal_issue_modify/bloc.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_create_screen.dart';
import 'package:BrandFarm/utils/field_util.dart';
import 'package:BrandFarm/utils/sub_journal/get_image.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/widgets/brandfarm_date_picker.dart';
import 'package:BrandFarm/widgets/customized_badge.dart';
import 'package:BrandFarm/widgets/loading/loading.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../utils/user/user_util.dart';

class SubJournalIssueModifyScreen extends StatefulWidget {
  @override
  _SubJournalIssueModifyScreenState createState() =>
      _SubJournalIssueModifyScreenState();
}

class _SubJournalIssueModifyScreenState
    extends State<SubJournalIssueModifyScreen> {
  //////////////////////////////////////////////////////////////////////////////
  TextEditingController _title;
  TextEditingController _content;
  FocusNode _focusTitle;
  FocusNode _focusContent;
  JournalIssueModifyBloc _journalIssueModifyBloc;
  JournalBloc _journalBloc;
  List list;

  //////////////////////////////////////////////////////////////////////////////
  Timestamp tnow = Timestamp.now();

  String title = '';
  String contents = '';
  int category;
  int issueState;

  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _focusTitle = FocusNode();
    _focusContent = FocusNode();
    _journalIssueModifyBloc = BlocProvider.of<JournalIssueModifyBloc>(context);
    _journalBloc = BlocProvider.of<JournalBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalBloc, JournalState>(builder: (context, state) {
      return BlocConsumer<JournalIssueModifyBloc, JournalIssueModifyState>(
        listener: (context, mstate) {
          if (mstate.isComplete == true && mstate.isUploaded == false) {
            // print('isUpload false');
            LoadingDialog.onLoading(context);
            _journalIssueModifyBloc.add(UpdateIssue(
              fid: FieldUtil.getField().fid,
              category: category,
              sfmid: FieldUtil.getField().sfmid,
              issid: state.selectedIssue.issid,
              contents: _content.text,
              title: _title.text,
              uid: UserUtil.getUser().uid,
              issueState: issueState,
              comments: state.selectedIssue.comments,
              isReadByFM: state.selectedIssue.isReadByFM,
              isReadByOffice: state.selectedIssue.isReadByOffice,
              selectedDate: mstate.selectedDate ??state.selectedIssue.date,
            ));
          } else if (mstate.isComplete == true && mstate.isUploaded == true) {
            // print('isUpload true');
            _journalBloc.add(GetInitialList());
            LoadingDialog.dismiss(context, () {
              _journalBloc.add(PassSelectedIssue(
                  issue: SubJournalIssue(
                date: mstate.selectedDate ?? state.selectedIssue.date,
                fid: FieldUtil.getField().fid,
                sfmid: FieldUtil.getField().sfmid ?? '--',
                issid: state.selectedIssue.issid ?? '--',
                uid: UserUtil.getUser().uid ?? '--',
                title: _title.text,
                category: category,
                issueState: issueState,
                contents: _content.text,
                comments: state.selectedIssue.comments ?? 0,
                isReadByFM: state.selectedIssue.isReadByFM ?? false,
                isReadByOffice: state.selectedIssue.isReadByOffice ?? false,
              )));
              Navigator.pop(context);
            });
          } else if (mstate.isModifyLoading) {
            _title =
                TextEditingController(text: '${state.selectedIssue.title}');
            _content =
                TextEditingController(text: '${state.selectedIssue.contents}');
            _journalIssueModifyBloc
                .add(GetImageList(issid: state.selectedIssue.issid));
            print(state.selectedIssue.issid);
            issueState = state.selectedIssue.issueState;
            category = state.selectedIssue.category;
            _journalIssueModifyBloc.add(ModifyLoaded());
          }
        },
        builder: (context, mstate) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                '이슈일지 작성',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              centerTitle: true,
            ),
            body: GestureDetector(
              onTap: () {
                _focusTitle.unfocus();
                _focusContent.unfocus();
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.0,
                    ),
                    _dateBar(context: context, state: state),
                    SizedBox(
                      height: 37.0,
                    ),
                    _inputTitleBar(context: context, state: state),
                    SizedBox(
                      height: 51.0,
                    ),
                    _chooseCategory(context: context, state: state),
                    SizedBox(
                      height: 45.0,
                    ),
                    _chooseIssueState(),
                    SizedBox(
                      height: 48.0,
                    ),
                    _addPictureBar(context: context, state: mstate),
                    SizedBox(
                      height: 43.0,
                    ),
                    _inputIssueContents(),
                    SizedBox(
                      height: 72,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomButton(
              title: '완료',
              onPressed: () {
                _journalIssueModifyBloc.add(PressComplete());
              },
            ),
          );
        },
      );
    });
  }

  Widget _dateBar({BuildContext context, JournalState state}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Text(
              '${DateFormat('yMMMMEEEEd', 'ko').format(_journalIssueModifyBloc.state.selectedDate == null ? state.selectedIssue.date.toDate() : _journalIssueModifyBloc.state.selectedDate.toDate())}',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontSize: 16.0, color: Theme.of(context).primaryColor)),
          Spacer(),
          IconButton(
              icon: SvgPicture.asset(
                'assets/svg_icon/calendar_icon.svg',
                color: Color(0xb3000000),
              ),
              onPressed: () async {
                final picked = await BrandFarmDatePicker(
                  context: context,
                  initialDate:
                      _journalIssueModifyBloc.state.selectedDate == null
                          ? state.selectedIssue.date.toDate()
                          : _journalIssueModifyBloc.state.selectedDate.toDate(),
                  firstDate: DateTime(2015, 1),
                  lastDate: DateTime(2100),
                  helpText: '날짜 선택',
                  locale: Locale('ko', 'KO'),
                );

                if (picked != null) {
                  _journalIssueModifyBloc.add(
                      DateSelected(selectedDate: Timestamp.fromDate(picked)));
                }
              }),
        ],
      ),
    );
  }

  Widget _inputTitleBar({BuildContext context, JournalState state}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('제목', style: Theme.of(context).textTheme.headline5),
          SizedBox(width: 8.0),
          Expanded(
              child: TextField(
            controller: _title,
            focusNode: _focusTitle,
            onTap: () {
              _focusTitle.requestFocus();
            },
            style:
                Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18.0),
            decoration: InputDecoration(
                hintText: '2021_0405_한동이네딸기농장',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 18.0, color: Color(0x2C000000)),
                isDense: true,
                contentPadding: EdgeInsets.all(5.0)),
          ))
        ],
      ),
    );
  }

  Widget _chooseCategory({BuildContext context, JournalState state}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('카테고리 선택', style: Theme.of(context).textTheme.headline5),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                category = 1;
              });
            },
            child: Text(
              '작물',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                    color:
                        (category == 1) ? Color(0xFF219653) : Color(0x40000000),
                  ),
            ),
          ),
          // SizedBox(width: 29,),
          TextButton(
            onPressed: () {
              setState(() {
                category = 2;
              });
            },
            child: Text(
              '시설',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                    color:
                        (category == 2) ? Color(0xFF219653) : Color(0x40000000),
                  ),
            ),
          ),
          // SizedBox(width: 28,),
          TextButton(
            onPressed: () {
              setState(() {
                category = 3;
              });
            },
            child: Text(
              '기타',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                    color:
                        (category == 3) ? Color(0xFF219653) : Color(0x40000000),
                  ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _chooseIssueState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('이슈 상태', style: Theme.of(context).textTheme.headline5),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                issueState = 1;
              });
            },
            child: Text(
              '예상',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                    color: (issueState == 1)
                        ? Color(0xFF219653)
                        : Color(0x40000000),
                  ),
            ),
          ),
          // SizedBox(width: 29,),
          TextButton(
            onPressed: () {
              setState(() {
                issueState = 2;
              });
            },
            child: Text(
              '진행',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                    color: (issueState == 2)
                        ? Color(0xFF219653)
                        : Color(0x40000000),
                  ),
            ),
          ),
          // SizedBox(width: 28,),
          TextButton(
            onPressed: () {
              setState(() {
                issueState = 3;
              });
            },
            child: Text(
              '완료',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                    color: (issueState == 3)
                        ? Color(0xFF219653)
                        : Color(0x40000000),
                  ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _addPictureBar({BuildContext context, JournalIssueModifyState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text('사진첨부', style: Theme.of(context).textTheme.headline5),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          height: 100.0,
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: (state?.imageList?.isEmpty ?? true)
                ? 1
                : state.imageList.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (index == 0)
                      ? SizedBox(
                          width: defaultPadding,
                        )
                      : Container(),
                  (index == 0)
                      ? Center(
                          child: InkWell(
                              onTap: () {
                                _pickImage(context: context, state: state);
                              },
                              child: Container(
                                height: 74.0,
                                width: 74.0,
                                decoration:
                                    BoxDecoration(color: Color(0x1a000000)),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 34.0,
                                  ),
                                ),
                              )),
                        )
                      : Container(),
                  (state.imageList.isNotEmpty && index == 0)
                      ? SizedBox(
                          width: defaultPadding,
                        )
                      : Container(),
                  (state?.imageList?.isNotEmpty ?? true)
                      ? _image(
                          context: context,
                          state: state,
                          index: index,
                        )
                      : Container(
                          width: defaultPadding,
                        ),
                  if (state.imageList.isEmpty && index == 0)
                    Row(
                      children: List.generate(state.existingImageList.length,
                          (index) {
                        return _existingImage(
                          context: context,
                          url: state.existingImageList[index].url,
                          obj: state.existingImageList[index],
                          index: index,
                        );
                      }),
                    )
                  else if (index + 1 == state.imageList.length &&
                      state.existingImageList.isNotEmpty)
                    Row(
                      children: List.generate(state.existingImageList.length,
                          (index) {
                        return _existingImage(
                            context: context,
                            url: state.existingImageList[index].url,
                            obj: state.existingImageList[index],
                            index: index);
                      }),
                    )
                  else
                    Container(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _existingImage(
      {BuildContext context, String url, ImagePicture obj, int index}) {
    return CustomizedBadge(
      onPressed: () {
        _journalIssueModifyBloc.add(DeleteExistingImage(obj: obj));
      },
      toAnimate: false,
      badgeContent: Icon(
        Icons.close,
        color: Colors.white,
        size: 11,
      ),
      position: BadgePosition.topEnd(top: 3, end: 3),
      badgeColor: Colors.black,
      shape: BadgeShape.circle,
      child: Stack(
        children: [
          Container(
            height: 87.0,
            width: 87.0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(
      {BuildContext context, JournalIssueModifyState state, int index}) {
    bool isNull = state.imageList[index] == null;
    return CustomizedBadge(
      onPressed: () {
        _journalIssueModifyBloc
            .add(DeleteImageFile(removedFile: state.imageList[index]));
      },
      // padding: EdgeInsets.zero,
      toAnimate: false,

      badgeContent: Icon(
        Icons.close,
        color: Colors.white,
        size: 11,
      ),
      position: BadgePosition.topEnd(top: 3, end: 3),
      badgeColor: Colors.black,
      shape: BadgeShape.circle,
      child: isNull
          ? Stack(
              children: [
                Container(
                  height: 87.0,
                  width: 87.0,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 74.0,
                      width: 74.0,
                      color: Colors.grey,
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 0, 61, 165)),
                      )),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Container(
                  height: 87.0,
                  width: 87.0,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 74.0,
                      width: 74.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            state.imageList[index],
                          ),
                          fit: BoxFit.cover,
                          // colorFilter: ColorFilter.mode(
                          //     Colors.black.withOpacity(0.5), BlendMode.srcATop),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _inputIssueContents() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('과정 기록', style: Theme.of(context).textTheme.headline5),
          SizedBox(
            height: 8.0,
          ),
          Scrollbar(
            child: TextField(
              controller: _content,
              focusNode: _focusContent,
              onTap: () {
                _focusContent.requestFocus();
              },
              scrollPhysics: ClampingScrollPhysics(),
              minLines: null,
              maxLines: 8,
              style: Theme.of(context).textTheme.bodyText1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: '내용을 입력해주세요',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18.0, color: Color(0x2C000000)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(),
                  )),
            ),
          )
        ],
      ),
    );
  }

  void _pickImage({BuildContext context, JournalIssueModifyState state}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                    height: 152,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Text(
                            '사진 첨부',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Color(0xFF868686),
                                      fontSize: 15,
                                    ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            getCameraImage(
                              journalIssueModifyBloc: _journalIssueModifyBloc,
                              from: 'SubJournalIssueModifyScreen',
                            );
                          },
                          title: Center(
                            child: Text(
                              '사진촬영',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: 20,
                                    color: Color(0xFF3183E3),
                                  ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            getImage(
                              journalIssueModifyBloc: _journalIssueModifyBloc,
                              from: 'SubJournalIssueModifyScreen',
                            );
                          },
                          title: Center(
                            child: Text(
                              '앨범에서 사진 선택',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: 20,
                                    color: Color(0xFF3183E3),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                    height: 61,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: Text(
                        '취소',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xFF3183E3),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                ],
              ),
            ],
          );
        });
  }
}
