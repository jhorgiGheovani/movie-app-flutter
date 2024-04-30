import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_event.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_see_more_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<TopRatedListBloc>().add(FetchTopRatedMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TopRatedListBloc, TopRatedListState>(
              builder: (context, state) {
            if (state is TopRatedLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedLoadedMovieState) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is TopRatedErrorState) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text("Something went wrong!"),
              );
            }
          })),
    );
  }
}
