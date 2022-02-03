import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService=AuthService();
  //we need some validation in the app before making any request to firebase
  final _formkey=GlobalKey<FormState>();
  //this key is used to identify our form and we are going to associate our form with global formstate key

  //so lets create 2 pieces of state and these pieces are going to store the 2 fields or the values written in the fields
  //text field state
  String email='';
  String password='';
  String error='';
  bool loading=false;
  final ButtonStyle style =
  ElevatedButton.styleFrom(primary: Colors.brown[400]);
  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        actions: [
          ElevatedButton.icon(onPressed: (){widget.toggleView();}, icon: Icon(Icons.person),label:Text('Sign in'),style: style,)
          //widget refers to Register widget itself and its property is toggleview and we can access it
        ],
        elevation: 0.0,
        title: Text('Sign up to Brew Crew'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 50.0),
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
          //what we do here is we are associating global key i.e. formkey with our form and its basically going to keep track of our form means state of our form and in future if we want to validate our form we can do that via formkey as we can access the form key and know the state of our form as it is associated with our form
          //basically to keep the track of the state of our form and validate it
          child: Column(
            children: [
              SizedBox(height:20),
              //now what we have to do is we have to track what the user is typing in the field and then store the value of those fields in some kind of local state variable
              TextFormField(
                //validator takes the current value inside that particular form field at that moment and we are going to return a value so
                // we are going to return a null value if the form field is valid or a string which is going to be a helper text if its not valid
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,//means there is an email so we return null
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                onChanged: (val) {
                //val represents whatever is in the form field at that point value currently in formfield
                //so when the user starts typing in this field we want to update the state so that the email property is now equal to val(value) that is in the formfield at that time and we return a value
                setState(() {
                  email=val;
                });
              },),
              SizedBox(height:20),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                //to check if the length of password is atleast 6
                validator: (val) => val!.length<6 ? 'Enter a password with atleast 6 characters' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password=val;
                  });
                },),
              SizedBox(height:20),
              InkWell(
                  onTap: () async {
                    //this will be async as when we click the button ut will have to interact with firebase to log the person in and since it will take sometime it will be an async function
                    //print(email);
                    //print(password);
                    //in future we dont print these values but we take these values and interact with firebase to sign that person in

                    //now we check is our form valid to the point at which we click the register button and async function fires
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        loading=true;
                      });
                      //how does the validate func knows that our form is valid or not as we have not specifie anywhere whether things are required or any other kind of validation so this method uses validator properties on different form fields e.g. email password etc
                      //but at the moment we dont have any validator properties on the form fields so lets create some and these properties allows us to validate the field

                      //so when we run the validate method it goes upto each one of the fields and runs each function so it checks and if something is not valid it evaluates as invalid
                      //this will validate our form based on current state
                      //this will evaluate either true or false
                      //if true then our form is correct and and we can execute code or send request to the firebase so sign the user up
                      //if it is not the it shows helper text


                      //we are going to create a dynamic variable because we can either get the user or null value
                      dynamic result= await _authService.registerWithEmailandPassword(email, password);
                      if(result==null){
                        //means there's an error as it returns null
                        //update to error or upate the state to error
                        setState(() {
                          loading=false;
                          error='please supply a valid email';
                        });
                      } else {
                        //when the user has registered successfully we have to show the homepage but tht can happen automatically bcoz we have a stream settled  inside root widget which listns to all auth changes so when a user registers successfully to firebase we get that user back
                        //an that user comes own to the stream which is listening to auth changes so it shows now we have the user back the auth state is changed an is now signed up and we have that user and we see homepage
                      }
                    }

                  },
                  child: Text('Register',style: TextStyle(color: Colors.brown[500]),)),
              //lets show the error message if not registered
              SizedBox(height:12),
              Text(error,style: TextStyle(color: Colors.red,fontSize: 14.0),)
              //we get this error because as we type the email it goes to the firebase server and firebase server tries to look for the email and it return an error as this is not an email
            ],
          ),
        ),
      ),
    );
  }
}
//since showSignIn is true we see the sign in screen at first
//so when we click on the sign in button it changes the screen as it activates the toggle view function from the signin/register widget and when we run that function its taking the current value and when we click its reversing it.

/*In this example, learn how to add validation to a form that has a single text field using the following steps:

Create a Form with a GlobalKey.
Add a TextFormField with validation logic.
Create a button to validate and submit the form.
*/