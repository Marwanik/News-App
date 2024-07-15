import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchInNews extends SearchEvent {
  final String query;
  final int page;

  const SearchInNews({required this.query, required this.page});

  @override
  List<Object> get props => [query, page];
}
