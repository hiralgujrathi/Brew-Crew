//we get uid which is important as we can identify the user and rest most of things are not important sp what we want to do is when we
// recieve this firebase user back so we want to turn it into some kind of object that contains only the info we need and rn its just the uid
// but it can include other info also in future whatever property we want to keep hold of as the user navigates b/w different screen
// into the user object we create that we want to use in this app so we create a user class that keeps the info we want to define the properties
// we want the user to have
//basically we have to listen and return the correct side of widget tree means home or authentication page and so we use something called stream
class TheUser {
  //in this we create a final property which is going to be a string which does not change as the user navigates through different screens which is uid
  final String uid;
  TheUser({required this.uid});
  //so we pass uid property in user class
//next we have to do is listen when the user signs in  and react to that return the correct content to the user
}
class UserData{
  final String uid;
  final String name;
  final String sugar;
  final int strength;
  UserData({required this.uid,required this.name,required this.sugar,required this.strength});
}
//this represents the user data
//so when we create a new user data object we pass these values