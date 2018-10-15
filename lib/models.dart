class UserStats {
  UserStats(this.sleepTs, this.wakeUpTs, this.weight, this.height);
  final DateTime sleepTs;
  final DateTime wakeUpTs;
  final double weight;
  final double height;
  int sleepDuration() => wakeUpTs.difference(sleepTs).inMinutes;
  double bmi() => weight / (height * height);
}

class NewsMenu {
  NewsMenu(this.title, this.desc, this.picture);
  final String title;
  final String desc;
  final String picture;
}