import 'package:BrandFarm/blocs/fm_purchase/bloc.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_bloc.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FMPurchaseDetailScreen extends StatefulWidget {
  @override
  _FMPurchaseDetailScreenState createState() => _FMPurchaseDetailScreenState();
}

class _FMPurchaseDetailScreenState extends State<FMPurchaseDetailScreen> {
  FMPurchaseBloc _fmPurchaseBloc;

  @override
  void initState() {
    super.initState();
    _fmPurchaseBloc = BlocProvider.of<FMPurchaseBloc>(context);
    _fmPurchaseBloc.add(MarkAsRead());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPurchaseBloc, FMPurchaseState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.product != null)
            ? AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: SingleChildScrollView(
                  child: Container(
                    height: 700, // 349
                    width: 452, // 452
                    padding: EdgeInsets.fromLTRB(29, 6, 5, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _closeButton(),
                        _detailInfo(state),
                        SizedBox(
                          height: 25,
                        ),
                        _requestInfo(state),
                        SizedBox(
                          height: 25,
                        ),
                        _officeComment(state),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : LinearProgressIndicator();
      },
    );
  }

  Widget _closeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 7,
        ),
      ],
    );
  }

  Widget _detailInfo(FMPurchaseState state) {
    String reqDate = (state.product.requestDate != null)
        ? DateFormat('yyyy-MM-dd').format(state.product.requestDate.toDate())
        : '--';
    String recDate = (state.product.receiveDate != null)
        ? DateFormat('yyyy-MM-dd').format(state.product.receiveDate.toDate())
        : '--';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 29, 0),
      child: Container(
        // height: 127, // 127
        width: double.infinity, // 394
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFF15B85B)),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.fromLTRB(17, 17, 14, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 60,
                        child: Text(
                          '신청일자',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(width: 14,),
                    Container(
                        width: 148,
                        child: Text(
                          '${reqDate}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 60,
                        child: Text(
                          '자재명(수량)',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(width: 14,),
                    Container(
                        width: 148,
                        child: Text(
                          '${state.product.productName}(${state.product.amount}EA)',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 60,
                        child: Text(
                          '신청인',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(width: 14,),
                    Container(
                        width: 148,
                        child: Text(
                          '${state.product.requester}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 50,
                        child: Text(
                          '수령일자',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(width: 14,),
                    Container(
                        child: Text(
                          '${recDate}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 50,
                        child: Text(
                          '상태',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(width: 14,),
                    Container( // 미처리: 1 ; 승인: 2 ; 대기: 3 ; 완료: 4
                        child: Text(
                          '${_waitingState(state.product.waitingState)}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 50,
                        child: Text(
                          '수령인',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(width: 14,),
                    Container(
                        child: Text(
                          '${state.product.receiver}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _waitingState(int state) {
    switch(state) {
      case 1 : {
        return '미처리';
      } break;
      case 2 : {
        return '승인';
      } break;
      case 3 : {
        return '대기';
      } break;
      case 4 : {
        return '완료';
      } break;
    }
  }

  Widget _requestInfo(FMPurchaseState state) {
    return Container(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              '요청사항',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
            ),
          ),
          Divider(
            height: 14,
            thickness: 1,
            color: Color(0xFFDCDCDC),
          ),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              '${state.product.memo}',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF4E4E4E),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _officeComment(FMPurchaseState state) {
    return Container(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              '관리자 검토내용',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
            ),
          ),
          Divider(
            height: 14,
            thickness: 1,
            color: Color(0xFFDCDCDC),
          ),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              '${state.product.officeReply}',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF4E4E4E),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
