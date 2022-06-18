import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flager_player/notifiers/progress_notifier.dart';
import 'package:flager_player/services/service_locator.dart';
import 'package:flager_player/utilities/page_manager.dart';

class PlayerBoxModelProgressBar extends StatefulWidget {
  const PlayerBoxModelProgressBar({Key? key}) : super(key: key);

  @override
  State<PlayerBoxModelProgressBar> createState() => _PlayerBoxModelProgressBarState();
}

class _PlayerBoxModelProgressBarState extends State<PlayerBoxModelProgressBar> {




  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
  
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      child: ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
    builder: (_, value, __) {
    return ProgressBar(
      barHeight: 3,
      thumbRadius: 6,
      timeLabelTextStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyMedium!.color
      ),
      progress: value.current,
      buffered: value.buffered,
      total: value.total,
      onSeek: pageManager.seek,
    );
  }
    ));
}
}
