import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';

class SegmentIndicator extends StatelessWidget {
  const SegmentIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return Row(
          children: [
            if (state.hasReachedStart)
              const _ColorBox(
                color: Colors.white,
              ),
              const SizedBox(width: 3),
            ...List.generate(
              state.segments.length,
              (index) => const _ColorBox(),
            ).expand((widget) => [widget,const SizedBox(width: 3)]),
            if (state.hasReachedEnd)
              const _ColorBox(
                color: Colors.white,
              )
          ],
        );
      },
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({super.key, this.color = Colors.yellow});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(
           5.0,
          ),
        ),
      ),
    );
  }
}
