import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'globals.dart';
import 'asset.dart';

class MePage extends StatefulWidget {
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
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
              padding: EdgeInsets.only(top: 15.0,),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(width: 100.0, height: 100.0,),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: firebaseUser.photoUrl == null ? AssetImage('assets/images/empty_avatar.png') : NetworkImage(firebaseUser.photoUrl),
                        ),
                        border: Border.all(color: BaseColorAssets.accent40, width: 2.0),
                      ),
                    ),
                    Text(firebaseUser.displayName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white, ),
                    ),
                    Text(firebaseUser.email,
                      style: TextStyle(color: Colors.white, ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              FlatButton(
                child: Text('Change Schedule'),
                onPressed: () {
                  Future(() { Navigator.pushNamed(context, '/schedule'); });
                },
              ),
              FlatButton(
                child: Text('Complete Sign Up'),
                onPressed: () {
                  Future(() { Navigator.pushNamed(context, '/signup'); });
                },
              ),
              FlatButton(
                child: Text('Logout from this Account'),
                onPressed: () {
                  Future<Null> handleSignOut() async {
                    await firebaseAuth.signOut();
                    await googleSignIn.signOut();
                  }
                  handleSignOut().then(
                    (_) {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Logged out")));
                      Future(() { Navigator.pushReplacementNamed(context, '/login '); });
                    }
                  );
                },
              ),
              FlatButton(
                child: Text('!DEBUG! Bluetooth !DEBUG!', style: TextStyle(color: Colors.black12),),
                onPressed: () {
                  Future(() { Navigator.of(context).pushNamed('/blue'); });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}