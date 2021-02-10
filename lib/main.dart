import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_ex/bloc/posts/posts_bloc.dart';

import 'models/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PostsBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> {
  List<Post> _posts = [];
  TextEditingController _filterQuery = TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    this._filterQuery.addListener(this._onFilterChanged);
  }

  @override
  void dispose() {
    this._filterQuery.removeListener(this._onFilterChanged);
    this._filterQuery.dispose();
    this._debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<PostsBloc>().add(FetchPosts());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test app with BLOC'),
      ),
      body: Center(
        child: BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            if (state is PostsFetched) {
              this._posts = state.posts;
            }

            if (state is PostsFiltered) {
              this._posts = state.posts;
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: filterField(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: listBuilder,
                    itemCount: _posts.length,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget filterField() {
    return TextField(
      controller: this._filterQuery,
      decoration: InputDecoration(labelText: 'Заголовок'),
    );
  }

  Widget listBuilder(BuildContext context, int index) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(this._posts[index].title),
              subtitle: Text(this._posts[index].body),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onFilterChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context
          .read<PostsBloc>()
          .add(FilterPosts(this._filterQuery.text, this._posts));
    });
  }
}
