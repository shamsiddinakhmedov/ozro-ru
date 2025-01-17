import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class TitleAndContentInfoBottomSheet extends StatelessWidget {
  const TitleAndContentInfoBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.scrollController,
  });
  final String title;
  final String content;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppUtils.kPaddingAllT16,
              child: Text(
                title,
                style: context.textStyle.appBarTitle,
              ),
            ),
            Padding(
              padding: AppUtils.kPaddingAllT16,
              child: Text(
                content,
                style: context.textStyle.regularSubheadline,
              ),
            ),
            AppUtils.kGap16,
            SafeArea(
              minimum: AppUtils.kPaddingAll16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Хорошо'),
              ),
            ),
          ],
        ),
      );
}
