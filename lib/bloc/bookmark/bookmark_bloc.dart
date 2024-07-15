import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/model/news_model.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final Box<NewsModel> bookmarkBox;

  BookmarkBloc(this.bookmarkBox) : super(BookmarkInitial()) {
    on<AddBookmark>((event, emit) async {
      emit(BookmarkLoading());
      try {
        await bookmarkBox.put(event.news.title, event.news);
        final bookmarks = bookmarkBox.values.toList();
        emit(BookmarkLoaded(bookmarks));
      } catch (e) {
        emit(BookmarkError('Failed to add bookmark'));
      }
    });

    on<RemoveBookmark>((event, emit) async {
      emit(BookmarkLoading());
      try {
        await bookmarkBox.delete(event.news.title);
        final bookmarks = bookmarkBox.values.toList();
        emit(BookmarkLoaded(bookmarks));
      } catch (e) {
        emit(BookmarkError('Failed to remove bookmark'));
      }
    });

    on<LoadBookmarks>((event, emit) async {
      emit(BookmarkLoading());
      try {
        final bookmarks = bookmarkBox.values.toList();
        emit(BookmarkLoaded(bookmarks));
      } catch (e) {
        emit(BookmarkError('Failed to load bookmarks'));
      }
    });
  }
}
