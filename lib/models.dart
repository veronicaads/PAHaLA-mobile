import 'dart:convert';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:html_unescape/html_unescape.dart';
import 'asset.dart';

class UserModel {
  UserModel({this.height, this.schedule});
  double height;
  Map<String, dynamic> schedule;
}

class SystemUser {
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount account;
  GoogleSignInAuthentication auth;
  FirebaseUser user;
  UserModel model;
  Future _done;
  SystemUser() {
    _done = _init();
  }
  Future _init() async {
    user = await FirebaseAuth.instance.currentUser();
    await handleSignIn();
    model = await fetchUserModel();
  }
  Future get initDone => _done;
  Future<UserModel> fetchUserModel() async {
    Response u = await post(APIEndpointAssets.userDataService, body: {'idToken': await user.getIdToken()});
    Map<String, dynamic> json = jsonDecode(u.body)['data'];
    return UserModel(height: json['height'], schedule: json['schedule']);
  }
  Future<bool> handleSignIn() async {
    account = await googleSignIn.signIn();
    if(account != null){
      auth = await account.authentication;
      // print("TOKEN: "  + googleAuth.accessToken + ", googleAccount + googleAuth.idToken);
      if(user != null) return true;
      user = await firebaseAuth.signInWithGoogle(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      // print("UID: " + firebaseUser.uid);
      if(user != null) return true;
      else return false;
    } else return false;
  }
  Future<void> handleSignOut() async {
    await firebaseAuth.signOut();
    user = null;
    await googleSignIn.signOut();
    auth = null;
    account = null;
  }
}

class UserStats {
  UserStats(this.sleepTs, this.wakeUpTs, this.weight, this.height);
  final DateTime sleepTs;
  final DateTime wakeUpTs;
  final double weight;
  final double height;
  int sleepDuration() => wakeUpTs.difference(sleepTs).inMinutes;
  double bmi() => weight / (height * height);
}

class Weather {
  Weather({this.lon, this.lat, this.code, this.title, this.desc, this.timeOfDay, this.temp, this.windSpeed, this.windDeg, this.humidity, this.pressure, this.cloud, this.visibility});
  final double lon;
  final double lat;
  final int code;
  final String title;
  final String desc;
  final String timeOfDay;
  final double temp;
  final double windSpeed;
  final int windDeg;
  final int humidity;
  final int pressure;
  final int cloud;
  final int visibility;
  factory Weather.weatherFromResponse(String json){
    var v = jsonDecode(json)['data'];
    return Weather(
      lon: v['coord']['lon'],
      lat: v['coord']['lat'],
      code: v['weather'][0]['id'],
      title: v['weather'][0]['main'],
      desc: v['weather'][0]['description'],
      timeOfDay: v['weather'][0]['icon'].toString().substring(v['weather'][0]['icon'].toString().length - 1),
      temp: double.parse(v['main']['temp'].toString()),
      windSpeed: v['wind']['speed'],
      windDeg: v['wind']['deg'] == null ? 0 : v['wind']['deg'],
      humidity: v['main']['humidity'],
      pressure: v['main']['pressure'],
      cloud: v['clouds']['all'],
      visibility: v['visibility']
    );
  }
}

class Quote {
  Quote({this.author, this.quote});
  final String author;
  final String quote;
  static Quote quoteFromResponse(String json){
    var decoded = jsonDecode(json)['data'];
    var unescape = new HtmlUnescape();
    return Quote(
      author: decoded['author'].join(", "),
      quote: unescape.convert(decoded['quote'])
    );
  }
}

class NewsMenu {
  NewsMenu({this.title, this.desc, this.picture, this.url});
  final String title;
  final String desc;
  final String picture;
  final String url;
  static List<NewsMenu> newsFromResponse(String json){
    var result = List<NewsMenu>();
    var decoded = jsonDecode(json)['data']['articles'];
    for(var item in decoded){
      result.add(NewsMenu(
        title: item['title'],
        desc: item['description'],
        picture: item['urlToImage'],
        url: item['url'],
      ));
    }
    return result;
  }
  static List<NewsMenu> menuFromResponse(String json){
    var result = List<NewsMenu>();
    var decoded = jsonDecode(json)['data'];
    for(var item in decoded){
      result.add(NewsMenu(
        title: item['title'],
        desc: item['ingredients'],
        picture: item['thumbnail'],
        url: item['href'],
      ));
    }
    return result;
  }
}
