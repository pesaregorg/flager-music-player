import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flager_player/screens/components/songs_modal_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumItem extends StatefulWidget {
  final AlbumModel albumModel;
  const AlbumItem({ required this.albumModel, Key? key}) : super(key: key);

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {

  final OnAudioQuery _audioQuery = OnAudioQuery();


  _onClickAlbum(BuildContext context, int albumId) async{
    List<SongModel> songs = await _audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      albumId,
      // You can also define a sortType
      sortType: SongSortType.TITLE, // Default
      orderType: OrderType.ASC_OR_SMALLER, // Default
    );
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
          return SongsModalSheet(songs: songs, title: "Album ${widget.albumModel.album}",);
        });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _onClickAlbum(context, widget.albumModel.id),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Theme.of(context).primaryColor,
                          child: Icon(Icons.album_rounded, color: Colors.white,),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.albumModel.album, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 8.0,),
                          Opacity(
                            opacity: 0.5,
                            child: Text("${widget.albumModel.numOfSongs} موزیک", style: TextStyle( fontSize: 12), overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
}
