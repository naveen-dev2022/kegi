import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/local_strings.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/screens/splash_screen.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key, this.repository}) : super(key: key);
  final Repository? repository;

  SharedPreference sharedPreference = SharedPreference();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<DataListner>(
              create: (BuildContext context) => DataListner(),
            ),
          ],
          child: GetMaterialApp(
            supportedLocales: const [
              Locale('en', 'US')
            ], //, Locale('pt', 'BR')],
            translations: LocalString(),
            locale: const Locale('en', 'US'),
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            /* supportedLocales: const [
            Locale("af"),
            Locale("am"),
            Locale("ar"),
            Locale("az"),
            Locale("be"),
            Locale("bg"),
            Locale("bn"),
            Locale("bs"),
            Locale("ca"),
            Locale("cs"),
            Locale("da"),
            Locale("de"),
            Locale("el"),
            Locale("en"),
            Locale("es"),
            Locale("et"),
            Locale("fa"),
            Locale("fi"),
            Locale("fr"),
            Locale("gl"),
            Locale("ha"),
            Locale("he"),
            Locale("hi"),
            Locale("hr"),
            Locale("hu"),
            Locale("hy"),
            Locale("id"),
            Locale("is"),
            Locale("it"),
            Locale("ja"),
            Locale("ka"),
            Locale("kk"),
            Locale("km"),
            Locale("ko"),
            Locale("ku"),
            Locale("ky"),
            Locale("lt"),
            Locale("lv"),
            Locale("mk"),
            Locale("ml"),
            Locale("mn"),
            Locale("ms"),
            Locale("nb"),
            Locale("nl"),
            Locale("nn"),
            Locale("no"),
            Locale("pl"),
            Locale("ps"),
            Locale("pt"),
            Locale("ro"),
            Locale("ru"),
            Locale("sd"),
            Locale("sk"),
            Locale("sl"),
            Locale("so"),
            Locale("sq"),
            Locale("sr"),
            Locale("sv"),
            Locale("ta"),
            Locale("tg"),
            Locale("th"),
            Locale("tk"),
            Locale("tr"),
            Locale("tt"),
            Locale("uk"),
            Locale("ug"),
            Locale("ur"),
            Locale("uz"),
            Locale("vi"),
            Locale("zh")
          ],
          localizationsDelegates: const [
            CountryLocalizations.delegate,
          ],*/
            debugShowCheckedModeBanner: false,
            title: 'Legato',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
