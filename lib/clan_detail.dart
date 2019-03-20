import 'dart:convert';
import 'package:youtube_player/youtube_player.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'profile.dart';
import 'homepage.dart';

class ClanDetail extends StatefulWidget {
  final int pk;
  ClanDetail(this.pk);

  @override
  _ClanDetailState createState() => _ClanDetailState();
}

class _ClanDetailState extends State<ClanDetail> {
  Map clan = {};
  List link = [];
  List member = [];
  bool isMember = false;
  bool isLoaded = false;
  bool error = false;
  bool isLeader;
  List comments=[];
  _getDetailedClan() {
    SharedPreferences.getInstance().then((prefs) {
      http.get(
        'http://10.0.2.2:8000/api/clan/' + widget.pk.toString() + '/',
        headers: {'Authorization': 'Token ${prefs.getString('token')}'},
      ).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            clan = jsonDecode(response.body);
            link.add(clan['links']);
            member.add(clan['members']);
            comments.add(clan['comments']);
            isLeader=clan['is_leader'];
            isLoaded = true;
          });
        }
      });
    });
  }
  join(String pk){
    
    SharedPreferences.getInstance().then((prefs){
      http.post('http://10.0.2.2:8000/api/join/'+widget.pk.toString()+'/', headers: {'Authorization': 'Token ${prefs.getString('token')}'},
      ).then((response){
        if(response.statusCode ==200){

          setState(() {
            isMember=jsonDecode(response.body)['member'];
            Refresh();
            error=false;
             //For sanity check
          });
        }
        else{
          setState(() {
            error=true;

          });
        }

      }); 

    });


  }

  @override
  void initState() {
    super.initState();
    _getDetailedClan();
  }

  Future<void> Refresh() {
    setState(() {
      _getDetailedClan();
    });
  }

  Widget video(clan) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        elevation: 20.0,
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: error ? Text("You are already a member,You are the leader",style: TextStyle(color: Colors.red),):Container(),
            ),


            Container(
              padding: EdgeInsets.only(top: 8.0),
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: YoutubePlayer(
                source: clan['url'],
                quality: YoutubeQuality.MEDIUM,
                aspectRatio: 16 / 9,
                showThumbnail: true,
              ),
            ),
            Divider(color: Colors.white70),
           Column(
              mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Container(
                padding: EdgeInsets.only(top: 8.0),
                alignment: Alignment.center,
                child: isLeader? Text('Members Count :   ' + clan['members_count'].toString(),style: TextStyle(color: Colors.teal,fontSize: 20.0),): RaisedButton(
                  child:  isMember ? Text("LEAVE") : Text('JOIN'),
                  color: isMember ? Colors.red : Colors.green,
                  onPressed: () {
                    join(widget.pk.toString());
                  },
                )),

                

             ],
           ),
            Divider(color: Colors.white70),
            Container(
              padding: EdgeInsets.only(top: 8.0),
              alignment: Alignment.center,
              child: Text(clan['description']),
            )
          ],
        ),
      ),
    );
  }

  Widget linkcard(List links) {
    return Column(
      children: links.map((link) {
        return Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0),
          margin: EdgeInsets.only(top: 8.0),
          child: Card(
            elevation: 40.0,
            child: InkWell(
              onTap: () => launch(link['link']),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      link['title'],
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Divider(color: Colors.white70),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                    child: Text(link['link'],
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontSize: 20.0,
                        )),
                  ),
                  Divider(
                    color: Colors.white70,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      link['description'],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: isLoaded ? Text(clan['name']) : Text("Loading"),
            centerTitle: true,
            backgroundColor: Colors.red,
          ),
          bottomNavigationBar: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.video_library),
                text: "Video",
              ),
              Tab(
                icon: Icon(Icons.insert_link),
                text: "Supporting Links",
              ),
              Tab(
                icon: Icon(Icons.people_outline),
                text: "Members",
              )
            ],
          ),
          body: isLoaded
              ? TabBarView(
                  children: <Widget>[
                    video(clan),
                    ListView.builder(
                      itemCount: link.length,
                      itemBuilder: (BuildContext context, i) {
                        return linkcard(link[i]);
                      },
                    ),


                    ListView.builder(
                      itemCount: link.length,
                      itemBuilder: (BuildContext context, i) {
                        return memberCard(member[i]);
                      },
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
