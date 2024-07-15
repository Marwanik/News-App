import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetNewsData extends NewsEvent {
  final String category;
  final int page;

  const GetNewsData({required this.category, required this.page});

  @override
  List<Object> get props => [category, page];
}

class GetNewsForAllCategories extends NewsEvent {
  final List<String> categories;
  final int page;

  const GetNewsForAllCategories({required this.categories, required this.page});

  @override
  List<Object> get props => [categories, page];
}
