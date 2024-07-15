import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/news/news_bloc.dart';
import 'package:newsapp/bloc/news/news_event.dart';
import 'package:newsapp/bloc/news/news_state.dart';




import 'package:newsapp/view/home/home_screen.dart';
import 'package:newsapp/view/newspage/news_page.dart';

class NewsListWheel extends StatefulWidget {
  final int selectedCategoryIndex;

  const NewsListWheel({Key? key, required this.selectedCategoryIndex}) : super(key: key);

  @override
  _NewsListWheelState createState() => _NewsListWheelState();
}

class _NewsListWheelState extends State<NewsListWheel> {
  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    context.read<NewsBloc>().add(GetNewsData(category: categories[widget.selectedCategoryIndex], page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsApiState>(
      builder: (context, state) {
        if (state is LoadingNews) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SuccessToGetNews) {
          final newsList = state.news.take(5).toList(); // Get the top 5 news articles

          return Container(
            height: 250,
            child: PageView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final double scale = 0.3 + (0.7 * (1 - (index % 1)));

                return Transform.scale(
                  scale: scale,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsPage(news: newsList[index]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              newsList[index].urlToImage,
                              fit: BoxFit.cover,
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
                                return Center(child: FlutterLogo(size: 100));
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: -10,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                                color: Colors.black54,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Text(
                                newsList[index].title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.78,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is NoNewsAvailable) {
          return Center(child: Text("No news available"));
        } else if (state is FailedToFetchNews) {
          return Center(child: Text('Failed to fetch news'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
