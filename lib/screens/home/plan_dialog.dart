import 'package:BrandFarm/blocs/home/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanDialog extends StatefulWidget {
  @override
  _PlanDialogState createState() => _PlanDialogState();
}

class _PlanDialogState extends State<PlanDialog> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
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
            Text('새로운 계획이 있습니다.',
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
                // ElevatedButton(
                //   onPressed: (){
                //     _homeBloc.add(UpdatePlanState());
                //     Navigator.pop(context);
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.grey[300],
                //   ),
                //   child: Text('취소',
                //     style: Theme.of(context).textTheme.bodyText1.copyWith(
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),),
                // ),
                // SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: (){
                    _homeBloc.add(UpdatePlanState());
                    _homeBloc.add(GetHomePlanList());
                    _homeBloc.add(SortPlanList());
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
