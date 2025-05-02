import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_board/domain/models/post/post.dart';

part 'post_state.freezed.dart';

@freezed
class PostListState with _$PostListState {
  const factory PostListState.loading() = _Loading;
  const factory PostListState.data(List<Post> posts) = _Data;
  const factory PostListState.error(String message) = _Error;
}

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState.loading() = _DetailLoading;
  const factory PostDetailState.data(Post post) = _DetailData;
  const factory PostDetailState.error(String message) = _DetailError;
}