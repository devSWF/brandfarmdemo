import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_home/fm_home_event.dart';
import 'package:BrandFarm/blocs/fm_notification/bloc.dart';
import 'package:BrandFarm/blocs/plan/plan_bloc.dart';
import 'package:BrandFarm/blocs/plan/plan_state.dart';
import 'package:BrandFarm/fm_screens/notification/write_notice_screen.dart';
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
  PlanBloc _fmPlanBloc;
  FMHomeBloc _fmHomeBloc;
  FMNotificationBloc _fmNotificationBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _fmPlanBloc = BlocProvider.of<PlanBloc>(context);
    _fmHomeBloc = BlocProvider.of<FMHomeBloc>(context);
    _fmNotificationBloc = BlocProvider.of<FMNotificationBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanBloc, PlanState>(
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
                        CreateAnnouncement(
                          onPressed: () async {
                            await _showMyDialog();
                          },
                        ),
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
                        BlocProvider.value(
                          value: _fmHomeBloc,
                          child: Comments(
                            onPressed1: () {
                              _fmHomeBloc.add(SetPageIndex(index: 1));
                              _fmHomeBloc.add(SetSubPageIndex(index: 1));
                            },
                            onPressed2: () {
                              _fmHomeBloc.add(SetPageIndex(index: 2));
                              _fmHomeBloc.add(SetSubPageIndex(index: 1));
                            },
                            onPressed3: () {
                              _fmHomeBloc.add(SetPageIndex(index: 4));
                              _fmHomeBloc.add(SetSubPageIndex(index: 1));
                            },
                            onPressed4: () {
                              _fmHomeBloc.add(SetPageIndex(index: 5));
                              _fmHomeBloc.add(SetSubPageIndex(index: 1));
                            },
                            onPressed5: () {
                              _fmHomeBloc.add(SetPageIndex(index: 5));
                              _fmHomeBloc.add(SetSubPageIndex(index: 1));
                            },
                          ),
                        ),
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

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _fmNotificationBloc,
            child: WriteNoticeScreen(),
          );
        });
  }
}
