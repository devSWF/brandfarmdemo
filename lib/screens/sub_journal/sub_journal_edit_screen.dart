import 'package:BrandFarm/blocs/journal/bloc.dart';
import 'package:BrandFarm/blocs/journal_create/bloc.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/screens/sub_journal/add/editCategory.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_input_activity_screen.dart';
import 'package:BrandFarm/utils/column_builder.dart';
import 'package:BrandFarm/utils/journal.category.dart';
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

class SubJournalEditScreen extends StatefulWidget {
  @override
  _SubJournalEditScreenState createState() => _SubJournalEditScreenState();
}

class _SubJournalEditScreenState extends State<SubJournalEditScreen> {
  JournalCreateBloc _journalCreateBloc;
  JournalBloc _journalBloc;
  ScrollController _progressScrollController;
  FocusNode _focusNode;
  ScrollController _scrollController = ScrollController();

  Color textFieldBorderColor;
  bool isFocus = false;

  TextEditingController titleController;
  TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    _journalCreateBloc = BlocProvider.of<JournalCreateBloc>(context);
    _journalBloc = BlocProvider.of<JournalBloc>(context);
    _progressScrollController = ScrollController(initialScrollOffset: 0.0);
    textFieldBorderColor = Color(0x4d000000);
    _focusNode = FocusNode()
      ..addListener(() {
        if (isFocus) {
          setState(() {
            textFieldBorderColor = Color(0x4d000000);
          });
        } else {
          setState(() {
            textFieldBorderColor = Theme.of(context).colorScheme.primary;
          });
        }
        isFocus = !isFocus;
      });

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: _journalCreateBloc,
        listener: (BuildContext context, JournalCreateState state) {
          if (state.isSuggestion == true) {
            Future.delayed(Duration(milliseconds: 100), () {
              _scrollController.animateTo(
                  MediaQuery.of(context).size.height * 0.3,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease);
            });
          }
          if (state.writeComplete == true) {
            _journalBloc.add(PassSelectedJournal(journal: state.bufferJournal));
            Navigator.pop(context);
            Navigator.pop(context);
          }
          if(state.isModifyLoading == true){
            titleController = TextEditingController(text: _journalCreateBloc.state.existJournal.title);
            contentController = TextEditingController(text: _journalCreateBloc.state.existJournal.content);
            _journalCreateBloc.add(TitleChanged(title: _journalCreateBloc.state.existJournal.title));
            _journalCreateBloc.add(ContentChanged(content: _journalCreateBloc.state.existJournal.content));
            _journalCreateBloc.add(ModifyLoaded());
          }
        },
        child: BlocBuilder<JournalCreateBloc, JournalCreateState>(
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  '성장일지 수정',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                centerTitle: true,
              ),
              body: BlocProvider<JournalCreateBloc>.value(
                value: _journalCreateBloc,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: ListView(
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      InputDateBar(
                        journalCreateBloc: _journalCreateBloc,
                        state: state,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      InputTitleBar(
                        journalCreateBloc: _journalCreateBloc,
                        state: state,
                        titleController: titleController,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      InputActivityBar(
                        state: state,
                        journalCreateBloc: _journalCreateBloc,
                      ),
                      _addedCategory(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _addPictureBar(context: context, state: state),
                      // AddPictureBar(),
                      SizedBox(
                        height: 15.0,
                      ),
                      AddProgressBar(
                        textFieldBorderColor: textFieldBorderColor,
                        scrollController: _progressScrollController,
                        focusNode: _focusNode,
                        journalCreateBloc: _journalCreateBloc,
                        state: state,
                        contentController: contentController,
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: CustomBottomButton(
                title: '완료',
                onPressed: state.title.isEmpty
                    ? null
                    : () {
                        // _journalCreateBloc.add(DailyJournal());
                        LoadingDialog.onLoading(context);
                        _journalCreateBloc.add(UpdateJournal());
                      },
              ),
            );
          },
        ));
  }

  Widget _addedCategory() {
    return _journalCreateBloc.state.widgets.isEmpty
        ? Container()
        : Container(
            child: ColumnBuilder(
              itemBuilder: (BuildContext context, int index) {
                return Ink(
                  padding: EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: defaultPadding),
                  color: Colors.white,
                  child: ListTile(
                    dense: true,
                    trailing: Text(
                      '수정',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18.0, color: Color(0xb3000000)),
                    ),
                    onTap: () {
                      _journalCreateBloc.add(CategoryChanged(
                          category: getJournalCategoryId(
                              name: _journalCreateBloc
                                  .state.widgets[index].name)));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BlocProvider<JournalCreateBloc>.value(
                                      value: _journalCreateBloc,
                                      child: EditCategory(
                                        index: _journalCreateBloc
                                            .state.widgets[index].index,
                                        category: _journalCreateBloc
                                            .state.widgets[index].name,
                                        listIndex: index,
                                      ))));
                    },
                    title: Row(
                      children: [
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          _journalCreateBloc.state.widgets[index].name,
                          style: Opacity70TileStyle,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _journalCreateBloc.state.widgets.length,
            ),
          );
  }

  Widget _addPictureBar({BuildContext context, JournalCreateState state}) {
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
                      children:
                          List.generate(state.existImageList.length, (index) {
                        return Row(
                          children: [
                            _existingImage(
                              context: context,
                              url: state.existImageList[index].url,
                              obj: state.existImageList[index],
                              index: index,
                            ),
                            SizedBox(
                              width: defaultPadding,
                            ),
                          ],
                        );
                      }),
                    )
                  else if (index + 1 == state.imageList.length &&
                      state.existImageList.isNotEmpty)
                    Row(
                      children:
                          List.generate(state.existImageList.length, (index) {
                        return Row(
                          children: [
                            _existingImage(
                                context: context,
                                url: state.existImageList[index].url,
                                obj: state.existImageList[index],
                                index: index),
                            SizedBox(
                              width: defaultPadding,
                            ),
                          ],
                        );
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
        _journalCreateBloc.add(DeleteExistingImage(index: index));
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

  Widget _image({BuildContext context, JournalCreateState state, int index}) {
    bool isNull = state.imageList[index] == null;
    return CustomizedBadge(
      onPressed: () {
        _journalCreateBloc
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

  void _pickImage({BuildContext context, JournalCreateState state}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
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
                              journalCreateBloc: _journalCreateBloc,
                              from: 'SubJournalCreateScreen',
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
                              journalCreateBloc: _journalCreateBloc,
                              from: 'SubJournalCreateScreen',
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

class InputDateBar extends StatelessWidget {
  const InputDateBar({
    Key key,
    @required JournalCreateBloc journalCreateBloc,
    @required this.state,
  })  : _journalCreateBloc = journalCreateBloc,
        super(key: key);

  final JournalCreateBloc _journalCreateBloc;
  final JournalCreateState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Text(
              '${DateFormat('yMMMMEEEEd', 'ko').format(state.selectedDate.toDate())}',
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
                  initialDate: state.selectedDate.toDate(),
                  firstDate: DateTime(2015, 1),
                  lastDate: DateTime(2100),
                  helpText: '날짜 선택',
                  locale: Locale('ko', 'KO'),
                );

                if (picked != null && picked != state.selectedDate.toDate()) {
                  _journalCreateBloc.add(
                      DateSelected(selectedDate: Timestamp.fromDate(picked)));
                }
              }),
        ],
      ),
    );
  }
}

class InputTitleBar extends StatelessWidget {
  const InputTitleBar({
    Key key,
    @required JournalCreateBloc journalCreateBloc,
    @required this.state,
    @required this.titleController,
  })  : _journalCreateBloc = journalCreateBloc,
        super(key: key);

  final JournalCreateBloc _journalCreateBloc;
  final JournalCreateState state;
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
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
            controller: titleController,
            onChanged: (title) {
              _journalCreateBloc.add(TitleChanged(title: title));
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
}

class InputActivityBar extends StatefulWidget {
  const InputActivityBar({
    Key key,
    @required this.state,
    @required JournalCreateBloc journalCreateBloc,
  })  : _journalCreateBloc = journalCreateBloc,
        super(key: key);

  final JournalCreateBloc _journalCreateBloc;
  final JournalCreateState state;

  @override
  _InputActivityBarState createState() => _InputActivityBarState();
}

class _InputActivityBarState extends State<InputActivityBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Text('일일 활동내역 입력', style: Theme.of(context).textTheme.headline5),
          Spacer(),
          TextButton(
            onPressed: () {
              mainBottomSheet(context);
            },
            child: Text(
              '추가',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 18.0, color: Color(0xb3000000)),
            ),
          )
        ],
      ),
    );
  }

  void mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext context) {
          return BlocProvider<JournalCreateBloc>.value(
            value: widget._journalCreateBloc,
            child: MyBottomSheet(),
          );
        });
  }
}

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  JournalCreateBloc _journalCreateBloc;

  @override
  void initState() {
    super.initState();
    _journalCreateBloc = BlocProvider.of<JournalCreateBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalCreateBloc, JournalCreateState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                  top: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        _journalCreateBloc.add(CategoryChanged(category: -1));
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '취소',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                  TextButton(
                      onPressed: state.category == -1
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BlocProvider<JournalCreateBloc>.value(
                                              value: _journalCreateBloc,
                                              child:
                                                  SubJournalInputActivityScreen())));
                            },
                      child: Text('완료',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: state.category == -1
                                  ? Color(0x4D000000)
                                  : Color(0xff000000)))),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Wrap(
                  children: journalCategory.map((Map<String, dynamic> item) {
                return categoryItem(item['name'], item['id'], context, state);
              }).toList()),
            ),
          ],
        );
      },
    );
  }

  Widget categoryItem(String buttonText, int id, BuildContext context,
      JournalCreateState state) {
    Color isButtonSelected;
    if (state.category != null && state.category == id) {
      isButtonSelected = Theme.of(context).primaryColor;
      print(state.category);
    } else {
      isButtonSelected = Color(0x4D000000);
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.4827,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 15.0),
          child: InkWell(
            onTap: () {
              _journalCreateBloc.add(CategoryChanged(
                  category: getJournalCategoryId(name: buttonText)));
            },
            child: Ink(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              width: MediaQuery.of(context).size.width * 0.349,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: isButtonSelected,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0.0, 4.0),
                      spreadRadius: 0.0,
                      blurRadius: 4.0,
                    )
                  ]),
              child: Center(
                child: Text(
                  buttonText,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: isButtonSelected),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddPictureBar extends StatelessWidget {
  const AddPictureBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? Row(
                      children: [
                        SizedBox(
                          width: defaultPadding,
                        ),
                        Center(
                          child: InkWell(
                              onTap: () {},
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
                        ),
                      ],
                    )
                  : Container();
            },
          ),
        ),
      ],
    );
  }
}

