import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  //when we need to use the stream in one single widget we can easily use the builtin stream builder as we use the stream in this setting form only fr eg in auth we needed it in multiple widgets so we didnt use this
  //we can use the stream builder when we want to use data in multiple widgets in the tree but it is harder to maintain but here are using in 1 stream only so we can use stream builder

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey = GlobalKey<FormState>();
  final ButtonStyle style =
      ElevatedButton.styleFrom(primary: Colors.brown[400]);
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  //form values
  String? _currentName;
  String _currentSugar='0';
  int _currentStrength=100;
  @override
  Widget build(BuildContext context) {
    //we have access to the user who the user who was logged in via the provider and the provider we use inside the wrapper so have used it here as we need the context so that we can have accesa to the current user logged in  and we can access he ID from the user
    final user=Provider.of<TheUser?>(context);
    return StreamBuilder<UserData>(
      //so when we use the stream to get the user data inside service class we can base it on users ID and we are gonna match out to firestore document for that user
      stream: DataBaseService(uid: user!.uid).userData,
        //so now we need stream name which we called user data so now we are listening to this stream inside streambuilder widget and the builder of widget it returns a widget tree
      builder: (context, snapshot) {
        //snapshot refers to the data coming down the stream
        //we want to check that we have data on the snapshot before we start to do anything
        //we need to check is the data coming down the stream

        //has data returns true or false and if there is data and ready to use it returns true
        if(snapshot.hasData){
          //then we return form that we get from snapshot
          return Form(
                key: _formkey,
                child: Column(
                  children: [
                    Text(
                      'Update your Brew settngs',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration,
                      //val makes sure that we have a value inside the form field and the value currently inside the formfield is assigned to currentname
                      validator: (val) => val!.isEmpty ? 'Please enter a mail' : null,
                      onChanged: (val) => setState(() {
                        _currentName = val;
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //dropdown
                    DropdownButton(
                      //list of drop down menu items widget so we map thru the sugars i.e. above list of sugars and return a value,for each value we fire a function
                      //here the number of sugar gets displayed
  //this value shows a selected value basically this is the thing that shows
                      //this is stored in database

                      //when we dont have the value for currentsugar it is initialized to 0 but we can change this  initial fallback value to whatever is stored in current user data in firestore document
                      value: _currentSugar ,
                      //this is the thing that shows in dropdown
                      //about this value:when we select some value for e.g. 3 sugars in DropdownMenuItem then its not the thing that shows its the thing getting updated
                      items:sugars.map((sugar){
                        //sugar is a particular value of each iteration
                        //we iterate through each sugar
                        return DropdownMenuItem(child: Text('$sugar sugar(s)'),value: sugar,
                          //this value keeps the track of actual value we select
                          //this is not the thing that is getting shown but this is getting updated
                        );
                        //in this the number of sugars get updated which ever we select
                      }).toList(),
                      //we add tolist because it is giving an iterator and items expect a list
                      //so we are cycling thru each value firing  fucntion for each and returning a dropdownmenuitem for each
                      onChanged: (String? val) => setState(() {
                        _currentSugar=val!;
                      }),
                      //onchanged updates the current sugar if we dont do this then we will see only 0 sugars as it wont get updated similar to currentname
                    ),
                    //slider
                    Slider(
                      //slider works with doubles
                      value: _currentStrength.toDouble(),
                      activeColor: Colors.brown[_currentStrength],
                      inactiveColor: Colors.brown[_currentStrength],
                      min: 100,
                      max:900,
                      divisions: 8,
                      onChanged: (val)=>setState(() {
                        _currentStrength=val.round();
                      }),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.brown[400]),
                        onPressed: () async {
                          if(_formkey.currentState!.validate()){
                            await DataBaseService(uid: user.uid).updateUserData(_currentSugar, _currentName!, _currentStrength);
                            Navigator.pop(context);
                          }
                          //we do this async because as it will communicate with the firebase to update the record in firestore
                          //print(_currentName);
                         // print(_currentStrength);
                          //print(_currentSugar);
                        },
                        child: Text('Update'))
                  ],
                ));
        }else{
          return Loading();
          //if there is no data then loading widget is returned
        }
      }
    );
  }
}
