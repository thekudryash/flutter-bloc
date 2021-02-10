part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostsEvent {}

class FilterPosts extends PostsEvent {
  final String filterQuery;
  final List<Post> posts;

  const FilterPosts(this.filterQuery, this.posts);

  @override
  List<Object> get props => [this.filterQuery, this.posts];
}
