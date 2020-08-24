import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg/log_level.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';

import 'flutter_ffmpeg_api_wrapper.dart';
import 'util.dart';
import 'video_util.dart';

CommandTab commandTab = new CommandTab();

class CommandTab {
  TextEditingController _commandController;
  String _commandOutput;

  void init(State state) {
    _commandController = TextEditingController();
    _commandOutput = "";

    getLastCommandOutput()
        .then((output) => ffprint("Last command output was: $output"));

    // COMMAND TAB IS SELECTED BY DEFAULT
    commandTab.setActive();
  }

  void setActive() {
    print("Command Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(statisticsCallback);
    showTooltip(COMMAND_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    if (log.level != LogLevel.AV_LOG_STDERR) {
      _commandOutput += log.message;
    }
  }

  void statisticsCallback(Statistics statistics) {
    _commandOutput += "Statistics: "
        "executionId: ${statistics.executionId}, "
        "time: ${statistics.time}, "
        "size: ${statistics.size}, "
        "bitrate: ${statistics.bitrate}, "
        "speed: ${statistics.speed}, "
        "videoFrameNumber: ${statistics.videoFrameNumber}, "
        "videoQuality: ${statistics.videoQuality}, "
        "videoFps: ${statistics.videoFps}";
  }

  void clearLog() {
    _commandOutput = "";
  }

  void runFFmpeg() {
    clearLog();

    getLogLevel()
        .then((logLevel) => ffprint("Current log level is $logLevel."));

    ffprint("Testing FFmpeg COMMAND synchronously.");

    // COMMENT OPTIONAL TESTS
    // VideoUtil.tempDirectory.then((tempDirectory) {
    //    Map<String, String> mapNameMap = new Map();
    //    mapNameMap["my_custom_font"] = "my custom font";
    //    setFontDirectory(tempDirectory.path, null);
    // });

    VideoUtil.tempDirectory.then((tempDirectory) {
      setFontconfigConfigurationPath(tempDirectory.path);
    });

    executeFFmpeg(_commandController.text)
        .then((rc) => ffprint("FFmpeg process exited with rc $rc"));
    // executeWithArguments(_commandController.text.split(" ")).then((rc) => ffprint("FFmpeg process exited with rc $rc"));
  }

  void runFFprobe() {
    clearLog();

    ffprint("Testing FFprobe COMMAND synchronously.");

    VideoUtil.tempDirectory.then((tempDirectory) {
      setFontconfigConfigurationPath(tempDirectory.path);
    });

    executeFFprobe(_commandController.text)
        .then((rc) => ffprint("FFprobe process exited with rc $rc"));
  }

  void dispose() {
    _commandController.dispose();
  }
}

var commandColumn = Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: TextField(
        controller: commandTab._commandController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3498DB)),
              borderRadius: const BorderRadius.all(
                const Radius.circular(5),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3498DB)),
              borderRadius: const BorderRadius.all(
                const Radius.circular(5),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3498DB)),
              borderRadius: const BorderRadius.all(
                const Radius.circular(5),
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(8, 12, 8, 12),
            hintStyle: new TextStyle(fontSize: 14, color: Colors.grey[400]),
            hintText: "Enter command"),
        style: new TextStyle(fontSize: 14, color: Colors.black),
      ),
    ),
    Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: new InkWell(
        onTap: () => commandTab.runFFmpeg(),
        child: new Container(
          width: 130,
          height: 38,
          decoration: new BoxDecoration(
            color: Color(0xFF2ECC71),
            borderRadius: new BorderRadius.circular(5),
          ),
          child: new Center(
            child: new Text(
              'RUN FFMPEG',
              style: new TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    ),
    Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: new InkWell(
        onTap: () => commandTab.runFFprobe(),
        child: new Container(
          width: 130,
          height: 38,
          decoration: new BoxDecoration(
            color: Color(0xFF2ECC71),
            borderRadius: new BorderRadius.circular(5),
          ),
          child: new Center(
            child: new Text(
              'RUN FFPROBE',
              style: new TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    ),
    Expanded(
      child: Container(
          alignment: Alignment(-1.0, -1.0),
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(4.0),
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(new Radius.circular(5)),
              color: Color(0xFFF1C40F)),
          child: SingleChildScrollView(
              reverse: true, child: Text(commandTab._commandOutput))),
    )
  ],
);
