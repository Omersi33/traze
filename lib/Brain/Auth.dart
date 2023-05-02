import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traze/pages/Landing.dart';
import 'package:traze/pages/Profile.dart';
import 'package:traze/pages/updateProfile.dart';

class Auth {
  static Future login(email, password, BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future logout() async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future signup(email, password, BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UpdateProfile()));
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  static Future updateProfile({name ,context,image}) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.updatePhotoURL(image);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  static Future updateNameEmail({name, email, context}) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.updateEmail(email);
      Fluttertoast.showToast(msg: "Les données ont été mis à jour avec succès.");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  static Future updatePassword({password, context}) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.currentUser!.updatePassword(password);
      Fluttertoast.showToast(msg: "Le mot de passe a été mis à jour avec succès.");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  static Future updateProfilePicture({context,image}) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.currentUser!.updatePhotoURL(image);
      Fluttertoast.showToast(msg: "La photo de profil a été mise à jour avec succès.");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  static Future sendEmailLostPassword({email, context}) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: "Un mail pour modifier votre mot de passe a été envoyé à l'adresse mail " + email + ".");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  static Future uploadPick() async {
    final _storage = FirebaseStorage.instance;
    var url;
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      await _storage.ref(image!.name).putFile(File(image.path)).then((p0) {
        url = p0.ref.getDownloadURL();
      });
      UploadTask uploadTask = _storage.ref(image!.name).putFile(File(image.path));
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress =
                  100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              print("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              print("Upload was canceled");
              break;
            case TaskState.error:
            // Handle unsuccessful uploads
              break;
            case TaskState.success:
            // Handle successful uploads on complete
            // ...
              break;
          }
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
    return url;
  }
}