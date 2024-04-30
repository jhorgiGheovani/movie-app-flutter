import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_see_more_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_see_more_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();

    context.read<GetWatchListMovieBloc>().add(GetWatchListMovie());
    context.read<GetWatchListTvSeriesBloc>().add(GetWatchListTvSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<GetWatchListMovieBloc>().add(GetWatchListMovie());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Text("Movie")),
                  Tab(icon: Text("Tv Series")),
                ],
              ),
              title: Text('Watchlist'),
            ),
            body: TabBarView(children: [movieContent(), tvSeriesContent()])));
  }

  Widget movieContent() {
    context.read<GetWatchListMovieBloc>().add(GetWatchListMovie());
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetWatchListMovieBloc, GetWatchListMovieState>(
            builder: (context, state) {
          if (state is GetWatchlistMovieLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetWatchlistLoadedMovieState) {
            final result = state.result;

            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = result[index];
                return MovieCard(movie);
              },
              itemCount: result.length,
            );
          } else if (state is GetWatchlistMovieErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text("Something went wrong!"),
            );
          }
        }));
  }

  Widget tvSeriesContent() {
    context.read<GetWatchListTvSeriesBloc>().add(GetWatchListTvSeries());
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetWatchListTvSeriesBloc, GetWatchTvSeriesListState>(
            builder: (context, state) {
          if (state is GetWatchlistTvSeriesLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetWatchlistLoadedTvSeriesState) {
            final result = state.result;

            return ListView.builder(
              itemBuilder: (context, index) {
                final data = result[index];
                return TvSeriesCard(data);
              },
              itemCount: result.length,
            );
          } else if (state is GetWatchlistTvSeriesErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text("Something went wrong!"),
            );
          }
        }));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
