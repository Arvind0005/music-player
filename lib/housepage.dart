import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicapp002/database.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:musicapp002/loading.dart';
import 'musicplayerpage.dart';
import 'package:musicapp002/textstyling.dart';

class Housepage extends StatefulWidget {
  final String username;

  Housepage({Key key, this.username}) : super(key: key);

  @override
  _HousepageState createState() => _HousepageState();
}

class _HousepageState extends State<Housepage> {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    List<String> imagenames = List();
    String songname;
    int i;
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
          imagenames = List(userdata.data()["songsfield"].length);
          for (i = 0; i < userdata.data()["songsfield"].length; i++) {
            songname = userdata.data()["songsfield"][i];
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
          return Scaffold(
            appBar: AppBar(
              title: Text("All Songs"),
            ),
            body: FutureBuilder(
                future: Database().downloadimagelist(imagenames),
                builder: (context, snapshot) {
                  print(imagenames);
                  if (snapshot.data == null) {
                    return Loading();
                  }
                  print(snapshot.data);
                  return imagenames.length != 0
                      ? ListView.builder(
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
                                  await audioPlayer.play(
                                      userdata.data()["songsfield"][index]);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Musicplayerpage(
                                      imageurl: snapshot.data[index].toString(),
                                      index: index,
                                      songurl: userdata.data()["songsfield"],
                                      imagenames: imagenames,
                                      username: widget.username,
                                      songfield: "songsfield",
                                    );
                                  }));
                                },
                              ),
                            );
                          },
                        )
                      : Scaffold(
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
                                                "Sorry You Do't Have Any Songs try Adding a Song And Comeback Later! ",
                                            style: textstyling.copyWith(
                                                fontSize: 25)),
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
                }),
          );
        });
  }
}
