import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:musicapp002/database.dart';
import 'package:musicapp002/editprofile.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/musicplayerpage.dart';
import 'package:musicapp002/pagestyling.dart';
import 'package:musicapp002/songsplaylist.dart';
import 'package:musicapp002/textstyling.dart';

class Account extends StatefulWidget {
  String username;
  Account({Key key, this.username}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // width of the screen

    double height = MediaQuery.of(context).size.height; //height of the screen

    double profile_segment_height = height * 1 / 4; //profilesegment's height

    Scaffold.of(context).appBarMaxHeight;
    //  String downloadimageurl = '';
//    print("jhcbdvycvsgd");

    String songname = ''; //songname is initialised

    int i;
    print(widget.username);
    return StreamBuilder(
        stream: FirebaseFirestore
            .instance //snapshots of the Fields in "Songs","username"'s documents.
            .collection("Songs")
            .doc(widget.username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Loading();
          }

          DocumentSnapshot songsdata =
              snapshot.data; //storing valuse in that document in songdata.
          String profilepicture;

          songsdata.data()["profilepicture"] == null
              ? profilepicture = null
              : profilepicture = songsdata.data()[
                  "profilepicture"]; //profilepicture is set to the profilepic url in document field.

          String bio;

          songsdata.data()["bio"] ==
                  null //if document bio is null dynamic value is stored.
              ? bio = "the bio is null"
              : bio = songsdata.data()["bio"];

          String new_username;

          songsdata.data()["musername"] ==
                  null //if musername is null default musername is set.
              ? new_username = widget.username
              : new_username = songsdata.data()["musername"];

          List<String> imagedata = List(); //list of imagedata is initialised.

          List<String> favimagedata = List();

          List playlistnames = List();

          songsdata.data()["playlist"] == null
              ? playlistnames = null
              : playlistnames = songsdata.data()["playlist"];

          int p = 0;

          List<String> playlistimages = List();
          if (playlistnames.length != 0) {
            playlistimages = List(playlistnames.length);
            while (true) {
              // print("songs");
              // print(songsdata.data());
              // print(playlistnames.length);
              playlistimages[p] = songsdata.data()[playlistnames[p]][0];
              if (p == playlistnames.length - 1) {
                // print("pppp");
                // print(p);
                // print("songs");
                // print(songsdata.data());
                // print(playlistnames.length);
                break;
              }
              p++;
            }
          }

          // print("songs");
          // print(songsdata.data());

          List<String> allplaylist0thsongnames = List();
          if (playlistimages != null) {
            allplaylist0thsongnames = List(playlistimages.length);
            for (i = 0; i < playlistimages.length; i++) {
              songname = playlistimages[
                  i]; //iterating through the urls of songs in songsfield and storing only the name of the songs in image data.
              songname = songname.split("/")[7];
              songname = songname.replaceAll("%20", " ");
              songname = songname.replaceAll("%2C", ",");
              songname = songname.substring(0, songname.indexOf('.mp3'));
              songname = songname.replaceAll("%40", "@");
              allplaylist0thsongnames[i] = songname;
            }
          }
          songsdata.data()["favs"] == null
              ? favimagedata = null
              : favimagedata = List(songsdata.data()["favs"].length);

          songsdata.data()["songsfield"] ==
                  null //if songs field is not null imagedata's length is set to songsfield's length since num of songs is equal to num of images.
              ? imagedata = null
              : imagedata = List(songsdata.data()["songsfield"].length);

          if (favimagedata != null) {
            for (i = 0; i < songsdata.data()["favs"].length; i++) {
              songname = songsdata.data()['favs'][
                  i]; //iterating through the urls of songs in songsfield and storing only the name of the songs in image data.
              songname = songname.split("/")[7];
              songname = songname.replaceAll("%20", " ");
              songname = songname.replaceAll("%2C", ",");
              songname = songname.substring(0, songname.indexOf('.mp3'));
              songname = songname.replaceAll("%40", "@");
              favimagedata[i] = songname;
            }
          }
          if (imagedata != null) {
            for (i = 0; i < songsdata.data()["songsfield"].length; i++) {
              songname = songsdata.data()['songsfield'][
                  i]; //iterating through the urls of songs in songsfield and storing only the name of the songs in image data.
              songname = songname.split("/")[7];
              songname = songname.replaceAll("%20", " ");
              songname = songname.replaceAll("%2C", ",");
              songname = songname.substring(0, songname.indexOf('.mp3'));
              songname = songname.replaceAll("%40", "@");
              imagedata[i] = songname;
            }
          }
          return Container(
              decoration: pagestyling,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFF414345),
                  actions: [
                    FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.exit_to_app),

                      ///Todo Logout session
                      label: Text(""),
                    ),
                  ],
                ),
                body: ListView(
                  children: [
                    Container(
                      //whole screen container
                      child: Column(
                        children: [
                          Container(
                            //top profile container
                            height: height * 1 / 4,
                            child: Column(
                              children: [
                                Container(
                                  //container to store texts abnd bios
                                  height: height * 1 / 4 -
                                      profile_segment_height *
                                          1 /
                                          3.5, //height = topprofile container - followers,post,likes whole container
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 160,
                                            //color: Colors.red,
                                            width: 110,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      songsdata
                                                          .data()[
                                                              "profilepicture"]
                                                          .toString(),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            new_username == null
                                                ? Text(
                                                    widget.username,
                                                    style: TextStyle(
                                                        fontFamily: "Assassin",
                                                        fontSize: 30),
                                                  )
                                                : Text(
                                                    new_username,
                                                    style: TextStyle(
                                                        //    fontFamily: "Assassin",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            bio == null
                                                ? Center(
                                                    child:
                                                        Text("Hey iam a muser"))
                                                : Text(
                                                    bio,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: "Assassin",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 23),
                                                  ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              //   width: 20,
                                              height: 20,
                                              child: FlatButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                color: Colors.grey[200],
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Editprofile(
                                                              username: widget
                                                                  .username,
                                                              bio: "",
                                                            )),
                                                  );
                                                },
                                                child: Text("EditProfile",
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        //followers,post,likes whole container
                                        height:
                                            profile_segment_height * 1 / 3.5,
                                        width: width,
                                        child: Row(
                                          children: [
                                            Container(
                                              //followers container
                                              width: width / 3,
                                              child: FlatButton(
                                                onPressed: () {},
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Favorites",
                                                      style:
                                                          textstyling.copyWith(
                                                              fontSize: 15),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child:
                                                          favimagedata == null
                                                              ? Text(
                                                                  "0",
                                                                  style: textstyling
                                                                      .copyWith(
                                                                          fontSize:
                                                                              15),
                                                                )
                                                              : Text(
                                                                  favimagedata
                                                                      .length
                                                                      .toString(),
                                                                  style: textstyling
                                                                      .copyWith(
                                                                          fontSize:
                                                                              15),
                                                                ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width / 3,
                                              child: FlatButton(
                                                onPressed: () {},
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Songs",
                                                      style:
                                                          textstyling.copyWith(
                                                              fontSize: 15),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: songsdata.data()[
                                                                    "songsfield"] ==
                                                                null
                                                            ? Text(
                                                                "0",
                                                                style: textstyling
                                                                    .copyWith(
                                                                        fontSize:
                                                                            15),
                                                              )
                                                            : Text(
                                                                songsdata
                                                                    .data()[
                                                                        "songsfield"]
                                                                    .length
                                                                    .toString(),
                                                                style: textstyling
                                                                    .copyWith(
                                                                        fontSize:
                                                                            15),
                                                              ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width / 3,
                                              child: FlatButton(
                                                onPressed: () {},
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Playists",
                                                      style:
                                                          textstyling.copyWith(
                                                              fontSize: 15),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: playlistnames
                                                                  .length ==
                                                              null
                                                          ? Text(
                                                              "0",
                                                              style: textstyling
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15),
                                                            )
                                                          : Text(
                                                              playlistnames
                                                                  .length
                                                                  .toString(),
                                                              style: textstyling
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 0.5,
                            width: width,
                            color: Colors.grey,
                          ),
                          imagedata == null
                              ? Container()
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  "All Songs",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                height: 180,
                                                width: width,
                                                //color: Colors.grey,
                                                child: FutureBuilder(
                                                  //Future builder is setup.
                                                  future:
                                                      Database() //this future returns the List of image urls in accordance with the sent song names since song name and image name are same it returns the list of images.
                                                          .downloadimagelist(
                                                              imagedata),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data == null) {
                                                      return Loading();
                                                    }
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: ScrollPhysics(),
                                                      //this list view builder takes the list of images from future builder and song urls from stream builder combaines and froms a horizontal list view
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: songsdata
                                                                  .data()[
                                                                      "songsfield"]
                                                                  .length ==
                                                              null
                                                          ? 0
                                                          : songsdata
                                                              .data()[
                                                                  "songsfield"]
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        songname = songsdata
                                                                    .data()[
                                                                'songsfield']
                                                            [index];
                                                        songname = songname
                                                            .split("/")[7];
                                                        songname =
                                                            songname.replaceAll(
                                                                "%20", " ");
                                                        songname =
                                                            songname.replaceAll(
                                                                "%2C", ",");
                                                        songname =
                                                            songname.substring(
                                                                0,
                                                                songname.indexOf(
                                                                    '.mp3'));
                                                        songname =
                                                            songname.replaceAll(
                                                                "%40", "@");
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Card(
                                                              child: Center(
                                                            child: FlatButton(
                                                              // color:
                                                              //     Colors.grey,
                                                              onPressed:
                                                                  () async {
                                                                await audioPlayer
                                                                    .stop();
                                                                await audioPlayer
                                                                    .play(songsdata
                                                                            .data()["songsfield"]
                                                                        [
                                                                        index]);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Musicplayerpage(
                                                                        index:
                                                                            index,
                                                                        songurl:
                                                                            songsdata.data()["songsfield"],
                                                                        imageurl: snapshot
                                                                            .data[index]
                                                                            .toString(),
                                                                        imagenames:
                                                                            imagedata,
                                                                        username:
                                                                            widget.username,
                                                                        songfield:
                                                                            "songsfield",
                                                                      ),
                                                                    ));
                                                              },
                                                              child: Column(
                                                                children: [
                                                                  Image.network(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .toString(),
                                                                    height: 130,
                                                                    width: 100,
                                                                  ),
                                                                  Text(
                                                                      "${imagedata[index].substring(0, 10)}..."),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              // Container(
                                              //   height: 40,
                                              //   color: Colors.red,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    favimagedata == null
                                        ? Container()
                                        : Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Favorite Songs",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Container(
                                                      height: 180,
                                                      width: width,
                                                      // color: const Color(
                                                      //     0xFF414345),
                                                      child: FutureBuilder(
                                                        //Future builder is setup.
                                                        future:
                                                            Database() //this future returns the List of image urls in accordance with the sent song names since song name and image name are same it returns the list of images.
                                                                .downloadimagelist(
                                                                    favimagedata),

                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot.data ==
                                                              null) {
                                                            return Loading();
                                                          }
                                                          return ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                ScrollPhysics(),
                                                            //this list view builder takes the list of images from future builder and song urls from stream builder combaines and froms a horizontal list view
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: songsdata
                                                                            .data()[
                                                                        "favs"] ==
                                                                    null
                                                                ? 0
                                                                : songsdata
                                                                    .data()[
                                                                        "favs"]
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              songname = songsdata
                                                                      .data()[
                                                                  'favs'][index];
                                                              songname =
                                                                  songname.split(
                                                                      "/")[7];
                                                              songname = songname
                                                                  .replaceAll(
                                                                      "%20",
                                                                      " ");
                                                              songname = songname
                                                                  .replaceAll(
                                                                      "%2C",
                                                                      ",");
                                                              songname = songname
                                                                  .substring(
                                                                      0,
                                                                      songname.indexOf(
                                                                          '.mp3'));
                                                              songname = songname
                                                                  .replaceAll(
                                                                      "%40",
                                                                      "@");
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Card(
                                                                    child:
                                                                        Center(
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await audioPlayer
                                                                          .stop();
                                                                      await audioPlayer.play(
                                                                          songsdata.data()["favs"]
                                                                              [
                                                                              index]);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                Musicplayerpage(
                                                                              imageurl: snapshot.data[index].toString(),
                                                                              songurl: songsdata.data()["favs"],
                                                                              imagenames: favimagedata,
                                                                              username: widget.username,
                                                                              index: index,
                                                                              songfield: "favs",
                                                                            ),
                                                                          ));
                                                                    },
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Image
                                                                            .network(
                                                                          snapshot
                                                                              .data[index]
                                                                              .toString(),
                                                                          height:
                                                                              130,
                                                                          width:
                                                                              100,
                                                                        ),
                                                                        Text(
                                                                            "${favimagedata[index].substring(0, 10)}..."),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 40,
                                                    //   color: Colors.red,
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    playlistnames == null
                                        ? Container()
                                        : Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                        "Playlists",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 180,
                                                      width: width,
                                                      //color: Colors.grey,
                                                      child: FutureBuilder(
                                                        //Future builder is setup.
                                                        future:
                                                            Database() //this future returns the List of image urls in accordance with the sent song names since song name and image name are same it returns the list of images.
                                                                .downloadplaylistimagelist(
                                                                    allplaylist0thsongnames),

                                                        builder: (context,
                                                            snapshot) {
                                                          // print("snapshotdata");
                                                          // print(snapshot.data);
                                                          if (snapshot.data ==
                                                              null) {
                                                            return Loading();
                                                          }
                                                          return ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                ScrollPhysics(),
                                                            //this list view builder takes the list of images from future builder and song urls from stream builder combaines and froms a horizontal list view
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                allplaylist0thsongnames
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              // String currentplaylistname = playlistnames
                                                              //      [index];
                                                              // songname = songname
                                                              //     .split("/")[7];
                                                              // songname =
                                                              //     songname.replaceAll(
                                                              //         "%20", " ");
                                                              // songname =
                                                              //     songname.replaceAll(
                                                              //         "%2C", ",");
                                                              // songname =
                                                              //     songname.substring(
                                                              //         0,
                                                              //         songname.indexOf(
                                                              //             '.mp3'));
                                                              // songname =
                                                              //     songname.replaceAll(
                                                              //         "%40", "@");
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Card(
                                                                    child:
                                                                        Center(
                                                                  child:
                                                                      FlatButton(
                                                                    // color:
                                                                    //     Colors.grey,
                                                                    onPressed:
                                                                        () {
                                                                      i++;
                                                                      i--;
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => Playlist_songs(
                                                                                    username: widget.username,
                                                                                    playlistname: playlistnames[index],
                                                                                  )));
                                                                    },
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Image
                                                                            .network(
                                                                          snapshot
                                                                              .data[index]
                                                                              .toString(),
                                                                          height:
                                                                              130,
                                                                          width:
                                                                              100,
                                                                        ),
                                                                        Text(
                                                                            "${playlistnames[index]}"),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 40,
                                                    //   color: Colors.red,
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
