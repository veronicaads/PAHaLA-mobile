import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'globals.dart';
import 'asset.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather _weatherData;
  Quote _quote;
  List<NewsMenu> _newsData;
  List<NewsMenu> _menuData;
  List<LampNode> _lampData;
  TimeOfDay _nextDayAlarm;
  Function _timeFormatter = (TimeOfDay t) {
    return t.hourOfPeriod.toString().padLeft(2, '0') + ':' + t.minute.toString().padLeft(2, '0') + " " + (t.period == DayPeriod.am ? "AM" : "PM");
  };
  int _lampSelection = 0;
  @override
  void initState() {
    super.initState();
    Future(() async {
      await user.initDone;
      Future<Response> fetchWeather() async {
        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
        return post(APIEndpointAssets.weatherService, body: {'idToken': await user.user.getIdToken(), 'lon': position.longitude.toString(), 'lat': position.latitude.toString()});
      }
      fetchWeather().then( (r) { setState(() { _weatherData = Weather.weatherFromResponse(r.body); }); });
      Future<Response> fetchQuote() async {return post(APIEndpointAssets.quoteService, body: {'idToken': await user.user.getIdToken()}); }
      fetchQuote().then( (r) { setState(() { _quote = Quote.quoteFromResponse(r.body); }); });
      Future<Response> fetchNews() async { return post(APIEndpointAssets.newsService, body: {'idToken': await user.user.getIdToken()}); }
      fetchNews().then( (r) { setState(() { _newsData = NewsMenu.newsFromResponse(r.body); }); });
      Future<Response> fetchMenu() async { return post(APIEndpointAssets.menuService, body: {'idToken': await user.user.getIdToken()}); }
      fetchMenu().then( (r) { setState(() { _menuData = NewsMenu.menuFromResponse(r.body); }); });
      Future<Response> fetchLampStatus() async { return post(APIEndpointAssets.userLampService, body: {'idToken': await user.user.getIdToken()}); }
      fetchLampStatus().then((r) { setState(() { _lampData = LampNode.lampNodeFromResponse(r.body); }); });
      Future<Response> fetchNextDayAlarm() async { return post(APIEndpointAssets.userNextAlarmService, body: { 'idToken' : await user.user.getIdToken() }); }
      fetchNextDayAlarm().then((r) {
        var time = jsonDecode(r.body)['data']['alarm'].split(':');
        setState(() { _nextDayAlarm = TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1])); });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return (_weatherData != null && _quote != null && _newsData != null && _menuData != null && _lampData != null) ? ListView(
      children: <Widget>[
        WeatherCard(weather: _weatherData, quote: _quote,),
        Container(
          constraints: BoxConstraints.expand(height: 180.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded( child: NodeControlCard(
                lampNode: _lampData,
                lampSelection: _lampSelection,
                lampSelect: (v) { setState(() { _lampSelection = v; }); },
                lampPress: () {
                  setState(() { _lampData[_lampSelection].isLoading = true; });
                  Future<Response> turnLamp(v) async { return post(APIEndpointAssets.nodeLampService, body: {'idToken': await user.user.getIdToken(), 'flag': v.toString()}); }
                  turnLamp(!_lampData[_lampSelection].isOn).then(
                    (r) {
                    print("RESPONSE SERVER LAMP: " + r.body);
                      setState(() { _lampData[_lampSelection].isOn = jsonDecode(r.body)['data']['status_lamp'] == "true"; _lampData[_lampSelection].isLoading = false; });
                    }
                  );
                },
              ), ),
              Expanded( child: SleepCard(alarmTime: _timeFormatter(_nextDayAlarm),), ),
            ],
          ),
        ),
        NewsMenuCard(menu: _menuData, news: _newsData,),
      ],
    ) : SpinKitDoubleBounce(color: BaseColorAssets.primary60, size: 200.0,);
  }
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key key, this.weather, this.quote}) : super(key: key);
  final Weather weather;
  final Quote quote;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(weather.timeOfDay == 'd' ? SkyAssets.daySky[0] : SkyAssets.nightSky[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Theme.of(context).canvasColor,
                ],
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 100.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(left: 125.0),
                title: Text(weather != null ? weather.title : "", style: TextStyle(fontSize: 18.0),),
                subtitle: Text(weather != null ? weather.desc : ""),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 20.0),
                child: Table(
                  defaultColumnWidth: FlexColumnWidth(),
                  columnWidths: {0: FractionColumnWidth(0.4), 1: FractionColumnWidth(0.2), 2: FractionColumnWidth(0.4)},
                  children: [
                    TableRow(
                        children: <Widget>[
                          WeatherDetail(tooltip: 'Wind Speed', icon: FontAwesomeIcons.wind, val: (weather != null ? weather.windSpeed.toString() : '?') + ' km/h', glyph: FontAwesomeIcons.locationArrow, glyphTransform: Matrix4.rotationZ((weather != null ? weather.windDeg / (2 * pi) : 0) + .25 * pi),),
                          WeatherDetail(tooltip: 'Humidity', icon: FontAwesomeIcons.tint, val: (weather != null ? weather.humidity.toString() : '?') + '%',),
                          WeatherDetail(tooltip: 'Pressure', icon: FontAwesomeIcons.weightHanging, val: (weather != null ? weather.pressure.toString() : '?') + ' hPa',),
                        ]
                    ),
                    TableRow(
                        children: [Padding(padding: EdgeInsets.only(top: 10.0),),Padding(padding: EdgeInsets.only(top: 10.0),),Padding(padding: EdgeInsets.only(top: 10.0),)]
                    ),
                    TableRow(
                        children: <Widget>[
                          WeatherDetail(tooltip: 'Temperature', icon: FontAwesomeIcons.thermometerHalf, val: (weather != null ? weather.temp.toString() : '?') + '°C',),
                          WeatherDetail(tooltip: 'Cloud Cover', icon: FontAwesomeIcons.cloud, val: (weather != null ? weather.cloud.toString() : '?') + '%',),
                          WeatherDetail(tooltip: 'Visibility', icon: FontAwesomeIcons.eye, val: (weather != null ? (weather.visibility / 1000).toString() : '?') + ' km',),
                        ]
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 35.0),
          constraints: BoxConstraints.tightFor(width: 125.0, height: 125.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(WeatherAssets.image[weather != null ? weather.code.toString() + weather.timeOfDay : '800d']),
                fit: BoxFit.cover,
              )
          ),
        ),
      ],
    );
  }
}

