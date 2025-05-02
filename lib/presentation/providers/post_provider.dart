import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_board/data/repositories/hive_post_repository.dart';
import 'package:riverpod_board/domain/models/post/post.dart';
import 'package:riverpod_board/domain/repositories/post_repository_interface.dart';
import 'package:riverpod_board/presentation/states/post_state.dart';
import 'package:uuid/uuid.dart';

part 'post_provider.g.dart';

// Repository provider
@riverpod
PostRepository postRepository(Ref ref) {
  return HivePostRepository();
}

// Post list notifier
class PostListNotifier extends StateNotifier<PostListState> {
  final PostRepository _repository;

  PostListNotifier(this._repository) : super(const PostListState.loading()) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      state = const PostListState.loading();
      final posts = await _repository.getAllPosts();
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신순 정렬
      state = PostListState.data(posts);
    } catch (e) {
      state = PostListState.error(e.toString());
    }
  }

  Future<void> addPost(String title, String content) async {
    try {
      final newPost = Post(
        id: const Uuid().v4(),
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );
      await _repository.savePost(newPost);
      loadPosts(); // 목록 리로드
    } catch (e) {
      state = PostListState.error(e.toString());
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _repository.deletePost(id);
      loadPosts(); // 목록 리로드
    } catch (e) {
      state = PostListState.error(e.toString());
    }
  }
}

// Post list provider
@riverpod
StateNotifierProvider<PostListNotifier, PostListState> postList(Ref ref) {
  final repository = ref.watch(postRepositoryProvider);
  return StateNotifierProvider<PostListNotifier, PostListState>(
    (ref) => PostListNotifier(repository),
  );
}

// Post detail notifier & provider
class PostDetailNotifier extends StateNotifier<PostDetailState> {
  final PostRepository _repository;
  final String _postId;

  PostDetailNotifier(this._repository, this._postId)
    : super(const PostDetailState.loading()) {
    loadPost();
  }

  Future<void> loadPost() async {
    try {
      state = const PostDetailState.loading();
      final post = await _repository.getPostById(_postId);
      if (post != null) {
        state = PostDetailState.data(post);
      } else {
        state = const PostDetailState.error('Post not found');
      }
    } catch (e) {
      state = PostDetailState.error(e.toString());
    }
  }

  Future<void> updatePost(String title, String content) async {
    try {
      final updatedPost = state.maybeWhen(
        data: (post) => post.copyWith(title: title, content: content),
        orElse: () => throw Exception('Invalid state'),
      );
      await _repository.savePost(updatedPost);
      state = PostDetailState.data(updatedPost);
    } catch (e) {
      state = PostDetailState.error(e.toString());
    }
  }
}

// Post detail provider factory
@riverpod
StateNotifierProvider<PostDetailNotifier, PostDetailState> postDetail(
  Ref ref,
  String postId,
) {
  final repository = ref.watch(postRepositoryProvider);
  return StateNotifierProvider<PostDetailNotifier, PostDetailState>(
    (ref) => PostDetailNotifier(repository, postId),
  );
}
