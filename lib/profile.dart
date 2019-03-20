import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'homepage.dart';
import 'clan_detail.dart';


class Profile extends StatefulWidget {
  final int pk;
  Profile(this.pk);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List followers = [];
  var clans = [];
  List following = [];
  String name = '';
  String email = '';
  var clanCount = '';
  bool isFollowing = false;
  bool error = false;
  bool isSame = false;

  _getProfile() {
    SharedPreferences.getInstance().then((prefs) {
      http.get('http://10.0.2.2:8000/api/profile/' + widget.pk.toString() + '/',
          headers: {
            'Authorization': 'Token ${prefs.getString('token')}'
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            print(jsonDecode(response.body));
            followers.add(jsonDecode(response.body)['followers']);
            following.add(jsonDecode(response.body)['following']);
            clans.add(jsonDecode(response.body)['clans']);
            name = jsonDecode(response.body)['name'];
            email = jsonDecode(response.body)['email'];
            clanCount = jsonDecode(response.body)['clan_count'].toString();
            isSame = jsonDecode(response.body)['is_same'];
            print(followers);
          });
        }
      });
    });
  }

  _follow() {
    SharedPreferences.getInstance().then((prefs) {
      http.post('http://10.0.2.2:8000/api/follow/' + widget.pk.toString() + '/',
          headers: {
            'Authorization': 'Token ${prefs.getString('token')}'
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            isFollowing = jsonDecode(response.body)['followed'];
            refresh();
          });
        } else {
          setState(() {
            error = true;
          });
        }
      });
    });
  }
   refresh(){
     _getProfile();

  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }
  Widget memberCard(List member){


  return Column(
    children:member.map((item){
      return ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage('images/trisha.jpeg'),radius: 30.0,),
        title: Text(item['name'],style: TextStyle(color: Colors.teal),),
        onTap: (){
          Navigator.push(context, 
          
          new MaterialPageRoute(
            builder: (BuildContext context) => Profile(item['pk'])
          )
          );

        },
      );


    }).toList()

  );




}
 Widget membersCard(List member){


  return Column(
    children:member.map((item){
      return ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage('images/trisha.jpeg'),radius: 30.0,),
        title: Text(item['name'],style: TextStyle(color: Colors.teal),),
        onTap: (){
          Navigator.push(context, 
          
          new MaterialPageRoute(
            builder: (BuildContext context) => Profile(item['pk'])
          )
          );

        },
      );


    }).toList()

  );



}
  Widget clanCard(List clans) {
    return  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: clans.map((item) {
        return Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          margin: EdgeInsets.only(top: 3.0),
          child: Card(
            elevation: 40.0,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ClanDetail(item['clan_pk']))),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 8.0),
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Text("Clan Name :"),
                        Text(
                          item['name'],
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 15.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  Container(
                    padding: EdgeInsets.only(top: 8.0),
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text("Leader :" + item['leader'] ,style: TextStyle(color: Colors.teal),),
                        ),
                        
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0),
                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Text(item['description']),

                  ),

                  Divider(
                    color: Colors.white70,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top: 8.0),
                    child: RaisedButton(
                      
                      child: Text("Members " + item['member_count'].toString()),
                      
                      onPressed: (){},)
                  ),
                   Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top: 8.0),
                    child: RaisedButton(
                      
                      child: Text( item['tag'].toString()),
                      color: Colors.green,
                      
                      onPressed: (){},)
                  ),

                ],
              ),
            ),
          ),
        );
      }).toList());
    
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.video_library),
              text: 'Clans',
            ),
            Tab(
              icon: Icon(Icons.people),
              text: 'Followers',
            ),
            Tab(
              icon: Icon(Icons.people_outline),
              text: 'Following',
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[

            Column(
              children: <Widget>[
                Card(
                  elevation: 30.0,
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        margin:EdgeInsets.only(left: 10.0,right: 10.0),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.teal,
                          backgroundImage: AssetImage('images/trisha.jpeg'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        margin: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Text(name,style:TextStyle(fontSize:20.0)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        margin: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Text(email,style:TextStyle(fontSize:20.0,color: Colors.red)),
                      ),
                       Container(
                        padding: EdgeInsets.only(top: 8.0),
                        margin: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Text( 'Total Clans Created: '+clanCount.toString(),style:TextStyle(fontSize:20.0,color: Colors.teal)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        margin: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: isSame ? Container():RaisedButton(
                          child: isFollowing ? Text("UNFOLLOW") :Text("FOLLOW") ,
                          color: isFollowing  ? Colors.red :Colors.green,
                          onPressed:()=>_follow(),
                        ),
                      ),
                  
                      Divider(
                        color: Colors.white70,
                      ),
                      
                      
                    ],
                  ),
                ),
                Expanded(
                        child:ListView.builder(
                        itemCount: clans.length,
                        itemBuilder: (BuildContext context,int i){
                          return clanCard(clans[i]);
                        },
                      )
                      )


              ],
            ),
           
           followers.length ==0 ? Center(child: Text(name+ 'Has no Followers'),): ListView.builder(
              itemCount: followers.length,
              itemBuilder: (BuildContext context,int i){
                return memberCard(followers[i]);
              },
            ),
             following.length ==0 ? Center(child: Text(name+ 'has no Followers'),): ListView.builder(
              itemCount: followers.length,
              itemBuilder: (BuildContext context,int i){
                return memberCard(following[i]);
              },
            )
              
                
                ],
              ),
            ),
            );

           
          
  }
}
