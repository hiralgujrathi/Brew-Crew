//when a user signs up we assign them new values like new crew member ad name 0 sugars and strength as lowest but we want in such a way that the user when opens the settings they can update their entries and can see on home screen
//so once they've changed and they come back they see their data on the screen
//for that the user have to setup some kind of stream again and this time listen to their user document
//for eg if i login or signup ive a unique id associated with it now i want to set up a stream to my firestore document with that id same as my id so we are listening to that document and we are getting the data initially  and we are then updating the data
//basically we want to update data in the form as well
//the data travels down the stream and ur app gets updated accordingly
//so we create a new stream in database and link to firestore document
//we create a user data model...in it everytime we get some kind of doc snapshot back down the stream of the user document we are going to take that data and put it into some kind of user data object (DOCUMENTSNAPSHOT STREAM)
import 'package:brew_crew/Home_screen/brew_list.dart';
import 'package:brew_crew/Home_screen/settings_form.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ButtonStyle style =
  ElevatedButton.styleFrom(primary: Colors.brown[400]);
  final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: SettingsForm(),
        );
      });
    }
    //since we want to see the doc info on home screen and that can happen with provider stream so we wrap scaffold with provider
    return StreamProvider<List<Brew>>.value(
      //we are listening the brews coming not querysnapshots
      value: DataBaseService(uid: '').brews,
      //QuerySnapshot is the type of data we get back
      initialData: [],
      //now we can access the data in descent widget tree
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
           ElevatedButton.icon(onPressed: () async{
             await _auth.signOut();
             //after this action is performed the user is going to get updated to null in wrapper and since user is null so we get authenticate screen
           }, icon: Icon(Icons.person),label:Text('Logout'),style: style,),
            IconButton(onPressed: () {_showSettingsPanel();}, icon: Icon(Icons.settings))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/coffee_bg.jpg'),
                fit: BoxFit.cover
              )
            ),
            child: BrewList()),
      ),
    );
  }
}
