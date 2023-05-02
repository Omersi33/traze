import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Brain/Auth.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final passwordController = TextEditingController();
  final passwordDecoration = InputDecoration(
      hintText: "Nouveau mot de passe",
      hintStyle: GoogleFonts.alice(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  final confirmPasswordController = TextEditingController();
  final confirmPasswordDecoration = InputDecoration(
      hintText: "Confirmer le nouveau mot de passe",
      hintStyle: GoogleFonts.alice(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

  var data;
  getProfile()async {
    final _auth = FirebaseAuth.instance;
    try {
      setState(() {
        data = _auth.currentUser;
      });
    } catch (e) {

    }
  }
  bool visibility = false;
  @override
  void initState() {
    getProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Mot de passe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                  decoration: passwordDecoration,
                  obscureText: true,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: confirmPasswordController,
                  decoration: confirmPasswordDecoration,
                  obscureText: true,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async{
                        setState(() {
                          visibility = true;
                        });
                        if(passwordController.text.trim() == confirmPasswordController.text.trim()) {
                            await Auth.updatePassword(password: passwordController.text.trim(), context: context);
                        }
                        else{
                          Fluttertoast.showToast(msg: "Les mots de passe ne sont pas identiques.");
                        }
                        setState(() {
                          visibility = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Sauvegarder le mot de passe",style: GoogleFonts.alice(fontSize: 16),),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Center(child: Visibility(
                visible: visibility,
                child: CircularProgressIndicator(color: Colors.white,)),)
          ],
        ),
      ),

    );
  }
}