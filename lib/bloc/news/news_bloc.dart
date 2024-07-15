import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:newsapp/bloc/news/news_event.dart';
import 'package:newsapp/bloc/news/news_state.dart';
import 'package:newsapp/model/news_model.dart';
import 'package:newsapp/service/news_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsBloc extends Bloc<NewsEvent, NewsApiState> {
  final NewsService newsService;

  NewsBloc({required this.newsService}) : super(InitialNewsState()) {
    on<GetNewsData>(_onGetNewsData);
    on<GetNewsForAllCategories>(_onGetNewsForAllCategories);
  }

  Future<void> _onGetNewsData(GetNewsData event, Emitter<NewsApiState> emit) async {
    emit(LoadingNews());
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '${event.category}_${event.page}';
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        List<NewsModel> newsList = (json.decode(cachedData) as List)
            .map((data) => NewsModel.fromMap(data))
            .toList();
        emit(SuccessToGetNews(news: newsList));
      } else {
        List<NewsModel> newsList = await newsService.fetchNewsByCategory(event.category, event.page);
        if (newsList.isNotEmpty) {
          prefs.setString(cacheKey, json.encode(newsList.map((e) => e.toMap()).toList()));
          emit(SuccessToGetNews(news: newsList));
        } else {
          emit(NoNewsAvailable());
        }
      }
    } catch (e) {
      emit(FailedToFetchNews(error: e.toString()));
    }
  }

  Future<void> _onGetNewsForAllCategories(GetNewsForAllCategories event, Emitter<NewsApiState> emit) async {
    emit(LoadingNews());
    try {
      Map<String, List<NewsModel>> newsMap = {};
      final prefs = await SharedPreferences.getInstance();
      bool hasAllCached = true;

      for (String category in event.categories) {
        final cacheKey = '${category}_${event.page}';
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          List<NewsModel> newsList = (json.decode(cachedData) as List)
              .map((data) => NewsModel.fromMap(data))
              .toList();
          newsMap[category] = newsList;
        } else {
          hasAllCached = false;
          break;
        }
      }

      if (hasAllCached) {
        emit(SuccessToGetNewsForAllCategories(newsMap: newsMap));
      } else {
        newsMap = await newsService.fetchNewsForAllCategories(event.categories, event.page);
        if (newsMap.isNotEmpty) {
          for (String category in newsMap.keys) {
            final cacheKey = '${category}_${event.page}';
            prefs.setString(cacheKey, json.encode(newsMap[category]!.map((e) => e.toMap()).toList()));
          }
          emit(SuccessToGetNewsForAllCategories(newsMap: newsMap));
        } else {
          emit(NoNewsAvailable());
        }
      }
    } catch (e) {
      emit(FailedToFetchNews(error: e.toString()));
    }
  }
}