import 'package:flutter/material.dart';
import 'globals.dart';
import 'asset.dart';
import 'login.dart';
import 'signup.dart';
import 'me.dart';
import 'home.dart';
import 'track.dart';
import 'blue.dart';

void main() => runApp(PahalaApp());

class PahalaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'PAHaLA',
      theme: ThemeData(
        fontFamily: 'Proxima Nova',
        primarySwatch: BaseColorAssets.materialPrimary,
        primaryColor: BaseColorAssets.materialSecondary,
        accentColor: BaseColorAssets.materialTertiary,
        brightness: globalBrightness,
      ),
      home: SafeArea(child: Home()),
      routes: <String, WidgetBuilder>{
        '/login':    (BuildContext context) => WelcomePage(),
        '/signup':   (BuildContext context) => SignUpPage(),
        '/schedule': (BuildContext context) => UpdateSchedulePage(),
        '/height':   (BuildContext context) => UpdateHeightPage(),
        '/blue':     (BuildContext context) => FlutterBlueApp(),
      },
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
    if(firebaseUser == null){
      Future(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      firebaseUser.getIdToken(refresh: true).then(
        (r) { print("GET ID TOKEN: " + r); }
      );
    }
  }
  final List<Widget> _children = [
    MePage(),
    HomePage(),
    TrackPage(),
  ];
  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Me')   ),
    BottomNavigationBarItem(icon: Icon(Icons.home)          , title: Text('Home') ),
    BottomNavigationBarItem(icon: Icon(Icons.show_chart)    , title: Text('Track')),
  ];
  void onTabTapped(int newIndex) => setState(() {_currentIndex = newIndex;});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      primary: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: onTabTapped,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  PlaceholderWidget(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(color: color,);
  }
}
