import 'package:flager_player/notifiers/playlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flager_player/screens/components/playlist_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {

  String newPlayListName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showAlert(context),
            label: Text(AppLocalizations.of(context)!.create_playlist_btn),
            icon: const Icon(Icons.add_rounded),
            backgroundColor: Theme.of(context).primaryColor,
          ),
      body:  ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: Provider.of<PlaylistNotifier>(context).getPlaylists.length,
        itemBuilder: (context, index) {
          return PlaylistItem(playlistModel: Provider.of<PlaylistNotifier>(context).getPlaylists[index]);
        },
      ),
    );
  }


  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.alert_playlist_create_hint_input
                    ),
                    onChanged: (value){
                      setState((){
                        newPlayListName = value;
                      });
                    },
                  ),
                ),
              ),
              title: Text(AppLocalizations.of(context)!.alert_playlist_create_title),
              actions: [
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.alert_playlist_create_save_btn),
                    onPressed: (){
                      context.read<PlaylistNotifier>().createPlaylist(newPlayListName);
                      Navigator.of(context).pop();
                    },
                ),
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.alert_playlist_create_cancel_btn),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ));
  }

}
