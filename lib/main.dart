import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamr/bloc/cubits/favorites/favorites_cubit.dart';
import 'package:streamr/bloc/search/search_bloc.dart';
import 'package:streamr/model/search_category.dart';

import 'package:streamr/screens/home_screen.dart';
import 'package:streamr/screens/login_screen.dart';
import 'package:streamr/screens/splash_screen.dart';

import 'api/api.dart';
import 'bloc/home/home_bloc.dart';
import 'bloc/home/home_event.dart';
import 'bloc/search/search_event.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // ✅ Clears the old data before running the app

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc()
            ..add(
              FetchMoviesEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => SearchBloc(Api())
            ..add(FetchMoviesByCategory(SearchCategory.topRated)),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      designSize: MediaQuery.of(context).size.width > 600
          ? const Size(600, 1024) // Tablet size
          : const Size(360, 690), // Mobile size
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            textTheme: GoogleFonts.montserratTextTheme(),
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