class AddProgressBar extends StatelessWidget {
  const AddProgressBar({
    Key key,
    @required this.textFieldBorderColor,
    @required ScrollController scrollController,
    @required FocusNode focusNode,
    @required JournalCreateBloc journalCreateBloc,
    @required this.state,
    @required this.contentController,
  })  : _scrollController = scrollController,
        _focusNode = focusNode,
        _journalCreateBloc = journalCreateBloc,
        super(key: key);

  final Color textFieldBorderColor;
  final ScrollController _scrollController;
  final FocusNode _focusNode;
  final JournalCreateBloc _journalCreateBloc;
  final JournalCreateState state;
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, bottom: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('과정 기록', style: Theme.of(context).textTheme.headline5),
          SizedBox(
            height: 15.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: textFieldBorderColor,
              ),
            ),
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: TextField(
                controller: contentController,
                focusNode: _focusNode,
                minLines: null,
                maxLines: 8,
                scrollPadding: EdgeInsets.zero,
                style: Theme.of(context).textTheme.bodyText1,
                scrollController: _scrollController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  isDense: true,
                  hintText: '내용을 입력해주세요',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18.0, color: Color(0x2C000000)),
                  border: InputBorder.none,
                ),
                onChanged: (content) {
                  _journalCreateBloc.add(ContentChanged(content: content));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String _title;

  CustomBottomButton({Key key, VoidCallback onPressed, @required String title})
      : _onPressed = onPressed,
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.086,
      child: ElevatedButton(
        child: Text(
          _title ?? '다음',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 20.0, color: Theme.of(context).colorScheme.onPrimary),
        ),
        onPressed: _onPressed,
      ),
    );
  }
}
