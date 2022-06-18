import 'package:flutter/material.dart';
import 'package:flager_player/screens/components/song_item.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SongsModalSheet extends StatefulWidget {
  final List<SongModel> songs;
  final String? title;
  bool? isPlaylist;
  int? playlistId;
  SongsModalSheet({required this.songs, this.title, this.isPlaylist, this.playlistId, Key? key}) : super(key: key);

  @override
  State<SongsModalSheet> createState() => _SongsModalSheetState();
}

class _SongsModalSheetState extends State<SongsModalSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, controller){
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 3,
                  width: 50,
                  color: Colors.grey,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Theme.of(context).primaryColor,
                          child: Icon(Icons.library_music_rounded, color: Colors.white,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(widget.title ?? AppLocalizations.of(context)!.tab_all_songs),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: EdgeInsets.zero,
                  itemCount: widget.songs.length,
                  itemBuilder: (BuildContext context, int index) {
                   return SongItem(
                     songModel: widget.songs[index],
                     currentSongs: widget.songs,
                     isPlaylist: widget.isPlaylist,
                     playlistId: widget.playlistId,
                   );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
