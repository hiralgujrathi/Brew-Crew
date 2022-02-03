import 'package:brew_crew/Auth_screen/authentication.dart';
import 'package:brew_crew/Home_screen/home.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//at the very top of our app we are tracking the user authentication status so that it can inform the wrapper the user logged in or not so that in wrapper we can either display authentication or home screen so if it a valid user we are logged in and the home screen is shown
//so we want a way to provide that stream data tot he to(root) widget so that it can listen to those auth changes and pass the info down accordingly so we do this by provider package for state management this can be done by wrapping a widget tree in a provider and then we supply a stream to that provider by the auth change stream so whenever we get new data in that stream the provider makes it accessible to the descendants in widget tree
// so whenever user logs in or logs out the firebase auth change stream will either send null or user object which we can access in our widget tree (in the wrapper) (authenticate if user is signed out and home if user is signed in)
//main.dart is the root widget so wr wrapp material app widget with the provider  and we're providing user data through it including wrapper where we want to access it
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //the user is the type of data it is going to listen
    return StreamProvider<TheUser?>.value(
      //we are creating an instance of Authservice and accessing the user stream on it so we are listening to that stream in the provider package
      //this takes what stream we want to listen to
      //so now inside the wrapper widget which is below the root widget we can access the user data when we get,this stream is actively listening for authentication events when user signs in we get that user when user signs out we get some kind of null value so when this change occurs we can listen to that in wrapper so lets try to access data in wrapper
      value: AuthService().user,
      initialData: TheUser(uid: ''),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute:  '/Wrapper',
        routes: {
          '/Wrapper': (context) => Wrapper(),
          '/HomePage': (context) => Home(),
          '/AuthPage': (context) => Authentication(),
        },
      ),
    );
  }
}


