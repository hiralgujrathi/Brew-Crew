import 'package:brew_crew/Auth_screen/register.dart';
import 'package:brew_crew/Auth_screen/sign_in.dart';
import 'package:flutter/material.dart';
//we enable anonymous sign in also means they dont have to supply any type of email or password to sign in
class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  //toggling between forms
  bool showSignIn=true;
  //we have to create a function that updates the state of the bool and we dont have to hardcode it means if we set it to false in set state then there is no way we turn it to true
  void toggleView() {
    setState(() {
      showSignIn=!showSignIn;
      //this is used to reverse , means it helps us to get reverse of what it currently is so if its currently true then this will make it false and vice versa
      //so it toggles it , it changes it to what it currently is to other one
    });
  }
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    if(showSignIn){
      return SignIn(toggleView:toggleView);
    }else{
      return Register(toggleView:toggleView);
    }
  }
}
