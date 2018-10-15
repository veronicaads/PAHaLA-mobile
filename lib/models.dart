import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class UserStats {
  UserStats(this.sleepTs, this.wakeUpTs, this.weight, this.height);
  final DateTime sleepTs;
  final DateTime wakeUpTs;
  final double weight;
  final double height;
  int sleepDuration() => wakeUpTs.difference(sleepTs).inMinutes;
  double bmi() => weight / (height * height);
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
  static List<NewsMenu> newsFromResponse(String json) {
//    var i=0;
//    var decoded = JSON.decode('["foo", { "bar": 499 }]');
//    JsonCodec().decode(source)
//    return jsonDecode(json, reviver: (k, v) {
//      i++;
//      debugPrint("iter" + i.toString() + ", " + k.toString() + ": " + v.toString());
//      return List<NewsMenu>();
//    });
    var result = List<NewsMenu>();
    var decoded = jsonDecode(json);
    var articles = decoded['articles'];
    for(var article in articles){
      result.add(NewsMenu(
        title: article['title'],
        desc: article['description'],
        picture: article['urlToImage'],
        url: article['url'],
      ));
    }
    return result;
  }
}

//class NewsSource{
//  NewsSource(this.id, this.name);
//  final int id;
//  final String name;
//}
//
//class News {
//  News(this.source, this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content);
//  final NewsSource source;
//  final String author;
//  final String title;
//  final String description;
//  final Uri url;
//  final Uri urlToImage;
//  final String publishedAt;
//  final String content;
//  factory News.fromJson(Map<String, dynamic> v){
//    return News
//  }
//}