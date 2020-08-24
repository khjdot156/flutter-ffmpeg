import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg/log_level.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';

import 'flutter_ffmpeg_api_wrapper.dart';
import 'util.dart';
import 'video_util.dart';

VideoTab videoTab = new VideoTab();

class VideoTab {
  List<DropdownMenuItem<String>> _codecDropDownMenuItems;
  String _currentCodec;
  String _encodeOutput;

  void init(State state) {
    _codecDropDownMenuItems = _getCodecDropDownMenuItems();
    _currentCodec = _codecDropDownMenuItems[0].value;
    _encodeOutput = "";
  }

  void setActive() {
    print("Video Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(statisticsCallback);
    showTooltip(VIDEO_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    if (log.level != LogLevel.AV_LOG_STDERR) {
      _encodeOutput += log.message;
    }
  }

  String getOutput() {
    return _encodeOutput;
  }

  void statisticsCallback(Statistics statistics) {
    ffprint("Statistics: "
        "executionId: ${statistics.executionId}, "
        "time: ${statistics.time}, "
        "size: ${statistics.size}, "
        "bitrate: ${statistics.bitrate}, "
        "speed: ${statistics.speed}, "
        "videoFrameNumber: ${statistics.videoFrameNumber}, "
        "videoQuality: ${statistics.videoQuality}, "
        "videoFps: ${statistics.videoFps}");
  }

  void testEncodeVideo() {
    ffprint("Testing VIDEO.");

    // CLEAR OUTPUT ON EACH EXECUTION
    _encodeOutput = "";

    disableStatistics();
    enableStatistics();

    VideoUtil.assetPath(VideoUtil.ASSET_1).then((image1Path) {
      VideoUtil.assetPath(VideoUtil.ASSET_2).then((image2Path) {
        VideoUtil.assetPath(VideoUtil.ASSET_3).then((image3Path) {
          final String videoPath = getVideoPath();
          final String customOptions = getCustomEncodingOptions();
          final String ffmpegCodec = getFFmpegCodecName();

          VideoUtil.assetPath(videoPath).then((fullVideoPath) {
            /*
            executeFFmpeg(VideoUtil.generateEncodeVideoScript(
                    image1Path,
                    image2Path,
                    image3Path,
                    fullVideoPath,
                    ffmpegCodec,
                    customOptions))
                .then((rc) {
              if (rc == 0) {
                testGetMediaInformation(fullVideoPath);
              }
            });
            */

            executeAsyncFFmpeg(
                VideoUtil.generateEncodeVideoScript(
                    image1Path,
                    image2Path,
                    image3Path,
                    fullVideoPath,
                    ffmpegCodec,
                    customOptions), (int executionId, int returnCode) {
              ffprint('Execution: $executionId '
                  'completed with return code: $returnCode');
            }).then(
                (executionId) => ffprint('Execution: $executionId started'));

            listFFmpegExecutions().then((list) {
              for (var i = 0; i < list.length; ++i) {
                ffprint("Execution -> "
                    "id: ${list[i].executionId}, "
                    "startTime: ${list[i].startTime}, "
                    "command: ${list[i].command}");
              }
            });

            // resetStatistics();

            getLastReceivedStatistics().then((lastStatistics) {
              if (lastStatistics == null) {
                ffprint('No last statistics');
              } else {
                ffprint('Last statistics ->');
                statisticsCallback(lastStatistics);
              }
            });
          });
        });
      });
    });
  }

  String getFFmpegCodecName() {
    String ffmpegCodec = _currentCodec;

    // VIDEO CODEC MENU HAS BASIC NAMES, FFMPEG NEEDS LONGER LIBRARY NAMES.
    if (ffmpegCodec == "x264") {
      ffmpegCodec = "libx264";
    } else if (ffmpegCodec == "x265") {
      ffmpegCodec = "libx265";
    } else if (ffmpegCodec == "xvid") {
      ffmpegCodec = "libxvid";
    } else if (ffmpegCodec == "vp8") {
      ffmpegCodec = "libvpx";
    } else if (ffmpegCodec == "vp9") {
      ffmpegCodec = "libvpx-vp9";
    }

    return ffmpegCodec;
  }

  String getVideoPath() {
    String ffmpegCodec = _currentCodec;

    String videoPath;
    if ((ffmpegCodec == "vp8") || (ffmpegCodec == "vp9")) {
      videoPath = "video.webm";
    } else {
      // mpeg4, x264, x265, xvid
      videoPath = "video.mp4";
    }

    return videoPath;
  }

  String getCustomEncodingOptions() {
    String videoCodec = _currentCodec;

    if (videoCodec == "x265") {
      return "-crf 28 -preset fast ";
    } else if (videoCodec == "vp8") {
      return "-b:v 1M -crf 10 ";
    } else if (videoCodec == "vp9") {
      return "-b:v 2M ";
    } else {
      return "";
    }
  }

  List<DropdownMenuItem<String>> _getCodecDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();

    items.add(new DropdownMenuItem(value: "mpeg4", child: new Text("mpeg4")));
    items.add(new DropdownMenuItem(value: "x264", child: new Text("x264")));
    items.add(new DropdownMenuItem(value: "x265", child: new Text("x265")));
    items.add(new DropdownMenuItem(value: "xvid", child: new Text("xvid")));
    items.add(new DropdownMenuItem(value: "vp8", child: new Text("vp8")));
    items.add(new DropdownMenuItem(value: "vp9", child: new Text("vp9")));

    return items;
  }

  void _changedCodec(String selectedCodec) {
    _currentCodec = selectedCodec;
  }
}

var videoColumn = Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: Container(
          width: 200,
          alignment: Alignment(0.0, 0.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(155, 89, 182, 1.0),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            style: new TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            value: videoTab._currentCodec,
            items: videoTab._codecDropDownMenuItems,
            onChanged: videoTab._changedCodec,
            iconSize: 0,
            isExpanded: false,
          )),
        )),
    Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: new InkWell(
        onTap: () => videoTab.testEncodeVideo(),
        child: new Container(
          width: 100,
          height: 38,
          decoration: new BoxDecoration(
            color: Color(0xFF2ECC71),
            borderRadius: new BorderRadius.circular(5),
          ),
          child: new Center(
            child: new Text(
              'ENCODE',
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
              reverse: true, child: Text(videoTab.getOutput()))),
    )
  ],
);
