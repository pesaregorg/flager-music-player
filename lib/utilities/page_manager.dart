import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flager_player/notifiers/play_button_notifier.dart';
import 'package:flager_player/notifiers/progress_notifier.dart';
import 'package:flager_player/notifiers/repeat_button_notifier.dart';
import 'package:flager_player/services/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final currentSongIdNotifier = ValueNotifier<String>('');
  final currentSongIndexNotifier = ValueNotifier<int>(0);
  final currentSongArtIdNotifier = ValueNotifier<int>(0);
  final currentSongArtistNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final currentSongModelsNotifier = ValueNotifier<List<SongModel>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final OnAudioQuery _audioQuery = OnAudioQuery();

  final _audioHandler = getIt<AudioHandler>();

  // Events: Calls coming from the UI
  void init() async {
    await _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  Future<void> _loadPlaylist() async {

    List<SongModel> songs = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: null,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    currentSongModelsNotifier.value = songs;

    final mediaItems = songs.map((song) => MediaItem(
      id: song.data,
      album: song.album ?? '',
      artist: song.artist ?? '',
      title: song.title ,
      extras: {'url': song.data, "artId": song.id},
    )).toList();

    _audioHandler.addQueueItems(mediaItems);
  }



  Future<void> onClickSongItem(List<SongModel> songs, String mediaId) async {

    currentSongModelsNotifier.value = songs;

    final mediaItems = songs.map((song) => MediaItem(
      id: song.data,
      album: song.album ?? '',
      artist: song.artist ?? '',
      title: song.title ,
      extras: {'url': song.data, "artId": song.id},
    )).toList();



    final newIndex = songs.indexWhere((item) => item.data == mediaId);
    currentSongIndexNotifier.value = newIndex;
    await _audioHandler.addQueueItems(mediaItems);
    _audioHandler.play();

  }



  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {

      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
        currentSongIdNotifier.value = '';
        currentSongArtIdNotifier.value = 0;
        currentSongArtistNotifier.value = '';
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      currentSongIdNotifier.value = mediaItem?.id ?? '';
      currentSongArtIdNotifier.value = mediaItem?.extras!["artId"] ?? 0;
      currentSongArtistNotifier.value = mediaItem?.artist ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> add(SongModel song) async {

    final mediaItem = MediaItem(
      id: song.data,
      album: song.album,
      title: song.title,
      extras: {'url': song.data, "artId": song.id},
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}