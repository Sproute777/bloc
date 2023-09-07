import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:http/http.dart' as http;

part 'post_event.dart';
part 'post_state.dart';

const _postLimit = 20;
// 40 ~ 60
const _segmentsCacheLimit = 3;

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostHeadFetched>(_onPostHeadFetched,transformer: sequential());
    on<PostTailFetched>(_onPostTailFetched,transformer: sequential());
  }

  final http.Client httpClient;

  Future<void> _onPostHeadFetched(
    PostHeadFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedStart) return;
    try {
      final posts = await _fetchPosts(state.segments.first.firstId - _postLimit);
      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedStart: true));
      }

      final segments = List.of(state.segments)
        ..insert(
          0,
          PostSegment(
            posts: posts,
          ),
        );
      if (segments.length > _segmentsCacheLimit) {
        segments.removeLast();
        return emit(
          state.copyWith(
            status: PostStatus.success,
            segments: segments,
            hasReachedEnd: false,
            hasReachedStart: false,
          ),
        );
      }
      return emit(
        state.copyWith(
          status: PostStatus.success,
          segments: segments,
          hasReachedStart: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onPostTailFetched(
    PostTailFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedEnd) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return emit(
          state.copyWith(
            status: PostStatus.success,
            segments: [
              PostSegment(posts: posts),
            ],
            hasReachedEnd: false,
          ),
        );
      }
      final posts = await _fetchPosts(state.segments.last.lastId);
      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedEnd: true));
      }

      final segments = List.of(state.segments)
        ..add(
          PostSegment(
            posts: posts,
          ),
        );
      if (segments.length > _segmentsCacheLimit) {
        segments.removeAt(0);
        return emit(
          state.copyWith(
            status: PostStatus.success,
            segments: segments,
            hasReachedStart: false,
            hasReachedEnd: false,
          ),
        );
      }
      return emit(
        state.copyWith(
          status: PostStatus.success,
          segments: segments,
          hasReachedEnd: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
