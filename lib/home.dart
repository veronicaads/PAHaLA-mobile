import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart';
import 'asset.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NewsMenu> _newsData = List<NewsMenu>();
  List<NewsMenu> _menuData = List<NewsMenu>();
  @override
  Widget build(BuildContext context) {
//    return NestedScrollView(
//      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) { return <Widget>[]; },
//      body: new Column(
//        children: <Widget>[
//          new FlutterLogo(size: 100.0, colors: Colors.purple),
//          new Container(
//            height: 300.0,
//            child: new ListView.builder(
//              itemCount: 60,
//              itemBuilder: (BuildContext context, int index) {
//                return new Text('Item $index');
//              },
//            ),
//          ),
//          new FlutterLogo(size: 100.0, colors: Colors.orange),
//        ],
//      ),
//    );
    return ListView(
      children: <Widget>[
        WeatherCard(),
        Container(
          constraints: BoxConstraints.expand(height: 180.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: NodeControlCard(),
              ),
              Expanded(
                child: SleepCard(alarmTime: "7:00 AM",),
              ),
            ],
          ),
        ),
        NewsMenuCard(menu: List<NewsMenu>(), news: _newsData,),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ButtonTheme.bar( // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('From Server'),
                      onPressed: () {
                        Future<Response> fetchPost() {
//                          return get('http://pahala.xyz:5000/helloworld');
                          return post('http://pahala.xyz:5000/hello', body: {'nama': 'SK'});
                        }
                        fetchPost().then(
                          (r) => Scaffold.of(context).showSnackBar(SnackBar(content: Text(r.body),))
                        );
                      },
                    ),
                    FlatButton(
                      child: Text('News'),
                      onPressed: () {
                        Future<Response> fetchNews() {
                          return get('http://pahala.xyz:5000/news');
                        }
                        fetchNews().then(
                          (r) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text(r.body),));
                            setState(() {
                              _newsData = NewsMenu.newsFromResponse(r.body);
                            });
                            debugPrint("NEWS DATA LENGTH: " + _newsData.length.toString());
                          }
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 400.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: const Icon(Icons.album),
                title: const Text('The Enchanted Nightingale'),
                subtitle: const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
              ButtonTheme.bar( // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('BUY TICKETS'),
                      onPressed: () { /* ... */ },
                    ),
                    FlatButton(
                      child: const Text('LISTEN'),
                      onPressed: () { /* ... */ },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(SkyAssets.brightSky[0]),
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
                title: Text('Partly Cloudy (34 °C)'),
                subtitle: Text('Periods of clouds and sunshine, a thunderstorm in spots this afternoon'),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Table(
                  defaultColumnWidth: FlexColumnWidth(),
                  columnWidths: {0: FractionColumnWidth(0.4), 1: FractionColumnWidth(0.2), 2: FractionColumnWidth(0.4)},
                  children: [
                    TableRow(
                        children: <Widget>[
                          WeatherDetail(tooltip: 'Wind Speed', icon: FontAwesomeIcons.wind, val: '18 km/h', glyph: FontAwesomeIcons.locationArrow, glyphTransform: Matrix4.rotationZ(.75 * pi + .25 * pi),),
                          WeatherDetail(tooltip: 'Humidity', icon: FontAwesomeIcons.tint, val: '45%',),
                          WeatherDetail(tooltip: 'Pressure', icon: FontAwesomeIcons.weightHanging, val: '1009.00 mb',),
                        ]
                    ),
                    TableRow(
                        children: [Padding(padding: EdgeInsets.only(top: 10.0),),Padding(padding: EdgeInsets.only(top: 10.0),),Padding(padding: EdgeInsets.only(top: 10.0),)]
                    ),
                    TableRow(
                        children: <Widget>[
                          WeatherDetail(tooltip: 'UV Index', icon: FontAwesomeIcons.solidSun, val: '8',),
                          WeatherDetail(tooltip: 'Cloud Cover', icon: FontAwesomeIcons.cloud, val: '35%',),
                          WeatherDetail(tooltip: 'Visibility', icon: FontAwesomeIcons.eye, val: '8 km',),
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
                image: AssetImage(WeatherIconAssets.icons[2]),
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
        Tooltip(message: this.tooltip, child: Icon(this.icon, size: 18.0, color: Colors.grey),),
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

class NodeControlCard extends StatefulWidget {
  _NodeControlCardState createState() => _NodeControlCardState();
}

class _NodeControlCardState extends State<NodeControlCard> {
  int _value = 0;
  List<String> _lampName = ["Lamp 1", "Lamp 2"];
  List<bool> _isOn = [false, false];
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0, right: 7.5),
        child: Container(
          margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
          child: Column(
            children: <Widget>[
              DropdownButton(
                items: [
                  DropdownMenuItem(child: Text(_lampName[0]), value: 0,),
                  DropdownMenuItem(child: Text(_lampName[1]), value: 1,),
                ],
                onChanged: (v) { setState(() { _value = v; }); },
                value: _value,
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.lightbulb, color: _isOn[_value] ? BaseColorAssets.accent60 : Colors.grey,),
                onPressed: () { setState(() { _isOn[_value] = !_isOn[_value]; }); },
                iconSize: 50.0,
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: Text("Turned " + (_isOn[_value] ? "on" : "off"), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
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
            title: Text("Feels sleepy?", textAlign: TextAlign.center,),
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.bed, color: BaseColorAssets.secondary100,),
            onPressed: () {  },
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
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: AspectRatio(
        aspectRatio: 1.5,
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
            size: 15.0
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
      children: List<Row>.generate(data.length,
        (i) => Row(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(width: 80.0, height: 60.0),
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: AspectRatio(
                aspectRatio: 1.5,
//                child: Image.asset('assets/images/placeholder.png'),
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
        )
      ),
    );
  }
}