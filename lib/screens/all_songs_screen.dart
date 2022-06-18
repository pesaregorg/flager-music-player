import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flager_player/screens/components/song_item.dart';
import 'package:on_audio_query/on_audio_query.dart';


class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({Key? key}) : super(key: key);

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: SongSortType.DATE_ADDED,
          orderType: null,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item){

          if (item.data == null) return const Center(child: CircularProgressIndicator(),);

          // When you try "query" without asking for [READ] or [Library] permission
          // the plugin will return a [Empty] list.
          if (item.data!.isEmpty) return const Text("Nothing found!");

          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: item.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return SongItem(songModel: item.data![index], currentSongs: item.data!,);
              }
          );
        },

      ),
    );
  }
}
