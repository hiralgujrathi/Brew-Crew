//this is responsible for outputting different brews on the page or cycling through them
import 'package:brew_crew/models/brew.dart';
import 'brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    //here we try to access data from the stream
    final brews=Provider.of<List<Brew>>(context);
    //so we must go use the for each method to go through the brews and print them
   // brews.forEach((brew) {
      //brew is basically instance of brew which we can use to access the parameters in Brew class
      //for each one we are going to fire a function and we take in that brew
      //print(brew.name);
      //print(brew.sugar);
      //print(brew.strength);
    //outputting the data on the screen

    return ListView.builder(itemBuilder: (context,index) {
      return BrewTile(brews[index]);
    },
      itemCount: brews.length,);
    //we cycle thru the documents
    //for(var doc in brews.docs){
    //since we changed querysnapshot to brews we dont need docs anymore
      //grabbing data from document
      //print(doc.data());




      //we want to recieve list of brew objects rather than query snapshot so that we can cycle through the brew objects and make a template for them
      //we are listening the stream that send query snapshots from the firestore database an it is object of firestore collection at that time
      //and it contains documents and for each document we grab data from the document so instead of recieving snapshots it would be good if we recieve a list of brew objects
      //so that we wont have to say doc and then grab data with .data we just have a single list of brew object
      //so we can create our own brew model and then when we recieve a querysnapshot we convert to brew object so we recieve a brew object not a query snapshot so we can cycle through them
      //basically we have to convert a querysnapshot into a list of brews

      //we cycle the brews thru for loop and we get the data through data() and we print it
    }
    //we are accessing the brews
    //so we cycle through brews and we can print them out
    //print(brews);
    //instance of querysnapshot
    //print(brews.docs);
    //this gets all the documents from firestore collection
    //we cycle through the ocuments and output the data for each document

  }
