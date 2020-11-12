import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp002/database.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/musicplayerpage.dart';
import 'package:musicapp002/textstyling.dart';
import 'package:audioplayer/audioplayer.dart';

class Playlist_songs extends StatefulWidget {
  final String username;
  final String playlistname;

  // Homepage({Key key, this.username}) : super(key: key);
  Playlist_songs({
    Key key,
    this.username,
    this.playlistname,
  }) : super(key: key);
  @override
  _Playlist_songsState createState() => _Playlist_songsState();
}

class _Playlist_songsState extends State<Playlist_songs> {
  List<String> imagenames = List();
  // List<String> duplicateimagenames =List();
  String songname;
  int i;
  AudioPlayer audioPlayer = AudioPlayer();
  String appbarname;
  @override
  Widget build(BuildContext context) {
    if (widget.playlistname != null) {
      if (widget.playlistname == "songsfield") {
        appbarname = "All Songs";
      } else if (widget.playlistname == "favs") {
        appbarname = "Favourites";
      } else {
        appbarname = widget.playlistname;
      }
    }
    print(widget.playlistname);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Songs")
            .doc(widget.username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Loading();
          }
          DocumentSnapshot userdata = snapshot.data;
          imagenames = List(userdata.data()[widget.playlistname].length);
          //  duplicateimagenames = List(userdata.data()[widget.playlistname].length);
          for (i = 0; i < userdata.data()[widget.playlistname].length; i++) {
            //   duplicateimagenames[i]=userdata.data()[widget.playlistname][i];
            songname = userdata.data()[widget.playlistname][i];
            songname = songname.split("/")[7];
            songname = songname.replaceAll("%20", " ");
            songname = songname.replaceAll("%2C", ",");
            songname = songname.substring(0, songname.indexOf('.mp3'));
            songname = songname.replaceAll("%40", "@");
            //  songname = songname.replaceAll("by", "");
            //songname = songname.replaceAll(widget.username, "");
            imagenames[i] = songname;
          }
          print(songname);
          // print(userdata.data()[widget.playlistname]);
          return imagenames.length != 0
              ? Scaffold(
                  appBar: AppBar(
                    title: Text(appbarname),
                  ),
                  body: FutureBuilder(
                      future: Database().downloadimagelist(imagenames),
                      builder: (context, snapshot) {
                        print(imagenames);
                        // print(snapshot.data);
                        if (snapshot.data == null) {
                          return Loading();
                        }
                        print(snapshot.data);
                        return ListView.builder(
                          itemCount: imagenames.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: snapshot.data[index] == null
                                    ? Loading()
                                    : ClipOval(
                                        child: Image.network(
                                        snapshot.data[index],
                                        height: 50,
                                        width: 50,
                                      )),
                                title: Text(imagenames[index]),
                                onTap: () async {
                                  await audioPlayer.stop();
                                  await audioPlayer.play(userdata
                                      .data()[widget.playlistname][index]);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Musicplayerpage(
                                      imageurl: snapshot.data[index].toString(),
                                      index: index,
                                      songurl:
                                          userdata.data()[widget.playlistname],
                                      imagenames: imagenames,
                                      username: widget.username,
                                      songfield: widget.playlistname,
                                    );
                                  }));
                                },
                              ),
                            );
                          },
                        );
                      }),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text("Favourites"),
                  ),
                  body: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 170,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        "Sorry You Do't Have Any Favourite Songs try Adding a Song to Favourites And Comeback Later! ",
                                    style: textstyling.copyWith(fontSize: 25)),
                                WidgetSpan(
                                  child: Icon(Icons.error,
                                      color: Colors.grey, size: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}
