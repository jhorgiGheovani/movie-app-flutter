import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_event.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_state.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_see_more_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tvSeries';

  @override
  State<StatefulWidget> createState() => _PopularTvSeriesPage();
}

class _PopularTvSeriesPage extends State<PopularTvSeriesPage> {
  @override
  Widget build(BuildContext context) {
    context.read<PopularListBloc>().add(FetchPopularTvSeries());
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularListBloc, PopularListState>(
            builder: (context, state) {
          if (state is PopularListResultLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularListResultLoadedTvSeries) {
            final result = state.result;
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvData = result[index];
                return TvSeriesCard(tvData);
              },
              itemCount: result.length,
            );
          } else if (state is PopularListResultError) {
            print("ErrorPopularMovie ${state.message}");
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text("Something went wrong!"),
            );
          }
        }),
      ),
    );
  }
}
