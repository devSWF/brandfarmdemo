import 'package:BrandFarm/blocs/authentication/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMLogoutScreen extends StatefulWidget {
  @override
  _FMLogoutScreenState createState() => _FMLogoutScreenState();
}

class _FMLogoutScreenState extends State<FMLogoutScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 130,
        width: 160,
        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text('로그아웃 하시겠습니까?',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.black,
                ),),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                  ),
                  child: Text('취소',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                    onPressed: (){
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        AuthenticationLoggedOut(),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
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
