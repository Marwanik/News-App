import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/service/news_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final NewsService newsService;

  SearchBloc({required this.newsService}) : super(SearchInitial()) {
    on<SearchInNews>(_onSearchInNews);
  }

  void _onSearchInNews(SearchInNews event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final news = await newsService.searchNews(query: event.query, page: event.page);
      emit(SearchResult(news: news));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
