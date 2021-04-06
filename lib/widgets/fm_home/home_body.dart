import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_bloc.dart';
import 'package:BrandFarm/blocs/fm_plan/fm_plan_state.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/widgets/fm_home/comments.dart';
import 'package:BrandFarm/widgets/fm_home/create_announcement.dart';
import 'package:BrandFarm/widgets/fm_home/plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatefulWidget {
  HomeBody({
    Key key,
  }) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  FMPlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<FMPlanBloc>(context);
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FMPlanBloc, FMPlanState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.fmHomeCalendarDateList.isNotEmpty)
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFEEEEEE),
                padding: EdgeInsets.fromLTRB(
                    defaultPadding, defaultPadding, defaultPadding, 0),
                child: Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        CreateAnnouncement(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: _fmPlanBloc,
                            ),
                            BlocProvider.value(
                              value: _fmHomeBloc,
                            ),
                          ],
                          child: Plan(),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Comments(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
