import 'package:flager_player/screens/components/search_box_modal.dart';
import 'package:flager_player/screens/folders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flager_player/screens/albums_screen.dart';
import 'package:flager_player/screens/all_songs_screen.dart';
import 'package:flager_player/screens/artists_screen.dart';
import 'package:flager_player/screens/components/drawer_menu.dart';
import 'package:flager_player/screens/components/player_box_small.dart';
import 'package:flager_player/screens/playlists_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        drawer: DrawerMenu(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return <Widget>[
              SliverAppBar(

                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                title: Text(AppLocalizations.of(context)!.app_name),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.search_rounded),
                      onPressed: (){
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context){
                              return SearchBoxModal();
                            });
                      },
                    ),
                  )
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: Text(AppLocalizations.of(context)!.tab_all_songs),
                      icon: Icon(Icons.my_library_music_rounded),
                    ),
                    Tab(
                      child: Text(AppLocalizations.of(context)!.tab_playlists),
                      icon: Icon(Icons.playlist_add_check_circle_rounded),
                    ),
                    Tab(
                      child: Text(AppLocalizations.of(context)!.tab_artists),
                      icon: Icon(Icons.account_box_rounded),
                    ),
                    Tab(
                      child: Text(AppLocalizations.of(context)!.tab_albums),
                      icon: Icon(Icons.album_rounded),
                    ),
                    Tab(
                      child: Text(AppLocalizations.of(context)!.tab_folders),
                      icon: Icon(Icons.folder_copy_rounded),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              PlayerBoxSmall(),
              Expanded(

                child: TabBarView(
                  children: [
                    AllSongsScreen(),
                    PlaylistsScreen(),
                    ArtistsScreen(),
                    AlbumsScreen(),
                    FoldersScreen(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
