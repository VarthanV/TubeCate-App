import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'homepage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LinkCreate extends StatefulWidget {
  final String pk;
  LinkCreate(this.pk);
  @override
  _LinkCreateState createState() => _LinkCreateState();
}

class _LinkCreateState extends State<LinkCreate> {
 final _formKey=GlobalKey<FormState>();
 final _link=new TextEditingController();
 final _description = new TextEditingController();
 final _title=new TextEditingController();

 _linkcreate() async{
   await  SharedPreferences.getInstance().then((prefs){
     http.post(Uri(path: link_create_path,port:port,scheme:'http',host:host),
      headers: {
            'Authorization': 'Token ${prefs.getString('token')}'
          },
    body: {
      'title':_title.text,
      'description':_description.text,
      'link':_link.text,
      'pk':widget.pk,

    }
     ).then((response){
       if(response.statusCode ==200){
         Navigator.push(context, new MaterialPageRoute(
           builder: (context) => HomePage()
         ));
       }
     });
   });

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Create Supporting Links"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top:20.0),
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: TextFormField(
                    controller: _title,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Title",
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    ),
                    validator: (String value){
                      if(value.isEmpty){
                        return "Enter a title";
                      }
                    },

                  ),

                ),
                Container(
                  padding: EdgeInsets.only(top:20.0),
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: TextFormField(
                    controller: _link,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Link",
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    ),
                    validator: (String value){
                      RegExp exp =new RegExp(r'\b(https?|ftp|file)://)?[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]');
                      if(exp.hasMatch(value)){
                        return null;
                      }
                      else{
                        return "A valid url must be entered";
                      }
                    },

                  ),

                ),

                Container(
                  padding: EdgeInsets.only(top:20.0),
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: TextFormField(
                    controller: _description,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Description",
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    ),
                    validator: (String value){
                      if(value.isEmpty){
                        return "Enter a Description";
                      }
                      
                    },

                  ),

                ),
                Container(
                  padding: EdgeInsets.only(top: 40.0),
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: RaisedButton(
                    child: Text("CREATE"),
                    color: Colors.teal,
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                       return _linkcreate();
                      }
                    },

                  ),
                )
              ],
            ),
          )
        ],
      ),
    );



  }
}    