import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicapp002/database.dart';

class Fauth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future SignupwithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //  print("{user.email}");
      await Database().setusername(email);
      await Database().updateusercredentials(email,
          "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500");
      await Database().updatemusername(email, email);
      await Database().createfav(email);
      await Database().createsongsfield(email);
      await Database().setplaylist(email);
      return user;
    } catch (e) {
      print("${e.toString()}");
      return e.toString();
    }
  }

  Future LoginInwithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return "e${e.toString()}";
    }
  }
}
