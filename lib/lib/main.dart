import 'package:flutter/material.dart';
import 'screens/SplashScreen.dart';
import 'utils/Mapping.dart';
import 'auth/Authentication.dart';

void main() {
  runApp(new App());
}

class App extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    // Путь, по которому создаётся Manager Screen
    '/Manager': (BuildContext context) => MappingPage(auth: Auth()),
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App",
      theme: new ThemeData(
      ),
      home: SplashScreen(nextRoute: '/Manager'),
      // передаём маршруты в приложение
      routes: routes,
    );
  }
}
