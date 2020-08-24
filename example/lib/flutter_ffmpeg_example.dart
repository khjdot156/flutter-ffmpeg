import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg_example/audio_tab.dart';
import 'package:flutter_ffmpeg_example/command_tab.dart';
import 'package:flutter_ffmpeg_example/concurrent_execution_tab.dart';
import 'package:flutter_ffmpeg_example/flutter_ffmpeg_api_wrapper.dart';
import 'package:flutter_ffmpeg_example/https_tab.dart';
import 'package:flutter_ffmpeg_example/pipe_tab.dart';
import 'package:flutter_ffmpeg_example/subtitle_tab.dart';
import 'package:flutter_ffmpeg_example/test.dart';
import 'package:flutter_ffmpeg_example/util.dart';
import 'package:flutter_ffmpeg_example/vid_stab_tab.dart';
import 'package:flutter_ffmpeg_example/video_tab.dart';
import 'package:flutter_ffmpeg_example/video_util.dart';

void main() => runApp(FlutterFFmpegExampleApp());

class FlutterFFmpegExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFF46842),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  FlutterFFmpegExampleAppState createState() =>
      new FlutterFFmpegExampleAppState();
}

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({@required this.tabBar, @required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}

class FlutterFFmpegExampleAppState extends State<MainPage>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 8, vsync: this);
    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        switch (_controller.index) {
          case 0:
            commandTab.setActive();
            break;
          case 1:
            videoTab.setActive();
            break;
          case 2:
            httpsTab.setActive();
            break;
          case 3:
            audioTab.setActive();
            break;
          case 4:
            subtitleTab.setActive();
            break;
          case 5:
            vidStabTab.setActive();
            break;
          case 6:
            pipeTab.setActive();
            break;
          case 7:
            concurrentExecutionTab.setActive();
            break;
        }
      }
    });

    commandTab.init(this);
    httpsTab.init(this);
    videoTab.init(this);
    audioTab.init(this);
    subtitleTab.init(this);
    vidStabTab.init(this);
    pipeTab.init(this);
    concurrentExecutionTab.init(this);

    testCommonApiMethods();
    testParseArguments();

    VideoUtil.prepareAssets();

    VideoUtil.tempDirectory.then((tempDirectory) {
      setFontconfigConfigurationPath(tempDirectory.path);
      setEnvironmentVariable(
          "FFREPORT",
          "file=" +
              new File(tempDirectory.path + "/" + today() + "-ffreport.txt")
                  .path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlutterFFmpeg Test'),
          centerTitle: true,
        ),
        bottomNavigationBar: Material(
          child: DecoratedTabBar(
            tabBar: TabBar(
              isScrollable: true,
              tabs: <Tab>[
                Tab(text: "COMMAND"),
                Tab(text: "VIDEO"),
                Tab(text: "HTTPS"),
                Tab(text: "AUDIO"),
                Tab(text: "SUBTITLE"),
                Tab(text: "VID.STAB"),
                Tab(text: "PIPE"),
                Tab(text: "CONCURRENT EXECUTION")
              ],
              controller: _controller,
              labelColor: Color(0xFF1e90ff),
              unselectedLabelColor: Color(0xFF808080),
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF808080),
                  width: 1.0,
                ),
                bottom: BorderSide(
                  width: 0.0,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            commandColumn,
            videoColumn,
            httpsColumn,
            audioColumn,
            subtitleColumn,
            vidStabColumn,
            pipeColumn,
            concurrentExecutionColumn
          ],
          controller: _controller,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    commandTab.dispose();
  }
}
