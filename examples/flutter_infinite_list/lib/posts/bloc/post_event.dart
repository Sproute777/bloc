part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class PostHeadFetched extends PostEvent {}
final class PostTailFetched extends PostEvent {}
