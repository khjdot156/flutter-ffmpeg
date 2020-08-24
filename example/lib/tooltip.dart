import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String COMMAND_TEST_TOOLTIP_TEXT =
    "Enter an FFmpeg command without 'ffmpeg' at the beginning and click one of the RUN buttons";

const String VIDEO_TEST_TOOLTIP_TEXT =
    "Select a video codec and press ENCODE button";

const String HTTPS_TEST_TOOLTIP_TEXT =
    "Enter the https url of a media file and click the button";

const String AUDIO_TEST_TOOLTIP_TEXT =
    "Select an audio codec and press ENCODE button";

const String SUBTITLE_TEST_TOOLTIP_TEXT =
    "Click the button to burn subtitles. Created video will play inside the frame below";

const String VIDSTAB_TEST_TOOLTIP_TEXT =
    "Click the button to stabilize video. Original video will play above and stabilized video will play below";

const String PIPE_TEST_TOOLTIP_TEXT =
    "Click the button to create a video using pipe redirection. Created video will play inside the frame below";

const String CONCURRENT_EXECUTION_TEST_TOOLTIP_TEXT =
    " Use ENCODE and CANCEL buttons to start/stop multiple execution";

void showTooltip(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.white70,
      textColor: Colors.black87,
      fontSize: 16.0);
}
