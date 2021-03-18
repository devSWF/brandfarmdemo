import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FMPurchaseDetailScreen extends StatefulWidget {
  @override
  _FMPurchaseDetailScreenState createState() => _FMPurchaseDetailScreenState();
}

class _FMPurchaseDetailScreenState extends State<FMPurchaseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 349,
        width: 452,
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
            _detailInfo(),
            SizedBox(height: 25,),
            _requestInfo(),
            SizedBox(height: 25,),
            _officeComment(),
            SizedBox(height: 25,),
          ],
        ),
      ),
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

  Widget _detailInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 29, 0),
      child: Container(
        height: 127,
        width: 394,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFF15B85B)),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.fromLTRB(17, 17, 14, 14),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(width: 50, child: Text('신청일자',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10,
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(width: 50, child: Text('자재명(수량)',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10,
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(width: 50, child: Text('신청인',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10,
                      color: Colors.black,
                    ),)),
                ],
              ),
              SizedBox(width: 14,),
              Column(
                children: [
                  Container(width: 148, child: Text('2021-04-05',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(width: 148, child: Text('농약(20EA)',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(width: 148, child: Text('박브팜',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black,
                    ),)),
                ],
              ),
              Column(
                children: [
                  Container(width: 35, child: Text('수령일자',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10,
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(width: 35, child: Text('상태',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10,
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(width: 35, child: Text('수령인',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10,
                      color: Colors.black,
                    ),)),
                ],
              ),
              SizedBox(width: 15,),
              Column(
                children: [
                  Container(child: Text('--',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(child: Text('대기',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black,
                    ),)),
                  SizedBox(height: 14,),
                  Container(child: Text('김브팜(한동이네딸기농장)',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black,
                    ),)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requestInfo() {
    return Container(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text('요청사항',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),),
          ),
          Divider(height: 14, thickness: 1, color: Color(0xFFDCDCDC),),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text('얄리리 얄량셩 얄리리 얄라',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w200,
                color: Color(0xFF4E4E4E),
              ),),
          ),
        ],
      ),
    );
  }
  Widget _officeComment() {
    return Container(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text('관리자 검토내용',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),),
          ),
          Divider(height: 14, thickness: 1, color: Color(0xFFDCDCDC),),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text('얄리리 얄량셩 얄리리 얄라',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w200,
                color: Color(0xFF4E4E4E),
              ),),
          ),
        ],
      ),
    );
  }
}
