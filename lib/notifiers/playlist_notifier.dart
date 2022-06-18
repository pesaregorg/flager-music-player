import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistNotifier with ChangeNotifier{
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<PlaylistModel> _playlists = [];
  List<SongModel> _currentSongModelList = [];

  PlaylistNotifier(){
    _init();
  }

  void _init() async {
    _playlists = await _audioQuery.queryPlaylists();
    notifyListeners();
  }


  void reloadPlaylist() async {
    _playlists = await _audioQuery.queryPlaylists();
    notifyListeners();
  }


  void createPlaylist(String name) async {
    try{
      await _audioQuery.createPlaylist(name);
      _playlists = await _audioQuery.queryPlaylists();
      notifyListeners();
    }catch(e){
      print("error remove");
    }
  }



  void removePlaylist(int id) async {
    try{
      await _audioQuery.removePlaylist(id);
      _playlists = await _audioQuery.queryPlaylists();
      notifyListeners();
    }catch(e){
      print("error remove");
    }
  }


  void renamePlaylist(int id, String name) async {
    try{
      _audioQuery.renamePlaylist(id, name);
      _playlists = await _audioQuery.queryPlaylists();
      notifyListeners();
    }catch(e){
      print("error rename");
    }
  }


  void addSongToPlaylist(int playlistId, int audioId) async {
    try{
      _audioQuery.addToPlaylist(playlistId, audioId);
      _playlists = await _audioQuery.queryPlaylists();
      notifyListeners();
    }catch(e){
      print("error rename");
    }
  }



  void removeSongToPlaylist(int playlistId, int audioId) async {
    try{
      _audioQuery.removeFromPlaylist(playlistId, audioId);
      _playlists = await _audioQuery.queryPlaylists();
      songsPlaylist(playlistId);
      notifyListeners();
    }catch(e){
      print("error rename");
    }
  }




  void songsPlaylist(int playlistId) async {
    try{
      _currentSongModelList = await _audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST,
       playlistId,
        sortType: SongSortType.TITLE, // Default
        orderType: OrderType.ASC_OR_SMALLER, // Default
      );
      notifyListeners();
    }catch(e){
      print("error list songs");
    }
  }




  List<PlaylistModel> get getPlaylists => _playlists;
  List<SongModel> get getCurrentSongModelPlaylist => _currentSongModelList;

}