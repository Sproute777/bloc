import 'package:flutter/material.dart';

final class TopLoader extends Loader{
  const TopLoader({required super.callback, super.key,});
}


final class BottomLoader extends Loader{
  const BottomLoader({required super.callback, super.key,});
}


sealed class Loader extends StatelessWidget {
  const Loader({
    required this.callback, super.key,
  });
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    callback();
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
