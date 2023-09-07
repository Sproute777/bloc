import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list/posts/models/post.dart';

final class PostSegment extends Equatable {
  const PostSegment({this.posts = const <Post>[]});
  final List<Post> posts;

  int get firstId => posts.isNotEmpty ? posts.first.id : -1;
  int get lastId =>   posts.isNotEmpty ? posts.last.id : -1;

  @override
  List<Object> get props => [posts];
}
