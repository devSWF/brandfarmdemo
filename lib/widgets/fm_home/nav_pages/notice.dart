import 'package:BrandFarm/models/fm_home/fm_home_model.dart';
import 'package:flutter/material.dart';

class Notice extends StatefulWidget {
  FMHomeRecentUpdates obj;
  Notice({Key key, @required this.obj}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 130,
        width: 160,
        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text('새로운 알림이 있습니다.',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.black,
              ),),
            // Text('확인하시겠습니까?',
            //   style: Theme.of(context).textTheme.bodyText1.copyWith(
            //     color: Colors.black,
            //   ),),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('확인',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
