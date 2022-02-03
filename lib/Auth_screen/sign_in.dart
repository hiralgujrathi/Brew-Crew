//lets create the sign in widget so that we can use the auth sign in to log in
//now we shold also know how to switch between sign in and register forms since when a person comes and he already has an account then he would want to sign in rther than register and when he wants to create an account he wants to register so there should be a facility to do that
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //instance and this instance allows us to use the signinanonymous function
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  //so lets create 2 pieces of state and these pieces are going to store the 2 fields or the values written in the fields
  //text field state
  String email = '';
  String password = '';
  String error = '';
  //if the credentials dont match or if there is any logging error
  bool loading=false;
  //whenever bool is true we show only the loading widget
  final ButtonStyle style =
      ElevatedButton.styleFrom(primary: Colors.brown[400]);
  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Register'),
            style: style,
          )
          //where refer to toggleView as widget.toggleView() ans:We don’t have the function available in this class, we are actually getting it from the stateful widget.
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        /*RaisedButton(onPressed: () async {
          dynamic result=await _authService.signInAnonymous();
          if (result==null){
            print('error signing in');
          }else{
            print('signing in');
            print(result.uid);
            //uid is used to identify the logged in user
          }
          //so it is going to return us one of the 2 things either the user if it was successful or null if it was not successful
          //if we get the user that means we have logged in
          // and it is going to be a dynamic variable as it can be a firebase user or null
        },child: Text('Sign in anon'),),*/
        //now we want to access signinanonymous from AuthService class so first of all we want the instance of authservice class in sign in dart file in order to access that function

        //lets create sign in and register forms
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(height: 20),
              //now what we have to do is we have to track what the user is typing in the field and then store the value of those fields in some kind of local state variable
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  //val represents whatever is in the form field at that point value currently in formfield
                  //so when the user starts typing in this field we want to update the state so that the email property is now equal to val(value) that is in the formfield at that time
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val!.length < 6
                    ? 'Enter a password with atleast 6 characters'
                    : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20),
              InkWell(
                  onTap: () async {
                    //this will be async as when we click the button ut will have to interact with firebase to log the person in and since it will take sometime it will be an async function
                    if (_formkey.currentState!.validate()) {
                      //when the form is valid then only its gonna make request to firbase at that time we show the loading widget
                      setState(() {
                        loading=true;
                      });
                      print('valid');
                      //how does the validate func knows that our form is valid or not as we have not specific anywhere whether things are required or any other kind of validation so this method uses validator properties on different form fields e.g. email password etc
                      //but at the moment we dont have any validator properties on the form fields so lets create some and these properties allows us to validate the field

                      //so when we run the validate method it goes upto each one of the fields and runs each function so it checks and if something is not valid it evaluates as invalid

                      //we are going to create a dynamic variable because we can either get the user or null value
                      dynamic result = await _authService
                          .signInWithEmailandPassword(email, password);
                      if (result == null) {
                        //means there's an error as it returns null
                        //update to error or upate the state to error
                        setState(() {
                          //when there is error it does doesnt return the home screen but return back the sign in page with the message as firebase is not able to identify the address as the credentials we used are wrong
                          loading=false;
                          error = 'Could not sign in with those credentials';
                        });
                      } else {
                        //when the user has registered successfully we have to show the homepage but tht can happen automatically bcoz we have a stream settled  inside root widget which listns to all auth changes so when a user registers successfully to firebase we get that user back
                        //an that user comes own to the stream which is listening to auth changes so it shows now we have the user back the auth state is changed an is now signed up and we have that user and we see homepage
                      }
                    }
                    //print(email);
                    //print(password);
                    //in future we dont print these values but we take these values and interact with firebase to sign that person in
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.brown[500]),
                  )),
              SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//it shows the default value i.e. showsignin = true then when we click register icon it activates the toggle function and reverses it and shows register
