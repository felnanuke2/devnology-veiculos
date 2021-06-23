import 'package:devnology_cars_register/constants/colors/constant_colors.dart';
import 'package:devnology_cars_register/views/dashboard_screen.dart';
import 'package:devnology_cars_register/views/login_screen.dart';
import 'package:devnology_cars_register/views/vehicle_purchase%20.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gerenciamento de Veículos',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),
          primarySwatch: primarySwatch,
          elevatedButtonTheme:
              ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: Color(0xff0d0d0d)))),
      home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : DashBoardScreen(),
    );
  }
}
