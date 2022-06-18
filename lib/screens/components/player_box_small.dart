import 'package:flutter/material.dart';
import 'package:flager_player/notifiers/play_button_notifier.dart';
import 'package:flager_player/screens/components/player_box_modal.dart';
import 'package:flager_player/services/service_locator.dart';
import 'package:flager_player/utilities/page_manager.dart';

class PlayerBoxSmall extends StatelessWidget {
  const PlayerBoxSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return Container(
      height: 45,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.blueGrey,
                  width: 0.3
              )
          )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<ButtonState>(
            valueListenable: pageManager.playButtonNotifier,
            builder: (_, value, __) {
              switch (value) {
                case ButtonState.loading:
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator(),
                  );
                case ButtonState.paused:
                  return IconButton(
                    icon: Icon(Icons.play_arrow_rounded, color: Theme.of(context).primaryColor,),
                    iconSize: 32.0,
                    onPressed: pageManager.play,
                  );
                case ButtonState.playing:
                  return IconButton(
                    icon: Icon(Icons.pause_rounded, color: Theme.of(context).primaryColor),
                    iconSize: 32.0,
                    onPressed: pageManager.pause,
                  );
              }
            },
          ),
          Expanded(
            child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context){
                        return PlayerBoxModal();
                      });
                },
                child:  Center(
                  child: Container(
                    width: double.infinity,
                    child: ValueListenableBuilder<String>(
                      valueListenable: pageManager.currentSongTitleNotifier,
                      builder: (_, value, __) {
                        return Text(value, textAlign: TextAlign.start,);
                      },
                    ),
                  ),
                  ),
                )
            ),
        ],
      ),
    );
  }
}
