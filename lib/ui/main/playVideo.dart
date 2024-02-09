import 'package:bc_remates/res/owner_colors.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../model/videoAPI.dart';
import '../../model/videos.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoAPI video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController? _controller = YoutubePlayerController(
      initialVideoId: widget.video.linkCortado!,
      flags: YoutubePlayerFlags(
          autoPlay: true, mute: false,
          controlsVisibleAtStart: true,
          showLiveFullscreenButton: true),
    );

    print(widget.video.live);

    return Center(
      child: Card(
        child: Container(
          child: YoutubePlayer(
            controller: _controller,
            progressColors: ProgressBarColors(
                playedColor: Color(0xff3a3e46),
                bufferedColor: Color(0xff797c81),
                handleColor: OwnerColors.colorPrimary),
            progressIndicatorColor: OwnerColors.colorPrimary,
            showVideoProgressIndicator: true,
          ),
        ),
      ),
    );
  }
}
