import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/news/news_bloc.dart';
import 'package:newsapp/bloc/news/news_event.dart';
import 'package:newsapp/bloc/news/news_state.dart';
import 'package:newsapp/design/colors.dart';

import 'package:newsapp/model/news_model.dart';

import 'package:newsapp/view/home/home_screen.dart';
import 'package:newsapp/view/newspage/news_page.dart';

class AllNewsScreen extends StatelessWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGround,
      appBar: AppBar(
        title: const Text('All News'),
        backgroundColor: BackGround,
        surfaceTintColor: BackGround,
      ),
      body: PaginatedNewsList(),
    );
  }
}

class PaginatedNewsList extends StatefulWidget {
  @override
  _PaginatedNewsListState createState() => _PaginatedNewsListState();
}

class _PaginatedNewsListState extends State<PaginatedNewsList> {
  final ScrollController _scrollController = ScrollController();
  List<NewsModel> _allNews = [];
  bool _isLoading = false;
  int _currentPage = 1;
  String _selectedCategory = categories[0];

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        _fetchNews();
      }
    });
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
    });

    context.read<NewsBloc>().add(GetNewsData(category: _selectedCategory, page: _currentPage));
    _currentPage++;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                    _allNews = [];
                    _currentPage = 1;
                    _fetchNews();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: isSelected ? PrimaryColor : UNButtonColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: BlocListener<NewsBloc, NewsApiState>(
            listener: (context, state) {
              if (state is SuccessToGetNews) {
                setState(() {
                  _allNews.addAll(state.news);
                  _isLoading = false;
                });
              } else if (state is FailedToFetchNews) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: BlocBuilder<NewsBloc, NewsApiState>(
              builder: (context, state) {
                if (_isLoading && _allNews.isEmpty) {
                  return Center(child: CircularProgressIndicator(backgroundColor: Colors.red, color: Colors.red,));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: _allNews.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _allNews.length) {
                      return _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.green)) : SizedBox.shrink();
                    }

                    final news = _allNews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewsPage(news: news)),
                          );
                        },
                        child: Card(
                          color: BackGround,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        news.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Published ${news.publishedAt}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Image.network(
                                      news.urlToImage ?? '',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Center(
                                          child: FlutterLogo(size: 100),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
