part of 'posts_bloc.dart';

@immutable
abstract class PostsState {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsFetched extends PostsState {
  final List<Post> posts;

  const PostsFetched(this.posts);

  @override
  List<Object> get props => [this.posts];
}

class PostsFiltered extends PostsState {
  final List<Post> posts;

  const PostsFiltered(this.posts);

  @override
  List<Object> get props => [this.posts];
}
