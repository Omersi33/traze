import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traze/pages/Login.dart';

import '../Brain/Auth.dart';
import 'Password.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final nomDecoration = InputDecoration(
      hintText: "Nom",
      hintStyle: GoogleFonts.alice(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  final emailDecoration = InputDecoration(
      hintText: "Adresse mail",hintStyle: GoogleFonts.alice(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

  var image;

  var data;
  getProfile()async{
    final _auth = FirebaseAuth.instance;
    try{
      setState(() {
        data = _auth.currentUser;
      });
    }catch(e){

    }
  }
  bool visibility = false;
  @override
  void initState() {
    getProfile();
    nomController.text = data.displayName;
    emailController.text = data.email;
    image = data.photoURL;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: ()async{
                  setState(() {
                    visibility = true;
                  });
                  await Auth.uploadPick().then((value){
                    setState(() {
                      image = value;
                    });
                  });
                  await Auth.updateProfilePicture(context: context, image: image);
                  setState(() {
                    visibility = false;
                  });
                },
                child:
                CircleAvatar(
                  radius: 70,
                  backgroundImage: image !=null ? NetworkImage(image) : NetworkImage(data.photoURL),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nomController,
                  decoration: nomDecoration,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailController,
                  decoration: emailDecoration,
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
                        await Auth.updateNameEmail(name: nomController.text.trim(), email: emailController.text.trim(), context: context);
                        setState(() {
                          visibility = false;
                        });
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Sauvegarder mes données",style: GoogleFonts.alice(fontSize: 16),),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Password()));
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Modifier mon mot de passe",style: GoogleFonts.alice(fontSize: 16),),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async{
                        setState(() {
                          visibility = true;
                        });
                        await Auth.logout();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                        setState(() {
                          visibility = false;
                        });
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Se déconnecter",style: GoogleFonts.alice(fontSize: 16),),
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