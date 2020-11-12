import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicapp002/createplaylist.dart';
import 'package:musicapp002/database.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/songsplaylist.dart';
import 'package:musicapp002/stylingtextformfield.dart';
import 'package:musicapp002/textstyling.dart';

class Playlists extends StatefulWidget {
  final String username;
  final String songurl;
  Playlists({Key key, this.username, this.songurl}) : super(key: key);
  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
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
                                        child: Text(
                                          "Sorry You Don't Have Any Playlist Try Creating One!",
                                          style: textstyling.copyWith(
                                              fontSize: 25),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 20),
                                      child: TextFormField(
                                        validator: (val) {
                                          return val.isEmpty
                                              ? "please specify a name for your playlist"
                                              : null;
                                        },
                                        onChanged: (val) {
                                          playlistname = val;
                                        },
                                        decoration: InputDecoration(
                                            hintText: "playlist name"),
                                      ),
                                    ),
                                    FlatButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () async {
                                        List songurl = List();
                                        songurl.add(widget.songurl);
                                        if (formkey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          await Database().createaplaylist(
                                              widget.username, playlistname);
                                          await Database().addtoplaylist(
                                              widget.username,
                                              playlistname,
                                              widget.songurl);
                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
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
                                                print("button is tapped");
                                                setState(() {
                                                  loading = true;
                                                });
                                                print("button2");
                                                await Database().addtoplaylist(
                                                    widget.username,
                                                    playlistnames[index],
                                                    widget.songurl);
                                                print("returned");
                                                setState(() {
                                                  loading = false;
                                                });
                                                showDialog(
                                                    context: _scaffoldKey
                                                        .currentContext,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Done"),
                                                        content: Container(
                                                          height: 80,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  "Your Song Has Added To The Playlist"),
                                                              ButtonTheme(
                                                                height: 30,
                                                                minWidth: 30,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          13.0),
                                                                  child:
                                                                      FlatButton(
                                                                    color: Colors
                                                                        .grey,
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          _scaffoldKey.currentContext,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => Playlist_songs(
                                                                                    username: widget.username,
                                                                                    playlistname: playlistnames[index],
                                                                                  )));
                                                                    },
                                                                    child: Text(
                                                                        "Go to ${playlistnames[index]}"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Createplaylist(
                                                              username: widget
                                                                  .username,
                                                              songurl: widget
                                                                  .songurl,
                                                            )));
                                              },
                                              title: Text("Add a new playlist"),
                                            ),
                                          )
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
                                              await Database().addtoplaylist(
                                                  widget.username,
                                                  playlistnames[index],
                                                  widget.songurl);
                                              print("returned");
                                              setState(() {
                                                loading = false;
                                              });
                                              showDialog(
                                                  context: _scaffoldKey
                                                      .currentContext,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Done"),
                                                      content: Container(
                                                        height: 80,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                "Your Song Has Added To The Playlist"),
                                                            ButtonTheme(
                                                              height: 30,
                                                              minWidth: 30,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            13.0),
                                                                child:
                                                                    FlatButton(
                                                                  color: Colors
                                                                      .grey,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(
                                                                        _scaffoldKey.currentContext,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => Playlist_songs(
                                                                                  username: widget.username,
                                                                                  playlistname: playlistnames[index],
                                                                                )));
                                                                  },
                                                                  child: Text(
                                                                      "Go to ${playlistnames[index]}"),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                      });
        });
  }
}
