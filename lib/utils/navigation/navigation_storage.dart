import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLastVisitedRoute(String route) async {
  final preferences = await SharedPreferences.getInstance();
  preferences.setString("last_route", route);
}

Future<String> getLastVisitedRoute() async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getString("last_route") ?? '/';
}