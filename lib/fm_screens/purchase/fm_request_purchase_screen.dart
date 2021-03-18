import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_bloc.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_state.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_purchase/fm_purchase_material_model.dart';
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
  Timestamp _currDate = Timestamp.now();
  DateTime now;
  TextEditingController _memoController;
  FocusNode _memoNode;
  String _memo;
  String _datetime;
  List<FMPurchaseMaterial> materialList;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    now = DateTime.fromMicrosecondsSinceEpoch(_currDate.microsecondsSinceEpoch);
    _datetime = _getDateTimeString(now);
    _memoController = TextEditingController();
    _memoNode = FocusNode();
    _memo = '';
    materialList = [
      FMPurchaseMaterial(
          num: 1,
          name: '',
          amount: '',
          unit: '',
          price: '',
          marketUrl: '',
          field: null),
    ];
  }

  String _getDateTimeString(DateTime now) {
    bool isBeforeNoon;
    String hhmm = DateFormat('h:mm').format(now);
    if(DateFormat('a').format(now) == 'AM') {
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
        return GestureDetector(
          onTap: () {
            _memoNode.unfocus();
          },
          child: Scaffold(
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
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: 747,
                        padding: EdgeInsets.fromLTRB(44, 39, 44, 30),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Color(0xFF15B85B),
                          ),
                        ),
                        child: Column(
                          children: [
                            _date(),
                            SizedBox(
                              height: 37,
                            ),
                            _material(context),
                            SizedBox(
                              height: 44,
                            ),
                            _writeMemo(),
                            SizedBox(
                              height: 27,
                            ),
                            _button(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _date() {
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
              '${_datetime}',
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

  Widget _material(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 666,
          child: ListView.builder(
              itemCount: materialList.length ?? 1,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '자재',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(
                      width: 44,
                    ),
                    _materialContent(materialList[index], index),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Widget _materialContent(FMPurchaseMaterial obj, int index) {
    return Container(
      height: 100,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _materialName(obj, index),
              SizedBox(height: 14,),
              _materialAmount(obj, index),
              SizedBox(height: 14,),
              _materialPrice(obj, index),
            ],
          ),
          SizedBox(width: 44,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _materialUrl(obj, index),
              SizedBox(height: 14,),
              _materialField(obj, index),
            ],
          ),
        ],
      ),
    );
  }

  Widget _materialName(FMPurchaseMaterial obj, int index) {
    return Row(
      children: [
        Container(
          height: 17,
          width: 37,
          child: Text('자재명',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Color(0x4D000000),
            ),
          ),
        ),
        SizedBox(width: 17,),
        Container(
          height: 23,
          width: 157,
          decoration: BoxDecoration(
            color: Color(0x0A000000),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onChanged: (text) {
              FMPurchaseMaterial changedVal = FMPurchaseMaterial(
                num: obj.num,
                name: text,
                amount: obj.amount,
                unit: obj.unit,
                price: obj.price,
                marketUrl: obj.marketUrl,
                field: obj.field,
              );
              setState(() {
                materialList.removeAt(index);
                materialList.insert(index, changedVal);
              });
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _materialAmount(FMPurchaseMaterial obj, int index) {
    return Row(
      children: [
        Container(
          height: 17,
          width: 37,
          child: Text('수량',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Color(0x4D000000),
            ),
          ),
        ),
        SizedBox(width: 17,),
        Container(
          height: 23,
          width: 81,
          decoration: BoxDecoration(
            color: Color(0x0A000000),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onChanged: (text) {
              FMPurchaseMaterial changedVal = FMPurchaseMaterial(
                num: obj.num,
                name: obj.name,
                amount: text,
                unit: obj.unit,
                price: obj.price,
                marketUrl: obj.marketUrl,
                field: obj.field,
              );
              setState(() {
                materialList.removeAt(index);
                materialList.insert(index, changedVal);
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _materialPrice(FMPurchaseMaterial obj, int index) {
    return Row(
      children: [
        Container(
          height: 17,
          width: 37,
          child: Text('가격',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Color(0x4D000000),
            ),
          ),
        ),
        SizedBox(width: 17,),
        Container(
          height: 23,
          width: 139,
          decoration: BoxDecoration(
            color: Color(0x0A000000),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onChanged: (text) {
              FMPurchaseMaterial changedVal = FMPurchaseMaterial(
                num: obj.num,
                name: obj.name,
                amount: obj.amount,
                unit: obj.unit,
                price: text,
                marketUrl: obj.marketUrl,
                field: obj.field,
              );
              setState(() {
                materialList.removeAt(index);
                materialList.insert(index, changedVal);
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _materialUrl(FMPurchaseMaterial obj, int index) {
    return Container(
      height: 23,
      width: 287,
      decoration: BoxDecoration(
        color: Color(0x0A000000),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        onChanged: (text) {
          FMPurchaseMaterial changedVal = FMPurchaseMaterial(
            num: obj.num,
            name: obj.name,
            amount: obj.amount,
            unit: obj.unit,
            price: obj.price,
            marketUrl: text,
            field: obj.field,
          );
          setState(() {
            materialList.removeAt(index);
            materialList.insert(index, changedVal);
          });
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '판매처 (판매처 링크)',
        ),
      ),
    );
  }

  Widget _materialField(FMPurchaseMaterial obj, int index) {
    return Row(
      children: [
        Container(
          height: 17,
          width: 37,
          child: Text('적용대상',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Color(0x4D000000),
            ),
          ),
        ),
        SizedBox(width: 17,),
        Container(
          height: 23,
          width: 139,
          decoration: BoxDecoration(
            color: Color(0x0A000000),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onChanged: (text) {
              FMPurchaseMaterial changedVal = FMPurchaseMaterial(
                num: obj.num,
                name: obj.name,
                amount: obj.amount,
                unit: obj.unit,
                price: obj.price,
                marketUrl: obj.marketUrl,
                field: obj.field,
              );
              setState(() {
                materialList.removeAt(index);
                materialList.insert(index, changedVal);
              });
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _writeMemo() {
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
            border: Border.all(width: 1, color: Color(0xFF15B85B),),
          ),
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: TextField(
            controller: _memoController,
            focusNode: _memoNode,
            onTap: () {
              _memoNode.requestFocus();
            },
            onChanged: (text) {
              _memo = text;
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
        onPressed: () {},
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
}
