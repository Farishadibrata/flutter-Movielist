import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttermovie/Layout/tile.dart';
import 'package:fluttermovie/Movie/fetches.dart';
import 'package:fluttermovie/Movie/model.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Trending Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Results>?> movieList;

  @override
  void initState() {
    super.initState();
    updateMovie();
  }

  updateMovie() {
    movieList = fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
              future: movieList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data == null
                      ? Container()
                      : ListView.builder(
                          itemBuilder: ((ctx, index) => CustomListItemTwo(
                                thumbnail: Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage("https://image.tmdb.org/t/p/original${snapshot.data![index].posterPath!}"), fit: BoxFit.fitHeight)
                                  ),
                                ),
                                title: snapshot.data![index].name == null
                                    ? snapshot.data![index].title!
                                    : snapshot. data![index].name!,
                                subtitle: snapshot.data![index].overview!,
                                author:
                                    snapshot.data?[index].releaseDate != null
                                        ? "Release Date : ${snapshot.data![index].releaseDate!}"
                                        : "",
                                publishDate: "Score: ${snapshot.data![index].voteAverage}",
                                readDuration:
                                    "Votes : ${snapshot.data![index].voteCount}",
                              )),
                          itemCount: snapshot.data!.length);
                } else {
                  return const ListTile(
                    title: Text("Loading"),
                    subtitle: Text("Please wait"),
                  );
                }
              })),
    );
  }
}
