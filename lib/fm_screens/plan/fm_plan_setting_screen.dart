import 'package:flutter/material.dart';

class FMPlanSettingScreen extends StatefulWidget {
  @override
  _FMPlanSettingScreenState createState() => _FMPlanSettingScreenState();
}

class _FMPlanSettingScreenState extends State<FMPlanSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: Center(
        child: Container(
          height: 500,
          width: 814,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category, color: Colors.grey, size: 100,),
              SizedBox(height: 10,),
              Text('아직 준비중에 있습니다',
                style: Theme.of(context).textTheme.headline3.copyWith(
                  color: Colors.grey,
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
