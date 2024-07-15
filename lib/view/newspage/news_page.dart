import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/bloc/bookmark/bookmark_bloc.dart';
import 'package:newsapp/bloc/bookmark/bookmark_event.dart';
import 'package:newsapp/bloc/bookmark/bookmark_state.dart';
import 'package:newsapp/design/colors.dart';
import 'package:newsapp/model/news_model.dart';

class NewsPage extends StatefulWidget {
  final NewsModel news;
  final VoidCallback? onBookmarkRemoved; // Callback for when a bookmark is removed

  const NewsPage({Key? key, required this.news, this.onBookmarkRemoved}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<NewsModel>('bookmarks');
    isBookmarked = box.containsKey(widget.news.title);
  }

  void _toggleBookmark(BuildContext context) {
    if (isBookmarked) {
      _confirmRemoveBookmark(context);
    } else {
      BlocProvider.of<BookmarkBloc>(context).add(AddBookmark(widget.news));
    }
  }

  void _confirmRemoveBookmark(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Bookmark'),
        content: Text('Do you want to remove this news from bookmarks?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<BookmarkBloc>(context).add(RemoveBookmark(widget.news));
              setState(() {
                isBookmarked = false;
              });
              widget.onBookmarkRemoved?.call(); // Invoke callback if set
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bookmark removed')),
              );
              Navigator.of(context).pop(); // Navigate back to the previous screen
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BookmarkBloc, BookmarkState>(
        listener: (context, state) {
          if (state is BookmarkLoaded) {
            setState(() {
              isBookmarked = state.bookmarks.any((news) => news.title == widget.news.title);
            });
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                surfaceTintColor: BackGround,
                floating: false,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white30,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 25),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                actions: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white30,
                    child: IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.orange : null,
                      ),
                      onPressed: () => _toggleBookmark(context),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.news.urlToImage.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.network(
                      widget.news.urlToImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return FlutterLogo(size: 100);
                      },
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/placeholder_image.png', // Provide a placeholder image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.news.title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.news.publishedAt,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(widget.news.description),
                      SizedBox(height: 8.0),
                      Text(widget.news.content),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
