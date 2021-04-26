//blocs
import 'package:BrandFarm/blocs/home/bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_event.dart';
import 'package:BrandFarm/blocs/weather/bloc.dart';

import 'package:BrandFarm/screens/notification/notification_list_screen.dart';
import 'package:BrandFarm/screens/setting/setting_screen.dart';
import 'package:BrandFarm/utils/themes/constants.dart';

//widgets
import 'package:BrandFarm/widgets/sub_home/sub_home_appbar.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_calendar.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_fab.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_greeting_bar.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_to_do_widget.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_weather_widget.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_announce_bar.dart';
import 'package:flutter/cupertino.dart';

//flutters
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubHomeScreen extends StatefulWidget {
  const SubHomeScreen({
    Key key,
  }) : super(key: key);


  @override
  _SubHomeScreenState createState() => _SubHomeScreenState();
}

class _SubHomeScreenState extends State<SubHomeScreen> {
  WeatherBloc _weatherBloc;
  HomeBloc _homeBloc;
  NotificationBloc _notificationBloc;
  String name;
  int initialIndex;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(GetHomePlanList());
    _homeBloc.add(SortPlanList());
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _notificationBloc.add(GetNotificationList());
    _weatherBloc = BlocProvider.of<WeatherBloc>(context);
    _weatherBloc.add(GetWeatherInfo());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: _homeBloc,
        listener: (BuildContext context, HomeState state) {},
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state.selectedDate < 3) {
            initialIndex = 0;
          } else {
            initialIndex = state.selectedDate - 4;
          }
          return Scaffold(
              // appBar: SubHomeAppBar(
              //   notificationPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => BlocProvider.value(
              //             value: _notificationBloc,
              //           child: NotificationListScreen(),
              //         ),
              //       ),
              //     );
              //   },
              //   settingPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => SettingScreen()));
              //   },
              // ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: BlocProvider.value(
                  value: _notificationBloc,
                child: SubHomeAppbarWithState(
                  notificationPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: _notificationBloc,
                          child: NotificationListScreen(),
                        ),
                      ),
                    );
                  },
                  settingPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingScreen()));
                  },
                ),
              ),
            ),
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SubHomeGreetingBar(),
                    SizedBox(height: 38.0),
                    SubHomeAnnounceBar(),
                    SizedBox(height: 14.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: BlocProvider.value(
                        value: _weatherBloc,
                        child: SubHomeWeatherWidget(),
                      ),
                    ),
                    SizedBox(height: defaultPadding),
                    BlocProvider.value(
                      value: _homeBloc,
                      child: SubHomeCalendar(
                        initialIndex: initialIndex,
                      ),
                    ),
                    SizedBox(height: defaultPadding),
                    // WeatherToDoWidgetBar(
                    //   weatherBloc: _weatherBloc,
                    //   state: state,
                    // ),
                  ],
                ),
              ),
              floatingActionButton: SubHomeFAB());
        }));
  }
}


class WeatherToDoWidgetBar extends StatelessWidget {
  const WeatherToDoWidgetBar({
    Key key,
    @required WeatherBloc weatherBloc,
    @required this.state,
  })  : _weatherBloc = weatherBloc,
        super(key: key);

  final WeatherBloc _weatherBloc;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Expanded(
            flex: 187,
            child: BlocProvider.value(
              value: _weatherBloc,
              child: SubHomeWeatherWidget(),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
              flex: 146,
              child: SubHomeToDoWidget(
                state: state,
              ))
        ],
      ),
    );
  }
}

