import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _username=TextEditingController();
  var _password =TextEditingController();
  var _formKey=GlobalKey<FormState>();
  var _scaffoldKey =GlobalKey<ScaffoldState>();
  String error='';

  _getAndSetToken(String username, String password)async{
    var response = await http.post(
      Uri(scheme: 'http',port: port,host: host,path: loginPath),
      
      body: {
        'username':username,
        'password':password,
       

      }
    );
    if(response.statusCode == 200){
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('token',jsonDecode(response.body)['token']);
      await  prefs.setString('username', jsonDecode(response.body)['username']);
      await prefs.setString('email', jsonDecode(response.body)['email']);
      await prefs.setInt('pk', jsonDecode(response.body)['pk']);
      setState(() {
        
       Navigator.of(context).pushNamed("home/");
        _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Welcome to TubeCate"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 100)) 
      );
        
      });
     
      
      
    }
    else if(response.statusCode==400){
      setState(() {
        error="Username or Password is Incorrect";
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      
      key:_scaffoldKey,
      appBar: AppBar(title: Text('Login'),centerTitle: true,backgroundColor: Colors.red,
        elevation: defaultTargetPlatform==TargetPlatform.android?5.0:0.0,      
      
      ),
      body: Center(
        
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        new Image(
          image: new  AssetImage('images/tube.jpg'),
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),

        
        new Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                    new TextStyle(color: Colors.tealAccent, fontSize: 20.0),
              )),
          isMaterialAppTheme: true,
          child: new ListView(
         
            children: <Widget>[
             
              new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Form(
                  key: _formKey,
                  autovalidate: true,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 30.0),
                        child:new TextFormField(
                        
                        controller: _username,
                        decoration: new InputDecoration(
                            labelText: "Username", fillColor: Colors.white, border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    )),
                            
                            
                          
                          validator: (String value){
                            if(value.isEmpty){
                              return  "This field cannot be Empty";
                            }
                          },
                      ),
                      ),
                     Container(
                       
                       padding: EdgeInsets.only(top: 30.0),
                       child: new TextFormField(
                        
                        controller: _password,
                        decoration: new InputDecoration(
                          labelText: "Enter Password",
                           border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Password cannot  be empty";
                          }
                        },
                      ),
                     ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                      ),
                      new MaterialButton(
                        height: 50.0,
                        minWidth: 150.0,
                        color: Colors.green,
                        splashColor: Colors.teal,
                        textColor: Colors.white,
                        child: new Icon(FontAwesomeIcons.signInAlt),
                        onPressed: () {
                           if(_formKey.currentState.validate()) {
                             _getAndSetToken(_username.text, _password.text); 
                           }

                          
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(top:30),
                        margin: EdgeInsets.only(left: 20.0,right: 2.0),
                        child:FlatButton(
                          child: Text("REGISTER"),
                          onPressed: (){
                            Navigator.push(context, 
                            new MaterialPageRoute(
                              builder: (BuildContext context) => new RegisterPage()
                            )
                            );
                          },
                        )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    ),
    );
}
}