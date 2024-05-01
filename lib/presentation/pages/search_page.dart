import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_event.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_see_more_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_see_more_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final String type;

  const SearchPage({Key? key, required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: type == MOVIE_TYPE
            ? movieSearch(context)
            : tvSeriesSearch(context));
  }
}

Widget tvSeriesSearch(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (query) {
            context.read<SearchBloc>().add(OnQueryChangedTvSeries(query));
          },
          decoration: InputDecoration(
            hintText: 'Search title',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.search,
        ),
        SizedBox(height: 16),
        Text(
          'Search Result',
          style: kHeading6,
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SearchTvSeriesHasData) {
              final result = state.result;
              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final tvSeries = result[index];
                    return TvSeriesCard(tvSeries);
                  },
                  itemCount: result.length,
                ),
              );
            } else if (state is SearchError) {
              return Expanded(
                child: Center(
                  child: Text(state.message),
                ),
              );
            } else {
              return Expanded(
                child: Container(),
              );
            }
          },
        )

        // Consumer<TvSeriesSearchNotifier>(
        //   builder: (context, data, child) {
        //     if (data.state == RequestState.Loading) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     } else if (data.state == RequestState.Loaded) {
        //       final result = data.searchResult;
        //       return Expanded(
        //         child: ListView.builder(
        //           padding: const EdgeInsets.all(8),
        //           itemBuilder: (context, index) {
        //             final movie = data.searchResult[index];
        //             return TvSeriesCard(movie);
        //           },
        //           itemCount: result.length,
        //         ),
        //       );
        //     } else {
        //       return Expanded(
        //         child: Container(),
        //       );
        //     }
        //   },
        // ),
      ],
    ),
  );
}

Widget movieSearch(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (query) {
            context.read<SearchBloc>().add(OnQueryChangedMovie(query));
          },
          decoration: InputDecoration(
            hintText: 'Search title',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.search,
        ),
        SizedBox(height: 16),
        Text(
          'Search Result',
          style: kHeading6,
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SearchMovieHasData) {
              final result = state.result;
              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final movie = result[index];
                    return MovieCard(movie);
                  },
                  itemCount: result.length,
                ),
              );
            } else if (state is SearchError) {
              return Expanded(
                child: Center(
                  child: Text(state.message),
                ),
              );
            } else {
              return Expanded(
                child: Container(),
              );
            }
          },
        ),

        // Consumer<MovieSearchNotifier>(
        //   builder: (context, data, child) {
        //     if (data.state == RequestState.Loading) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     } else if (data.state == RequestState.Loaded) {
        //       final result = data.searchResult;
        //       return Expanded(
        //         child: ListView.builder(
        //           padding: const EdgeInsets.all(8),
        //           itemBuilder: (context, index) {
        //             final movie = data.searchResult[index];
        //             return MovieCard(movie);
        //           },
        //           itemCount: result.length,
        //         ),
        //       );
        //     } else {
        //       return Expanded(
        //         child: Container(),
        //       );
        //     }
        //   },
        // ),
      ],
    ),
  );
}
