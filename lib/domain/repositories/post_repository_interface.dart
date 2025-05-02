import 'package:riverpod_board/domain/models/post/post.dart';

abstract class PostRepository {
  Future<List<Post>> getAllPosts();
  Future<Post?> getPostById(String id);
  Future<void> savePost(Post post);
  Future<void> deletePost(String id);
}