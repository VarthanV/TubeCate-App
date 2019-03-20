import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'clan_detail.dart';
import 'dart:convert';
import 'dart:async';
class LikeView extends StatefulWidget {
  final int pk;
  LikeView(this.pk);
  @override
  _LikeViewState createState() => _LikeViewState();
}

class _LikeViewState extends State<LikeView> {
List clans=[];
 _getProfile() {
    SharedPreferences.getInstance().then((prefs) {
      http.get('http://10.0.2.2:8000/api/profile/' + widget.pk.toString() + '/',
          headers: {
            'Authorization': 'Token ${prefs.getString('token')}'
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            
            clans.add(jsonDecode(response.body)['likes']);
            print(clans);
            
          });
        }
      });
    });
  }
  @override
   void initState(){
     super.initState();
     _getProfile();
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
                          ClanDetail(item['pk']))),
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
    return Scaffold(
      appBar: AppBar(title: Text("Liked Clans"),
      centerTitle: true,
      backgroundColor: Colors.red,
      ),
      body:Center(
        child: ListView.builder(
        itemCount: clans.length,
        itemBuilder: (BuildContext context,int i){
          return clanCard(clans[i]);
        },
      ),
      ),
    );
  }
}