import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamr/model/movie_model.dart';
import 'package:streamr/model/search_category.dart';
import 'package:streamr/widgets/movie_tile.dart';

import '../api/api.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late double _deviceHeight;
  late double _deviceWidth;
  final _searchTextFieldController = TextEditingController();
  final Api _api = Api(); // Create an instance of the Api class
  List<Movie> _movies = []; // List to store fetched movies
  String _selectedCategory = SearchCategory.topRated; // Default category

  @override
  void initState() {
    super.initState();
    _fetchMovies(_selectedCategory); // Fetch movies when the screen initializes
  }

  // Method to fetch movies based on the selected category
  Future<void> _fetchMovies(String category) async {
    try {
      List<Movie> movies;
      switch (category) {
        case SearchCategory.topRated:
          movies = await _api.getTopRatedMovies();
          break;
        case SearchCategory.upcoming:
          movies = await _api.getUpcomingMovies();
          break;
        case SearchCategory.trending:
          movies = await _api.getTrendingMovies();
          break;
        default:
          movies = [];
          break;
      }
      setState(() {
        _movies = movies; // Update the movies list
      });
    } catch (e) {
      print('Error fetching movies: $e');
      // Handle the error (e.g., show a snackbar or dialog)
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        image: const DecorationImage(
          image: NetworkImage(
            "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/b70af2b5-d696-4bf5-b0d9-4cfbfc5b8bc4/dh26tou-3826978e-3d9e-42d4-a1b2-c8476cab668b.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2I3MGFmMmI1LWQ2OTYtNGJmNS1iMGQ5LTRjZmJmYzViOGJjNFwvZGgyNnRvdS0zODI2OTc4ZS0zZDllLTQyZDQtYTFiMi1jODQ3NmNhYjY2OGIuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.4MBhS_mAVBSdET8n9DkdFtgbAHBRfShEsFYc3wFGP0A",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15.0,
          sigmaY: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _foregroundWidgets() {
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
                  Navigator.pop(context);
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
            child: _moviesListViewWidget(),
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
          _categorySelectionWidget(),
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
        onSubmitted: (input) {},
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

  Widget _categorySelectionWidget() {
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
        if (newValue != null) {
          setState(() {
            _selectedCategory = newValue; // Update the selected category
          });
          _fetchMovies(newValue); // Fetch movies for the new category
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
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _moviesListViewWidget() {
    if (_movies.isNotEmpty) {
      return ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: _deviceHeight * 0.01,
              horizontal: 0,
            ),
            child: GestureDetector(
                onTap: () {},
                child: MovieTile(
                    height: _deviceHeight * 0.20,
                    width: _deviceWidth * 0.85,
                    movie: _movies[index])),
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
