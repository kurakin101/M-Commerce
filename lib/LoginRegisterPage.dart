import 'package:flutter/material.dart';
import 'Auntification.dart';


class LoginRegisterPage extends StatefulWidget
{

  LoginRegisterPage
      ({
   this.auth,
   this.onSignedIn,
   this.onSignedOut,
});

  final AuthImplemention auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;


  State<StatefulWidget> createState()
  {
    return _LoginRegisterPage();
  }


}



enum FormType
{
  login,
  register
}

class _LoginRegisterPage extends State<LoginRegisterPage>
{
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";



//Methods
bool validateAndSave()
{
   final form = formKey.currentState;

   if(form.validate())
     {
       form.save();
       return true;
     }
   else
     {
       return false;
     }
}



  void validateAndSubmit() async
  {
    if(validateAndSave())
      {
        try
            {
              if(_formType == FormType.login)
                {
                  String userId = await widget.auth.SignIn(_email, _password);
                  print("login userId = " + userId);
                }
              else
                {
                  String userId = await widget.auth.SignUp(_email, _password);
                  print("register userId = " + userId);
                }
              widget.onSignedIn;
            }
            catch(e)
    {
        print("Error = " + e.toString());
    }
      }
  }



void moveToRegister()
{
    formKey.currentState.reset();

    setState(()
    {
    _formType = FormType.register;
    });
}

void moveToLogin()
{
    formKey.currentState.reset();

    setState(()
    {
    _formType = FormType.login;
    });
}


//Design
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold
      (
        appBar: new AppBar
          (
          title: new Text("Flutter App"),
        ),
        body: new Container
          (
          margin: EdgeInsets.all(15.0),

          child: new Form
            (
            key: formKey,

            child: new Column
              (
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: createInputs() + createButtons(),

            ),
          ),
        ),

    );
  }



  List<Widget>createInputs()
  {
    return
        [
          SizedBox(height: 10.0,),
          logo(),
          SizedBox(height: 20.0,),

          new TextFormField
            (
            decoration: new   InputDecoration(labelText: 'Email'),

            validator: (value)
            {
              return value.isEmpty ? 'Email is requred' : null;
            },
            onSaved: (value)
            {
              return _email = value;
            }

          ),

          SizedBox(height: 10.0,),

          new TextFormField
            (
            decoration: new   InputDecoration(labelText: 'Password'),
              obscureText: true,


              validator: (value)
              {
                return value.isEmpty ? 'Password is requred' : null;
              },
              onSaved: (value)
              {
                return _password = value;
              }
          ),

          SizedBox(height: 20.0,),

        ];
  }

  Widget logo()
  {
    return new Hero
      (
      tag: 'hero',


      child: new CircleAvatar
        (
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('logo300_400x400.png'),
      ),
    );
  }


  // ignore: missing_return
  List<Widget>createButtons()
  {
  if(_formType == FormType.login)
  {
    return
      [
        new RaisedButton
          (
          child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.green,

          onPressed: validateAndSubmit,
        ),

        new FlatButton
          (
          child: new Text("Create Account", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.red,

          onPressed: moveToRegister,
        ),
      ];
  }

  else
    {
      return
        [
          new RaisedButton
            (
            child: new Text("Create Account", style: new TextStyle(fontSize: 20.0)),
            textColor: Colors.white,
            color: Colors.green,

            onPressed: validateAndSubmit,
          ),

          new FlatButton
            (
            child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
            textColor: Colors.red,

            onPressed: moveToLogin,
          ),
        ];
    }
  }

}