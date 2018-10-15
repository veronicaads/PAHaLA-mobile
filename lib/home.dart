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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            WeatherCard(),
            NewsMenuCard(),
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
//                              return get('http://pahala.xyz:5000/helloworld');
                              return post('http://pahala.xyz:5000/hello', body: {'nama': 'SK'});
                            }
                            fetchPost().then(
                              (r) => Scaffold.of(context).showSnackBar(SnackBar(content: Text(r.body),))
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
      children: List<Row>.generate(5,
        (i) => Row(
          children: <Widget>[
//            AspectRatio()
            Container(
              constraints: BoxConstraints.expand(width: 80.0, height: 80.0,),
              child: Image(image: AssetImage('assets/images/placeholder.png')),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Title', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                    Container(
                      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse in eros eget sapien aliquam mollis vitae sed nibh. Donec posuere quis felis in fringilla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec pulvinar sagittis erat, eget sollicitudin erat interdum at. Duis hendrerit, nisl a maximus porta, sem quam tincidunt neque, eu cursus ligula sapien non est. Praesent sed egestas justo. Sed blandit quam ipsum. Proin fringilla odio vitae mi rutrum, ut viverra est faucibus.', maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12.0),),
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