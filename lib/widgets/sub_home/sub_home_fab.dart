import 'package:BrandFarm/blocs/journal/bloc.dart';
import 'package:BrandFarm/blocs/journal_create/bloc.dart';
import 'package:BrandFarm/blocs/journal_issue_create/journal_issue_create_bloc.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_issue_create_screen.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_list_screen.dart';
import 'package:BrandFarm/screens/sub_journal/sub_journal_create_screen.dart';
import 'package:BrandFarm/widgets/speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SubHomeFAB extends StatelessWidget {
  const SubHomeFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      onOpen: () {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ));
      },
      onClose: () {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ));
      },
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      overlayColor: Colors.black,
      overlayOpacity: 0.7,
      children: [
        SpeedDialChild(
          child: SvgPicture.asset('assets/svg_icon/list_icon.svg',
              width: 24, fit: BoxFit.none),
          backgroundColor: Colors.white,
          labelWidget: Text(
            '일지목록',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        create: (BuildContext context) => JournalBloc(),
                        child: JournalListScreen(),
                      )),
            );
          },
        ),
        SpeedDialChild(
          child: SvgPicture.asset(
            'assets/svg_icon/grow_icon.svg',
            width: 24,
            fit: BoxFit.none,
          ),
          backgroundColor: Colors.white,
          labelWidget: Text(
            '성장일지',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (BuildContext context) => JournalCreateBloc(),
                          child: SubJournalCreateScreen(),
                        )));
          },
        ),
        SpeedDialChild(
          child: SvgPicture.asset('assets/svg_icon/issue_icon.svg',
              width: 24, fit: BoxFit.none),
          backgroundColor: Colors.white,
          labelWidget: Text(
            '이슈일지',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (BuildContext context) =>
                              JournalIssueCreateBloc(),
                          child: SubJournalIssueCreateScreen(),
                        )));
          },
        ),
      ],
    );
  }
}
