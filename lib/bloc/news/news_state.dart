import 'package:equatable/equatable.dart';
import 'package:newsapp/model/news_model.dart';

abstract class NewsApiState extends Equatable {
  const NewsApiState();

  @override
  List<Object> get props => [];
}

class InitialNewsState extends NewsApiState {}

class LoadingNews extends NewsApiState {}

class SuccessToGetNews extends NewsApiState {
  final List<NewsModel> news;

  const SuccessToGetNews({required this.news});

  @override
  List<Object> get props => [news];
}

class SuccessToGetNewsForAllCategories extends NewsApiState {
  final Map<String, List<NewsModel>> newsMap;

  const SuccessToGetNewsForAllCategories({required this.newsMap});

  @override
  List<Object> get props => [newsMap];
}

class FailedToFetchNews extends NewsApiState {
  final String error;

  const FailedToFetchNews({required this.error});

  @override
  List<Object> get props => [error];
}

class NoNewsAvailable extends NewsApiState {}
