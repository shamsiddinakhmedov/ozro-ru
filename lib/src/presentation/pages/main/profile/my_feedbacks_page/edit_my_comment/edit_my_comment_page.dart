import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

part 'widgets/select_image_widget.dart';

part 'widgets/select_article_widget.dart';

part 'widgets/select_review_widget.dart';

part 'widgets/article_info_sheet.dart';

class EditMyCommentPage extends StatefulWidget {
  const EditMyCommentPage({super.key, required this.args});

  final EditMyCommentArgs args;

  @override
  State<EditMyCommentPage> createState() => _EditMyCommentPageState();
}

class _EditMyCommentPageState extends State<EditMyCommentPage> {
  // late final TextEditingController articleController;
  // final GlobalKey<FormState> articleForm = GlobalKey<FormState>();
  final GlobalKey<FormState> reviewForm = GlobalKey<FormState>();
  late final TextEditingController reviewController;

  ValueNotifier<File?> image = ValueNotifier<File?>(null);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    // articleController = TextEditingController(text: widget.commentOrFeedback.sourceId.toString());
    reviewController = TextEditingController(text: widget.args.comment.content);
    super.initState();
  }

  @override
  void dispose() {
    // articleController.dispose();
    reviewController.dispose();
    // articleForm.currentState?.dispose();
    reviewForm.currentState?.dispose();
    image.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppBar(
          title: Text('Изменить ${widget.args.fromComment ? 'комментарий' : 'отзыв'}'),
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (_, isLoading, __) => ModalProgressHUD(
            inAsyncCall: isLoading,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: AppUtils.kPaddingAll16,
                  sliver: SliverList.list(
                    children: [
                      // ProfileItemWidget(
                      //   isTopRadius: true,
                      //   isBottomRadius: true,
                      //   text: 'Как получить артикул товара?',
                      //   textStyle: context.textStyle.regularSubheadline,
                      //   onTap: () {
                      //     customModalBottomSheet<void>(
                      //       context: context,
                      //       isScrollControlled: true,
                      //       maxHeight: 0.8,
                      //       builder: (_, controller) => _ArticleInfoSheet(
                      //         scrollController: controller,
                      //       ),
                      //     );
                      //   },
                      //   tileColor: context.colorScheme.primary.withOpacity(0.15),
                      // ),
                      // AppUtils.kGap12,
                      // _SelectArticleWidget(
                      //   articleController: articleController,
                      //   articleForm: articleForm,
                      // ),
                      // AppUtils.kGap12,
                      // Row(
                      //   children: [
                      //     Text(
                      //       '*',
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         height: 14 / 12,
                      //         fontWeight: FontWeight.w400,
                      //         color: context.colorScheme.error,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Фото/видео',
                      //       style: context.textStyle.regularFootnote.copyWith(fontSize: 12),
                      //     ),
                      //   ],
                      // ),
                      // AppUtils.kGap4,
                      // _SelectImageWidget(
                      //   onSelectImage: () => selectFile(context),
                      //   videoPlayerController: videoPlayerController,
                      //   image: image,
                      //   commentFile: widget.commentOrFeedback.files.firstOrNull,
                      // ),
                      AppUtils.kGap12,
                      _SelectReviewWidget(
                        title: widget.args.fromComment ? 'Комментарий' : 'Отзыв',
                        reviewForm: reviewForm,
                        reviewController: reviewController,
                      ),
                      AppUtils.kGap12,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationButton(
          child: ElevatedButton(
            onPressed: () {
              if (!reviewForm.currentState!.validate()) return;
              // if (image.value == null) {
              //   showFlashError(context: context, content: 'Загрузите фото/видео');
              //   return;
              // }
              submitReview();
            },
            child: const Text('Отправить'),
          ),
        ),
      );

  Future<void> selectFile(BuildContext context) async {
    if (image.value != null) {
      return;
    }
    await Permission.mediaLibrary.isDenied.then((value) {
      if (value) {
        Permission.mediaLibrary.request();
      }
    });
    final ImagePicker picker = ImagePicker();
    final File? file = await picker.pickMedia(maxHeight: 1000, maxWidth: 1000).then((value) {
      if (value == null) return null;
      return File(value.path);
    });

    if (file != null) {
      if (context.mounted) {
        debugLog('selected file: ${file.path}');
        if (getMediaType(file).type == 'VIDEO') {
          videoPlayerController =
              VideoPlayerController.file(file, videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
          await videoPlayerController!.initialize().then((_) {
            setState(() {});
            debugLog('videoPlayerController!.value: ${videoPlayerController!.value}');
          });
        }
        image.value = file;
      }
    }
  }

  Future<void> submitReview() async {
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    // final file = await MultipartFile.fromFile(image.value!.path);
    final result = await sl<MainRepository>().editMyFeedbackOrComment(
      request: {
        'source_id': widget.args.comment.id,
        'content': reviewController.text.trim(),
        // 'rating': widget.args.comment.rating,
        'reply_to': widget.args.comment.replyTo,
      },
      feedbackId: widget.args.comment.id,
    );
    result.fold(
      (left) {
        isLoading.value = false;
        showFlashError(context: context, content: left.message);
      },
      (right) {
        isLoading.value = false;

        // articleController.clear();
        // image.value = null;
        reviewController.clear();
        context.pop(true);
        // showCustomDialog(
        //   context: context,
        //   title: '🌟',
        //   titleTextStyle: const TextStyle(
        //     fontSize: 48,
        //   ),
        //   subTitle: 'Отправлено!',
        //   content: 'Спасибо за ваш отзыв! Он сейчас проверяется. Скоро он будет опубликован.',
        //   defaultActionText: 'Хорошо',
        //   contentPadding: AppUtils.kPaddingVertical16,
        //   contentTextStyle: context.textStyle.regularSubheadline.copyWith(
        //     color: context.color.black,
        //   ),
        // );
      },
    );
  }
}

class EditMyCommentArgs {
  EditMyCommentArgs({
    required this.comment,
    required this.fromComment,
  });

  final CommentListResponse comment;
  final bool fromComment;
}
