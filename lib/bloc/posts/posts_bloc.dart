import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_ex/api.dart';
import 'package:test_ex/models/post.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];

  PostsBloc() : super(PostsInitial());

  @override
  Stream<PostsState> mapEventToState(
    PostsEvent event,
  ) async* {
    if (event is FetchPosts) {
      this._posts = await Api.fetchPosts();
      yield PostsFetched(this._posts);
    }

    if (event is FilterPosts) {
      if (event.filterQuery.length == 0) {
        yield PostsFetched(this._posts);
      } else {
        final regex = RegExp(event.filterQuery);
        this._filteredPosts =
            event.posts.where((p) => regex.hasMatch(p.title)).toList();
        yield PostsFiltered(this._filteredPosts);
      }
    }
  }
}
