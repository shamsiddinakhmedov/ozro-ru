import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/main/add_review/add_feedback_request.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/dialogs/custom_dialog.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/widgets/profile_item_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

part 'widgets/select_image_widget.dart';

part 'widgets/select_article_widget.dart';

part 'widgets/select_review_widget.dart';

part 'widgets/article_info_sheet.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  late final TextEditingController articleController;
  final GlobalKey<FormState> articleForm = GlobalKey<FormState>();
  final GlobalKey<FormState> reviewForm = GlobalKey<FormState>();
  late final TextEditingController reviewController;
  ValueNotifier<File?> image = ValueNotifier<File?>(null);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    articleController = TextEditingController();
    reviewController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    articleController.dispose();
    reviewController.dispose();
    articleForm.currentState?.dispose();
    reviewForm.currentState?.dispose();
    image.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          title: const Text('Добавления отзыва'),
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (_, isLoading, __) => ModalProgressHUD(
            inAsyncCall: isLoading,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.zero,
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
                      AppUtils.kGap12,
                      Container(
                        width: double.infinity,
                        color: context.color.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Column(
                          children: [
                            _SelectArticleWidget(
                              articleController: articleController,
                              articleForm: articleForm,
                            ),
                            AppUtils.kGap12,
                            Row(
                              children: [
                                Text(
                                  '*',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 14 / 12,
                                    fontWeight: FontWeight.w400,
                                    color: context.colorScheme.error,
                                  ),
                                ),
                                Text(
                                  'Фото/видео',
                                  style: context.textStyle.regularFootnote.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                            AppUtils.kGap4,
                            _SelectImageWidget(
                              onSelectImage: () => selectFile(context),
                              videoPlayerController: videoPlayerController,
                              image: image,
                            ),
                            AppUtils.kGap12,
                            _SelectReviewWidget(
                              reviewForm: reviewForm,
                              reviewController: reviewController,
                            ),
                            AppUtils.kGap16,
                            SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!articleForm.currentState!.validate() || !reviewForm.currentState!.validate()) return;
                                  if (image.value == null) {
                                    showFlashError(context: context, content: 'Загрузите фото/видео');
                                    return;
                                  }
                                  submitReview();
                                },
                                child: const Text('Отправить'),
                              ),
                            )
                          ],
                        ),
                      ),
                      AppUtils.kGap12,
                      Container(
                        width: double.infinity,
                        color: context.color.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Как получить артикул товара?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            AppUtils.kGap12,
                            const Text(
                              'Чтобы оставить отзыв, вам нужен артикул товара с Wildberries. Вот как его найти:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            AppUtils.kGap12,
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xffFFC800).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1. Зайдите на сайт Wildberries.',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  AppUtils.kGap12,
                                  Text(
                                    '2. Найдите товар через поиск или навигацию.',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  AppUtils.kGap12,
                                  Text(
                                    '3. На странице товара найдите артикул (под названием или рядом с описанием).',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  AppUtils.kGap12,
                                  Text(
                                    '4. Скопируйте артикул и вставьте в нужное поле в приложении.',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    final File? file = await picker
        .pickMedia(
      maxHeight: 1000,
      maxWidth: 1000,
    ).then(
      (value) async {
        if (value == null) return null;
        const num maxVideoSize = 30 * 1024 * 1024; // 30MB in bytes
        final fileSize = await value.length();
        if (fileSize > maxVideoSize && context.mounted) {
          await showFlashError(
            context: context,
            content: 'Размер видео/фото не должен превышать 30MB',
          );
          return null;
        }
        return File(value.path);
      },
    );

    if (file != null) {
      if (context.mounted) {
        debugLog('selected file: ${file.path}');
        if (getMediaType(file).type == 'VIDEO') {
          videoPlayerController = VideoPlayerController.file(file, videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
          await videoPlayerController!.initialize().then((_) {
            setState(() {});
            debugLog('videoPlayerController!.value: ${videoPlayerController!.value}');
          });
        }
        setState(() {
          image.value = file;
        });
      }
    }
  }

  Future<void> submitReview() async {
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    final file = await MultipartFile.fromFile(image.value!.path);
    final fileType = getMediaType(image.value!).type;
    final result = await sl<MainRepository>().addFeedback(
      request: AddFeedbackRequest(
        file: file,
        content: reviewController.text,
        sourceId: num.parse(articleController.text),
        fileType: fileType.toUpperCase(),
      ),
      params: {},
    );
    result.fold(
      (left) {
        isLoading.value = false;
        showFlashError(context: context, content: left.message);
      },
      (right) {
        isLoading.value = false;

        articleController.clear();
        image.value = null;
        reviewController.clear();
        showCustomDialog(
          context: context,
          title: '🌟',
          titleTextStyle: const TextStyle(
            fontSize: 48,
          ),
          subTitle: 'Отправлено!',
          content: 'Спасибо за ваш отзыв! Он сейчас проверяется. Скоро он будет опубликован.',
          defaultActionText: 'Хорошо',
          contentPadding: AppUtils.kPaddingVertical16,
          contentTextStyle: context.textStyle.regularSubheadline.copyWith(
            color: context.color.black,
          ),
        );
      },
    );
  }
}
