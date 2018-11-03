import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'models.dart';
import 'asset.dart';

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
    for(var d = 1; d <= DateTime(y, m+1, 0).day; d++) {
      var sleepTime = DateTime(y, m, d + 1, 19 + r.nextInt(4), r.nextInt(59), r.nextInt(59));
      sleepTime = sleepTime.subtract(Duration(days: 1));
      data.add(UserStats(
        sleepTime,
        sleepTime.add(Duration(hours: 5 + r.nextInt(4), minutes: r.nextInt(59), seconds: r.nextInt(59))),
        67 + r.nextDouble() * 5,
        1.70
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
            color: BaseColorAssets.primary100,
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
        Text("Sleep Duration (in minutes)",
          style: TextStyle(
            color: BaseColorAssets.primary100,
            fontWeight: FontWeight.bold,
          ),
        ),
        AspectRatio(
          aspectRatio: 2.0,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: TimeSeriesChart([
              Series<UserStats, DateTime>(
                id: 'Sleep Time',
                colorFn: (_, __) => Color(
                  r: BaseColorAssets.secondary80.red,
                  g: BaseColorAssets.secondary80.green,
                  b: BaseColorAssets.secondary80.blue,
                ),
                domainFn: (UserStats stat, _) => stat.sleepTs,
                measureFn: (UserStats stat, _) => stat.sleepDuration(),
                data: data,
              )],
              animate: true,
              defaultRenderer: BarRendererConfig<DateTime>(),
              domainAxis: DateTimeAxisSpec(
                showAxisLine: false,
                usingBarRenderer: true,
              ),
              behaviors: [SelectNearest(), DomainHighlighter()],
            ),
          )
        ),
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
        Text("Body Mass Index",
          style: TextStyle(
            color: BaseColorAssets.primary100,
            fontWeight: FontWeight.bold,
          ),
        ),
        AspectRatio(
            aspectRatio: 2.0,
            child: Container(
              constraints: BoxConstraints.expand(),
              child: TimeSeriesChart([
                Series<UserStats, DateTime>(
                  id: 'Sleep Time',
                  colorFn: (_, __) => Color(
                    r: BaseColorAssets.secondary80.red,
                    g: BaseColorAssets.secondary80.green,
                    b: BaseColorAssets.secondary80.blue,
                  ),
                  domainFn: (UserStats stat, _) => stat.sleepTs,
                  measureFn: (UserStats stat, _) => stat.bmi(),
                  data: data,
                )],
                animate: true,
                domainAxis: DateTimeAxisSpec(
                  showAxisLine: false,
                ),
                primaryMeasureAxis: NumericAxisSpec(
                  tickProviderSpec: BasicNumericTickProviderSpec(
                    zeroBound: false,
                    desiredTickCount: 4,
                  ),
                ),
                behaviors: [SelectNearest(), DomainHighlighter(),
                  RangeAnnotation([
                    RangeAnnotationSegment(18, 24, RangeAnnotationAxisType.measure,
                      startLabel: 'Ideal',
                      labelAnchor: AnnotationLabelAnchor.start,
                      color: Color(
                        r: BaseColorAssets.primary40.red,
                        g: BaseColorAssets.primary40.green,
                        b: BaseColorAssets.primary40.blue,
                      ),
                      labelDirection: AnnotationLabelDirection.vertical,

                    )
                  ])
                ],
              ),
            )
        ),
      ],
    );
  }
}
