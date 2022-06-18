import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flager_player/notifiers/play_button_notifier.dart';
import 'package:flager_player/notifiers/repeat_button_notifier.dart';
import 'package:flager_player/screens/components/player_box_model_progress_bar.dart';
import 'package:flager_player/screens/components/song_item.dart';
import 'package:flager_player/services/service_locator.dart';
import 'package:flager_player/utilities/page_manager.dart';
import 'package:flager_player/widgets/null_art_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerBoxModal extends StatefulWidget {
  PlayerBoxModal({Key? key}) : super(key: key);

  @override
  State<PlayerBoxModal> createState() => _PlayerBoxModalState();
}

class _PlayerBoxModalState extends State<PlayerBoxModal> {


  void showAlert(BuildContext context) {
    final pageManager = getIt<PageManager>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: pageManager.currentSongArtIdNotifier,
                  builder: (_, value, __) {
                    return QueryArtworkWidget(
                      id: value,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: NullArtWidget(),
                      artworkBorder: BorderRadius.circular(8.0),
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

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
                child: ValueListenableBuilder<List<SongModel>>(
                  valueListenable: pageManager.currentSongModelsNotifier,
                  builder: (_, value, __) {
                    return ListView.builder(
                      controller: controller,
                      padding: EdgeInsets.zero,
                      itemCount: value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SongItem(songModel: value[index], currentSongs: value);
                      },
                    );
                  },
                )
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.95)
                    )
                  ],
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: InkWell(
                                  onTap: () => showAlert(context),
                                  child: ValueListenableBuilder<int>(
                                    valueListenable: pageManager.currentSongArtIdNotifier,
                                    builder: (_, value, __) {
                                      return QueryArtworkWidget(
                                        id: value,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: NullArtWidget(),
                                        artworkBorder: BorderRadius.circular(8.0),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ValueListenableBuilder<String>(
                                    valueListenable: pageManager.currentSongTitleNotifier,
                                    builder: (_, value, __) {
                                      return Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis,);
                                    },
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: pageManager.currentSongArtistNotifier,
                                    builder: (_, value, __) {
                                      return Opacity(
                                        opacity: 0.5,
                                        child: Text(value, style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis,),
                                      );
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PlayerBoxModelProgressBar(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder<RepeatState>(
                              valueListenable: pageManager.repeatButtonNotifier,
                              builder: (_, value, __) {
                                switch (value) {
                                  case RepeatState.off:
                                    return IconButton(
                                      icon: const Icon(Icons.arrow_right_alt_rounded),
                                      onPressed: pageManager.repeat,
                                    );
                                  case RepeatState.repeatPlaylist:
                                    return IconButton(
                                      icon: const Icon(Icons.loop_rounded),
                                      onPressed: pageManager.repeat,
                                    );
                                  case RepeatState.repeatSong:
                                    return IconButton(
                                      icon: const Icon(Icons.repeat_one_rounded),
                                      onPressed: pageManager.repeat,
                                    );
                                }
                              },
                            ),
                            IconButton(
                                onPressed: pageManager.next,
                                icon: Icon(Icons.skip_next_rounded)
                            ),
                            ValueListenableBuilder<ButtonState>(
                              valueListenable: pageManager.playButtonNotifier,
                              builder: (_, value, __) {
                                switch (value) {
                                  case ButtonState.loading:
                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      width: 36.0,
                                      height: 36.0,
                                      child: CircularProgressIndicator(),
                                    );
                                  case ButtonState.paused:
                                    return IconButton(
                                      icon: Icon(Icons.play_arrow_rounded, color: Theme.of(context).primaryColor,),
                                      iconSize: 36.0,
                                      onPressed: pageManager.play,
                                    );
                                  case ButtonState.playing:
                                    return IconButton(
                                      icon: Icon(Icons.pause_rounded, color: Theme.of(context).primaryColor),
                                      iconSize: 36.0,
                                      onPressed: pageManager.pause,
                                    );
                                }
                              },
                            ),
                            IconButton(
                                onPressed: pageManager.previous,
                                icon: Icon(Icons.skip_previous_rounded)
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: pageManager.isShuffleModeEnabledNotifier,
                              builder: (_, value, __) {
                                return IconButton(
                                  icon: Icon(value ?  Icons.shuffle_on_rounded : Icons.shuffle_rounded, color: value ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,),

                                  onPressed: pageManager.shuffle,
                                );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
