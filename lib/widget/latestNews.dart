import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/news/news_bloc.dart';
import 'package:newsapp/bloc/news/news_event.dart';
import 'package:newsapp/bloc/news/news_state.dart';
import 'package:newsapp/design/colors.dart';
import 'package:newsapp/view/allnews/allnews_screen.dart';
import 'package:newsapp/view/home/home_screen.dart';
import 'package:newsapp/view/newspage/news_page.dart';

class LatestNews extends StatefulWidget {
  final int selectedCategoryIndex;

  const LatestNews({Key? key, required this.selectedCategoryIndex}) : super(key: key);

  @override
  _LatestNewsState createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    context.read<NewsBloc>().add(GetNewsData(
      category: categories[widget.selectedCategoryIndex],
      page: 1,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest News',
                style: TextStyle(
                  fontSize: 20,
                  color: TextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllNewsScreen(),
                    ),
                  );
                },
                child: Text(
                  'See More',
                  style: TextStyle(
                    fontSize: 10,
                    color: LabelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsApiState>(
              builder: (context, state) {
                if (state is LoadingNews) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SuccessToGetNews) {
                  final latestNews = state.news.take(3).toList();

                  return ListView.builder(
                    itemCount: latestNews.length,
                    itemBuilder: (context, index) {
                      final news = latestNews[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsPage(news: news),
                              ),
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
                                        news.urlToImage ?? 'https://via.placeholder.com/100',
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
                                            child: CircularProgressIndicator(),
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
                } else if (state is NoNewsAvailable) {
                  return Center(child: Text("No news available"));
                } else if (state is FailedToFetchNews) {
                  return Center(child: Text("Failed to fetch news"));
                } else {
                  return Center(child: Text("Unknown state"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
