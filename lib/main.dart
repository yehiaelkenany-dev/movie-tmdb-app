import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamr/bloc/search/search_bloc.dart';
import 'package:streamr/model/search_category.dart';

import 'package:streamr/screens/home_screen.dart';

import 'api/api.dart';
import 'bloc/home/home_bloc.dart';
import 'bloc/home/home_event.dart';
import 'bloc/search/search_event.dart';

void main() {
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
        )
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
