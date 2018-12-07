import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:material_switch/material_switch.dart';
import 'package:http/http.dart';
import 'globals.dart';
import 'asset.dart';

class SchedulePage extends StatefulWidget{
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>{
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
                          'uuid': firebaseUser.uid,
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