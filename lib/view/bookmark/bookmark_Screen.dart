import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/bloc/bookmark/bookmark_bloc.dart';
import 'package:newsapp/bloc/bookmark/bookmark_event.dart';
import 'package:newsapp/bloc/bookmark/bookmark_state.dart';
import 'package:newsapp/model/news_model.dart';

import 'package:newsapp/view/newspage/news_page.dart';

class BookmarkedNewsScreen extends StatelessWidget {
  const BookmarkedNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked News'),
      ),
      body: BlocProvider(
        create: (context) => BookmarkBloc(Hive.box<NewsModel>('bookmarks'))..add(LoadBookmarks()),
        child: BlocBuilder<BookmarkBloc, BookmarkState>(
          builder: (context, state) {
            if (state is BookmarkLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookmarkLoaded) {
              if (state.bookmarks.isEmpty) {
                return Center(child: Text('No bookmarks added.'));
              }
              return ListView.builder(
                itemCount: state.bookmarks.length,
                itemBuilder: (context, index) {
                  final news = state.bookmarks[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsPage(
                              news: news,
                              onBookmarkRemoved: () {
                                BlocProvider.of<BookmarkBloc>(context).add(LoadBookmarks());
                              },
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: news.urlToImage.isNotEmpty
                                  ? Image.network(
                                news.urlToImage,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return FlutterLogo(size: 100,);
                                },
                              )
                                  : FlutterLogo(size: 100,),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    news.publishedAt,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    news.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookmarkError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
