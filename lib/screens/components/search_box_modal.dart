import 'package:flager_player/screens/components/album_item.dart';
import 'package:flager_player/screens/components/artist_item.dart';
import 'package:flager_player/screens/components/song_item.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchBoxModal extends StatefulWidget {
  const SearchBoxModal({Key? key}) : super(key: key);

  @override
  State<SearchBoxModal> createState() => _SearchBoxModalState();
}

class _SearchBoxModalState extends State<SearchBoxModal> {

  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> searchSongs = [];
  List<SongModel> allSongs = [];
  List<ArtistModel> searchArtists = [];
  List<AlbumModel> searchAlbums = [];



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFetch(context));
  }

  _initFetch(BuildContext context) async{

    allSongs = await _audioQuery.querySongs(sortType: SongSortType.DATE_ADDED);
  }




  _inputSearchChanged(String text) async{
    if(text.isNotEmpty){
      List<dynamic> valueSongs = await _audioQuery.queryWithFilters(text, WithFiltersType.AUDIOS, args: AudiosArgs.TITLE);
      List<dynamic> valueArtists = await _audioQuery.queryWithFilters(text, WithFiltersType.ARTISTS, args: AudiosArgs.TITLE);
      List<dynamic> valueAlbums = await _audioQuery.queryWithFilters(text, WithFiltersType.ALBUMS, args: AudiosArgs.TITLE);

      setState((){
        searchSongs = valueSongs.toSongModel();
        searchArtists = valueArtists.toArtistModel();
        searchAlbums = valueAlbums.toAlbumModel();
      });
    }else{
      setState((){
        searchSongs = [];
        searchArtists = [];
        searchAlbums = [];
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, controller){
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),

          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 3,
                    width: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search_modal_input_hint,

                    ),
                    onChanged: (value){
                      _inputSearchChanged(value);
                    },
                  ),
                ),
              ),

              // songs
              searchSongs.isNotEmpty ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(AppLocalizations.of(context)!.search_modal_songs_title),
              ) : const SizedBox.shrink(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: searchSongs.isNotEmpty ? searchSongs.length > 5 ? 5 : searchSongs.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return SongItem(songModel: searchSongs[index], currentSongs: allSongs);
                },
              ),

              // artists
              searchArtists.isNotEmpty ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(AppLocalizations.of(context)!.search_modal_artists_title),
              ) : const SizedBox.shrink(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: searchArtists.isNotEmpty ? searchArtists.length > 5 ? 5 : searchArtists.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return ArtistItem(artistModel: searchArtists[index]);
                },
              ),

              // albums
              searchAlbums.isNotEmpty ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(AppLocalizations.of(context)!.search_modal_albums_title),
              ) : const SizedBox.shrink(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: searchAlbums.isNotEmpty ? searchAlbums.length > 5 ? 5 : searchAlbums.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return AlbumItem(albumModel: searchAlbums[index]);
                },
              ),

            ],
          ),
        );
      },
    );
  }
}
