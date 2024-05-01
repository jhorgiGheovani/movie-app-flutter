import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_event.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_state.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_event.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_state.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_event.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_state.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMoviePage = true;
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<TopRatedListBloc>().add(FetchTopRatedMovie());
  //   context.read<PopularListBloc>().add(FetchPopularMovie());
  //   context.read<NowPlayingListBloc>().add(FetchNowPlayingMovie());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/circle-g.png'),
                ),
                accountName: Text('Ditonton'),
                accountEmail: Text('ditonton@dicoding.com'),
              ),
              ListTile(
                leading: Icon(Icons.movie),
                title: Text('Movies'),
                onTap: () {
                  setState(() {
                    isMoviePage = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.tv),
                title: Text('Tv Series'),
                onTap: () {
                  setState(() {
                    isMoviePage = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.save_alt),
                title: Text('Watchlist'),
                onTap: () {
                  Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                },
                leading: Icon(Icons.info_outline),
                title: Text('About'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Ditonton'),
          actions: [
            IconButton(
              onPressed: () {
                isMoviePage
                    ? Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                        arguments: MOVIE_TYPE)
                    : Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                        arguments: TV_SERIES_TYPE);
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: isMoviePage ? _moviesData() : _tvResultData());
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tvResultData() {
    context.read<TopRatedListBloc>().add(FetchTopRatedTvSeries());
    context.read<PopularListBloc>().add(FetchPopularTvSeries());
    context.read<NowPlayingListBloc>().add(FetchNowPlayingTvSeries());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
              title: 'Now Playing Tv Series',
              onTap: () => Navigator.pushNamed(
                  context, NowPlayingTvSeriesPage.ROUTE_NAME),
            ),
            BlocBuilder<NowPlayingListBloc, NowPlayingListState>(
                builder: (context, state) {
              if (state is NowPlayingListResultLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is NowPlayingListResultLoadedTvSeries) {
                final result = state.result;
                return TvSeriesList(result);
              } else if (state is NowPlayingListResultError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(
                  child: Text("Something went wrong!"),
                );
              }
            }),
            _buildSubHeading(
              title: 'Popular Tv Series',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME),
            ),
            BlocBuilder<PopularListBloc, PopularListState>(
                builder: (context, state) {
              if (state is PopularListResultLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularListResultLoadedTvSeries) {
                final result = state.result;
                return TvSeriesList(result);
              } else if (state is PopularListResultError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(
                  child: Text("Something went wrong!"),
                );
              }
            }),
            _buildSubHeading(
              title: 'Top Rated Tv Series',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvSeriesPage.ROUTE_NAME),
            ),
            BlocBuilder<TopRatedListBloc, TopRatedListState>(
                builder: (context, state) {
              if (state is TopRatedLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedLoadedTvSeriesState) {
                final result = state.result;
                return TvSeriesList(result);
              } else if (state is TopRatedErrorState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(
                  child: Text("Something went wrong!"),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _moviesData() {
    context.read<TopRatedListBloc>().add(FetchTopRatedMovie());
    context.read<PopularListBloc>().add(FetchPopularMovie());
    context.read<NowPlayingListBloc>().add(FetchNowPlayingMovie());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            BlocBuilder<NowPlayingListBloc, NowPlayingListState>(
                builder: (context, state) {
              if (state is NowPlayingListResultLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is NowPlayingListResultLoadedMovie) {
                final result = state.result;
                return MovieList(result);
              } else if (state is NowPlayingListResultError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(
                  child: Text("Something went wrong!"),
                );
              }
            }),
            _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME);
                }),
            BlocBuilder<PopularListBloc, PopularListState>(
                builder: (context, state) {
              if (state is PopularListResultLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularListResultLoadedMovie) {
                final result = state.result;
                return MovieList(result);
              } else if (state is PopularListResultError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(
                  child: Text("Something went wrong!"),
                );
              }
            }),
            _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME);
                }),
            BlocBuilder<TopRatedListBloc, TopRatedListState>(
                builder: (context, state) {
              if (state is TopRatedLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedLoadedMovieState) {
                final result = state.result;
                return MovieList(result);
              } else if (state is TopRatedErrorState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(
                  child: Text("Something went wrong!"),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailPage.ROUTE_NAME,
                  arguments: [
                    movie.id,
                    MOVIE_TYPE,
                  ],
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeriesList;

  TvSeriesList(this.tvSeriesList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSeries = tvSeriesList[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailPage.ROUTE_NAME,
                  arguments: [
                    tvSeries.id,
                    TV_SERIES_TYPE,
                  ],
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSeries.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeriesList.length,
      ),
    );
  }
}