class WeatherDetail extends StatelessWidget {
  const WeatherDetail({Key key, this.icon, this.tooltip, this.val, this.glyph, this.glyphTransform}) : super(key: key);
  final IconData icon;
  final String tooltip;
  final String val;
  final IconData glyph;
  final Matrix4 glyphTransform;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: Tooltip(message: this.tooltip, child: Icon(this.icon, size: 20.0, color: Colors.grey),),
        ),
        glyph == null ? Text(this.val, style: TextStyle(color: Colors.grey)) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(this.val + ' (', style: TextStyle(color: Colors.grey),),
            Transform(
              child: Icon(this.glyph, size: 12.0, color: Colors.grey,),
              transform: this.glyphTransform,
              alignment: FractionalOffset.center,
            ),
            Text(')', style: TextStyle(color: Colors.grey))
          ],
        ),
      ],
    );
  }
}

class NodeControlCard extends StatelessWidget {
  NodeControlCard({Key key, this.lampNode, this.lampSelection, this.lampSelect, this.lampPress}) : super(key: key);
  final List<LampNode> lampNode;
  final int lampSelection;
  final Function lampSelect;
  final Function lampPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0, right: 7.5),
      child: Container(
        margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        child: Column(
          children: <Widget>[
            DropdownButton(
              items: lampNode.asMap().entries.map((v) => DropdownMenuItem(child: Text(v.value.name), value: v.key,)).toList(),
              value: lampSelection,
              onChanged: lampSelect,
            ),
            lampNode[lampSelection].isLoading == false ? IconButton(
              icon: Icon(FontAwesomeIcons.lightbulb, color: lampNode[lampSelection].isOn ? BaseColorAssets.accent60 : Colors.grey,),
              onPressed: lampPress,
              iconSize: 50.0,
            ) : SpinKitRipple(
              size: 66.0,
              color: BaseColorAssets.primary60,
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: Text((lampNode[lampSelection].isLoading ? "Turning " : "Turned ") + (lampNode[lampSelection].isOn ^ lampNode[lampSelection].isLoading ? "on" : "off"),
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class SleepCard extends StatelessWidget {
  const SleepCard({Key key, this.alarmTime}) : super(key: key);
  final String alarmTime;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 7.5, top: 5.0, bottom: 5.0, right: 15.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Feel sleepy?", textAlign: TextAlign.center,),
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.bed, color: BaseColorAssets.secondary100,),
            onPressed: () {
              Future<Response> goToSleep() async {
                return post(APIEndpointAssets.nodeSleepService, body: {'idToken': await user.user.getIdToken(), 'flag': false.toString(),});
              }
              goToSleep().then((r) { Scaffold.of(context).showSnackBar(SnackBar(content: Text('Zzz...'),)); });
            },
            iconSize: 50.0,
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text("Alarm: " + alarmTime, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
          ),
        ],
      ),
    );
  }
}

class NewsMenuCard extends StatelessWidget {
  const NewsMenuCard({Key key, this.news, this.menu}) : super(key: key);
  final List<NewsMenu> news;
  final List<NewsMenu> menu;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 20.0),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            var scenes = <Widget>[
              NewsMenuScene(data: news,),
              NewsMenuScene(data: menu,),
            ];
            return scenes[index];
          },
          itemCount: 2,
          viewportFraction: 0.85,
          scale: 0.85,
//          pagination: SwiperPagination(
//            margin: EdgeInsets.all(0.0),
//          ),
          control: SwiperControl(
            size: 15.0,
            color: BaseColorAssets.primary100,
          ),
          loop: false,
        ),
      )
    );
  }
}

class NewsMenuScene extends StatelessWidget {
  const NewsMenuScene({Key key, this.data}) : super(key: key);
  final List<NewsMenu> data;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List<GestureDetector>.generate(data.length,
        (i) => GestureDetector(
          onTap: () {
            _launchURL(url) async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
            _launchURL(data[i].url);
          },
          child: Row(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(width: 80.0, height: 60.0),
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: data[i].picture != null ? Image.network(data[i].picture) : Image.asset('assets/images/placeholder.png'),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(data[i].title != null ? data[i].title : '', maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                      Container(
                        child: Text(data[i].desc != null ? data[i].desc : '', maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12.0),),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}