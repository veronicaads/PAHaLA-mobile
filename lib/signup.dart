import 'package:flutter/material.dart';
import 'package:material_switch/material_switch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'asset.dart';
import 'globals.dart';

class SignUpPage extends StatefulWidget{
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  final _titles = {
    'M': ['Mr'],
    'F': ['Ms', 'Mrs']
  };
  String _title = 'Mr';
  String _nickname = "";
  String _genderString = "Male";
  String _gender = "M";
  double _height = 160.0;
  DateTime _dob = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Text("Complete you sign up process,",
              style: TextStyle(
                fontSize: 20.0,
                color: BaseColorAssets.secondary80,
              ),
              textAlign: TextAlign.center,
            ),
            Text(user.user != null ? user.user.displayName : "",
              style: TextStyle(
                fontSize: 24.0,
                color: BaseColorAssets.secondary100,
              ),
              textAlign: TextAlign.center,
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    MaterialSwitch(
                      options: ["Male", "Female"],
                      selectedOption: _genderString,
                      onSelect: (v) {
                        setState(() {
                          _gender = v == "Male" ? "M" : "F";
                          _title = _titles[_gender][0];
                        });
                      },
                      selectedBackgroundColor: _gender == "M" ? Colors.blue : Colors.pinkAccent,
                      selectedTextColor: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                    ),
                    Row(
                      children: <Widget>[
                        DropdownButton(
                          items: _titles[_gender].map((v) { return DropdownMenuItem(child: Text(v), value: v,); }).toList(),
                          onChanged: (v) { setState(() { _title = v; }); },
                          value: _title,
                        ),
                        Text(user.user != null ? user.user.displayName : "",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Your nickname",
                        labelText: "What should we call you?",
                      ),
                      initialValue: _nickname,
                      onSaved: (v) { setState(() { _nickname = v; }); },
                    ),
                    DateTimePickerFormField(
                      dateOnly: true,
                      editable: false,
                      keyboardType: TextInputType.datetime,
                      format: DateFormat("EEEE, dd MMMM yyyy"),
                      onChanged: (v) { setState(() { _dob = v; }); },
                      initialDate: _dob,
                      resetIcon: null,
                      lastDate: DateTime.now(),
                      decoration: InputDecoration(
                        labelText: "When were you born?"
                      ),
                    ),
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
                        Future( () { Navigator.pushReplacementNamed(context, '/'); } );
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
