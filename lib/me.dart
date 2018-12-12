import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:material_switch/material_switch.dart';
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
                child: Text('Update Height'),
                onPressed: () {
                  Future(() { Navigator.pushNamed(context, '/height'); });
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

class UpdateSchedulePage extends StatefulWidget{
  _UpdateSchedulePageState createState() => _UpdateSchedulePageState();
}

class _UpdateSchedulePageState extends State<UpdateSchedulePage>{
  TimeOfDay _weekDayAlarm = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _weekEndAlarm = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _publicHolidayAlarm = TimeOfDay(hour: 7, minute: 0);
  String _advancedString = "Basic";
  bool _advanced = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Text("Set up your schedule",
              style: TextStyle(
                fontSize: 20.0,
                color: BaseColorAssets.secondary80,
              ),
              textAlign: TextAlign.center,
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    TimePickerFormField(
                      editable: false,
                      format: DateFormat('KK:mm a'),
                      initialValue: _weekDayAlarm,
                      onChanged: (v) {
                        _weekDayAlarm = v;
                        if(!_advanced){
                          _weekEndAlarm = _publicHolidayAlarm = _weekDayAlarm;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "When is your daily alarm?"
                      ),
                      resetIcon: null,
                    ),
                    MaterialSwitch(
                      options: ["Basic", "Advanced"],
                      selectedTextColor: Colors.white,
                      selectedOption: _advancedString,
                      selectedBackgroundColor: BaseColorAssets.secondary60,
                      onSelect: (v) {
                        setState(() {
                          _advancedString = v;
                          _advanced = _advancedString == "Advanced";
                        });
                      },
                      margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                    ),
                    _advanced ? TimePickerFormField(
                      editable: false,
                      format: DateFormat('KK:mm a'),
                      initialValue: _weekEndAlarm,
                      onChanged: (v) { _weekEndAlarm = v; },
                      decoration: InputDecoration(
                          labelText: "On weekend?"
                      ),
                      resetIcon: null,
                    ) : Container(),
                    _advanced ? TimePickerFormField(
                      editable: false,
                      format: DateFormat('KK:mm a'),
                      initialValue: _publicHolidayAlarm,
                      onChanged: (v) { _publicHolidayAlarm = v; },
                      decoration: InputDecoration(
                          labelText: "On public holidays?"
                      ),
                      resetIcon: null,
                    ) : Container(),
                    FlatButton(
                      child: Text('Submit',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: BaseColorAssets.secondary80,
                        ),
                      ),
                      onPressed: () {
                        String f(TimeOfDay t) {
                          return t.hour.toString().padLeft(2, '0') + ':' + t.minute.toString().padLeft(2, '0') + ":00";
                        }
                        Future<Response> setAlarm() async { return post(APIEndpointAssets.userAlarmService, body: {
                          'idToken': await firebaseUser.getIdToken(),
                          'wd': f(_weekDayAlarm),
                          'we': f(_weekEndAlarm),
                          'ph': f(_publicHolidayAlarm),
                        }); }
                        setAlarm().then( (r) { Future( () { Navigator.pushReplacementNamed(context, '/'); }); });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateHeightPage extends StatefulWidget{
  _UpdateHeightPageState createState() => _UpdateHeightPageState();
}

class _UpdateHeightPageState extends State<UpdateHeightPage>{
  double _height = 160.0;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Text("Update your height",
              style: TextStyle(
                fontSize: 20.0,
                color: BaseColorAssets.secondary80,
              ),
              textAlign: TextAlign.center,
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("How tall are you?",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF808080),
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: NumberPicker.decimal(
                                  initialValue: _height,
                                  minValue: 0,
                                  maxValue: 300,
                                  onChanged: (v) { setState(() { _height = v; }); },
                                  decimalPlaces: 1,
                                  itemExtent: 28.0,
                                ),
                              ),
                              Text("cm",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: BaseColorAssets.secondary80,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Text('Submit',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: BaseColorAssets.secondary80,
                        ),
                      ),
                      onPressed: () {
                        Future<Response> setAlarm() async { return post(APIEndpointAssets.userHeightService, body: {
                          'idToken': await firebaseUser.getIdToken(),
                          'height': _height.toString(),
                        }); }
                        setAlarm().then( (r) { Future( () { Navigator.pushReplacementNamed(context, '/'); }); });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
