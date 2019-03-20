import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool error =false;
var _scaffoldKey= new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  var _emailController =TextEditingController();
  var _usernameController =TextEditingController();
  var _passwordController =TextEditingController();
  var _conbfirmController =TextEditingController();

  _register(String email,String username, String password)async{
    var response = await http.post(
      Uri(scheme: 'http',host: host,port: port,path: registerPath),
      body: {
        'email':email,
        'username':username,
        'password':password
      }
    ).then((response){
      if (response.statusCode == 200){
      Navigator.of(context).pushNamed("login/");
    }
    else if(response.statusCode==400){
      setState(() {
        error=true;
        

      });
    }
    }

    );
    
    
    }

  @override
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Register'),centerTitle: true,backgroundColor: Colors.red[700],),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                error ? Container(
                  child: Text('Username Already Exists'),
                ):Container(),
                Container(
                
                  padding: EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
                  child: TextFormField(
                    
                    validator: (String value){
                      if(value.isEmpty)
                      return "Please enter email";
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      hintText: "Email",
                      labelText: "Email"
                    ),
                  ),),
                  Container(
                    margin: EdgeInsets.only(top:30.0),
                    padding: EdgeInsets.only(left:20.0,right: 20.0),
                  child:TextFormField(
                    validator: (String value){
                      if(value.isEmpty)
                      return "Please enter email";
                    },
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      hintText: "Username",
                      labelText: "Username",
                    ),),),
                  Container(
                    margin: EdgeInsets.only(top:30.0),
                    padding: EdgeInsets.only(left:20.0,right: 20.0),
                  child:TextFormField(
                    
                    validator: (String value){
                      if(value.isEmpty)
                      return "Please enter email";
                    },
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      hintText: "Password",
                      labelText: "Password"
                    ),),),
                  Container(
                    margin: EdgeInsets.only(top:30.0),
                    padding: EdgeInsets.only(left:20.0,right: 20.0),
                  child:TextFormField(
                    validator: (String value){
                      if(value.isEmpty){
                        return "Enter a password";
                      }
                      
                      else if(_passwordController.text !=_conbfirmController.text)
                      return "Password Does Not Match";
                    },
                    obscureText: true,
                    controller: _conbfirmController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      hintText: "Confirm Password",
                      labelText: "Confirm Password"
                    ),

                  ),
                ),
                Container(
                 margin: EdgeInsets.only(top: 30.0),

                 height: 50.0,
                 width: 300,
                 child: FlatButton(
                   color: Colors.teal,
                   child: Text("REGISTER"),
                   onPressed: (){
                     _register(_emailController.text,_usernameController.text,_passwordController.text);
                     
                      
                   },
                 ),
               )
                
              ],
            ),
          )
        ],
      )
    );
  }
}