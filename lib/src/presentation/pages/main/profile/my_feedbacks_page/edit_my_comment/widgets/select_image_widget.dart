part of '../edit_my_comment_page.dart';

class _SelectImageWidget extends StatefulWidget {
  const _SelectImageWidget({
    required this.onSelectImage,
    required this.image,
    this.videoPlayerController,
    this.commentFile,
  });

  final VoidCallback onSelectImage;
  final ValueNotifier<File?> image;
  final Files? commentFile;
  final VideoPlayerController? videoPlayerController;

  @override
  State<_SelectImageWidget> createState() => _SelectImageWidgetState();
}

class _SelectImageWidgetState extends State<_SelectImageWidget> {
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          InkWell(
            borderRadius: AppUtils.kBorderRadius12,
            onTap: widget.onSelectImage,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppUtils.kBorderRadius12,
                border: Border.all(
                  color: context.color.lightGrey2,
                ),
              ),
              child: ValueListenableBuilder(
                valueListenable: widget.image,
                builder: (_, value, __) =>
                    value != null && getMediaType(value).type == 'VIDEO' && widget.videoPlayerController != null
                        ? SizedBox(
                            width: widget.videoPlayerController!.value.size.width * 0.3,
                            height: widget.videoPlayerController!.value.size.height * 0.3,
                            child: AspectRatio(
                              aspectRatio: widget.videoPlayerController!.value.size.aspectRatio,
                              child: ClipRRect(
                                borderRadius: AppUtils.kBorderRadius12,
                                child: Stack(
                                  children: [
                                    if (widget.videoPlayerController!.value.isInitialized) ...[
                                      VideoPlayer(widget.videoPlayerController!),

                                      /// play button

                                      ValueListenableBuilder(
                                        valueListenable: isPlaying,
                                        builder: (_, value, __) => Positioned.fill(
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                isPlaying.value = !isPlaying.value;
                                                if (widget.videoPlayerController!.value.isPlaying) {
                                                  widget.videoPlayerController!.pause();
                                                } else {
                                                  widget.videoPlayerController!.play();
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
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.image.value = null;
                                          isPlaying.value = false;
                                          widget.videoPlayerController?.pause();
                                        },
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: context.color.lightGrey4.withOpacity(0.6),
                                          child: Icon(
                                            Icons.close,
                                            color: context.color.black,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            width: 100,
                            child: value != null
                                ? ClipRRect(
                                    borderRadius: AppUtils.kBorderRadius12,
                                    child: Stack(
                                      children: [
                                        SizedBox.expand(
                                          child: getMediaType(value).type == 'IMAGE'
                                              ? Image.file(
                                                  value,
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              widget.image.value = null;
                                              widget.videoPlayerController?.pause();
                                            },
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: context.color.lightGrey4.withOpacity(0.6),
                                              child: Icon(
                                                Icons.close,
                                                color: context.color.black,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: context.colorScheme.primary,
                                        ),
                                        Text(
                                          'Загрузить',
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 14 / 12,
                                            fontWeight: FontWeight.w400,
                                            color: context.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
              ),
            ),
          ),
        ],
      );
}
