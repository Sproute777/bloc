part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

final class PostState extends Equatable {
  const PostState({
    this.status = PostStatus.initial,
    this.segments = const <PostSegment>[],
    this.hasReachedStart = false,
    this.hasReachedEnd = false,
  });

  final PostStatus status;
  final List<PostSegment> segments;
  final bool hasReachedStart;
  final bool hasReachedEnd;

  PostState copyWith({
    PostStatus? status,
    List<PostSegment>? segments,
    bool? hasReachedStart,
    bool? hasReachedEnd,
  }) {
    return PostState(
      status: status ?? this.status,
      segments: segments ?? this.segments,
      hasReachedStart: hasReachedStart ?? this.hasReachedStart,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  int get countPosts =>
      segments.fold<int>(
        segments.first.lastId,
        (count, nextSegment) => count + nextSegment.posts.length,
      );

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedStart: $hasReachedStart,, hasReachedEnd: $hasReachedEnd, posts: ${segments.length} }''';
  }

  @override
  List<Object> get props => [status, segments, hasReachedStart, hasReachedEnd];
}
