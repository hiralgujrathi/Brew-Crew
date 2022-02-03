import 'package:flutter/material.dart';
import 'package:brew_crew/models/brew.dart';
class BrewTile extends StatelessWidget {
  final Brew brew;
  BrewTile(this.brew);
  //now we have access to individual brew object so we return some kind of template for individual brew
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top:8.0),
    child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
    child: ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.brown[brew.strength],
      ),
      title: Text(brew.name),
      subtitle: Text('Takes ${brew.sugar} sugar(s)'),
    ),
    ),
    );
  }
}
