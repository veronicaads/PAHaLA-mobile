import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:timeline/timeline.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'globals.dart';
import 'models.dart';
import 'asset.dart';

class TrackPage extends StatefulWidget {
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  DateTime _earliest, _latest;
  DateTime _selectedMonth = DateTime.now();
  List<UserStats> _data;
  List<TimelineModel> _timeline;
//  List<UserStats> generatePlaceholderData() {
//    var r = Random();
//    List<UserStats> data = [];
//    var y = _selectedMonth.year, m = _selectedMonth.month;
//    var h = DateTime.now().year == y && DateTime.now().month == m ? DateTime.now().day - 1 : DateTime(y, m+1, 0).day;
//    for(var d = 1; d <= h; d++) {
//      var sleepTime = DateTime(y, m, d, 19 + r.nextInt(4), r.nextInt(59), r.nextInt(59));
//      data.add(UserStats(
//        sleepTs: sleepTime,
//        wakeUpTs: sleepTime.add(Duration(hours: 5 + r.nextInt(4), minutes: r.nextInt(59), seconds: r.nextInt(59))),
//        weight: 67 + r.nextDouble() * 5,
//        height: 1.70,
//      ));
//    }
//    return data;
//  }
  Future<void> refreshData() async {
    setState(() { _data = _timeline = null; });
    Future<Response> fetchStatistics() async { return post(APIEndpointAssets.userStatisticsService, body: {'idToken': await user.user.getIdToken(), 'month': _selectedMonth.month.toString(), 'year': _selectedMonth.year.toString()}); }
    fetchStatistics().then((r) async {
      setState(() {
        _data = UserStats.userStatFromResponse(r.body);
        _timeline = generateTimeline(_data);
      });
    });
  }
  List<TimelineModel> generateTimeline(List<UserStats> data){
    return data.map((v) {
      return TimelineModel(
        id: v.sleepTs.toIso8601String(),
        title: formatDate(v.sleepTs, [MM, ', ', d, ' ', yyyy]),
        description: "Sleep Duration: " + v.sleepDuration().toString() + " mins (" + (v.sleepDuration() / 60).toStringAsPrecision(3) + " hours)\nBMI: " + v.bmi().toStringAsPrecision(5),
      );
    }).toList();
  }
  @override
  void initState() {
    super.initState();
    Future<Response> fetchAvailStats() async { return post(APIEndpointAssets.userAvailStatsService, body: {'idToken': await user.user.getIdToken()}); }
    fetchAvailStats().then((r) { setState(() {
      var statsAvail = jsonDecode(r.body)['data'];
      _earliest = DateTime(statsAvail['min_year'], statsAvail['min_month']);
      _latest   = DateTime(statsAvail['max_year'], statsAvail['max_month']);
    }); });
    Future(() async { await refreshData(); });
  }
  @override
  Widget build(BuildContext context) {
    return (_earliest != null && _latest != null) ? Column(
      children: <Widget>[
        MonthStrip(
          format: 'MMM yyyy',
          from: _earliest,
          to: _latest,
          initialMonth: _selectedMonth,
          onMonthChanged: (v) {
            _selectedMonth = v;
            Future(() async { await refreshData(); });
          },
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: BaseColorAssets.primary100,
          ),
        ),
        (_data != null) ? Expanded(
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(height: 200.0),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    var scenes = <Widget>[
                      SleepScene(data: _data,),
                      WeightScene(data: _data,),
                    ];
                    return scenes[index];
                  },
                  itemCount: 2,
                  viewportFraction: 0.85,
                  scale: 0.9,
                  control: SwiperControl(
                    size: 15.0,
                    color: BaseColorAssets.primary100,
                  ),
                ),
              ),
              Expanded(
                child: TimelineComponent(
                  timelineList: _timeline,
                  lineColor: BaseColorAssets.primary100,
                  headingColor: BaseColorAssets.secondary80,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ) : SpinKitRipple(color: BaseColorAssets.primary60, size: 100.0,),
      ]
    ) : SpinKitDoubleBounce(color: BaseColorAssets.primary60, size: 200.0,);
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
                tickProviderSpec: DayTickProviderSpec(increments: [3]),
              ),
              primaryMeasureAxis: NumericAxisSpec(
                tickProviderSpec: BasicNumericTickProviderSpec(
                  zeroBound: true,
                  desiredMinTickCount: 4,
                ),
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
                tickProviderSpec: DayTickProviderSpec(increments: [3]),
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
