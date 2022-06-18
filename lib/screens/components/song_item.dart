import 'package:flager_player/notifiers/playlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flager_player/notifiers/play_button_notifier.dart';
import 'package:flager_player/services/service_locator.dart';
import 'package:flager_player/utilities/page_manager.dart';
import 'package:flager_player/widgets/null_art_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongItem extends StatefulWidget {
  SongModel songModel;
  final List<SongModel> currentSongs;
  bool? isPlaylist;
  int? playlistId;

  SongItem({required this.songModel , required this.currentSongs, this.isPlaylist, this.playlistId, Key? key}) : super(key: key);

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {


  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                  pageManager.onClickSongItem(widget.currentSongs, widget.songModel.data);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: QueryArtworkWidget(
                            id: widget.songModel.id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: NullArtWidget(),
                            artworkBorder: BorderRadius.circular(8.0),
                            key: Key("${widget.songModel}"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.songModel.title.length > 20 ?
                              widget.songModel.title.substring(0, 20) + "..." :
                              widget.songModel.title,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Opacity(
                            opacity: 0.5,
                            child: Text(widget.songModel.artist!, style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  ValueListenableBuilder<ButtonState>(
                    valueListenable: pageManager.playButtonNotifier,
                    builder: (_, value, __) {
                      if(value == ButtonState.playing){
                        return ValueListenableBuilder<String>(
                          valueListenable: pageManager.currentSongIdNotifier,
                          builder: (_, currentId, __) {

                            if(currentId == widget.songModel.data){
                              return Image.asset("assets/images/song-is-play-gifly.gif", height: 20, width: 20,);
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  //Image.asset("assets/images/song-is-play-gifly.gif", height: 20, width: 20,),
                  IconButton(
                    icon: Icon(Icons.more_vert_rounded),
                    onPressed: () => _onClickMenuPlaylist(context),
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: AppLocalizations.of(context)!.localeName == "fa" ?
          const EdgeInsets.only(right:82.0) : const EdgeInsets.only(left:82.0),
          child: Container(height: 0.13, color: Colors.blueGrey, width: double.infinity,),
        )
      ],
    );
  }





  _onClickMenuPlaylist(BuildContext context) async{

    showModalBottomSheet(

        backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
          return Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                (widget.isPlaylist != null && widget.isPlaylist!) ?

                ListTile(
                  title: Text(AppLocalizations.of(context)!.delete_song_from_playlist_btn),
                  onTap: (){
                    if(widget.playlistId != null){
                      context.read<PlaylistNotifier>().removeSongToPlaylist(widget.playlistId!, widget.songModel.id);
                    }

                    Navigator.of(context).pop();

                  },
                  tileColor: Theme.of(context).primaryColor.withAlpha(30),
                  leading: Icon(Icons.add_rounded),
                )

                : ListTile(
                  title: Text(AppLocalizations.of(context)!.add_to_playlist),
                  onTap: (){
                    Navigator.of(context).pop();
                    _openModalSheetPlaylists(context);
                  },
                  tileColor: Theme.of(context).primaryColor.withAlpha(30),
                  leading: Icon(Icons.add_rounded),
                ),
              ],
            ),
          );
        });
  }




  _openModalSheetPlaylists(BuildContext context) async{
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
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
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.zero,
                        itemCount:  Provider.of<PlaylistNotifier>(context).getPlaylists.length,
                        itemBuilder: (BuildContext context, int index) {
                          final playlist = Provider.of<PlaylistNotifier>(context).getPlaylists[index];
                          return ListTile(
                            title: Text(playlist.playlist),
                            onTap: (){
                              context.read<PlaylistNotifier>().addSongToPlaylist(playlist.id, widget.songModel.id);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }



}
