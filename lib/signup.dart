import 'package:flutter/material.dart';
import 'package:material_switch/material_switch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'asset.dart';
import 'globals.dart';

class SignUpPage extends StatefulWidget{
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  String _title = 'Mr';
  String _nickname = "";
  String _gender = "Male";
  double _height = 160.0;
  DateTime _dob = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(color: BaseColorAssets.tertiary20),
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Text("Complete you sign up process,",
                style: TextStyle(
                  fontSize: 20.0,
                  color: BaseColorAssets.secondary80,
                ),
                textAlign: TextAlign.center,
              ),
              Text(firebaseUser != null ? firebaseUser.displayName : "",
                style: TextStyle(
                  fontSize: 24.0,
                  color: BaseColorAssets.secondary100,
                ),
                textAlign: TextAlign.center,
              ),
              NameCard(
                title: _title,
                titleSelect: (v) { setState(() { _title = v; }); },
                nickname: _nickname,
                nicknameSelect: (v) { setState(() { _nickname = v; }); },
              ),
              DOBCard(
                dob: _dob,
                dobSelect: (v) { setState(() { _dob = v; }); },
              ),
              GenderCard(
                gender: _gender,
                genderSelect: (v) { setState(() { _gender = v; }); },
              ),
              HeightCard(
                height: _height,
                heightSelect: (v) { setState(() { _height = v; }); },
              ),
              FlatButton(
                child: const Text('SUBMIT'),
                onPressed: () {
                  Future( () { Navigator.pushReplacementNamed(context, '/'); } );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NameCard extends StatelessWidget{
  const NameCard({Key key, this.title, this.titleSelect, this.nickname, this.nicknameSelect}) : super(key: key);
  final String title;
  final Function titleSelect;
  final String nickname;
  final Function nicknameSelect;
  @override
  Widget build(BuildContext context) {
    final titles = ['Mr', 'Ms', 'Mrs'];
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Name", textAlign: TextAlign.center,),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    DropdownButton(
                      items: [
                        DropdownMenuItem(child: Text(titles[0]), value: titles[0],),
                        DropdownMenuItem(child: Text(titles[1]), value: titles[1],),
                        DropdownMenuItem(child: Text(titles[2]), value: titles[2],),
                      ],
                      onChanged: titleSelect,
                      value: title,
                    ),
                    Text(firebaseUser != null ? firebaseUser.displayName : ""),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Your nickname",
                    labelText: "What should we call you?",
                  ),
                  initialValue: nickname,
                  onSaved: nicknameSelect,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DOBCard extends StatelessWidget{
  const DOBCard({Key key, this.dob, this.dobSelect}) : super(key: key);
  final DateTime dob;
  final Function dobSelect;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Date of Birth", textAlign: TextAlign.center,),
            ),
            DateTimePickerFormField(
              dateOnly: true,
              editable: false,
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.center,
              format: DateFormat("EEEE, dd MMMM yyyy"),
              onChanged: dobSelect,
              initialDate: dob,
              resetIcon: FontAwesomeIcons.calendarTimes,
            ),
          ],
        ),
      ),
    );
  }
}

class GenderCard extends StatelessWidget{
  const GenderCard({Key key, this.gender, this.genderSelect}) : super(key: key);
  final String gender;
  final Function genderSelect;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Gender", textAlign: TextAlign.center,),
            ),
            MaterialSwitch(
              options: ["Male", "Female"],
              selectedOption: gender,
              onSelect: genderSelect,
              selectedBackgroundColor: gender == "Male" ? Colors.blue : Colors.pinkAccent,
              selectedTextColor: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
            ),
          ],
        ),
      ),
    );
  }
}

class HeightCard extends StatelessWidget{
  const HeightCard({Key key, this.height, this.heightSelect}) : super(key: key);
  final double height;
  final Function heightSelect;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Height", textAlign: TextAlign.center,),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: NumberPicker.decimal(
                    initialValue: height,
                    minValue: 0,
                    maxValue: 300,
                    onChanged: heightSelect,
                    decimalPlaces: 1,
                  ),
                ),
                Text("cm",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: BaseColorAssets.secondary80,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}