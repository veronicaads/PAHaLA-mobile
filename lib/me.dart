import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          constraints: BoxConstraints.expand(height: 175.0,),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/me_bg.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5.0)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Settings'),));
                },
                color: Colors.white70,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 100.0,),
          child: Column(
            children: <Widget>[
              Center(
                child: Text('<NAME>',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints.expand(width: 100.0, height: 100.0,),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/empty_avatar.png'),
                  ),
                  border: Border.all(color: Colors.white70, width: 5.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}