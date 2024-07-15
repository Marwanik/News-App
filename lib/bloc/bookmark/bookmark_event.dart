import 'package:equatable/equatable.dart';
import 'package:newsapp/model/news_model.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class AddBookmark extends BookmarkEvent {
  final NewsModel news;

  const AddBookmark(this.news);

  @override
  List<Object> get props => [news];
}

class RemoveBookmark extends BookmarkEvent {
  final NewsModel news;

  const RemoveBookmark(this.news);

  @override
  List<Object> get props => [news];
}

class LoadBookmarks extends BookmarkEvent {}
