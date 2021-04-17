
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OMHomeScreen extends StatefulWidget {
  @override
  _OMHomeScreenState createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<OMHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: _appBar(context: context),
      body: LayoutBuilder(
        builder: (context, constraints){
          if(constraints.maxWidth>=1000){
            return Center(
              child: Text('큰 화 면'),
            );
          }else{
            return Center(
              child: Text('작 은 화 면'),
            );
          }
        },
      ),
    );
  }

  Widget _appBar({BuildContext context}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        elevation: 1,
        title: Center(
          child: Row(
            children: [
              Image.asset('assets/fm_home_logo.png'),
              SizedBox(
                width: 114,
              ),
              _appBarNotification(context: context),
            ],
          ),
        ),
      ),
    );
  }
  Widget _appBarNotification({BuildContext context}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(width: 1, color: Color(0xFFBCBCBC)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFDD015),
          ),
          SizedBox(
            width: 13,
          ),
          Text(
            '날씨가 아직 춥습니다. 매니저분들 모두 농작물 관리에 주의해 주시길 바랍니다',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
