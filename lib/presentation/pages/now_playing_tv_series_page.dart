import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_event.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_state.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_see_more_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/now_playing-tvSeries';

  @override
  State<StatefulWidget> createState() => _NowPlayingTvSeriesPage();
}

class _NowPlayingTvSeriesPage extends State<NowPlayingTvSeriesPage> {
  @override
  Widget build(BuildContext context) {
    context.read<NowPlayingListBloc>().add(FetchNowPlayingTvSeries());
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingListBloc, NowPlayingListState>(
            builder: (context, state) {
          if (state is NowPlayingListResultLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NowPlayingListResultLoadedTvSeries) {
            final result = state.result;
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvData = result[index];
                return TvSeriesCard(tvData);
              },
              itemCount: result.length,
            );
          } else if (state is NowPlayingListResultError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            print(state.toString());
            return Center(
              child: Text("Something went wrong!"),
            );
          }
        }),
      ),
    );
  }
}
