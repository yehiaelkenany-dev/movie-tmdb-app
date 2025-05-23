// navigation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerNavigationCubit extends Cubit<int> {
  DrawerNavigationCubit() : super(0); // Default index (e.g. Home)

  void setPage(int index) => emit(index);
}
