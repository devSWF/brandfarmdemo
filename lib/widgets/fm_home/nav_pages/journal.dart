import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_state.dart';
import 'package:BrandFarm/models/comment/comment_model.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/journal/journal_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Journal extends StatefulWidget {
  int index;
  FMHomeState state;
  Journal({Key key, this.index, this.state}) : super(key: key);
  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  FMHomeBloc _fmHomeBloc;
  TextEditingController _textEditingController;
  TextEditingController _subTextEditingController;
  FocusNode _focusNode;
  FocusNode _subFocusNode;
  bool wroteComments;

  // String weekday;
  String comment;
  bool repeat;
  bool isComment;
  bool isSubComment;

  @override
  void initState() {
    super.initState();
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    if (!widget.state.recentUpdateList[widget.index].journal.isReadByFM) {
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
    wroteComments = false;
    repeat = true;
    isComment = false;
    isSubComment = false;
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
                              _infoCard(state),
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
              )
            : Scaffold(body: LinearProgressIndicator());
      },
    );
  }

  Widget _title(FMHomeState state) {
    return Text(
      '${state.recentUpdateList[widget.index].journal.title}',
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
    );
  }

  Widget _subtitle(FMHomeState state) {
    return Text(
      '${getDate(date: state.recentUpdateList[widget.index].journal.date)} / ${getFieldName(state)} / 성장일지',
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Color(0x80000000),
          ),
    );
  }

  String getFieldName(FMHomeState state) {
    int index = state.fieldList.indexWhere((element) {
          return element.fid ==
              state.recentUpdateList[widget.index].journal.fid;
        }) ??
        -1;

    String field = state.fieldList[index].name;
    return field;
  }

  Widget _infoCard(FMHomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // shipment
        // shipment
        // shipment
        (state.recentUpdateList[widget.index].journal.shipment != null &&
                state.recentUpdateList[widget.index].journal.shipment.length >
                    0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.shipment
                        .length, (index) {
                  return _shipment(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.shipment != null &&
                state.recentUpdateList[widget.index].journal.shipment.length >
                    0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // pesticide
        // pesticide
        // pesticide
        (state.recentUpdateList[widget.index].journal.pesticide != null &&
                state.recentUpdateList[widget.index].journal.pesticide.length >
                    0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.pesticide
                        .length, (index) {
                  return _pesticide(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.pesticide != null &&
                state.recentUpdateList[widget.index].journal.pesticide.length >
                    0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // planting
        // planting
        // planting
        (state.recentUpdateList[widget.index].journal.planting != null &&
                state.recentUpdateList[widget.index].journal.planting.length >
                    0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.planting
                        .length, (index) {
                  return _planting(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.planting != null &&
                state.recentUpdateList[widget.index].journal.planting.length >
                    0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // weeding
        // weeding
        // weeding
        (state.recentUpdateList[widget.index].journal.weeding != null &&
                state.recentUpdateList[widget.index].journal.weeding.length > 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.weeding.length,
                    (index) {
                  return _weeding(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.weeding != null &&
                state.recentUpdateList[widget.index].journal.weeding.length > 0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // workforce
        // workforce
        // workforce
        (state.recentUpdateList[widget.index].journal.workforce != null &&
                state.recentUpdateList[widget.index].journal.workforce.length >
                    0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.workforce
                        .length, (index) {
                  return _workforce(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.workforce != null &&
                state.recentUpdateList[widget.index].journal.workforce.length >
                    0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // fertilize
        // fertilize
        // fertilize
        (state.recentUpdateList[widget.index].journal.fertilize != null &&
                state.recentUpdateList[widget.index].journal.fertilize.length >
                    0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.fertilize
                        .length, (index) {
                  return _fertilize(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.fertilize != null &&
                state.recentUpdateList[widget.index].journal.fertilize.length >
                    0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // pest
        // pest
        // pest
        (state.recentUpdateList[widget.index].journal.pest != null &&
                state.recentUpdateList[widget.index].journal.pest.length > 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.pest.length,
                    (index) {
                  return _pest(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.pest != null &&
                state.recentUpdateList[widget.index].journal.pest.length > 0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // seeding
        // seeding
        // seeding
        (state.recentUpdateList[widget.index].journal.seeding != null &&
                state.recentUpdateList[widget.index].journal.seeding.length > 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.seeding.length,
                    (index) {
                  return _seeding(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.seeding != null &&
                state.recentUpdateList[widget.index].journal.seeding.length > 0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // watering
        // watering
        // watering
        (state.recentUpdateList[widget.index].journal.watering != null &&
                state.recentUpdateList[widget.index].journal.watering.length >
                    0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.watering
                        .length, (index) {
                  return _watering(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.watering != null &&
                state.recentUpdateList[widget.index].journal.watering.length >
                    0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
        // farming
        // farming
        // farming
        (state.recentUpdateList[widget.index].journal.farming != null &&
                state.recentUpdateList[widget.index].journal.farming.length > 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    state.recentUpdateList[widget.index].journal.farming.length,
                    (index) {
                  return _farming(state, index);
                }),
              )
            : Container(),
        (state.recentUpdateList[widget.index].journal.farming != null &&
                state.recentUpdateList[widget.index].journal.farming.length > 0)
            ? Divider(
                height: 84,
                thickness: 1,
                color: Color(0xFFDFDFDF),
              )
            : Container(),
      ],
    );
  }

  Widget _shipment(FMHomeState state, int index) {
    Shipment obj = state.recentUpdateList[widget.index].journal.shipment[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '출하정보 ${obj.index}',
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
              _infoCardItem(title: '출하작물', content: '${obj.shipmentPlant}'),
              _infoCardItem(
                  title: '출하숫자',
                  content: '${obj.shipmentAmount} ${obj.shipmentUnitSelect}'),
            ]),
            TableRow(children: [
              _infoCardItem(title: '출하경로', content: '${obj.shipmentPath}'),
              _infoCardItem(title: '등급', content: '${obj.shipmentGrade}'),
            ]),
            TableRow(children: [
              _infoCardItem(title: '출하단위', content: '${obj.shipmentUnit}'),
              _infoCardItem(title: '단위가격', content: '${obj.shipmentPrice} 원'),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _pesticide(FMHomeState state, int index) {
    Pesticide obj =
        state.recentUpdateList[widget.index].journal.pesticide[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '농약정보 ${obj.index}',
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
              _infoCardItem(
                  title: '자재이름', content: '${obj.pesticideMaterialName}'),
              _infoCardItem(
                  title: '면적',
                  content: '${obj.pesticideArea} ${obj.pesticideAreaUnit}'),
            ]),
            TableRow(children: [
              _infoCardItem(
                  title: '자재 사용량',
                  content:
                      '${obj.pesticideMaterialUse} ${obj.pesticideMaterialUnit}'),
              _infoCardItem(
                  title: '물 사용량',
                  content: '${obj.pesticideWater} ${obj.pesticideWaterUnit}'),
            ]),
            TableRow(children: [
              _infoCardItem(title: '살포방식', content: '${obj.pesticideMethod}'),
              _infoCardItem(title: '', content: ''),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _planting(FMHomeState state, int index) {
    Planting obj = state.recentUpdateList[widget.index].journal.planting[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '정식정보 ${obj.index}',
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
              _infoCardItem(title: '주수', content: '${obj.plantingCount}'),
              _infoCardItem(
                  title: '면적',
                  content: '${obj.plantingArea} ${obj.plantingAreaUnit}'),
            ]),
            TableRow(children: [
              _infoCardItem(title: '주당가격', content: '${obj.plantingPrice}'),
              _infoCardItem(title: '', content: ''),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _weeding(FMHomeState state, int index) {
    Weeding obj = state.recentUpdateList[widget.index].journal.weeding[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '제초정보 ${obj.index}',
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
              _infoCardItem(
                  title: '제초 작업 진행율',
                  content: '${obj.weedingProgress} ${obj.weedingUnit}'),
              _infoCardItem(title: '', content: ''),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _workforce(FMHomeState state, int index) {
    Workforce obj =
        state.recentUpdateList[widget.index].journal.workforce[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '인력투입정보 ${obj.index}',
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
              _infoCardItem(title: '참여인원', content: '${obj.workforceNum}'),
              _infoCardItem(
                  title: '인건비(1인당)', content: '${obj.workforcePrice} 원'),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _fertilize(FMHomeState state, int index) {
    Fertilize obj =
        state.recentUpdateList[widget.index].journal.fertilize[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '비료정보 ${obj.index}',
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
              _infoCardItem(
                  title: '자재이름', content: '${obj.fertilizerMaterialName}'),
              _infoCardItem(
                  title: '면적',
                  content: '${obj.fertilizerArea} ${obj.fertilizerAreaUnit}'),
            ]),
            TableRow(children: [
              _infoCardItem(
                  title: '자재 사용량',
                  content:
                      '${obj.fertilizerMaterialUse} ${obj.fertilizerMaterialUnit}'),
              _infoCardItem(
                  title: '물 사용량',
                  content: '${obj.fertilizerWater} ${obj.fertilizerWaterUnit}'),
            ]),
            TableRow(children: [
              _infoCardItem(title: '살포방식', content: '${obj.fertilizerMethod}'),
              _infoCardItem(title: '', content: ''),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _pest(FMHomeState state, int index) {
    Pest obj = state.recentUpdateList[widget.index].journal.pest[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '병, 해충정보 ${obj.index}',
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
              _infoCardItem(title: '종류', content: '${obj.pestKind}'),
              _infoCardItem(
                  title: '확산정도',
                  content: '${obj.spreadDegree} ${obj.spreadDegreeUnit}'),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _seeding(FMHomeState state, int index) {
    Seeding obj = state.recentUpdateList[widget.index].journal.seeding[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '파종정보 ${obj.index}',
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
              _infoCardItem(
                  title: '파종면적',
                  content: '${obj.seedingArea} ${obj.seedingAreaUnit}'),
              _infoCardItem(
                  title: '파종량',
                  content: '${obj.seedingAmount} ${obj.seedingAmountUnit}'),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _watering(FMHomeState state, int index) {
    Watering obj = state.recentUpdateList[widget.index].journal.watering[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '관수정보 ${obj.index}',
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
              _infoCardItem(
                  title: '총관수량',
                  content: '${obj.wateringAmount} ${obj.wateringAmountUnit}'),
              _infoCardItem(
                  title: '면적',
                  content: '${obj.wateringArea} ${obj.wateringAreaUnit}'),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _farming(FMHomeState state, int index) {
    Farming obj = state.recentUpdateList[widget.index].journal.farming[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                '경운정보 ${obj.index}',
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
              _infoCardItem(
                  title: '경운방법',
                  content: '${obj.farmingMethod} ${obj.farmingMethodUnit}'),
              _infoCardItem(
                  title: '면적',
                  content: '${obj.farmingArea} ${obj.farmingAreaUnit}'),
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
              width: 30,
            ),
            Container(
              width: 74,
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

  Widget _imageList(FMHomeState state) {
    List<ImagePicture> pic = state.picture.where((element) {
      return state.recentUpdateList[widget.index].journal.jid == element.jid;
    }).toList();
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

  Widget _contents(FMHomeState state) {
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
          '${state.recentUpdateList[widget.index].journal.content}',
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
                backgroundImage: (state.user.imgUrl.isNotEmpty)
                    ? NetworkImage(state.user.imgUrl)
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
              '댓글 ${state.recentUpdateList[widget.index].journal.comments}',
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
                  //         if (state
                  //             .clist[index].isWriteSubCommentClicked) {
                  //           _subFocusNode.unfocus();
                  //           _subTextEditingController.clear();
                  //         }
                  //         setState(() {
                  //           _fmJournalBloc.add(
                  //               ChangeJournalWriteReplyState(index: index));
                  //         });
                  //       },
                  //       child:
                  //           (!state.commentList[index].isWriteSubCommentClicked)
                  //               ? Text(
                  //                   '답글 달기',
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyText2
                  //                       .copyWith(
                  //                         fontSize: 12,
                  //                         color: Colors.grey,
                  //                       ),
                  //                 )
                  //               : Text(
                  //                   '취소',
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyText2
                  //                       .copyWith(
                  //                         fontSize: 12,
                  //                         color: Colors.grey,
                  //                       ),
                  //                 ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
          // (state.commentList[index].isWriteSubCommentClicked)
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
          //                   _fmJournalBloc
          //                       .add(ChangeJournalExpandState(index: index));
          //                 });
          //               },
          //               child: (!state.commentList[index].isExpanded)
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

  // Widget _writeReply({int index, FMHomeState state}) {
  //   return Container(
  //     child: Row(
  //       children: [
  //         Container(
  //           height: 42,
  //           width: 42,
  //           child: CircleAvatar(
  //             backgroundImage: (UserUtil.getUser().imgUrl.isNotEmpty)
  //                 ? CachedNetworkImageProvider(UserUtil.getUser().imgUrl)
  //                 : AssetImage('assets/profile.png'),
  //             radius: 42,
  //           ),
  //         ),
  //         SizedBox(
  //           width: 20,
  //         ),
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               height: 42,
  //               width: 589,
  //               child: TextField(
  //                 focusNode: _subFocusNode,
  //                 controller: _subTextEditingController,
  //                 keyboardType: TextInputType.text,
  //                 onTap: () {
  //                   _subFocusNode.requestFocus();
  //                 },
  //                 onChanged: (text) {
  //                   setState(() {
  //                     comment = text;
  //                   });
  //                 },
  //                 onSubmitted: (text) {
  //                   _fmJournalBloc
  //                       .add(WriteJournalReply(cmt: text, index: index));
  //                   setState(() {
  //                     repeat = true;
  //                     isSubComment = true;
  //                   });
  //                   _subFocusNode.unfocus();
  //                   _subTextEditingController.clear();
  //                 },
  //                 decoration: InputDecoration(
  //                     // border: InputBorder.none,
  //                     // contentPadding: EdgeInsets.zero,
  //                     // isDense: true,
  //                     hintText: '답글을 남겨주세요',
  //                     hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
  //                           fontWeight: FontWeight.w300,
  //                           color: Color(0x4D000000),
  //                         )),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _writeComment(FMJournalState state) {
  //   return Container(
  //     height: 78,
  //     padding: EdgeInsets.fromLTRB(12, 12, 12, 24),
  //     decoration: BoxDecoration(
  //       border: Border.all(width: 1, color: Color(0x80000000)),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           height: 42,
  //           width: 42,
  //           child: CircleAvatar(
  //             backgroundImage: (UserUtil.getUser().imgUrl.isNotEmpty)
  //                 ? CachedNetworkImageProvider(UserUtil.getUser().imgUrl)
  //                 : AssetImage('assets/profile.png'),
  //             radius: 46,
  //           ),
  //         ),
  //         SizedBox(
  //           width: 20,
  //         ),
  //         Expanded(
  //           child: TextField(
  //             focusNode: _focusNode,
  //             controller: _textEditingController,
  //             keyboardType: TextInputType.text,
  //             onTap: () {
  //               _focusNode.requestFocus();
  //             },
  //             onChanged: (text) {
  //               setState(() {
  //                 comment = text;
  //               });
  //             },
  //             onSubmitted: (text) {
  //               _fmJournalBloc.add(WriteJournalComment(
  //                 cmt: text,
  //               ));
  //               setState(() {
  //                 repeat = true;
  //                 isComment = true;
  //               });
  //               _focusNode.unfocus();
  //               _textEditingController.clear();
  //             },
  //             decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 contentPadding: EdgeInsets.zero,
  //                 isDense: true,
  //                 hintText: '댓글을 남겨주세요',
  //                 hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
  //                       fontWeight: FontWeight.w300,
  //                       color: Color(0x4D000000),
  //                     )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
