import 'package:flager_player/notifiers/playlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flager_player/screens/components/songs_modal_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistItem extends StatefulWidget {
  final PlaylistModel playlistModel;
  const PlaylistItem({required this.playlistModel,Key? key}) : super(key: key);

  @override
  State<PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {

  final OnAudioQuery _audioQuery = OnAudioQuery();

  String newPlaylistName = '';


  _onClickPlaylist(BuildContext context) async{
    context.read<PlaylistNotifier>().songsPlaylist(widget.playlistModel.id);
    //List<SongModel> songs = Provider.of<PlaylistNotifier>(context).getCurrentSongModelPlaylist;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
          return SongsModalSheet(songs: Provider.of<PlaylistNotifier>(context).getCurrentSongModelPlaylist, title: "Playlist ${widget.playlistModel.playlist}",
            isPlaylist: true, playlistId: widget.playlistModel.id,);
        });
  }



  _onClickMenuPlaylist(BuildContext context, int playlistId) async{
    showModalBottomSheet(

        backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.alert_playlist_edit_title),
                  onTap: (){
                    Navigator.of(context).pop();
                    showAlertEdit(context, widget.playlistModel);
                  },
                  tileColor: Theme.of(context).primaryColor.withAlpha(30),
                  leading: Icon(Icons.edit_rounded),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.playlist_delete_btn),
                  onTap: (){
                    Navigator.of(context).pop();
                    showAlertDelete(context, widget.playlistModel);
                  },
                  tileColor: Theme.of(context).primaryColor.withAlpha(30),
                  leading: Icon(Icons.delete_rounded),
                )
              ],
            ),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _onClickPlaylist(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Theme.of(context).primaryColor,
                            child: Icon(Icons.playlist_add_check_circle_rounded, color: Colors.white,),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.playlistModel.playlist, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 8.0,),
                            Opacity(
                              opacity: 0.5,
                              child: Text("${widget.playlistModel.numOfSongs} ${AppLocalizations.of(context)!.song}", style: TextStyle( fontSize: 12), overflow: TextOverflow.ellipsis,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                child: IconButton(
                  icon: Icon(Icons.more_vert_rounded),
                  onPressed: () => _onClickMenuPlaylist(context, widget.playlistModel.id),
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
      ),
    );
  }




  void showAlertEdit(BuildContext context, PlaylistModel playlistModel) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.alert_playlist_edit_hint_input,
                    ),
                    onChanged: (value){
                      newPlaylistName = value;
                      setState((){});
                    },
                  ),
                ),
              ),
              title: Text(AppLocalizations.of(context)!.alert_playlist_edit_title),
              actions: [
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.alert_playlist_edit_save_btn),
                    onPressed: () {
                      context.read<PlaylistNotifier>().renamePlaylist(playlistModel.id, newPlaylistName);
                      Navigator.of(context).pop();
                    }
                ),
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.alert_playlist_edit_cancel_btn),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ));
  }



  void showAlertDelete(BuildContext context, PlaylistModel playlistModel) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(AppLocalizations.of(context)!.are_you_sure_delete_playlist),
                ),
              ),
              title: Text(AppLocalizations.of(context)!.playlist_delete_btn),
              actions: [
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.yes),
                    onPressed: () {
                      context.read<PlaylistNotifier>().removePlaylist(widget.playlistModel.id);
                      Navigator.of(context).pop();
                    }
                ),
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.no),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ));
  }


}
