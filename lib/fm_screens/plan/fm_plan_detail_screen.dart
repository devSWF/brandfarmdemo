import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FMPlanDetailScreen extends StatefulWidget {
  @override
  _FMPlanDetailScreenState createState() => _FMPlanDetailScreenState();
}

class _FMPlanDetailScreenState extends State<FMPlanDetailScreen> {
  FMPlanBloc _fmPlanBloc;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${state.selectedDate.year}년 ${state.selectedDate.month}월 ${state.selectedDate.day}일',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),),
            SizedBox(height: 37,),
            _detailList(),
          ],
        );
      },
    );
  }

  Widget _detailList(){
    return Container();
  }
}
