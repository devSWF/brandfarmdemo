import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_bloc.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_event.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_state.dart';
import 'package:BrandFarm/models/fm_purchase/fm_purchase_model.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FMRequestPurchaseScreen extends StatefulWidget {
  @override
  _FMRequestPurchaseScreenState createState() =>
      _FMRequestPurchaseScreenState();
}

class _FMRequestPurchaseScreenState extends State<FMRequestPurchaseScreen> {
  FMPurchaseBloc _fmPurchaseBloc;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    _fmPurchaseBloc.add(LoadFMPurchase());
    _fmPurchaseBloc.add(SetInitialProductList());
  }

  String _getDateTimeString(Timestamp curr) {
    DateTime now =
        DateTime.fromMicrosecondsSinceEpoch(curr.microsecondsSinceEpoch);
    bool isBeforeNoon;
    String hhmm = DateFormat('h:mm').format(now);
    if (DateFormat('a').format(now) == 'AM') {
      isBeforeNoon = true;
    } else {
      isBeforeNoon = false;
    }
    return (isBeforeNoon)
        ? '${now.year}년 ${now.month}월 ${now.day}일 오전 ${hhmm}'
        : '${now.year}년 ${now.month}월 ${now.day}일 오후 ${hhmm}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPurchaseBloc, FMPurchaseState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (!state.isLoading) ? Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
              child: Container(
                width: 814,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(54, 40, 54, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '구매요청하기',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 25,
                            color: Colors.black,
                          ),
                    ),
                    Column(
                      children: List.generate(state.productList.length ?? 1, (index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 23,
                            ),
                            Container(
                              width: 747,
                              padding: EdgeInsets.fromLTRB(44, 39, 44, 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  width: 2,
                                  color: Color(0xFF15B85B),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _date(state),
                                  SizedBox(
                                    height: 37,
                                  ),
                                  _material(state, index),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _fmPurchaseBloc.add(SetAdditionalProduct());
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: Color(0xFF15B85B),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Color(0xFF15B85B),
                                size: 12,
                              ),
                              Text(
                                '자재 추가하기',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: Color(0xFF15B85B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 27,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _button(),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) : LinearProgressIndicator();
      },
    );
  }

  Widget _date(FMPurchaseState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '구매요청일자',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              '${_getDateTimeString(state.productList[0].requestDate)}',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF15B85B),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _material(FMPurchaseState state, int index) {
    return Container(
      // height: 100,
      width: 666,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '자재${index + 1}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 44,
              ),
              _materialContent(state, index),
            ],
          ),
          SizedBox(
            height: 44,
          ),
          _writeMemo(state, index),
        ],
      ),
    );
  }

  Widget _materialContent(FMPurchaseState state, int index) {
    return Container(
      // height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _materialName(index),
              SizedBox(
                height: 14,
              ),
              _materialAmount(index),
              SizedBox(
                height: 14,
              ),
              _materialPrice(index),
            ],
          ),
          SizedBox(
            width: 67,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _materialUrl(index),
              SizedBox(
                height: 14,
              ),
              _materialField(state, index),
            ],
          ),
        ],
      ),
    );
  }

  Widget _materialName(int index) {
    return Container(
      height: 23,
      width: 157,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color(0x0A000000),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        onChanged: (text) {
          _fmPurchaseBloc.add(UpdateProductName(index: index, name: text));
        },
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Colors.black,
            ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(9, 4, 0, 16),
          hintText: '자재명',
          hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Color(0x4D000000),
              ),
        ),
      ),
    );
  }

  Widget _materialAmount(int index) {
    return Container(
      height: 23,
      width: 157,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 23,
            width: 127,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Color(0x0A000000),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              onChanged: (text) {
                _fmPurchaseBloc.add(UpdateAmount(index: index, amount: text));
              },
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.black,
                  ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(9, 4, 0, 16),
                hintText: '수량',
                hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Color(0x4D000000),
                    ),
              ),
            ),
          ),
          Text(
            'EA',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget _materialPrice(int index) {
    return Container(
      height: 23,
      width: 157,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 23,
            width: 137,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Color(0x0A000000),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              onChanged: (text) {
                _fmPurchaseBloc.add(UpdatePrice(index: index, price: text));
              },
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.black,
                  ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(9, 4, 0, 16),
                hintText: '가격(택배비 포함)',
                hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Color(0x4D000000),
                    ),
              ),
            ),
          ),
          Text(
            '원',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget _materialUrl(int index) {
    return Container(
      height: 23,
      width: 310,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color(0x0A000000),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        onChanged: (text) {
          _fmPurchaseBloc.add(UpdateMarketUrl(index: index, url: text));
        },
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Colors.black,
            ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(9, 4, 0, 16),
          hintText: '판매처 (판매처 링크)',
          hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Color(0x4D000000),
              ),
        ),
      ),
    );
  }

  Widget _materialField(FMPurchaseState state, int index) {
    String field = (state.productList[index].fid != null)
        ? state.fieldList[state.fieldList.indexWhere((element) => element.fid == state.productList[index].fid)].name
        : '필드선택';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 17,
          width: 56,
          child: Text(
            '적용대상',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
          ),
        ),
        SizedBox(
          width: 14,
        ),
        Column(
          children: [
            InkResponse(
              onTap: () {
                _fmPurchaseBloc.add(UpdateFieldButtonState(index: index));
              },
              child: Container(
                height: 23,
                width: 150,
                padding: EdgeInsets.fromLTRB(9, 4, 9, 2),
                decoration: BoxDecoration(
                  color: Color(0x0A000000),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${field}',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Color(0x4D000000),
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Color(0x4D000000),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            (state.productList[index].isFieldSelectionButtonClicked)
                ? Column(
                    children: List.generate(state.fieldList.length, (field) {
                      return InkResponse(
                        onTap: (){
                          _fmPurchaseBloc.add(UpdateFieldName(index: index, field: field));
                        },
                        child: Container(
                          height: 23,
                          width: 150,
                          color: Color(0x0A000000),
                          padding: EdgeInsets.fromLTRB(9, 4, 9, 2),
                          child: Text(
                            '${state.fieldList[field].name}',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: Color(0x4D000000),
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }),
                  )
                : Container(),
          ],
        )
      ],
    );
  }

  Widget _writeMemo(FMPurchaseState state, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메모',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
        ),
        SizedBox(
          width: 44,
        ),
        Container(
          height: 95,
          width: 542,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Color(0xFF15B85B),
            ),
          ),
          padding: EdgeInsets.fromLTRB(9, 5, 0, 5),
          child: TextField(
            onChanged: (text) {
              _fmPurchaseBloc.add(UpdateMemo(index: index, memo: text));
            },
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black,
                ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _button() {
    return Container(
      width: 100,
      height: 31,
      decoration: BoxDecoration(
        color: Color(0xFF15B85B),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextButton(
        onPressed: () async {
          await _showCompleteDialog();
        },
        child: Text(
          '등록',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
    );
  }

  Future<void> _showCompleteDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmPurchaseBloc,
            child: PurchaseComplete(),
          );
        });
  }
}

class PurchaseComplete extends StatefulWidget {
  @override
  _PurchaseCompleteState createState() => _PurchaseCompleteState();
}

class _PurchaseCompleteState extends State<PurchaseComplete> {
  FMPurchaseBloc _fmPurchaseBloc;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPurchaseBloc, FMPurchaseState>(
      listener: (context, state) {},
      builder: (context, state) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              height: 203,
              width: 366,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(Icons.close, color: Colors.black,),
                              onPressed: (){
                                Navigator.pop(context);
                              }
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('구매사항 ',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Color(0xFF15B85B),
                                  ),),
                                Text('등록을 요청 하시겠습니까?',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.black,
                                  ),),
                              ],
                            ),
                            SizedBox(height: 54,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(right: 0, left: 0, bottom: 23, child: _button()),
                ],
              ),
            ),
          );
      },
    );
  }

  Widget _button() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 31,
              width: 97,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(0xFFB5B5B5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('취소',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),),
              ),
            ),
            SizedBox(width: 12,),
            Container(
              height: 31,
              width: 97,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(0xFF15B85B),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: (){
                  _fmPurchaseBloc.add(LoadFMPurchase());
                  _fmPurchaseBloc.add(CompletePurchase());
                  Navigator.pop(context);
                },
                child: Text('확인',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),),
              ),
            ),
          ],
        ),
        // SizedBox(height: 10,),
      ],
    );
  }
}

