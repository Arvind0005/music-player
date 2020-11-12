//import 'package:audioplayers/audioplayers.dart' as ap;
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicapp002/database.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/menu.dart';
import 'package:musicapp002/pagestyling.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:musicapp002/playlists.dart';

class Musicplayerpage extends StatefulWidget {
  final String imageurl;
  final List<dynamic> songurl;
  final List<String> imagenames;
  final String username;
  final String songfield;
  int index;
  int d = 0;
  Musicplayerpage({
    Key key,
    this.imageurl,
    this.songurl,
    this.index,
    this.imagenames,
    this.username,
    this.songfield,
  }) : super(key: key);
  @override
  _MusicplayerpageState createState() => _MusicplayerpageState();
}

class _MusicplayerpageState extends State<Musicplayerpage> {
  bool loading = false;
  bool playing = true;
  bool duplicate = false;
  int playingindex;
  String deletestring;
  Duration slidervalue;
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    if (widget.songfield != null) {
      if (widget.songfield == "songsfield") {
        deletestring = "All Songs";
      } else if (widget.songfield == "favs") {
        deletestring = "Favourites";
      } else {
        deletestring = widget.songfield;
      }
    }
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loading == true
        ? Loading()
        : FutureBuilder(
            future: Database().downloadimagelist(widget.imagenames),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Loading();
              }
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Songs")
                      .doc(widget.username)
                      .snapshots(),
                  builder: (context, snapshotx) {
                    DocumentSnapshot userdata = snapshotx.data;
                    void menuchoice(String choice) async {
                      print(height);
                      print(width);
                      if (choice == Menuconstants.add_to_playlist) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Playlists(
                                      username: widget.username,
                                      songurl: widget.songurl[widget.index],
                                    )));
                      } else if (choice == Menuconstants.delete) {
                        if (userdata.data()[widget.songfield].length == 1) {
                          await Database().deletesong(widget.username,
                              widget.songurl[widget.index], widget.songfield);
                          // await Database()
                          //     .deletefield(widget.username, widget.songfield);
                          if (widget.songfield != "favs" &&
                              widget.songfield != "songsfield") {
                            await Database().removefromplaylist(
                                widget.username, widget.songfield);
                          }
                          // await Database().removefromplaylist(
                          //     widget.username, widget.songfield);
                        } else {
                          await Database().deletesong(widget.username,
                              widget.songurl[widget.index], widget.songfield);
                        }
                      }
                    }

                    if (snapshotx.data == null) {
                      return Loading();
                    }
                    List favs = List(userdata.data()["favs"].length);
                    int i;
                    for (i = 0; i < userdata.data()["favs"].length; i++) {
                      favs[i] = userdata.data()["favs"][i];
                    }
                    int z;
                    for (z = 0; z < favs.length; z++) {
                      if (widget.songurl[widget.index] == favs[z]) {
                        duplicate = true;
                        // const style= Icon(Icons.star);
                        break;
                      } else {
                        if (z == favs.length - 1) {
                          duplicate = false;
                          // const style =Icon(Icons.star_border);
                        }
                      }
                    }
                    return Scaffold(
                      appBar: AppBar(),
                      body: Stack(children: <Widget>[
                        Container(
                          height: height,
                          width: width,
                          child: Image.network(
                            snapshot.data[widget.index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          color: Color.fromRGBO(255, 255, 250, 0.34),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(height / 42.7),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height / 19.5)),
                              ),
                              width: width,
                              height: height / 8,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 20.0,
                                      child: StreamBuilder(
                                          stream: audioPlayer
                                              .onAudioPositionChanged,
                                          builder: (context, snapshot) {
                                            slidervalue = snapshot.data;
                                            // if (slidervalue.inSeconds
                                            //         .toDouble() ==
                                            //     audioPlayer.duration.inSeconds
                                            //         .toDouble()) {
                                            //   audioPlayer.stop();
                                            //   setState(() {
                                            //     widget.index = widget.index + 1;
                                            //   });
                                            //   if (widget.index >
                                            //       widget.songurl.length - 1) {
                                            //     widget.index = 0;
                                            //   }
                                            //   audioPlayer.play(
                                            //       widget.songurl[widget.index]);
                                            //   setState(() {
                                            //     playing = true;
                                            //   });
                                            // }
                                            return snapshot.data == null
                                                ? Slider(
                                                    value: 0.0, onChanged: null)
                                                : Slider(
                                                    activeColor: Colors.grey,
                                                    inactiveColor: Colors.grey,
                                                    value: slidervalue.inSeconds
                                                        .toDouble(),
                                                    min: 0.0,
                                                    max: audioPlayer
                                                        .duration.inSeconds
                                                        .toDouble(),
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        audioPlayer.seek(value);
                                                        // seekToSecond(value.toInt());
                                                        // value = value;
                                                      });
                                                    });
                                          }),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: height / 7.89,
                                        child: Center(
                                          child: ButtonTheme(
                                            minWidth: height / 22.7,
                                            height: height / 22.7,
                                            child: ButtonTheme(
                                              minWidth: height / 22.7,
                                              height: height / 22.7,
                                              child: FlatButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  if (duplicate) {
                                                    await Database()
                                                        .removefromfav(
                                                            widget.username,
                                                            widget.songurl[
                                                                widget.index]);
                                                    setState(() {
                                                      duplicate = false;
                                                      loading = false;
                                                    });
                                                  } else {
                                                    await Database().addtofav(
                                                        widget.username,
                                                        widget.songurl[
                                                            widget.index]);
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }
                                                },
                                                child: duplicate == true
                                                    ? Icon(Icons.star)
                                                    : Icon(Icons.star_border),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ButtonTheme(
                                        minWidth: height / 22.7,
                                        height: height / 22.7,
                                        child: FlatButton(
                                          onPressed: () async {
                                            await audioPlayer.stop();
                                            setState(() {
                                              widget.index = widget.index - 1;
                                              if (widget.index < 0) {
                                                setState(() {
                                                  widget.index =
                                                      widget.songurl.length - 1;
                                                });
                                              }
                                            });
                                            await audioPlayer.play(
                                                widget.songurl[widget.index]);
                                            //  print(audiodutation);
                                            setState(() {
                                              playing = true;
                                            });
                                          },
                                          child: Icon(Icons.skip_previous),
                                          // label: Text("Play"))
                                        ),
                                      ),
                                      ButtonTheme(
                                        minWidth: height / 22.7,
                                        height: height / 22.7,
                                        child: FlatButton(
                                          onPressed: () async {
                                            if (playing) {
                                              //  await AudioPlayer().stop();
                                              await audioPlayer.pause();
                                              // print("duration");
                                              // print(audioPlayer
                                              //     .duration.inSeconds
                                              //     .toDouble());
                                              // await AudioPlayer().play(
                                              //     widget.songurl[widget.index]);
                                              // await AudioPlayer().pause();
                                              setState(() {
                                                playing = false;
                                              });
                                            } else {
                                              await audioPlayer.play(
                                                  widget.songurl[widget.index]);
                                              // print("duration");
                                              // print(audioPlayer
                                              //     .duration.inSeconds);
                                              setState(() {
                                                playing = true;
                                                playingindex = widget.index;
                                              });
                                            }
                                          },
                                          child: playing == true
                                              ? Icon(Icons.pause)
                                              : Icon(Icons.play_arrow),
                                          // label: Text("Play"))
                                        ),
                                      ),
                                      ButtonTheme(
                                        minWidth: height / 22.7,
                                        height: height / 22.7,
                                        child: FlatButton(
                                          onPressed: () async {
                                            await audioPlayer.stop();
                                            setState(() {
                                              widget.index = widget.index + 1;
                                            });
                                            if (widget.index >
                                                widget.songurl.length - 1) {
                                              widget.index = 0;
                                            }
                                            await audioPlayer.play(
                                                widget.songurl[widget.index]);
                                            setState(() {
                                              playing = true;
                                            });
                                          },
                                          child: Icon(Icons.skip_next),
                                          // label: Text("Play"))
                                        ),
                                      ),
                                      ButtonTheme(
                                        minWidth: height / 22.7,
                                        height: height / 22.7,
                                        child: PopupMenuButton<String>(
                                          onSelected: menuchoice,
                                          itemBuilder: (context) {
                                            return Menuconstants.constants
                                                .map((String item) {
                                              return PopupMenuItem<String>(
                                                value: item,
                                                child: item ==
                                                        Menuconstants.delete
                                                    ? Text(
                                                        "$item from $deletestring")
                                                    : Text(item),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ]),
                    );
                  });
            });
  }
}
