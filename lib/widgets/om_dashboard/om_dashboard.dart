import 'package:BrandFarm/blocs/om_home/bloc.dart';
import 'package:BrandFarm/blocs/om_notification/om_notification_bloc.dart';
import 'package:BrandFarm/om_screens/om_notification/om_write_notice_screen.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/widgets/fm_home/create_announcement.dart';
import 'package:BrandFarm/widgets/om_dashboard/om_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OMDashboard extends StatefulWidget {
  const OMDashboard({Key key}) : super(key: key);

  @override
  _OMDashboardState createState() => _OMDashboardState();
}

class _OMDashboardState extends State<OMDashboard> {
  OMHomeBloc _omHomeBloc;
  OMNotificationBloc _omNotificationBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _omHomeBloc = BlocProvider.of<OMHomeBloc>(context);
    _omNotificationBloc = BlocProvider.of<OMNotificationBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.fromLTRB(
          defaultPadding, defaultPadding, defaultPadding, 0),
      child: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: ListView(
          controller: _scrollController,
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
            OMComments(),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: _omNotificationBloc,
            child: OMWriteNoticeScreen(),
          );
        });
  }
}
