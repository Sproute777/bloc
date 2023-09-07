import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_infinite_list/posts/widgets/post_segment_item.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case PostStatus.success:
            if (state.segments.isEmpty) {
              return const Center(child: Text('no posts'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (!state.hasReachedStart && index == 0) {
                  return TopLoader(
                    callback: () => context.read<PostBloc>().add(
                          PostHeadFetched(),
                        ),
                  );
                }
                if (!state.hasReachedEnd && index >= state.segments.length) {
                return  BottomLoader(
                    callback: () => context.read<PostBloc>().add(
                          PostTailFetched(),
                        ),
                  );
                }
                return PostSegmentItem(segment: state.segments[index - state.hasReachedStart.toInt]);
              },
              itemCount: state.segments.length +
                  state.hasReachedStart.toInt + state.hasReachedEnd.toInt,
            );
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

extension _BoolToInt on bool {
  int get toInt => this ? 0 : 1;
}
