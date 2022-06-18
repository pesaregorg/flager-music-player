import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FolderItem extends StatefulWidget {
  const FolderItem({Key? key}) : super(key: key);

  @override
  State<FolderItem> createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){},
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
                          child: Icon(Icons.folder_rounded, color: Colors.white,),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Downloads", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 8.0,),
                          Opacity(
                            opacity: 0.5,
                            child: Text("34 موزیک", style: TextStyle( fontSize: 12), overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.more_vert_rounded),
                    onPressed: (){},
                  ),
                ],
              ),
            )
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
