// here we contain all the authentication related information like signing in registering so all the authentication activties will be handled by this file
// firebase auth is a service
//thats why we create a class that handles all the firebase authentication activites
// async keyword represents an action that starts now and finishes some time later in future eg interacting with API or getting data from database
//so we start the request but doesnt finish straight away as it may take time to complete the req so it finishes sometimes after the initial req is made
//meanwhile the code should not stop till we get our data  the code should be not blocking while req is made rest of code in our file should carry on
//so we use combo of async keywords await keyowrd an Future
//e.g simulate a network req from username from a database so we use Future.delayed so it triggers delays and takes 2 args i.e. duration and func which fires once  those 3 secs are up
//async req doesnt block our code it doesnt wait until our request comes back but sometimes we want it to wait as sometimes the 2nd request depends on the result of 1st req so we have to wait for 1st requent to get completed
//so we do that by using an async function for the funcion and then we use the await keyword then it tells to wait
//so then we wait for request to get completed and assign it to the variable(photo)
//the statements that are out of the scope of async dont get blocked means data outside doesnt get blocked
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//ALL OF THE AUTHENTICATION IS GOING TO GO IN THIS CLASS AUTHSERVICE
class AuthService {
  //here we define all the methods that interact with firebase authentication
  //sign in anonymous
  //sign in with email and password
  //register with email and password
  //sign out

  //lets create an instance of this class and it allows us to communicate with firebase auth basically a firebase auth object
  //this is an instance of firebase auth class and it gives us the access to different sign in register methods
  // and _auth is the property which we are going to use
  final FirebaseAuth _auth=FirebaseAuth.instance;
  // create user object based on FirebaseUser and it returns user object
  TheUser? _userfromFirebase(User? user){
    //inside this function we want to accept a firebase user and we want to take that user and we want to turn into new user based on the user class
    //we check if its not null and if it is not we make sure that it return new user
    //in uid we pass the id of the user we get from the signinanonymously function
    //it should return custom user object(the one we have created) instead of firebase user and so we get an instance of user class so in order to get uid we go to sign in page and print result.uid
    // ignore: unnecessary_null_comparison
    if (user != null) {
      return TheUser(uid: user.uid);
    } else {
      return null;
    }
    //so we are basically creating a new user object based on the return user that we are getting
    //so we created this object because if we get a firebase user back and if its not null we get the user based on return user type
  }
  // we need to listen to authentication changes and when the user logs in it needs to navigate to home page and this happens through streams
// if we set a stream between flutter and firebase auth service the firebase auth service is going to emit something to us everytime an user either signs in our signs out,it can be a null value if the user signs out or some kind of user object if they sign in
//so our flutter app is going to recieve those event objects when they happen and determine based on the value inside of them whether they're user object or null whether the user is locked in or out and according to that we update our UI and this stream detects the authentication changes
//firebase auth already has a stream built in it we need to invoke it by a function(onauth) in our auth service class
  //'get' keyword is to declare as a getter, if we say .user for any object, it will return the below syntax
  Stream<TheUser?> get user{
    //this stream is going to return to us firebase user whenever there is change in authentication NOW WE DONT WANNA USE FIREBASE USER WE WANNA WORK WITH OUR OWN CUSTOM USER BY THE USER SO INSTEAD OF GETTING STREAM OF FIREBASE USER WE WANT TO GET NORMAL USER BASED ON OUR USER CLASS
    //SO WE HAVE TO MAP THIS STREAM INTO A STREAM OF USERS BASED ON OUR USERS CLASS BY USING MAP METHOD
    //so everytime we get a firebase user we map that to our normal user based on our user class
    //since we are not returning firebase user we are returning a normal user so we get an error
    //method map() is to reassign for every FirebaseUser in _auth.authStateChange it will change to _userFromFirebaseUser which is our Use
    return _auth.authStateChanges()
    .map((User? user) => _userfromFirebase(user));
  }
  Future signInAnonymous() async {
    try{
// we want to get an authentication request from the firebase auth
    // since it takes time we await
      // authresult(User credential) is the type of object it returns
      UserCredential userCredential= await _auth.signInAnonymously();
      //this is used for signing up anonymously
      //now we have access to user object which represents users
      User user = userCredential.user!;
      //! indicates that variable cant be null
      return _userfromFirebase(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // we can use this method in a different widget also
  // sign in anonymous
  //this is going to return Future
  // Lets create signout method
  Future signOut() async{
    try{
      return await _auth.signOut();
      //this is inbuilt in the firebase auth library we just have to access it by the auth instance
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  //lets create a method to register with email and password
 Future registerWithEmailandPassword(String email,String password) async{
    //make a request to firebase
    try{
      UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //grab the user from that result
      User user = userCredential.user!;
      //create a new document for the user with the uid
      await DataBaseService(uid:user.uid).updateUserData('0', 'new brew crew member ', 100);//we create a record for the user (the user can update it whenever they want to)
      //this is a firebase user but we want our custom user so
      return _userfromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with email and password
  Future signInWithEmailandPassword(String email,String password) async{
    //make a request to firebase
    try{
      //we get authresult when we try to sign in
      UserCredential userCredential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      //grab the user from that result
      User user = userCredential.user!;
      //this is a firebase user but we want our custom user so
      return _userfromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;

      //when we create a new user i.e. when we register with email and password then we get that user back and with that user comes a uid created by firebase
      //then we want to create a user document inside the brews collection for the user to store the data
      //so we create an instance of database service and in that we pass a uid from that user that comes back to us and then we call the updateuserdata function and pass some dummy data for the user
      //then we go to the brewReference and get the document with uid that we passed in to the database service instance
      //that uid represents the new user that just signed up
      //now that uid wont be present at that moment as as the user just signed up but firestore will look at that and say as the doc doesnt exist i'll create a document  with that uid
      //and inside that document i'll(firestore) set some data with the 3 properties with the values we passe in (dummy values)
      //so now we get a firestore doc int he brews collection for that user to store the user data
    }
  }
}
