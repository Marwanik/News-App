import 'package:dio/dio.dart';
import 'package:newsapp/model/news_model.dart';

class BaseService {
  Dio dio = Dio();
  late Response response;
  String baseUrl = 'https://newsapi.org/v2/everything';
  String apiKey = '49ea232354d249e0ba338da1c03690db';
}

abstract class NewsService extends BaseService {
  Future<List<NewsModel>> fetchNewsByCategory(String category, int page);
  Future<Map<String, List<NewsModel>>> fetchNewsForAllCategories(List<String> categories, int page);
  Future<List<NewsModel>> searchNews({required String query, required int page});
}

class NewsServiceImp extends NewsService {
  @override
  Future<List<NewsModel>> fetchNewsByCategory(String category, int page) async {
    return _fetchNews(query: category, page: page);
  }

  @override
  Future<Map<String, List<NewsModel>>> fetchNewsForAllCategories(List<String> categories, int page) async {
    Map<String, List<NewsModel>> newsByCategory = {};
    for (String category in categories) {
      List<NewsModel> newsList = await fetchNewsByCategory(category, page);
      newsByCategory[category] = newsList;
    }
    return newsByCategory;
  }

  @override
  Future<List<NewsModel>> searchNews({required String query, required int page}) async {
    return _fetchNews(query: query, page: page);
  }

  Future<List<NewsModel>> _fetchNews({required String query, required int page}) async {
    try {
      response = await dio.get(baseUrl, queryParameters: {
        'q': query,
        'apiKey': apiKey,
        'pageSize': 10,
        'page': page,
      });
      if (response.statusCode == 200) {
        List<NewsModel> newsList = List.generate(
          response.data['articles'].length,
              (index) => NewsModel.fromMap(response.data['articles'][index]),
        );
        // Filter out news with title or description '[Removed]'
        newsList = newsList.where((news) {
          return !(news.title.contains('[Removed]') || news.description.contains('[Removed]'));
        }).toList();
        return newsList;
      } else {
        throw Exception('Failed to fetch news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
