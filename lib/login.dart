import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';
import 'asset.dart';
import 'globals.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Authorization.getCurrentUser().then(
      (u) {
        setState(() {
          firebaseUser = u;
        });
        if(firebaseUser != null){
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: BaseColorAssets.tertiary20),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0, top: 150.0),
            child: Image(
              image: AssetImage(BrandImageAssets.logo),
            ),
          ),
          Container(
            constraints: BoxConstraints.tightFor(width: 110.0),
            child: RotateAnimatedTextKit(
              onTap: () {},
              text: [" Simple", "Healthy", " Stylish"],
              textStyle: TextStyle(
                fontSize: 32.0,
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.normal,
                color: BaseColorAssets.secondary40,
                decoration: TextDecoration.combine([]),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: BaseColorAssets.light40, width: 1.0),
              color: Colors.white,
            ),
            child: FlatButton.icon(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.5),
              icon: Image.asset(VendorAsset.googleFav, height: 24.0, width: 24.0,),
              onPressed: () {
                Authorization.handleSignIn().then((v) {
                  if(v) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                });
              },
              label: Text("Sign in with Google", style: TextStyle(color: BaseColorAssets.gray100, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}