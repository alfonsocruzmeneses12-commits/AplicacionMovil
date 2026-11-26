import 'package:flutter/material.dart';
import 'package:pideylisto/Core/AppColor.dart';
import 'package:pideylisto/Core/AppRutas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PideYListo());
}

class PideYListo extends StatelessWidget {
  const PideYListo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PideYListo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.fondo,
        primaryColor: AppColor.primary,
        fontFamily: 'Roboto',
      ),
      initialRoute: Apprutas.bienvenido,
      routes: Apprutas.rutas,
    );
  }
}
