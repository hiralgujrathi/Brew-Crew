//like we had a file for authentication we will have one for database also
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;
  DataBaseService({required this.uid});
  //collection reference for storing or reading data
  //CollectionReference is a type
  final CollectionReference brewReference=FirebaseFirestore.instance.collection('brews');
  //in this way we can find out which document belongs to which person
  //we are going to use this function twice when the user creates an account and second when they want ti update their info
//each time its going to get the reference to that document and update the data
  Future updateUserData(String sugar,String name,int strength) async {
    //we call this function when a new user signs up
    return await brewReference.doc(uid).set({
      'sugars': sugar,
      'name': name,
      'strength': strength,
    });
    //when we create an instance of DataBaseService in future we will pass in the uid in the document
    //this uid is going to get a reference to that document in the collection now if that document with that particular uid doesnt exist with this uid then firestore creates a document with this uid
    //so when the user first signs up and we call the function and pass the uid of that user then that doc doesnt exist yet its gonna create that document with that uid
    //then it will link the firestore document for the user to the firebase user
  }
  //how we can get the data from firestore in our app so we have to show the data on our screen
//for this we are going to set a stream which is going to notify us about any changes on the documents in the database
//as we have set a stream for auth changes and it notifies us about the auth changes here the stream is going to notify us about the documents in the firestore collection initially and also if any changes occur to those documents
//for eg if a new document is added then we get notified or if any document is changed
//we get the current data in an object an then its our responsibility to get the data from the object and organize it in a way we want in our app
//for e.g. we add a document as a user signs up we get an object down through the stream and that object represents brews collection at that moment and it contains the documents in it including the one thats just added so we can extract that data
// and if we change an existing doc then we get a fresh object that represent the current state of the that collection including the fresh change so we get an upto date data all the time
//Querysnapshot is the object of the firestore collection at that moment in time when there is a change

  //getting a brewlist from snapshots
  List<Brew> _brewListfromSnapshot(QuerySnapshot snapshot){
    //we get the original data from the snapshot means when we recieve the snapshot own the stream that contains all the original data and we map through that data
    return snapshot.docs.map((doc){
      return Brew(name: doc.get('name')?? '',
          sugar: doc.get('sugars')?? '0',
          strength: doc.get('strength')?? 0
      );
      //this returns an iterable not a list so we need to convert it to a list when we output the data in UI widget
    }).toList();
  }

//we need a method to take the document snapshot and turn into user data object based on user data model
//userData from snapshot
  UserData _userDatafromSnapshot(DocumentSnapshot snapshot){
    return UserData(
        uid: uid,
        //this is how we get data from document snapshot
        name: snapshot['name'],
        sugar: snapshot['sugars'],
        strength:snapshot['strength']
    );
    //this function is basically taking a snapshot and based on the snapshot we are returning userdata object
  }
  //as it is going to take document snapshot so we pass in document snapshot and in this function we return a new user data object
  Stream<List<Brew>> get brews{
    //brewsReference references the brews collection nd we return that with metho .snapshots
    //snapshots is a built in methof in firestore library and this returns the stream
    return brewReference.snapshots().map(_brewListfromSnapshot);
    //and now in home screen we can use the provider package to listen to this stream in the home screen
  }

  //get user document stream
  //Stream <DocumentSnapshot> get userData {
  Stream<UserData> get userData{
    //this stream is listening for data inside a particular document of the user now we will work with the data that we get back from that stream inside the settings form
  //now we will map here

    //brewreference is a collection reference and when we want to get a specific document say uid we do.doc and uid is coming frm database service
    //we pass the uid so that we can know which document to get
    //we have done .snapshot as we did for brewreference.snapshots so whenever the document changes we gonna recieve a document snapshot back and we also recieve when the app first loads
    return brewReference.doc(uid).snapshots()
        .map(_userDatafromSnapshot);
    //so basically we have set up our stream which is returning brewReference.doc(uid).snapshots() means its taking the current firebase stream from our firestore document based on id
//and everytime there is a change or initially we recieve a snapshot tha tells us about the document means whats the data but we dont want to work with snapahot we want to work with a custom object base on our userdata model means just 4 porperties i.e. name sugar strength uid
  //so we map it into a different stream based on function _userDatafromSnapshot which takes the document snapshot and returns a user data objct based on document snapshot
    //now we have to listen to stream inside the form so that we can take values when we take them and output the,

    //so like this we have set up a stream
    //we will map this to something else but we need a user data model to do that
  }
  //we want to return actual user data model or user data object based on user data

}


//how are we going to link the user and their data such as their name sugar strength
//brews is a collection of documents in which the users requirements are going to be stored like name sugar strength
//when the user signs up they get a unique ID so we can give the same ID to their info means document in the collection






