import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/bloc/news/news_bloc.dart';
import 'package:newsapp/core/bloc/app_manger_bloc.dart';
import 'package:newsapp/core/config/observer_bloc.dart';
import 'package:newsapp/core/config/service_locator.dart';
import 'package:newsapp/model/news_model.dart';
import 'package:newsapp/model/source_model.dart';
import 'package:newsapp/service/news_service.dart';
import 'package:newsapp/view/splash/spalshScreen.dart';
import 'package:newsapp/bloc/search/search_bloc.dart';
import 'package:newsapp/bloc/bookmark/bookmark_bloc.dart';
import 'package:newsapp/bloc/bookmark/bookmark_event.dart';
import 'package:newsapp/bloc/splash/splash_bloc.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  Hive.registerAdapter(SourceAdapter());
  await Hive.openBox<NewsModel>('bookmarks');
  Bloc.observer = MyBlocObserver();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashBloc(),
        ),
        BlocProvider(
          create: (context) => NewsBloc(newsService: NewsServiceImp()),
        ),
        BlocProvider(
          create: (context) => SearchBloc(newsService: NewsServiceImp()),
        ),
        BlocProvider(
          create: (context) => AppManagerBloc()..add(CheckAuthorized()),
        ),
        BlocProvider(
          create: (context) => BookmarkBloc(Hive.box<NewsModel>('bookmarks'))..add(LoadBookmarks()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
