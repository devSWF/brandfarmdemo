//screens
import 'package:BrandFarm/blocs/fm_home/fm_home_bloc.dart';
import 'package:BrandFarm/blocs/fm_notification/bloc.dart';
import 'package:BrandFarm/blocs/plan/plan_bloc.dart';
import 'package:BrandFarm/blocs/purchase/purchase_bloc.dart';
import 'package:BrandFarm/blocs/notification/notification_bloc.dart';
import 'package:BrandFarm/blocs/weather/bloc.dart';
import 'package:BrandFarm/fm_screens/home/fm_home_screen.dart';
import 'package:BrandFarm/om_screens/home/om_home_screen.dart';
import 'package:BrandFarm/screens/home/sub_home_screen.dart';
import 'package:BrandFarm/screens/splash/splash_screen.dart';
import 'package:BrandFarm/screens/login/login_screen.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:BrandFarm/blocs/login/bloc.dart';
import 'blocs/home/bloc.dart';
import 'package:BrandFarm/blocs/authentication/bloc.dart';
import 'package:BrandFarm/blocs/blocObserver.dart';

//repository
import 'package:BrandFarm/repository/user/user_repository.dart';

//flutter firebase
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//util
import 'package:BrandFarm/utils/themes/farm_theme_data.dart';
import 'package:flutter/foundation.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
import 'blocs/om_home/om_home_bloc.dart';

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    App(),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;
  bool isDesktop;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    try {
      if ((defaultTargetPlatform == TargetPlatform.iOS) ||
          (defaultTargetPlatform == TargetPlatform.android)) {
        isDesktop = false;
      } else {
        isDesktop = true;
      }
    } catch (e) {
      isDesktop = true;
    }
    if (isDesktop) {
      _authenticationBloc.add(AuthenticationStarted());
    } else {
      Timer(Duration(seconds: 2), () {
        _authenticationBloc.add(AuthenticationStarted());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: null,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return BlocProvider.value(
      value: _authenticationBloc,
      child: MaterialApp(
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'EN'), // English
          const Locale('ko', 'KO'), // Korean
          // ... other locales the app supports
        ],

        debugShowCheckedModeBanner: false,
        theme: FarmThemeData.lightThemeData,
        // darkTheme: FarmThemeData.darkThemeData,
        // ThemeData(
        //   backgroundColor: Colors.white,
        //   primaryColor: Colors.black,
        //   primaryColorLight: Colors.white,
        //   accentColor: Colors.blue[600],
        //   appBarTheme: AppBarTheme(brightness: Brightness.light),
        // ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationSuccess) {
              if (UserUtil.getUser().position == 3) {
                return MultiBlocProvider(providers: [
                  BlocProvider<HomeBloc>(
                    create: (BuildContext context) => HomeBloc(),
                  ),
                  BlocProvider<WeatherBloc>(
                    create: (BuildContext context) => WeatherBloc(),
                  ),
                  BlocProvider<NotificationBloc>(
                    create: (BuildContext context) => NotificationBloc(),
                  ),
                ], child: SubHomeScreen());
              } else if (UserUtil.getUser().position == 2) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<PurchaseBloc>(
                      create: (BuildContext context) => PurchaseBloc(),
                    ),
                    BlocProvider<PlanBloc>(
                      create: (BuildContext context) => PlanBloc(),
                    ),
                    BlocProvider<FMHomeBloc>(
                      create: (BuildContext context) => FMHomeBloc(),
                    ),
                    BlocProvider<FMNotificationBloc>(
                      create: (BuildContext context) => FMNotificationBloc(),
                    ),
                  ],
                  child: FMHomeScreen(),
                );
              } else {
                return MultiBlocProvider(providers: [
                  BlocProvider<OMHomeBloc>(
                    create: (BuildContext context) => OMHomeBloc(),
                  )
                ], child: OMHomeScreen());
              }
              // return (UserUtil.getUser().position == 3)
              //     ? MultiBlocProvider(providers: [
              //         BlocProvider<HomeBloc>(
              //           create: (BuildContext context) => HomeBloc(),
              //         ),
              //         BlocProvider<WeatherBloc>(
              //           create: (BuildContext context) => WeatherBloc(),
              //         )
              //       ], child: SubHomeScreen())
              //     : FMHomeScreen();
            } else if (state is AuthenticationInitial && !isDesktop) {
              return SplashScreen(duration: 2);
            } else {
              return BlocProvider<LoginBloc>(
                create: (BuildContext context) =>
                    LoginBloc(userRepository: userRepository),
                child: LoginScreen(
                  userRepository: userRepository,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.distinct();
    super.dispose();
  }
}
