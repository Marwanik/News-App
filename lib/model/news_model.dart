import 'package:hive/hive.dart';
import 'dart:convert';
import 'source_model.dart';

part 'news_model.g.dart';

@HiveType(typeId: 0)
class NewsModel extends HiveObject {
  @HiveField(0)
  final Source source;
  @HiveField(1)
  final String author;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String url;
  @HiveField(5)
  final String urlToImage;
  @HiveField(6)
  final String publishedAt;
  @HiveField(7)
  final String content;

  NewsModel({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  NewsModel copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
  }) {
    return NewsModel(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      source: Source.fromMap(map['source'] as Map<String,dynamic>),
      author: map['author'] ?? 'No Author',
      title: map['title'] ?? 'No Title',
      description: map['description'] ?? 'No Description',
      url: map['url'] ?? 'No URL',
      urlToImage: map['urlToImage'] ?? 'No Image',
      publishedAt: map['publishedAt'] ?? 'No Publish',
      content: map['content'] ?? 'No Content',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) => NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'News(source: $source, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content)';
  }

  @override
  bool operator ==(covariant NewsModel other) {
    if (identical(this, other)) return true;

    return
      other.source == source &&
          other.author == author &&
          other.title == title &&
          other.description == description &&
          other.url == url &&
          other.urlToImage == urlToImage &&
          other.publishedAt == publishedAt &&
          other.content == content;
  }

  @override
  int get hashCode {
    return source.hashCode ^
    author.hashCode ^
    title.hashCode ^
    description.hashCode ^
    url.hashCode ^
    urlToImage.hashCode ^
    publishedAt.hashCode ^
    content.hashCode;
  }
}
