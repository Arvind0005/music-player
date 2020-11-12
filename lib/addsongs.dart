import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:musicapp002/post.dart';
import 'package:musicapp002/spinner.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicapp002/loading.dart';
import 'database.dart';
import 'package:musicapp002/stylingtextformfield.dart';
import 'package:musicapp002/pagestyling.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

class Addsongs extends StatefulWidget {
  final username;
  Addsongs({this.username});
  @override
  _AddsongsState createState() => _AddsongsState();
}

class _AddsongsState extends State<Addsongs> {
  bool loading = false;
  File musictrack;
  File imagefile;
  String imagename;
  String trackname;
  String downloadsongurl;
  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Spinkit()
        : Scaffold(
            appBar: AppBar(
              title: Text("Add songs"),
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Songs")
                    .doc(widget.username)
                    .snapshots(),
                builder: (context, snapshot) {
                  DocumentSnapshot allsongs;
                  allsongs = snapshot.data;

                  return ListView(
                    children: [
                      Card(
                        child: ListTile(
                          title: Text("Add a Song"),
                          onTap: () async {
                            musictrack =
                                await FilePicker.getFile(type: FileType.audio);
                            setState(() {
                              loading = true;
                              trackname = basename(musictrack.path);
                              imagename = trackname;
                            });
                            trackname = trackname.replaceAll(".mp3", "");
                            trackname = trackname + "by ${widget.username}";
                            // trackname =trackname.replaceAll(".Mp3", "");
                            await Database().uploadonlysong(
                              trackname,
                              musictrack,
                            );
                            // await Database()
                            //     .uploadimage(imagefile, trackname, musictrack);
                            // downloadsongurl =
                            downloadsongurl =
                                await Database().downloadsong(trackname);
                            // await Database().uploadsongdata(
                            //     widget.username, trackname, downloadsongurl);
                            await Database().uploadsongdata(
                                widget.username, trackname, downloadsongurl);
                            setState(() {
                              loading = false;
                            });
                            String songname;
                            songname =
                                downloadsongurl; //iterating through the urls of songs in songsfield and storing only the name of the songs in image data.
                            songname = songname.split("/")[7];
                            songname = songname.replaceAll("%20", " ");
                            songname = songname.replaceAll("%2C", ",");
                            songname =
                                songname.substring(0, songname.indexOf('.mp3'));
                            songname = songname.replaceAll("%40", "@");
                            print("song url");
                            print(downloadsongurl);
                            print("original songname");
                            print(trackname);
                            print("eddited songname");
                            print(songname);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text("Add a Custom Song"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Post(
                                          username: widget.username,
                                        )));
                          },
                        ),
                      )
                    ],
                  );
                }),
          );
  }
}
