import 'package:hive/hive.dart';
import 'package:riverpod_board/domain/models/post/post.dart';
import 'package:riverpod_board/domain/repositories/post_repository_interface.dart';

class HivePostRepository implements PostRepository {
  final String boxName = 'posts';

  @override
  Future<List<Post>> getAllPosts() async {
    final box = await Hive.openBox<Post>(boxName);
    return box.values.toList();
  }

  @override
  Future<Post?> getPostById(String id) async {
    final box = await Hive.openBox<Post>(boxName);
    final post = box.values.where((post) => post.id == id).firstOrNull;
    return post;
  }

  @override
  Future<void> savePost(Post post) async {
    final box = await Hive.openBox<Post>(boxName);
    await box.put(post.id, post);
  }

  @override
  Future<void> deletePost(String id) async {
    final box = await Hive.openBox<Post>(boxName);
    await box.delete(id);
  }
}
