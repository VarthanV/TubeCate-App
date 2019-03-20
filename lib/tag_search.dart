import 'package:flutter/material.dart';
import 'main.dart';
import 'clan_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TagSearch extends StatefulWidget {
  @override
  _TagSearchState createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> {
  final _tag = new TextEditingController();
  bool error = false;
  bool empty=false;
  bool isLoaded = false;
  List clan = [];
  Widget clanCard(List clans) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,

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
                child: Column(
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
                            child: Text(
                              "Leader :" + item['leader'],
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8.0),
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(item['description']),
                    ),
                    Divider(
                      color: Colors.white70,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 8.0),
                        child: RaisedButton(
                          child: Text(
                              "Members " + item['member_count'].toString()),
                          onPressed: () {},
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 8.0),
                        child: RaisedButton(
                          child: Text(item['tag'].toString()),
                          color: Colors.green,
                          onPressed: () {},
                        )),
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }

  _fetchClan(String tag) {
   SharedPreferences.getInstance().then((prefs){
     http.post(Uri(path: tag_path,host:host,port:port,scheme:'http'),
     headers: {
            'Authorization': 'Token ${prefs.getString('token')}'
          },
          body: {
            'tag':tag
            
          }
     

    
     ).then((response){
       if(response.statusCode ==200){
         setState(() {
           clan.add(jsonDecode(response.body));
           isLoaded=true;

         });
       }
      if(response.statusCode ==400){
        setState(() {
          empty=true;

        });
      }


     });

   });


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Search by Tag"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(  
            padding: EdgeInsets.only(top: 8.0),
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  controller: _tag,
                  decoration: InputDecoration(
                      labelText: "Enter the Tag  that you want to Search",
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  validator: (String value) {
                    if (value.isEmpty) {
                      setState(() {
                        error = true;
                      });
                    }
                  },
                ),
              ),
               Container(
                 padding: EdgeInsets.only(top: 10.0),
                 alignment: Alignment.center,
                 child:RaisedButton(
                child: Text("Search"),
                color: Colors.blue,
                onPressed: () => _fetchClan(_tag.text),
              )
               ),
            ],
          ),
          ),
            empty?  Center( child:Text("No clans Found",style:TextStyle(fontSize:30,))):
              Flexible(
                
                child: ListView.builder(
                  itemCount: clan.length,
                  itemBuilder: (BuildContext context, int i) {
                    return clanCard(clan[i]);
                  },
                ),
              )
            
        ],
      ),
    );
  }
}
