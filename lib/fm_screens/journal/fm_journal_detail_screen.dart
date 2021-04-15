import 'package:BrandFarm/blocs/fm_journal/fm_journal_bloc.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_event.dart';
import 'package:BrandFarm/blocs/fm_journal/fm_journal_state.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMJournalDetailScreen extends StatefulWidget {
  @override
  _FMJournalDetailScreenState createState() => _FMJournalDetailScreenState();
}

class _FMJournalDetailScreenState extends State<FMJournalDetailScreen> {
  FMJournalBloc _fmJournalBloc;
  TextEditingController _textEditingController;
  FocusNode _focusNode;

  // String weekday;
  String comment;

  @override
  void initState() {
    super.initState();
    _fmJournalBloc = BlocProvider.of<FMJournalBloc>(context);
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  String getDate({Timestamp date}) {
    DateTime dt =
        DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
    // setState(() {
    //   weekday = daysOfWeek(index: dt.weekday);
    // });
    return '${dt.year}년 ${dt.month}월 ${dt.day}일';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMJournalBloc, FMJournalState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.journal != null)
            ? GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                  _textEditingController.clear();
                },
                child: Container(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _title(state),
                              ],
                            ),
                            SizedBox(
                              height: 31,
                            ),
                            Divider(
                              height: 26,
                              thickness: 1,
                              color: Color(0xFFDFDFDF),
                            ),
                            _subtitle(state),
                            Divider(
                              height: 26,
                              thickness: 1,
                              color: Color(0xFFDFDFDF),
                            ),
                            SizedBox(
                              height: 33,
                            ),
                            _infoCard1(state),
                            Divider(
                              height: 84,
                              thickness: 1,
                              color: Color(0xFFDFDFDF),
                            ),
                            _infoCard1(state),
                            Divider(
                              height: 84,
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
                            _contents(state),
                            SizedBox(
                              height: 18,
                            ),
                            Container(
                              height: 31,
                              width: 75,
                              padding: EdgeInsets.fromLTRB(15, 7, 15, 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Color(0x80000000)),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: FittedBox(
                                child: Text(
                                  '댓글 ${state.journal.comments}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Color(0x80000000),
                                      ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 44,
                              thickness: 1,
                              color: Color(0xFFDFDFDF),
                            ),
                            _writeComment(state),
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
                                  _fmJournalBloc
                                      .add(ChangeScreen(navTo: 1, index: 0));
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
              )
            : LinearProgressIndicator();
      },
    );
  }

  Widget _title(FMJournalState state) {
    return Text(
      '${state.journal.title}',
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
    );
  }

  Widget _subtitle(FMJournalState state) {
    return Text(
      '${getDate(date: state.journal.date)} / ${getFieldName(state)} / 성장일지',
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Color(0x80000000),
          ),
    );
  }

  String getFieldName(FMJournalState state) {
    int index = state.fieldList.indexWhere((element) {
          return element.sfmid == state.journal.fid;
        }) ?? -1;

    String field = state.fieldList[index].name;
    return field;
  }

  Widget _infoCard1(FMJournalState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '출하정보',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color(0xB3000000),
                    ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Table(
          border: TableBorder.all(
            width: 1,
            color: Color(0xFF888888),
          ),
          columnWidths: {
            0: FixedColumnWidth(375),
            1: FixedColumnWidth(375),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              _infoCardItem(title: '출하작물', content: '딸기'),
              _infoCardItem(title: '출하숫자', content: '50 kg'),
            ]),
            TableRow(children: [
              _infoCardItem(title: '출하경로', content: '얄리리 얄랑셩 얄라리 얄라'),
              _infoCardItem(title: '등급', content: '특'),
            ]),
            TableRow(children: [
              _infoCardItem(title: '출하단위', content: '1'),
              _infoCardItem(title: '단위가격', content: '9000 원'),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _infoCardItem({String title, String content}) {
    return Container(
      height: 41,
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 55,
            ),
            Container(
              width: 60,
              child: Text(
                '${title}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color(0xB3000000),
                    ),
              ),
            ),
            SizedBox(
              width: 40,
            ),
            Text(
              '${content}',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Color(0xFF219653),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageList(FMJournalState state) {
    List<ImagePicture> pic = state.imageList.where((element) {
      return state.journal.jid == element.jid;
    }).toList();
    return (pic.isNotEmpty) ? Column(
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
    ) : Container();
  }

  Widget _contents(FMJournalState state) {
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
          '${state.journal.content}',
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
                backgroundImage: AssetImage('assets/strawberry.png'),
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
                  '김브팜',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Color(0x80000000),
                      ),
                ),
                Text(
                  '필드A',
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

  Widget _writeComment(FMJournalState state) {
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
              backgroundImage: AssetImage('assets/strawberry.png'),
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
              onSubmitted: (text) {},
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
