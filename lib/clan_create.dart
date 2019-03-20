import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'linkcreate.dart';

class ClanCreate extends StatefulWidget {
  @override
  _ClanCreateState createState() => _ClanCreateState();
}

class _ClanCreateState extends State<ClanCreate> {
  final _formKey = GlobalKey<FormState>();
  final _name = new TextEditingController();
  final _url = new TextEditingController();
  final _description = new TextEditingController();
  final _tag = new TextEditingController();
  final _scaffoldkey = new GlobalKey<ScaffoldState>();
  String _errorText = "This field must not be Empty";
  bool error = false;
  var pk='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Clan"),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),
      body: ListView(
        children: <Widget>[
          error
              ? Container(
                  child: Text("Clan Name Already Exists"),
                )
              : Container(),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: _name,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Enter Your Clan Name",
                        hasFloatingPlaceholder: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return _errorText;
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: _url,
                    decoration: InputDecoration(
                      labelText: "Enter the Valid URL of the YouTube Video ",
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    validator: (String value) {
                      RegExp exp = new RegExp(
                          r"^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$");
                      var value = _url.text;
                      if (exp.hasMatch(value)) {
                        error = false;
                      } else {
                        return "Enter a Valid YouTube URL";
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    maxLength: 100,
                    maxLines: null,
                    controller: _description,
                    decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        labelText: "Enter a Crisp Description",
                        hintMaxLines: 200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return _errorText;
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: _tag,
                    maxLength: null,
                    decoration: InputDecoration(
                        labelText: "Enter a Tag for your Clan",
                        labelStyle:TextStyle(color: Colors.teal),
                        hasFloatingPlaceholder: true,
                        hintMaxLines: 200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return _errorText;
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: OutlineButton(
                    child: Text("CREATE"),
                    color: Colors.red[700],
                    borderSide: BorderSide(color: Colors.red[700]),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _createClan();
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

  _createClan() async {
    await SharedPreferences.getInstance().then((prefs) {
      http.post(
          Uri(scheme: 'http', port: port, host: host, path: clan_create_path),
          headers: {
            'Authorization': 'Token ${prefs.getString('token')}'
          },
          body: {
            'name': _name.text,
            'url': _url.text,
            'description': _description.text,
            'tag': _tag.text,
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() async {
            _scaffoldkey.currentState.showSnackBar(SnackBar(
              content: Text(
                "Clan Created Successfully",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.green,
            ));
            await SharedPreferences.getInstance().then((prefs) {
              http.get(
                Uri(
                    scheme: 'http',
                    port: port,
                    host: host,
                    path: clan_create_path),
                headers: {'Authorization': 'Token ${prefs.getString('token')}'},
              ).then((response)  {
                if (response.statusCode == 200) {
                   pk = jsonDecode(response.body)['pk'];
                 
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LinkCreate(pk)));
                
                }
              });
            });
          });
        } else if (response.statusCode == 400) {
          setState(() {
            error = true;
          });
        }
      });
    });
  }
}
