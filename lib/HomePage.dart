import 'package:flutter/material.dart';
import 'Auntification.dart';


class HomePage extends StatefulWidget
{

    HomePage
        ({
   this.auth,
   this.onSignedIn,
   this.onSignedOut,
});



    final AuthImplemention auth;
    final VoidCallback onSignedIn;
    final VoidCallback onSignedOut;


  @override
  State<StatefulWidget> createState()
  {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
{

void _logoutUser() async
{
try
    {
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e)
  {
    print(e.toString());
  }
}



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold
      (
      appBar: new AppBar
        (
        title: new Text("Home"),
      ),

      body: new Container
        (

      ),

      bottomNavigationBar: new BottomAppBar
        (
        color: Colors.green,

        child: new Container
          (

          margin: const EdgeInsets.only(left: 70.0 , right: 70.0),
          child: new Row
            (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,


            children: <Widget>
            [
              new IconButton
                (
                icon: new Icon(Icons.local_car_wash),
                iconSize: 50,
                color: Colors.white,

                onPressed: _logoutUser,
              ),

              new IconButton
                (
                icon: new Icon(Icons.add_a_photo),
                iconSize: 50,
                color: Colors.white,

                onPressed: null,
              ),
            ],

          ),
        ),
      ),
    );
  }
}