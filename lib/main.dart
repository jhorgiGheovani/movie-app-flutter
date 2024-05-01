import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/ssl_pinning_client.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_bloc.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_bloc.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailPageBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<RecommendationListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<GetWatchListMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<GetWatchListTvSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case DetailPage.ROUTE_NAME:
              final List<dynamic> args = settings.arguments as List<dynamic>;
              final int id = args[0] as int;
              final String type = args[1] as String;
              return MaterialPageRoute(
                builder: (_) => DetailPage(id: id, type: type),
                settings: settings,
              );
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case NowPlayingTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingTvSeriesPage());
            case SearchPage.ROUTE_NAME:
              final type = settings.arguments as String;
              return CupertinoPageRoute(builder: (_) => SearchPage(type: type));
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
