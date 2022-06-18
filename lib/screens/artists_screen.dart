import 'package:flutter/material.dart';
import 'package:flager_player/screens/components/artist_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<ArtistModel>>(
        future: _audioQuery.queryArtists(
          sortType: ArtistSortType.ARTIST,
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
                return ArtistItem(artistModel: item.data![index],);
              }
          );
        },

      ),
    );
  }
}
