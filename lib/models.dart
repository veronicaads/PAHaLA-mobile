import 'dart:convert';
import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:html_unescape/html_unescape.dart';

class Authorization {
  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }
  static Future<bool> handleSignIn() async {
    googleAccount = await googleSignIn.signIn();
    if(googleAccount != null){
      googleAuth = await googleAccount.authentication;
      // print("TOKEN: "  + googleAuth.accessToken + ", googleAccount + googleAuth.idToken);
      firebaseUser = await firebaseAuth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // print("UID: " + firebaseUser.uid);
      if(firebaseUser != null) return true;
      else return false;
    } else return false;
  }
  static Future<void> handleSignOut() async {
    await firebaseAuth.signOut();
    firebaseUser = null;
    await googleSignIn.signOut();
    googleAuth = null;
    googleAccount = null;
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
    var v = jsonDecode(json);
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
    var decoded = jsonDecode(json);
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
  factory NewsMenu.newsFromJson(Map<String, dynamic> v){
    return NewsMenu(
      title: v['title'],
      desc: v['desc'],
      picture: v['urlToImage'],
      url: v['url'],
    );
  }
  static List<NewsMenu> newsFromResponse(String json){
    var result = List<NewsMenu>();
    var decoded = jsonDecode(json)['articles'];
    for(var article in decoded){
      result.add(NewsMenu(
        title: article['title'],
        desc: article['description'],
        picture: article['urlToImage'],
        url: article['url'],
      ));
    }
    return result;
  }
  factory NewsMenu.menuFormJson(Map<String, dynamic> v){
    return NewsMenu(
      title: v['title'],
      desc: v['ingredients'],
      picture: v['thumbnail'],
      url: v['href'],
    );
  }
  static List<NewsMenu> menuFromResponse(String json){
    var result = List<NewsMenu>();
    var decoded = jsonDecode(json);
    for(var menu in decoded){
      result.add(NewsMenu(
        title: menu['title'],
        desc: menu['ingredients'],
        picture: menu['thumbnail'],
        url: menu['href'],
      ));
    }
    return result;
  }
}
