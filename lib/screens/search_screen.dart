import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamr/bloc/search/search_bloc.dart';
import 'package:streamr/bloc/search/search_event.dart';
import 'package:streamr/bloc/search/search_state.dart';
import 'package:streamr/constants.dart';
import 'package:streamr/model/search_category.dart';
import 'package:streamr/widgets/movie_tile.dart';

import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late double _deviceHeight;
  late double _deviceWidth;
  final _searchTextFieldController = TextEditingController();
  String _selectedCategory = SearchCategory.topRated; // Default category

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Container(
            height: _deviceHeight,
            width: _deviceWidth,
            child: Stack(
              children: [
                _backgroundWidget(),
                _foregroundWidgets(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _backgroundWidget() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        String? backgroundImageUrl;

        if (state is SearchLoaded && state.backgroundImage != null) {
          backgroundImageUrl = AppConstants.baseUrl + state.backgroundImage!;
        }

        return Container(
          height: _deviceHeight,
          width: _deviceWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: backgroundImageUrl != null
                  ? NetworkImage(backgroundImageUrl)
                  : const NetworkImage(AppConstants.defaultBackgroundURL),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
            ),
          ),
        );
      },
    );
  }

  Widget _foregroundWidgets(BuildContext context, SearchState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          _deviceWidth * 0.025, _deviceHeight * 0.02, _deviceWidth * 0.025, 0),
      width: _deviceWidth,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: _topBarWidget(),
              ),
            ],
          ),
          Container(
            height: _deviceHeight * 0.83,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
            child: _moviesListViewWidget(state),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(context),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    const border = InputBorder.none;
    return Container(
      width: _deviceWidth * 0.50,
      height: _deviceHeight * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            context.read<SearchBloc>().add(SearchMovies(query));
          }
        },
        style: GoogleFonts.montserrat(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            focusedBorder: border,
            border: border,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: GoogleFonts.montserrat(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: 'Search....'),
      ),
    );
  }

  Widget _categorySelectionWidget(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.black38,
      value: _selectedCategory, // Use the selected category string
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (String? newValue) {
        if (newValue != null && newValue != _selectedCategory) {
          setState(() {
            _selectedCategory = newValue; // Update state variable
          });

          context
              .read<SearchBloc>()
              .add(FetchMoviesByCategory(newValue)); // Fetch new movies
        }
      },
      items: [
        DropdownMenuItem(
          value: SearchCategory.topRated,
          child: Text(
            SearchCategory.topRated,
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.upcoming,
          child: Text(
            SearchCategory.upcoming,
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.trending,
          child: Text(
            SearchCategory.trending,
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _moviesListViewWidget(SearchState state) {
    if (state is SearchLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SearchLoaded) {
      if (state.movies.isEmpty) {
        return const Center(child: Text("No movies available"));
      }
      return ListView.builder(
        itemCount: state.movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: _deviceHeight * 0.01,
              horizontal: 0,
            ),
            child: GestureDetector(
                onTap: () {
                  if (state.movies.isNotEmpty) {
                    context.read<SearchBloc>().add(UpdateBackgroundImage(
                        AppConstants.baseUrl +
                            state.movies[index].posterPath!));
                  } else {
                    // Handle the case when movies are not available
                  }
                },
                child: MovieTile(
                    height: _deviceHeight * 0.20,
                    width: _deviceWidth * 0.85,
                    movie: state.movies[index])),
          );
        },
      );
    } else if (state is SearchError) {
      return Center(child: Text(state.message));
    }
    return Container();
  }
}
