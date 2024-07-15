import 'package:equatable/equatable.dart';
import 'package:newsapp/model/news_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResult extends SearchState {
  final List<NewsModel> news;

  const SearchResult({required this.news});

  @override
  List<Object> get props => [news];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}
