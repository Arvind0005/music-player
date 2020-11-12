import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/spinner.dart';
import 'database.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:musicapp002/stylingtextformfield.dart';
import 'package:musicapp002/pagestyling.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:file_picker/file_picker.dart';

class Post extends StatefulWidget {
  final String username;
  Post({Key key, this.username}) : super(key: key);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  File imagefile = null;

  String downloadedimageurl = '';

  String downloadsongurl = '';

  AudioPlayer audioPlayer = AudioPlayer();

  final TextEditingController namecontroller = TextEditingController();

  final TextEditingController artistcontroller = TextEditingController();

  final TextEditingController albumcontroller = TextEditingController();

  String songname = '';

  String albumname = '';

  String artistname = '';

  File musictrack = null;

  String snapshot = '';

  String finalsong = '';

  final formkey = GlobalKey<FormState>();

  bool uploaded = false;
  Future<PickedFile> getimage(bool iscamera) async {
    PickedFile image;
    if (iscamera) {
      image = await ImagePicker().getImage(
        source: ImageSource.camera,
      );
    } else {
      image = await ImagePicker().getImage(source: ImageSource.gallery);
    }
    return image;
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Spinkit()
        : Scaffold(
            body: Container(
              decoration: pagestyling,
              child: Form(
                key: formkey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(
                          child: Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[400].withOpacity(1.0),
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Container(
                        child: imagefile == null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/music_png.png",
                                  height: 250,
                                  width: 250,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    imagefile,
                                    height: 250.0,
                                    width: 250.0,
                                  ),
                                ),
                              )),
                    Center(
                      child: SizedBox(
                        child: Text("Add an Image to your song"),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            child: Text("Add image from camera"),
                            color: Color(0xFF414345),
                            onPressed: () async {
                              PickedFile imagepickedfile = await getimage(true);
                              setState(() {
                                imagefile = File(imagepickedfile.path);
                              });
                              if (imagefile != null) {
                                File cropped = await ImageCropper.cropImage(
                                    sourcePath: imagefile.path,
                                    aspectRatio: CropAspectRatio(
                                        ratioX: 1.0, ratioY: 1.0));
                                if (cropped != null) {
                                  setState(() {
                                    imagefile = cropped;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Color(0xFF414345),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            child: Text("Add image from galery"),
                            onPressed: () async {
                              PickedFile imagepickedfile =
                                  await getimage(false);
                              setState(() {
                                imagefile = File(imagepickedfile.path);
                              });
                              if (imagefile != null) {
                                File cropped = await ImageCropper.cropImage(
                                    sourcePath: imagefile.path,
                                    aspectRatio: CropAspectRatio(
                                        ratioX: 1.0, ratioY: 1.0));
                                if (cropped != null) {
                                  setState(() {
                                    imagefile = cropped;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        color: Color(0xFF414345),
                        child: Text("Add music track"),
                        onPressed: () async {
                          musictrack =
                              await FilePicker.getFile(type: FileType.audio);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextFormField(
                          controller: namecontroller,
                          validator: (val) {
                            return val.isEmpty
                                ? 'please enter the song name'
                                : null;
                          },
                          onChanged: (val) => songname = val,
                          decoration:
                              styling.copyWith(hintText: "Name of the song")),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextFormField(
                          controller: albumcontroller,
                          validator: (val) {
                            return val.isEmpty
                                ? 'please enter the album name'
                                : null;
                          },
                          onChanged: (val) => albumname = val,
                          decoration:
                              styling.copyWith(hintText: "Name of the album")),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextFormField(
                          controller: artistcontroller,
                          validator: (val) {
                            return val.isEmpty
                                ? 'please enter the artist(s) name'
                                : null;
                          },
                          onChanged: (val) => artistname = val,
                          decoration: styling.copyWith(
                              hintText: "Name of the artist(s)")),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        child: Text("Post"),
                        color: Color(0xFF414345),
                        onPressed: () async {
                          // print(
                          //     "qwertyuiopasdfghjklzxcv bnm,wertyuixcvbnmsrtyjukvbsnmfxb");
                          // print(downloadsongurl
                          //     .split(RegExp(r'(%2F)..*(%2F)'))[1]);
                          songname = songname +
                              "," +
                              albumname +
                              "," +
                              artistname +
                              " "
                                  "by" +
                              " " +
                              widget.username;
                          if (formkey.currentState.validate()) {
                            // print(
                            //     "qwertyuiopasdfghjklzxcv bnm,wertyuixcvbnmsrtyjukvbsnmfxb");
                            // print(downloadsongurl
                            //     .split(RegExp(r'(%2F)..*(%2F)'))[1]
                            //     .split(".")[0]);
                            if (imagefile != null) {
                              setState(() {
                                loading = true;
                              });
                              await Database()
                                  .uploadimage(imagefile, songname, musictrack);
                              downloadsongurl =
                                  await Database().downloadsong(songname);
                              await Database().uploadsongdata(
                                  widget.username, songname, downloadsongurl);
                              // namecontroller.clear();
                              // artistcontroller.clear();
                              // albumcontroller.clear();
                              setState(() {
                                loading = false;
                              });
                            } else {
                              setState(() {
                                songname = songname + "by ${widget.username}";
                                loading = true;
                              });
                              await Database().uploadonlysong(
                                songname,
                                musictrack,
                              );
                              downloadsongurl =
                                  await Database().downloadsong(songname);
                              await Database().uploadsongdata(
                                  widget.username, songname, downloadsongurl);
                              namecontroller.clear();
                              artistcontroller.clear();
                              albumcontroller.clear();
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                          print(songname);
                          // print(
                          //     "qwertyuiopasdfghjklzxcv bnm,wertyuixcvbnmsrtyjukvbsnmfxbaaaaaaaaaaaaaaaa");
                          // print(downloadsongurl
                          //     .split(RegExp(r'(%2F)..*(%2F)'))[1]
                          //     .split(".")[0]);
                          // print(downloadsongurl);
                          // List<String> array = downloadsongurl.split('%2F');
                          // print(
                          //     "sbhcjbhchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh yuxxxxxxxxxxx  $array");
                          print(downloadsongurl);
                          finalsong = downloadsongurl.split("/")[7];
                          finalsong = finalsong.replaceAll("%20", " ");
                          finalsong = finalsong.replaceAll("%2C", ",");
                          finalsong =
                              finalsong.substring(0, finalsong.indexOf('.mp3'));
                          finalsong = finalsong.replaceAll("%40", "@");
                          print(downloadsongurl);
                          print(finalsong);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
