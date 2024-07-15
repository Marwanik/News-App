import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/search/search_bloc.dart';
import 'package:newsapp/bloc/search/search_event.dart';
import 'package:newsapp/bloc/search/search_state.dart';
import 'package:newsapp/design/colors.dart';
import 'package:newsapp/model/news_model.dart';

import 'package:newsapp/view/newspage/news_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedCategory = 'general';
  final ScrollController _scrollController = ScrollController();
  List<NewsModel> _newsList = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchNews(String query) async {
    setState(() {
      _isLoading = true;
    });

    context.read<SearchBloc>().add(SearchInNews(query: query, page: _currentPage));
    _currentPage++;
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _hasSearched = false;
      _newsList = [];
    });
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      _newsList = [];
      _currentPage = 1;
      _fetchNews(query);
      setState(() {
        _hasSearched = true;
      });
    } else {
      setState(() {
        _hasSearched = false;
        _newsList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGround,
      appBar: AppBar(
        backgroundColor: BackGround,
        surfaceTintColor: BackGround,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: BackGround,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: 'Search for news...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
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
                    _onCategoryChanged(category);
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
          SizedBox(height: 20),
          Expanded(
            child: BlocListener<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchResult) {
                  setState(() {
                    _newsList.addAll(state.news);
                    _isLoading = false;
                  });
                } else if (state is SearchError) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (_isLoading && _newsList.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!_hasSearched) {
                    return Center(child: Text("Enter your search news"));
                  } else if (_newsList.isEmpty) {
                    return Center(child: Text("No results found"));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _newsList.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _newsList.length) {
                        return _isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
                      }

                      final news = _newsList[index];
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
                                        news.urlToImage ?? 'https://via.placeholder.com/100',
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> categories = [
  'general',
  'business',
  'entertainment',
  'health',
  'science',
  'sports',
  'technology',
];
