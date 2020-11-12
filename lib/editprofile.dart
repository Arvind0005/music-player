import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp002/database.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/spinner.dart';
import 'package:musicapp002/stylingtextformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class Editprofile extends StatefulWidget {
  final String username;
  final String bio;
  Editprofile({Key key, this.username, this.bio}) : super(key: key);
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  File imagefile;
  String imageurl;
  @override
  final _formkey = GlobalKey<FormState>();
  String newmusername = '';
  String newbio = '';
  bool loading = false;
  String error = "";
  String temp;
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int i;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Songs").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<DocumentSnapshot> userdata = snapshot.data.docs;
          print(userdata);
          for (i = 0; i < userdata.length - 1; i++) {
            if (userdata[i].data()["Username"] == widget.username) {
              break;
            }
          }
          String musernametextfield = userdata[i].data()["musername"];

          String biotextfield = userdata[i].data()["bio"];

          TextEditingController usernamecontroller =
              TextEditingController(text: musernametextfield);

          TextEditingController biocontroller =
              TextEditingController(text: biotextfield);

          return loading == true
              ? Spinkit()
              : Scaffold(
                  appBar: AppBar(
                    title: Text("Edit your profile"),
                  ),
                  body: ListView(
                    children: [
                      Container(
                        height: 200,
                        width: width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            FlatButton(
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          userdata[i].data()['profilepicture']),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              onPressed: () async {
                                PickedFile imagepickedfile = await ImagePicker()
                                    .getImage(source: ImageSource.gallery);
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
                                setState(() {
                                  loading = true;
                                });
                                await Database().uploadprofilepicture(
                                    imagefile, "profilepicture");
                                imageurl = await Database()
                                    .downloadimage("profilepicture");
                                await Database().updateusercredentials(
                                    widget.username, imageurl);
                                setState(() {
                                  loading = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formkey,
                        child: Container(
                          height: 397,
                          width: width,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: TextFormField(
                                  // controller: usernamecontroller,
                                  initialValue: musernametextfield,
                                  validator: (val) {
                                    return val.isEmpty
                                        ? "please enter an username"
                                        : null;
                                  },
                                  decoration: styling.copyWith(
                                    labelText: "New Username",
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      newmusername = val;
                                    });
                                    setState(() {
                                      musernametextfield = val;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: TextFormField(
                                  //controller: biocontrol  ler,
                                  initialValue: biotextfield,
                                  decoration:
                                      styling.copyWith(labelText: "New bio"),
                                  onChanged: (val) {
                                    newbio = val;
                                    biotextfield = val;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FlatButton(
                                  child: Text("Update"),
                                  color: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                      error = '';
                                    });
                                    print(newmusername);
                                    print(widget.username);
                                    int k;
                                    if (_formkey.currentState.validate()) {
                                      if (newmusername == "") {
                                        newmusername =
                                            userdata[i].data()["musername"];
                                      }
                                      if (newbio == '') {
                                        newbio = userdata[i].data()["bio"];
                                      }
                                      await Database().updatemuserbio(
                                          newbio, widget.username);
                                      print("skjshdcsdcgvzvsvcfvfvdstcvdd");
                                      print(newmusername);
                                      for (k = 0; k < userdata.length; k++) {
                                        if (newmusername ==
                                            userdata[k].data()["musername"]) {
                                          if (widget.username !=
                                              userdata[k].data()["Username"]) {
                                            setState(() {
                                              error =
                                                  "this musername is already present";
                                            });
                                            print(error);
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                        } else if (k == userdata.length - 1 &&
                                            newmusername !=
                                                userdata[k]
                                                    .data()["musername"]) {
                                          await Database().updatemusername(
                                              newmusername, widget.username);
                                          setState(() {
                                            musernametextfield =
                                                userdata[i].data()["musername"];
                                            biotextfield =
                                                userdata[i].data()["bio"];
                                          });
                                          setState(() {
                                            loading = false;
                                          });
                                          setState(() {
                                            musernametextfield =
                                                userdata[i].data()["musername"];
                                            biotextfield =
                                                userdata[i].data()["bio"];
                                          });
                                        }
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  }),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
        });
  }
}
