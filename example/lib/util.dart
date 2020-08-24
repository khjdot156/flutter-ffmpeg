String today() {
  var now = new DateTime.now();
  return "${now.year}-${now.month}-${now.day}";
}

String now() {
  var now = new DateTime.now();
  return "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}.${now.millisecond}";
}

void ffprint(String text) {
  final pattern = new RegExp('.{1,900}');
  var nowString = now();
  pattern
      .allMatches(text)
      .forEach((match) => print("$nowString - " + match.group(0)));
}
