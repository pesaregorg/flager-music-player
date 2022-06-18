import 'package:flutter/material.dart';

class NullArtWidget extends StatelessWidget {
  const NullArtWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: Theme.of(context).primaryColor,
      child: Icon(Icons.music_note_rounded, color: Colors.white,),
    );
  }
}
