
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/navigation/navigation_storage.dart';

class RouteCubit extends Cubit<String> {
  RouteCubit() : super('/');

  void setRoute(String route) {
    emit(route);
    saveLastVisitedRoute(route);
  }

  Future<String> loadInitialRoute() async {
    final preferences = await SharedPreferences.getInstance();
    final route = await getLastVisitedRoute();
    emit(route);
    return route;
  }

}