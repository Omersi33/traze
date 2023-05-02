import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traze/Brain/Auth.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailDecoration = InputDecoration(
      hintText: "Adresse mail",hintStyle: GoogleFonts.alice(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  final passwordDecoration = InputDecoration(
      hintText: "Mot de passe",
      hintStyle: GoogleFonts.alice(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  final confirmPasswordDecoration = InputDecoration(
      hintText: "Confirmer le mot de passe",
      hintStyle: GoogleFonts.alice(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Stack(
          children: [
            SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Inscription",
                          style: GoogleFonts.alice(color: Colors.white, fontSize: 50),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: emailController,
                                decoration: emailDecoration,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passwordController,
                                decoration: passwordDecoration,
                                obscureText: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: confirmPasswordController,
                                decoration: confirmPasswordDecoration,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                onPressed: () async{
                                  setState(() {
                                    visibility = true;
                                  });
                                  if(passwordController.text == confirmPasswordController.text){
                                    await Auth.signup(emailController.text.trim(), passwordController.text, context);
                                  }else{
                                    Fluttertoast.showToast(msg: "Les mots de passe ne sont pas identiques");
                                  }
                                  setState(() {
                                    visibility = false;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text("S'inscrire",style: GoogleFonts.alice(fontSize: 16),),
                                ),
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text("Retour vers la page de connexion",style: GoogleFonts.alice(fontSize: 16),),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),)
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