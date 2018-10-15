import 'dart:math';
import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart';
import 'package:fcharts/fcharts.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'models.dart';

class TrackPage extends StatefulWidget {
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  DateTime _selectedMonth = DateTime.now();
  List<UserStats> _data;
  List<UserStats> generatePlaceholderData() {
    var r = Random();
    List<UserStats> data = [];
    var y = _selectedMonth.year, m = _selectedMonth.month;
    for(var d = 1; d < DateTime(y, m+1, 0).day; d++) {
      var sleepTime = DateTime(y, m, d, 19 + r.nextInt(4), r.nextInt(59), r.nextInt(59));
      sleepTime = sleepTime.subtract(Duration(days: 1));
      data.add(UserStats(
        sleepTime,
        sleepTime.add(Duration(hours: 5 + r.nextInt(4), minutes: r.nextInt(59), seconds: r.nextInt(59))),
        75 + r.nextDouble() * 5,
        1.65
      ));
    }
    return data;
  }
  @override
  Widget build(BuildContext context) {
    _data = generatePlaceholderData();
    return Column(
      children: <Widget>[
        MonthStrip(
          format: 'MMM yyyy',
          from: DateTime(2000),
          to: DateTime.now(),
          initialMonth: _selectedMonth,
          onMonthChanged: (v) {
            _selectedMonth = v;
            setState(() {
              _data = generatePlaceholderData();
            });
            print(_data);
          },
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        Expanded(
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              var scenes = <Widget>[
                SleepScene(data: _data,),
                WeightScene(data: _data,),
              ];
              return scenes[index];
            },
            itemCount: 2,
            viewportFraction: 0.95,
            scale: 0.9,
          ),
        ),
      ]
    );
  }
}

class SleepScene extends StatelessWidget {
  const SleepScene({Key key, this.data}) : super(key: key);
  final List<UserStats> data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2.0,
          child: BarChart(
            data: data,
            xAxis: ChartAxis<String>(
              span: ListSpan(data.map((us) => us.wakeUpTs.toString()).toList()),
            ),
            yAxis: ChartAxis<int>(
              span: IntSpan(0, 600),
              tickGenerator: IntervalTickGenerator.byN(60),
              tickLabelFn: (us) => "Ha",
            ),
            bars: [
              new Bar<UserStats, String, int>(
                xFn: (us) => us.wakeUpTs.toString(),
                valueFn: (us) => us.sleepDuration(),
                fill: new PaintOptions.fill(color: Colors.teal),
                stack: new BarStack(),
              )
            ],
          ),
        ),
        Text("TEST"),
      ],
    );
  }
}

class WeightScene extends StatelessWidget {
  const WeightScene({Key key, this.data}) : super(key: key);
  final List<UserStats> data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2.0,
          child: LineChart(
            lines: [
              new Line(
                data: data,
                xFn: (it) => it.wakeUpTs.day,
                yFn: (it) => it.bmi(),
                xAxis: ChartAxis<int>(
                  span: IntSpan(1, data.length + 1),
                  tickGenerator: IntervalTickGenerator.byN(3),
                  paint: PaintOptions.stroke(color: Colors.teal),
                ),
                yAxis: ChartAxis<double>(
                  span: DoubleSpan(data.map((val) => val.bmi()).reduce(min).floor().toDouble(), data.map((val) => val.bmi()).reduce(max).ceil().toDouble()),
                  tickGenerator: IntervalTickGenerator.byN(1.0),
                  tickLabelFn: (val) => val.toStringAsFixed(0),
                  paint: PaintOptions.stroke(color: Colors.teal),
                ),
                stroke: PaintOptions.stroke(color: Colors.teal),
                marker: MarkerOptions(
                  paint: PaintOptions.fill(color: Colors.teal),
                  size: 2.0,
                ),
              )
            ],
            chartPadding: EdgeInsets.only(left: 30.0, bottom: 25.0, top: 10.0, right: 10.0),
          ),
        ),
      ],
    );
  }
}