// //bloc
// import 'package:BrandFarm/blocs/home/bloc.dart';
// import 'package:BrandFarm/blocs/weather/bloc.dart';
// import 'package:BrandFarm/blocs/authentication/bloc.dart';
// import 'package:BrandFarm/screens/journal/journal_list_screen.dart';
// import 'package:animations/animations.dart';
// import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
// import 'package:quiver/time.dart';
//
// //screen
// import 'package:BrandFarm/layout/adaptive.dart';
// import 'package:BrandFarm/screens/field/field_detail_screen.dart';
//
// import 'package:BrandFarm/screens/notification/notification_list_screen.dart';
// import 'package:flutter/cupertino.dart';
//
// //flutter
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// //util
// import 'package:BrandFarm/utils/todays_date.dart';
//
// import 'package:BrandFarm/widgets/brandfarm_icons.dart';
// import 'package:BrandFarm/widgets/department_badge.dart';
//
// //plugin
// import 'package:badges/badges.dart';
// import 'fm_home_screen_widget.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//
// TextTheme textTheme;
// ColorScheme colorScheme;
//
// class SubHomeScreen extends StatefulWidget {
//   final String name;
//
//   SubHomeScreen({Key key, @required String name})
//       : this.name = name,
//         super(key: key);
//
//   @override
//   _SubHomeScreenState createState() => _SubHomeScreenState();
// }
//
// class _SubHomeScreenState extends State<SubHomeScreen> {
//   String name;
//   HomeBloc _homeBloc;
//   ScrollController _hideBottomNavController;
//
//   bool _isVisible;
//
//   @override
//   void initState() {
//     super.initState();
//     _homeBloc = BlocProvider.of<HomeBloc>(context);
//     this.name = widget.name;
//     _isVisible = true;
//     _hideBottomNavController = ScrollController();
//     _hideBottomNavController.addListener(
//       () {
//         if (_hideBottomNavController.position.userScrollDirection ==
//             ScrollDirection.reverse) {
//           if (_isVisible)
//             setState(() {
//               _isVisible = false;
//             });
//         }
//         if (_hideBottomNavController.position.userScrollDirection ==
//             ScrollDirection.forward) {
//           if (!_isVisible)
//             setState(() {
//               _isVisible = true;
//             });
//         }
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     colorScheme = Theme.of(context).colorScheme;
//     textTheme = Theme.of(context).textTheme;
//     final isDesktop = isDisplayDesktop(context);
//
//     return BlocListener(
//       cubit: _homeBloc,
//       listener: (BuildContext context, HomeState state) {},
//       child: BlocBuilder<HomeBloc, HomeState>(
//         builder: (context, state) {
//           final List<Widget> _children = [
//             Home(
//               hideBottomNavController: _hideBottomNavController,
//               name: name,
//               homeState: state,
//             ),
//             Home(),
//             JournalListScreen(
//               scrollController: _hideBottomNavController,
//             ),
//             Container()
//           ];
//           if (isDesktop) {
//             return Scaffold(
//               appBar: AppBar(
//                 elevation: 0.0,
//                 leading: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.indigoAccent,
//                   ),
//                   onPressed: () {
//                     BlocProvider.of<AuthenticationBloc>(context).add(
//                       AuthenticationLoggedOut(),
//                     );
//                     Navigator.of(context).popUntil((route) => route.isFirst);
//                   },
//                 ),
//               ),
//               body: Center(
//                 child: Text('test page'),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 heroTag: 'home',
//                 child: Icon(
//                   Icons.add,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BlocProvider(
//                         create: (BuildContext context) =>
//                             WeatherBloc()..add(Wait_Fetch_Weather()),
//                         child: WeatherMain(),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           } else {
//             return Scaffold(
//               appBar: PreferredSize(
//                 preferredSize: Size.fromHeight(80.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             iconSize: 60.0,
//                             icon: Image.asset('assets/brandfarm.png'),
//                             onPressed: () {
//                               BlocProvider.of<AuthenticationBloc>(context).add(
//                                 AuthenticationLoggedOut(),
//                               );
//                               Navigator.of(context).popUntil((route) => route.isFirst);
//                             },
//                           ),
//                           Spacer(),
//                           Badge(
//                             position: BadgePosition.topEnd(top: 2, end: 8),
//                             badgeContent: Text(
//                               '2',
//                               style: TextStyle(color: Colors.white, fontSize: 14.0),
//                             ),
//                             child: IconButton(
//                               iconSize: 40.0,
//                               icon: Icon(
//                                 Icons.notifications_none_sharp,
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => NotificationListScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             padding: EdgeInsets.all(4.5),
//                           ),
//                           IconButton(
//                               iconSize: 35.0,
//                               icon: Icon(
//                                 BrandFarmIcons.settings,
//                               ),
//                               onPressed: () {})
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               body: PageTransitionSwitcher(
//                 transitionBuilder: (
//                   Widget child,
//                   Animation<double> animation,
//                   Animation<double> secondaryAnimation,
//                 ) {
//                   return FadeThroughTransition(
//                     animation: animation,
//                     secondaryAnimation: secondaryAnimation,
//                     child: child,
//                   );
//                 },
//                 child: _children[state.currentIndex],
//               ),
//               floatingActionButton: FloatingActionButton(
//                 heroTag: 'home',
//                 child: Icon(Icons.add),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BlocProvider(
//                         create: (BuildContext context) =>
//                             WeatherBloc()..add(Wait_Fetch_Weather()),
//                         child: WeatherMain(),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               bottomNavigationBar: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 height: _isVisible ? 56.0 : 0.0,
//                 child: Wrap(
//                   children: [
//                     BottomNavigationBar(
//                       type: BottomNavigationBarType.fixed,
//                       currentIndex: state.currentIndex,
//                       backgroundColor: colorScheme.surface,
//                       selectedItemColor: colorScheme.onSurface,
//                       unselectedItemColor:
//                           colorScheme.onSurface.withOpacity(.60),
//                       selectedLabelStyle: textTheme.caption,
//                       unselectedLabelStyle: textTheme.caption,
//                       onTap: (value) {
//                         _homeBloc.add(BottomNavBarClicked(index: value));
//                       },
//                       items: [
//                         BottomNavigationBarItem(
//                           label: '',
//                           icon: Icon(CupertinoIcons.home),
//                         ),
//                         BottomNavigationBarItem(
//                           label: '',
//                           icon: Icon(CupertinoIcons.graph_circle),
//                         ),
//                         BottomNavigationBarItem(
//                           label: '',
//                           icon: Icon(Icons.note_outlined),
//                         ),
//                         BottomNavigationBarItem(
//                           label: '',
//                           icon: Icon(CupertinoIcons.person_alt_circle),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class Home extends StatelessWidget {
//   Home({this.hideBottomNavController, this.name, this.homeState});
//
//   final HomeState homeState;
//   final ScrollController hideBottomNavController;
//   final String name;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       physics: ClampingScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       controller: hideBottomNavController,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '$year년 $month월 $day일 $weekday',
//                   style: textTheme.bodyText2,
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     DepartmentBadge(
//                       department: 'field',
//                     ),
//                     SizedBox(
//                       width: 4.0,
//                     ),
//                     Text('$name', style: textTheme.headline3),
//                     Text(' 님, 안녕하세요',
//                         style: textTheme.headline6)
//                   ],
//                 )
//               ],
//             ),
//             Spacer(),
//             Container(
//               decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
//                 BoxShadow(
//                   color: Color(0xffbfbfbf),
//                   offset: Offset(0.0, 4.0),
//                   spreadRadius: 2.0,
//                   blurRadius: 4.0,
//                 )
//               ]),
//               child: CircleAvatar(
//                   radius: 34.0,
//                   backgroundImage: NetworkImage(
//                       'https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70')),
//             )
//           ],
//         ),
//         SizedBox(height: 32.0),
//         _Announce(),
//         SizedBox(
//           height: 17,
//         ),
//         _HomeCalendar(
//           homeState: homeState,
//         ),
//         SizedBox(
//           height: 19.0,
//         ),
//         FMHomeScreenWidget(),
//       ],
//     );
//   }
// }
//
// class _Announce extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(11.5), color: Color(0xfff5f5f5)),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
//         child: Row(
//           children: [
//             Icon(
//               Icons.error_outline_rounded,
//               color: Color(0xfffdd015),
//             ),
//             SizedBox(
//               width: 7.0,
//             ),
//             Expanded(
//               child: Text(
//                 '$month/$day - 안전에 유의하시길 당부드립니다.',
//                 style: textTheme
//                     .overline
//                     .copyWith(color: Color(0xff8b8b8b)),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _HomeCalendar extends StatelessWidget {
//   final HomeState homeState;
//
//   _HomeCalendar({this.homeState});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14.0),
//             border: Border.all(color: Theme.of(context).dividerColor)),
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 9.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 11.0),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(right: 6.0),
//                       child: Image(
//                         width: 17.0,
//                         height: 21.0,
//                         image: AssetImage('assets/brandfarm.png'),
//                       ),
//                     ),
//                     Text('캘린더', style: textTheme.headline5),
//                     Spacer(),
//                     Icon(
//                       CupertinoIcons.calendar,
//                       color: Color(0xff878787),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 9.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                       color: Color(0xff878787),
//                       icon: Icon(Icons.keyboard_arrow_left_sharp),
//                       onPressed: () {}),
//                   Text(
//                     '$month월',
//                     style: textTheme.headline6,
//                   ),
//                   IconButton(
//                       color: Color(0xff878787),
//                       icon: Icon(Icons.keyboard_arrow_right_sharp),
//                       onPressed: () {}),
//                 ],
//               ),
//               SizedBox(
//                 height: 17.0,
//               ),
//               CalendarDateBuilder(
//                 homeState: homeState,
//               ),
//               SizedBox(
//                 height: 31.0,
//               ),
//               Divider(),
//               Padding(
//                 padding: EdgeInsets.only(left: 17.0, right: 13.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       '메모   ',
//                       style: textTheme.headline5,
//                     ),
//                     Text(
//                       '1',
//                       style: textTheme
//                           .headline5
//                           .copyWith(color: Theme.of(context).primaryColor),
//                     ),
//                     Spacer(),
//                     Icon(
//                       Icons.keyboard_arrow_down_sharp,
//                       color: colorScheme.secondary,
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }
//
// class CalendarDateBuilder extends StatelessWidget {
//   final HomeState homeState;
//
//   CalendarDateBuilder({this.homeState});
//
//   final ItemScrollController _controllerDay = ItemScrollController();
//   int initialIndex;
//   Color tapColor;
//
//   @override
//   Widget build(BuildContext context) {
//     if (homeState.dayState < 3) {
//       initialIndex = homeState.dayState;
//     } else {
//       initialIndex = homeState.dayState - 4;
//     }
//
//     return Container(
//       height: 63.0,
//       child: ScrollablePositionedList.builder(
//           itemScrollController: _controllerDay,
//           initialScrollIndex: initialIndex,
//           initialAlignment: 0,
//           scrollDirection: Axis.horizontal,
//           itemCount: daysInMonth(homeState.yearState, homeState.monthState),
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {},
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 3),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   color: (index + 1 == homeState.dayState)
//                       ? Theme.of(context).primaryColor
//                       : Colors.white,
//                 ),
//                 child: Padding(
//                     padding:
//                         EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           DateFormat('E').format(DateTime(homeState.yearState,
//                               homeState.monthState, index + 1)),
//                           style: (index + 1 == homeState.dayState)
//                               ? Theme.of(context)
//                                   .textTheme
//                                   .bodyText2
//                                   .copyWith(color: Colors.white)
//                               : textTheme.bodyText2.copyWith(
//                                   color: Theme.of(context).dividerColor),
//                         ),
//                         SizedBox(
//                           height: 5.0,
//                         ),
//                         Text(
//                           '${index + 1}',
//                           style: (index + 1 == homeState.dayState)
//                               ? Theme.of(context)
//                                   .textTheme
//                                   .subtitle1
//                                   .copyWith(color: Colors.white)
//                               : textTheme.subtitle1,
//                         ),
//                       ],
//                     )),
//               ),
//             );
//           }),
//     );
//   }
// // CalendarDateBuilder({this.onPressed});
//
// // final VoidCallback onPressed;
//
// // int _year = int.parse('$year');
// // int _month = int.parse('$month');
// // int DOM = daysInMonth(2020, 12);
// //
// // @override
// // Widget build(BuildContext context) {
// //   return InkWell(
// //     onTap: onPressed,
// //     child: Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(8.0),
// //         color: Theme.of(context).primaryColor,
// //       ),
// //       child: Padding(
// //           padding: EdgeInsets.all(8.0),
// //           child: Column(
// //             children: [
// //               Text(
// //                 '$engWeekday',
// //                 style: Theme.of(context)
// //                     .textTheme
// //                     .bodyText2
// //                     .copyWith(color: Colors.white),
// //               ),
// //               SizedBox(
// //                 height: 5.0,
// //               ),
// //               Text(
// //                 '$day',
// //                 style: Theme.of(context)
// //                     .textTheme
// //                     .subtitle1
// //                     .copyWith(color: Colors.white),
// //               ),
// //             ],
// //           )),
// //     ),
// //   );
// // }
// }
