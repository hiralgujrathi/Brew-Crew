import 'package:brew_crew/Auth_screen/authentication.dart';
import 'package:brew_crew/Home_screen/home.dart';
import 'package:brew_crew/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//this is going to be a stateless widget and this is where we either return home or authentication widget
//only logged in users can see the homescreen the users who havent can see only the authentication page
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<TheUser?>(context);
    //print(user);
    //when we print first of all we get null thats when firebase auth was not initialized so we dont have a valid user value and then we get instance of user
    //this is accessing the user data from the provider 'TheUser ' type of data is recieved by stream
    //return Authentication();
    if(user==null){
      return Authentication();
    }else{
      return Home();
      //when we run we see the home screen as we are signed in anon
      //now lets add a button on the home page that we can press and log out and show the authenticate page
    }
  }
}
//everytime user logs in we get a user object back from that stream and is stored in the user variable and everytime user logs out we get some kind of null value back from the stream so if the user value we get back is null that means user isnt currently logged in so in that case we dont have to show home screen we have to show the authenticate screen and when the user is logged in we dont want to show the authenticate screen we want to show the home screen
