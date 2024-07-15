import 'package:hive/hive.dart';
import 'dart:convert';

part 'source_model.g.dart';

@HiveType(typeId: 1)
class Source {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String name;

  Source({
    this.id,
    required this.name,
  });

  Source copyWith({
    String? id,
    String? name,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Source.fromJson(String source) => Source.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Source(id: $id, name: $name)';

  @override
  bool operator ==(covariant Source other) {
    if (identical(this, other)) return true;

    return
      other.id == id &&
          other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
