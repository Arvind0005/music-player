import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/textstyling.dart';
import 'package:musicapp002/songsplaylist.dart';

class Displaylist extends StatefulWidget {
  final String username;
  Displaylist({Key key, this.username}) : super(key: key);
  @override
  _DisplaylistState createState() => _DisplaylistState();
}

class _DisplaylistState extends State<Displaylist> {
  final formkey = GlobalKey<FormState>();
  String playlistname = '';
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Songs")
            .doc(widget.username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Loading();
          }
          DocumentSnapshot playlistdocument = snapshot.data;
          List playlist = playlistdocument.data()["playlist"];
          print("xyz");
          print(playlist);
          return playlist == null
              ? loading == true
              : playlist.length == 0
                  ? Form(
                      key: formkey,
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text("Playlists"),
                        ),
                        body: Container(
                          //  color: Colors.,
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 150,
                              ),
                              Container(
                                height: height - (80 + 150),
                                width: width,
                                //      color: Colors.red,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "Sorry Your Playlist Does Not Have Any Songs In It try Adding a Song And Comeback Later! ",
                                                    style: textstyling.copyWith(
                                                        fontSize: 25)),
                                                WidgetSpan(
                                                  child: Icon(Icons.error,
                                                      color: Colors.grey,
                                                      size: 25),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : StreamBuilder(
                      key: _scaffoldKey,
                      stream: FirebaseFirestore.instance
                          .collection("Songs")
                          .doc(widget.username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Loading();
                        }
                        DocumentSnapshot playlistdata = snapshot.data;
                        List playlistnames = playlistdata.data()["playlist"];
                        return loading == true
                            ? Loading()
                            : Scaffold(
                                //key: _scaffoldKey,
                                appBar: AppBar(
                                  title: Text("Playlist"),
                                ),
                                body: ListView.builder(
                                  itemCount: playlistnames.length,
                                  itemBuilder: (context, index) {
                                    if (index == playlistnames.length - 1) {
                                      return Column(
                                        children: [
                                          Card(
                                            margin: EdgeInsets.fromLTRB(
                                                5.0, 5.0, 5.0, 5.0),
                                            child: ListTile(
                                              title: Text(playlistnames[index]),
                                              onTap: () async {
                                                setState(() {
                                                  loading = true;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Playlist_songs(
                                                              username: widget
                                                                  .username,
                                                              playlistname:
                                                                  playlistnames[
                                                                      index],
                                                            )));
                                                setState(() {
                                                  loading = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return Column(
                                      children: [
                                        Card(
                                          margin: EdgeInsets.fromLTRB(
                                              5.0, 5.0, 5.0, 5.0),
                                          child: ListTile(
                                            title: Text(playlistnames[index]),
                                            onTap: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Playlist_songs(
                                                            username:
                                                                widget.username,
                                                            playlistname:
                                                                playlistnames[
                                                                    index],
                                                          )));
                                              setState(() {
                                                loading = false;
                                              });
                                            },
                                          ),
                                        ),
                                        // Card(
                                        //   child: ListTile(
                                        //     title: Text("Add a new playlist"),
                                        //   ),
                                        // )
                                      ],
                                    );
                                  },
                                ),
                              );
                      });
        });
  }
}
