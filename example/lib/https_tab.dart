import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg/log_level.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';

import 'flutter_ffmpeg_api_wrapper.dart';
import 'util.dart';
import 'video_util.dart';

HttpsTab httpsTab = new HttpsTab();

class HttpsTab {
  String _commandOutput;

  void init(State state) {
    _commandOutput = "";
  }

  void setActive() {
    print("Https Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(statisticsCallback);
    showTooltip(HTTPS_TEST_TOOLTIP_TEXT);
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

  void testGetMediaInformation(String mediaPath) {
    ffprint("Testing Get Media Information.");

    // ENABLE LOG CALLBACK ON EACH CALL
    // enableLogCallback(encodeOutputLogCallback);
    enableStatisticsCallback(null);

    // CLEAR OUTPUT ON EACH EXECUTION
    _commandOutput = "";

    VideoUtil.assetPath(mediaPath).then((image1Path) {
      getMediaInformation(image1Path).then((info) {
        ffprint('Media Information');

        var mediaProperties = info.getMediaProperties().entries;
        if (mediaProperties != null) {
          mediaProperties.forEach((element) {
            if (element.key == 'tags') {
              var tags = element.value as Map<dynamic, dynamic>;
              ffprint('Tag Count: ${tags.length}');
              tags.forEach((key, value) {
                ffprint('-> $key: $value');
              });
            } else {
              ffprint('${element.key}: ${element.value}');
            }
          });
        }

        var number = 0;
        var streams = info.getStreams();
        ffprint('Stream Count: ${streams.length}');
        streams.forEach((element) {
          ffprint('Stream Information ${number++}');
          element.getAllProperties().entries.forEach((element) {
            if (element.key == 'tags') {
              var tags = element.value as Map<dynamic, dynamic>;
              ffprint('Tag Count: ${tags.length}');
              tags.forEach((key, value) {
                ffprint('--> $key: $value');
              });
            } else if (element.key == 'disposition') {
              var dispositions = element.value as Map<dynamic, dynamic>;
              ffprint('Disposition Count: ${dispositions.length}');
              dispositions.forEach((key, value) {
                ffprint('--> $key: $value');
              });
            } else {
              ffprint('-> ${element.key}: ${element.value}');
            }
          });
        });
      });
    });
  }
}

var httpsColumn = Column();
