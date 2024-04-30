import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/detail_entity.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_event.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_bloc.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_state.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_bloc.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_event.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  final String type;
  DetailPage({required this.id, required this.type});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.type == MOVIE_TYPE) {
      context.read<DetailPageBloc>().add(FetchMovieDetail(widget.id));
      context
          .read<RecommendationListBloc>()
          .add(FetchMovieRecommendation(widget.id));
      context.read<WatchlistBloc>().add(CheckMovieWatchlistStatus(widget.id));
    }
    if (widget.type == TV_SERIES_TYPE) {
      context.read<DetailPageBloc>().add(FetchTvSeriesDetail(widget.id));
      context
          .read<RecommendationListBloc>()
          .add(FetchTvSeriesRecommendation(widget.id));
      context
          .read<WatchlistBloc>()
          .add(CheckTvSeriesWatchlistStatus(widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.type == MOVIE_TYPE
            ? loadMovieDetail(widget.id)
            : loadTvSeriesDetails(widget.id));
  }
}

Widget loadTvSeriesDetails(int id) {
  return BlocBuilder<DetailPageBloc, DetailPageState>(
      builder: (context, state) {
    if (state is DetailPageLoadingState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is DetailPageLoadedState) {
      final result = state.result;
      ;
      return SafeArea(
        child: DetailContentTvSeries(result, id),
      );
    } else if (state is DetailPageErrorState) {
      return Center(
        child: Text(state.message),
      );
    } else {
      print(state.toString());
      return Center(
        child: Text("Something went wrong!"),
      );
    }
  });
}

Widget loadMovieDetail(int id) {
  return BlocBuilder<DetailPageBloc, DetailPageState>(
      builder: (context, state) {
    if (state is DetailPageLoadingState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is DetailPageLoadedState) {
      final result = state.result;
      return SafeArea(child: DetailContentMovie(result, id));
    } else if (state is DetailPageErrorState) {
      return Center(
        child: Text(state.message),
      );
    } else {
      print(state.toString());
      return Center(
        child: Text("Something went wrong!"),
      );
    }
  });
}

class DetailContentMovie extends StatefulWidget {
  final DetailEntity detail;
  final int id;
  // final bool isAddedWatchlist;

  DetailContentMovie(this.detail, this.id);

  @override
  State<DetailContentMovie> createState() => _DetailContentMovieState();
}

class _DetailContentMovieState extends State<DetailContentMovie> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${widget.detail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.detail.title,
                              style: kHeading5,
                            ),
                            BlocBuilder<WatchlistBloc, WatchlistState>(
                                builder: (context, watchliststate) {
                              if (watchliststate is StatusState) {
                                final status = watchliststate.status;
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (!status) {
                                      //operate operation
                                      context.read<WatchlistBloc>().add(
                                          AddItemToWatchlist(
                                              widget.detail, MOVIE_TYPE));
                                    } else {
                                      context.read<WatchlistBloc>().add(
                                          RemoveMovieFromWatchlist(
                                              widget.detail, MOVIE_TYPE));
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      status
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text('Watchlist')
                                    ],
                                  ),
                                );
                              } else if (watchliststate
                                  is WatchlistSuccessState) {
                                context
                                    .read<WatchlistBloc>()
                                    .add(CheckMovieWatchlistStatus(widget.id));
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(watchliststate.message),
                                    ),
                                  );
                                });
                                return Center(
                                  child:
                                      CircularProgressIndicator(), // You can show a loading indicator while fetching data
                                );
                              } else if (watchliststate
                                  is WatchlistFailedState) {
                                context
                                    .read<WatchlistBloc>()
                                    .add(CheckMovieWatchlistStatus(widget.id));
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(watchliststate.message),
                                    ),
                                  );
                                });
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Center(
                                  child: Text("Something went wrong!!!"),
                                );
                              }
                            }),
                            Text(
                              _showGenres(widget.detail.genres),
                            ),
                            Text(
                              _showDuration(widget.detail.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.detail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.detail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.detail.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationListBloc,
                                    RecommendationListState>(
                                builder: (context, recommendationState) {
                              if (recommendationState
                                  is RecommendationLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (recommendationState
                                  is RecommendationLoadedMovieState) {
                                final result = recommendationState.result;

                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final movie = result[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              DetailPage.ROUTE_NAME,
                                              arguments: [
                                                movie.id,
                                                MOVIE_TYPE,
                                              ],
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: result.length,
                                  ),
                                );
                              } else if (recommendationState
                                  is RecommendationErrorState) {
                                return Center(
                                  child: Text(recommendationState.message),
                                );
                              } else {
                                return Center(
                                  child: Text("Something went wrong!"),
                                );
                              }
                            })
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class DetailContentTvSeries extends StatelessWidget {
  final DetailEntity detail;
  final int id;
  // final bool isAddedWatchlist;

  DetailContentTvSeries(this.detail, this.id);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${detail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.title,
                              style: kHeading5,
                            ),
                            BlocBuilder<WatchlistBloc, WatchlistState>(
                                builder: (context, state) {
                              if (state is StatusState) {
                                final status = state.status;
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (!status) {
                                      context.read<WatchlistBloc>().add(
                                          AddItemToWatchlist(
                                              detail, TV_SERIES_TYPE));
                                    } else {
                                      context.read<WatchlistBloc>().add(
                                          RemoveMovieFromWatchlist(
                                              detail, TV_SERIES_TYPE));
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      status
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text('Watchlist'),
                                    ],
                                  ),
                                );
                              } else if (state is WatchlistSuccessState) {
                                context
                                    .read<WatchlistBloc>()
                                    .add(CheckTvSeriesWatchlistStatus(id));
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                    ),
                                  );
                                });
                                return Center(
                                  child:
                                      CircularProgressIndicator(), // You can show a loading indicator while fetching data
                                );
                              } else if (state is WatchlistFailedState) {
                                context
                                    .read<WatchlistBloc>()
                                    .add(CheckMovieWatchlistStatus(id));
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                    ),
                                  );
                                });
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Center(
                                  child: Text("Something went wrong!!!"),
                                );
                              }
                            }),
                            Text(
                              _showGenres(detail.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: detail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${detail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              detail.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationListBloc,
                                    RecommendationListState>(
                                builder: (context, state) {
                              if (state is RecommendationLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state
                                  is RecommendationLoadedTvSeriesState) {
                                final result = state.result;
                                print(
                                    "RecommendationLoadedTvSeriesState $result");
                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final movie = result[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              DetailPage.ROUTE_NAME,
                                              arguments: [
                                                movie.id,
                                                TV_SERIES_TYPE,
                                              ],
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: result.length,
                                  ),
                                );
                              } else if (state is RecommendationErrorState) {
                                return Center(
                                  child: Text(state.message),
                                );
                              } else {
                                print(state.toString());
                                return Center(
                                  child: Text("Something went wrong!"),
                                );
                              }
                            })
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
