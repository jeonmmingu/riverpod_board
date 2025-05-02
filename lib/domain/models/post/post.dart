import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
@HiveType(typeId: 0)
class Post with _$Post {
  const factory Post({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String content,
    @HiveField(3) required DateTime createdAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}