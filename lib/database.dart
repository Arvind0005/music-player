import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Database {
  //Firebase Storage
  Future uploadimage(File imagefile, String songname, File musictrack) async {
    StorageReference referenece =
        FirebaseStorage.instance.ref().child("$songname.jpg");
    StorageUploadTask uploadTask = referenece.putFile(imagefile);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    referenece = FirebaseStorage.instance.ref().child("${songname}.mp3");
    StorageUploadTask uploadTaskm = referenece.putFile(musictrack);
    StorageTaskSnapshot snapshotx = await uploadTaskm.onComplete;
    return snapshot;
  }

  Future uploadprofilepicture(File imagefile, String imagename) async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child("$imagename.jpg");
    StorageUploadTask uploadTask = reference.putFile(imagefile);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    return snapshot;
  }

  // StorageUploadTask putFile(File file, [StorageMetadata metadata]) {
  //   assert(file.existsSync());
  //   final _StorageFileUploadTask task =
  //       _StorageFileUploadTask._(file, _firebaseStorage, this, metadata);
  //   task._start();
  //   return task;
  // }

  Future uploadonlysong(
    String songname,
    File musictrack,
  ) async {
    Future<File> getImageFileFromAssets(String path) async {
      final byteData = await rootBundle.load('assets/$path');
      final file = File('${(await getTemporaryDirectory()).path}/$path');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
    }

    final path = "assets";
    File imagefile;

    imagefile = await getImageFileFromAssets("music_png.png");

    StorageReference referenece =
        FirebaseStorage.instance.ref().child("$songname.jpg");

    StorageUploadTask uploadTask = referenece.putFile(imagefile);

    StorageTaskSnapshot snapshot = await uploadTask.onComplete;

    referenece = FirebaseStorage.instance.ref().child("${songname}.mp3");

    StorageUploadTask uploadTaskm = referenece.putFile(musictrack);

    StorageTaskSnapshot snapshotx = await uploadTaskm.onComplete;
    return;
  }

  //Firbase Strorage file
  Future<String> downloadimage(
    String songname,
  ) async {
    StorageReference referenece =
        FirebaseStorage.instance.ref().child("${songname}.jpg");
    String downloadimageurl = await referenece.getDownloadURL();
    // print(downloadimageurl);
    return downloadimageurl.toString();
  }

  Future<List<String>> downloadimagelist(List<String> imagenamelist) async {
    int i;
    List<String> imageurls = List(imagenamelist.length);
    for (i = 0; i < imagenamelist.length; i++) {
      StorageReference referenece =
          FirebaseStorage.instance.ref().child("${imagenamelist[i]}.jpg");
      imageurls[i] = await referenece.getDownloadURL();
    }
    return imageurls;
  }

  Future<List<String>> downloadplaylistimagelist(
      List<String> allplaylist0thimagenamelist) async {
    int i;
    List<String> all0thimageurls = List(allplaylist0thimagenamelist.length);
    for (i = 0; i < allplaylist0thimagenamelist.length; i++) {
      StorageReference referenece = FirebaseStorage.instance
          .ref()
          .child("${allplaylist0thimagenamelist[i]}.jpg");
      all0thimageurls[i] = await referenece.getDownloadURL();
    }
    return all0thimageurls;
  }

  //Storagefile
  Future downloadsong(
    String songname,
  ) async {
    StorageReference referenece =
        FirebaseStorage.instance.ref().child("${songname}.mp3");
    String downloadsongurl = await referenece.getDownloadURL();
    return downloadsongurl;
  }

  //Firestore

  Future uploadsongdata(
      String username, String songname, String songurl) async {
    final CollectionReference songs =
        FirebaseFirestore.instance.collection("Songs");
    return await songs.doc(username).update({
      "songsfield": FieldValue.arrayUnion([songurl])
    });
  }

  Future updateusername(String username, String newusername) async {
    final DocumentReference Docreference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await Docreference.update({"Username": newusername});
  }

  // Future updateusername(String username, int place) {
  //   final List<QuerySnapshot> querySnapshot = FirebaseFirestore.instance.collection("Songs").snapshots();
  // }

  Future updateusercredentials(String username, String profile) async {
    final DocumentReference Docreference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await Docreference.update(
        {"profilepicture": profile, "bio": "Spread Positive Vibes"});
  }

  Future setusername(String username) async {
    final DocumentReference Docreference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await Docreference.set({"Username": username});
  }

  Future updatemusername(String musername, String username) async {
    final DocumentReference Docreference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await Docreference.update({"musername": musername});
  }

  Future updatemuserbio(String newbio, String username) async {
    final DocumentReference Docreference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await Docreference.update({"bio": newbio});
  }

  Future createfav(String username) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({"favs": FieldValue.arrayUnion([])});
  }

  Future createsongsfield(String username) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference
        .update({"songsfield": FieldValue.arrayUnion([])});
  }

  Future setplaylist(String username) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference
        .update({"playlist": FieldValue.arrayUnion([])});
  }

  Future addtofav(String username, String songurl) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({
      "favs": FieldValue.arrayUnion([songurl])
    });
  }

  Future setaddtofav(String username, String songurl) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.set({
      "favs": FieldValue.arrayUnion([songurl])
    });
  }

  Future removefromfav(String username, String songurl) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({
      "favs": FieldValue.arrayRemove([songurl])
    });
  }

  Future deletesong(String username, String songurl, String songsfield) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({
      songsfield: FieldValue.arrayRemove([songurl])
    });
  }

  Future deletefield(String username, String playlistname) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({playlistname: FieldValue.delete()});
  }

  Future removefromplaylist(String username, String playlistname) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({
      "playlist": FieldValue.arrayRemove([playlistname])
    });
  }

  Future createaplaylist(String username, String playlistname) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({
      "playlist": FieldValue.arrayUnion([playlistname])
    });
  }

  Future addtoplaylist(
      String username, String playlistname, String songurl) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Songs").doc(username);
    return await documentReference.update({
      playlistname: FieldValue.arrayUnion([songurl])
    });
  }

  Stream<QuerySnapshot> get songdata {
    return FirebaseFirestore.instance.collection("Songs").snapshots();
  }
}
