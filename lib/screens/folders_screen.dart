import 'package:flutter/material.dart';
import 'package:flager_player/screens/components/folder_item.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({Key? key}) : super(key: key);

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text("Empty"),
      )/*ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 0,
          itemBuilder: (BuildContext context, int index){
            return FolderItem();
          }
      )*/
    );
  }
}
