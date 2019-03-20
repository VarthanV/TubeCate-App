import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'clan_create.dart';
import 'homepage.dart';
import 'linkcreate.dart';

var host = '10.0.2.2'; //127.0.0.1 == 10.0.2.2
var port = 8000;
var registerPath = 'api/register/';
var loginPath = 'api/login/';
var clan_create_path = 'api/create/';
var home = 'api/home/';
var link_create_path='api/link/';
var like_path ='api/clan/like/';
var member_path='api/join/';
var profile_path='api/profile/';
var tag_path='api/clan/tag/';


main(List<String> args) {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    
    routes: <String, WidgetBuilder>{
    "login/": (BuildContext context) => new LoginPage(),
    "register/": (BuildContext context) => new RegisterPage(),
    "create/": (BuildContext context) => new ClanCreate(),
    "home/": (BuildContext context) => new HomePage(),
    
  }, debugShowCheckedModeBanner: false, home: LoginPage()
  
  )
  
  );
}
