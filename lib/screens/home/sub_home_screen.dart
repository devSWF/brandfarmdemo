//blocs
import 'package:BrandFarm/blocs/home/bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_event.dart';
import 'package:BrandFarm/blocs/weather/bloc.dart';
import 'package:BrandFarm/screens/home/notification_dialog.dart';
import 'package:BrandFarm/screens/notification/notification_list_screen.dart';
import 'package:BrandFarm/screens/setting/setting_screen.dart';
import 'package:BrandFarm/utils/themes/constants.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_announce_bar.dart';
//widgets
import 'package:BrandFarm/widgets/sub_home/sub_home_appbar.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_calendar.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_fab.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_greeting_bar.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_to_do_widget.dart';
import 'package:BrandFarm/widgets/sub_home/sub_home_weather_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    _homeBloc.add(CheckFcmToken());
    _homeBloc.add(GetHomePlanList());
    _homeBloc.add(SortPlanList());
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _notificationBloc.add(GetNotificationList());
    _weatherBloc = BlocProvider.of<WeatherBloc>(context);
    _weatherBloc.add(GetWeatherInfo());
    getMessage();
  }

  void getMessage() {
    // app을 terminated 상태에서 열었을때 실행
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('Handling a background message ${message.messageId}');
      }
      refresh();
    });

    // app이 <foreground>열려있일때 실행
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      _showNotificationDialog();
    });

    // app이 running on background 상태에서 다시 열렸을때 실행
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(
          'Handling onMessageOpenedApp.listener message ${message.messageId}');
      refresh();
    });

    // // app이 background or terminated 상태에서 실행
    // FirebaseMessaging.onBackgroundMessage((message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   refresh();
    // });
  }

  void refresh() {
    _notificationBloc.add(LoadNotification());
    _homeBloc.add(GetHomePlanList());
    _homeBloc.add(SortPlanList());
    _notificationBloc.add(GetNotificationList());
  }

  Future<void> _showNotificationDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeBloc,
              ),
              BlocProvider.value(
                value: _notificationBloc,
              ),
            ],
            child: NotificationDialog(),
          );
        });
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()));
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
                    BlocProvider.value(
                      value: _notificationBloc,
                      child: SubHomeAnnounceBar(),
                    ),
                    SizedBox(height: 14.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
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
