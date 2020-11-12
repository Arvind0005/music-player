import 'package:flutter/material.dart';
import 'package:musicapp002/displayplaylist.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/textstyling.dart';
import 'database.dart';

class Createplaylist extends StatefulWidget {
  final String username;
  final String songurl;
  Createplaylist({this.username, this.songurl});
  @override
  _CreateplaylistState createState() => _CreateplaylistState();
}

class _CreateplaylistState extends State<Createplaylist> {
  final formkey = GlobalKey<FormState>();
  String playlistname = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loading == true
        ? Loading()
        : Form(
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
                                "Create a New Playlist!",
                                style: textstyling.copyWith(fontSize: 25),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: TextFormField(
                              validator: (val) {
                                return val.isEmpty
                                    ? "please specify a name for your playlist"
                                    : null;
                              },
                              onChanged: (val) {
                                playlistname = val;
                              },
                              decoration:
                                  InputDecoration(hintText: "playlist name"),
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
                                await Database().addtoplaylist(widget.username,
                                    playlistname, widget.songurl);
                                setState(() {
                                  loading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Displaylist(
                                              username: widget.username,
                                            )));
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
          );
  }
}
