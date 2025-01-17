import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWithNetworkUrlWidget extends StatefulWidget {
  const VideoPlayerWithNetworkUrlWidget({
    super.key,
    required this.videoLink,
  });

  final String videoLink;

  @override
  State<VideoPlayerWithNetworkUrlWidget> createState() => _VideoPlayerWithNetworkUrlWidgetState();
}

class _VideoPlayerWithNetworkUrlWidgetState extends State<VideoPlayerWithNetworkUrlWidget> {
  late final VideoPlayerController videoPlayerController;
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  @override
  void initState() {
    if (widget.videoLink.isNotEmpty) {
      debugLog('videoLink---> ${widget.videoLink}');
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoLink),
      );
      _init();
    }
    super.initState();
  }

  Future<void> _init() async {
    await videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: videoPlayerController.value.size.width * 0.2,
        height: videoPlayerController.value.size.height * 0.2,
        child: ClipRRect(
          borderRadius: AppUtils.kBorderRadius12,
          child: Stack(
            children: [
              if (videoPlayerController.value.isInitialized) ...[
                VideoPlayer(videoPlayerController),
                /// play button
                ValueListenableBuilder(
                  valueListenable: isPlaying,
                  builder: (_, value, __) => Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          isPlaying.value = !isPlaying.value;
                          if (videoPlayerController.value.isPlaying) {
                            videoPlayerController.pause();
                          } else {
                            videoPlayerController.play();
                          }
                        },
                        child: Icon(
                          value ? Icons.pause : Icons.play_arrow,
                          color: context.color.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}
