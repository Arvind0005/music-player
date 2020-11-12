import 'package:flutter/material.dart';
import 'package:musicapp002/addsongs.dart';
import 'package:musicapp002/displayplaylist.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/songsplaylist.dart';
import 'account.dart';
import 'explore.dart';
import 'housepage.dart';
import 'post.dart';

class Homepage extends StatefulWidget {
  final String username;
  Homepage({Key key, this.username}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  int index = 0;
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Housepage(username: widget.username),
      //Loading(),
      Playlist_songs(
        username: widget.username,
        playlistname: "favs",
      ),
      Addsongs(username: widget.username),
      Displaylist(username: widget.username),
      Account(username: widget.username),
    ];
    return Scaffold(
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          child: Icon(
            Icons.access_time,
            size: 40.0,
            color: Colors.grey[400],
          ),
          onPressed: () {},
          backgroundColor: Colors.grey[700],
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData.dark(),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          //elevation: 120.0,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey[500],
          selectedItemColor: Colors.grey[300],
          onTap: (int x) {
            setState(() {
              index = x;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              title: Text("All Songs"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text("Favourites"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              title: Text("Add song"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_play),
              title: Text("Playlist"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Account"),
            )
          ],
        ),
      ),
      body: widgets[index],
    );
  }
}
