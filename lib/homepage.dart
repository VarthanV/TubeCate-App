import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'clan_create.dart';
import 'login.dart';
import 'clan_detail.dart';
import 'profile.dart';
import 'liked_view.dart';
import 'tag_search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, bool> likeMap = {};
  Map<String, int> likeCount = {};
  List clan = [];
  bool isLoaded = false;
  var email = '';
  var username = '';
  int pk;
  _setcredentials() {
    SharedPreferences.getInstance().then((prefs) {
      email = prefs.getString('email');
      username = prefs.getString('username');
      pk=prefs.getInt('pk');
    });
  }
  like(String pk) async{
   var prefs=  await SharedPreferences.getInstance();
   setState(() {
      likeMap[pk] ? likeCount[pk.toString()]-- : likeCount[pk.toString()]++;
      
        http.post(Uri(port: port,host:host,scheme: 'http',path: like_path),
        headers: {'Authorization': 'Token ${prefs.getString('token')}'},
        body: jsonEncode({'pk':pk})
        
        ).then((response){
          if(response.statusCode ==200){
            likeMap[pk.toString()] = json.decode(response.body)['liked'];
            refresh();

          }
        });
   });

    


  }

  @override
  _logout(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("LogOut"),
            content: Text("Are You Sure want to Logout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('email');
                    prefs.remove('username');
                    prefs.remove('pk');
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new LoginPage()));
                    });
                  });
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _getClan() {
    SharedPreferences.getInstance().then((prefs) {
      http.get(
        Uri(scheme: 'http', host: host, port: port, path: home),
        headers: {'Authorization': "Token ${prefs.getString('token')}"},
      ).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            clan.add(jsonDecode(response.body)['clan']);
            for (var likes in jsonDecode(response.body)['clan']) {
              likeMap[likes['pk'].toString()] = likes['liked'];
              likeCount[likes['pk'].toString()] = likes['likes_count'];
            }
            isLoaded = true;
          });
        }
      });
    });
  }

  Future<Null> refresh() async {
    setState(() {
      _getClan();
    });
  }

  clanCard(List clan, Map likeMap, Map likeCount,Function like) {
    return Column(
        children: clan
            .map((item) => Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  margin: EdgeInsets.only(top: 3.0),
                  child: Card(
                    elevation: 30.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ClanDetail(item['pk'])));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('images/trisha.jpeg'),
                                  radius: 20.0,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    item['leader'],
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ),
                                Container(child: Text("  created   ")),
                                Container(
                                    child: Text(
                                  item['name'],
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 20.0),
                                )),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white70,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(item['description']),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Members :" + item['members_count'].toString(),
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.teal),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 8.0),
                              alignment: Alignment.topLeft,
                              child: Text("Tag :")),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 8.0),
                            margin: EdgeInsets.only(left: 8.0),
                            child: RaisedButton(
                              child: Text(item['tag'].toString()),
                              onPressed: () {
                                return null;
                              },
                            ),
                          ),
                          Divider(
                            color: Colors.white70,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                    splashColor: Colors.redAccent,
                                    color: Colors.redAccent,
                                    iconSize: 37.0,
                                    padding: EdgeInsets.zero,
                                    icon: likeMap[item['pk'].toString()]
                                        ? Icon(Icons.favorite)
                                        : Icon(Icons.favorite_border),
                                    onPressed: () {
                                      like(item['pk'].toString());
                                    }),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  likeCount[item['pk'].toString()].toString(),
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ))
            .toList());
  }

  @override
  void initState() {
    _getClan();
    super.initState();
    _setcredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TubeCate'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                child: Image.asset('images/trisha.jpeg'),
                radius: 20.0,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('My Profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => Profile(pk)
                )
                 );
              },
            ),

            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text(' My Likes'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => LikeView(pk) 
                )
                 );
              },
            ),
             ListTile(
              leading: Icon(Icons.text_format),
              title: Text(' Search by Tag'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => TagSearch() 
                )
                 );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Logout"),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                _logout(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ClanCreate()));
        },
      ),
      body: isLoaded
          ? RefreshIndicator(
              onRefresh: refresh,
              child: Center(
                child: ListView.builder(
                  itemCount: clan.length,
                  itemBuilder: (BuildContext context, var i) {
                    return clanCard(clan[i], likeMap, likeCount,like);
                  },
                ),
              ))
          : ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 200.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
    );
  }
}
