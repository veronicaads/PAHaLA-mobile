import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'asset.dart';

class IntroPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [
        PageViewModel(
          title: Container(),
          body: Text("Welcome to PAHaLA,\nwe hope you enjoy it!", style: TextStyle(color: BaseColorAssets.secondary80),),
          mainImage: Container(
            margin: EdgeInsets.all(20.0),
            child: Image.asset(BrandImageAssets.logo),
          ),
          pageColor: BaseColorAssets.accent20,
        ),
        PageViewModel(
          title: Text("Always\nknow the weather", textAlign: TextAlign.center, style: TextStyle(fontSize: 40.0),),
          body: Text("Whether it's raining or sunny,\nyou'll know right away"),
          mainImage: Icon(FontAwesomeIcons.solidSun,
            color: BaseColorAssets.primary100,
            size: 150.0,
          ),
          pageColor: BaseColorAssets.primary60,
        ),
        PageViewModel(
          title: Text("Always\nup-to-date", textAlign: TextAlign.center, style: TextStyle(fontSize: 40.0),),
          body: Text("The most recent news are\nready at your fingertips"),
          mainImage: Icon(FontAwesomeIcons.newspaper,
            color: BaseColorAssets.secondary100,
            size: 150.0,
          ),
          pageColor: BaseColorAssets.secondary60,
        ),
        PageViewModel(
          title: Text("Always\nknow what to eat", textAlign: TextAlign.center, style: TextStyle(fontSize: 40.0),),
          body: Text("Fulfill your nutritions and\ndaily intakes to stay healthy"),
          mainImage: Icon(FontAwesomeIcons.utensils,
            color: BaseColorAssets.tertiary100,
            size: 150.0,
          ),
          pageColor: BaseColorAssets.tertiary60,
        ),
        PageViewModel(
          title: Text("Always\nwake up on time", textAlign: TextAlign.center, style: TextStyle(fontSize: 40.0),),
          body: Text("Start your activity early;\nnever to be late again"),
          mainImage: Icon(FontAwesomeIcons.clock,
            color: BaseColorAssets.quaternary100,
            size: 150.0,
          ),
          pageColor: BaseColorAssets.quaternary80,
        ),
        PageViewModel(
          title: Text("Always\nknow your body", textAlign: TextAlign.center, style: TextStyle(fontSize: 40.0),),
          body: Text("All records can be accessed instantly, are stored securely"),
          mainImage: Icon(FontAwesomeIcons.chartBar,
            color: BaseColorAssets.accent100,
            size: 150.0,
          ),
          pageColor: BaseColorAssets.accent80,
        ),
      ],
      doneText: Text("OK"),
      onTapDoneButton: () { Future(() { Navigator.pop(context); }); },
      columnMainAxisAlignment: MainAxisAlignment.start,
    );
  }
}