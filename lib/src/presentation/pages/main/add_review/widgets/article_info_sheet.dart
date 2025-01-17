part of '../add_review_page.dart';

class _ArticleInfoSheet extends StatelessWidget {
  const _ArticleInfoSheet({required this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding: AppUtils.kPaddingAll16.copyWith(
                      bottom: 32,
                    ),
                    sliver: SliverList.list(
                      children: [
                        Text(
                          'Как получить артикул товара?',
                          style: context.textStyle.appBarTitle.copyWith(
                            fontSize: 17,
                          ),
                        ),
                        AppUtils.kGap12,
                        Text(
                          'Чтобы оставить отзыв в нашем приложении, вам потребуется артикул товара с сайта Wildberries. Вот как его найти:',
                          style: context.textStyle.regularSubheadline,
                        ),
                        AppUtils.kGap16,
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: AppUtils.kBorderRadius12,
                            color: context.colorScheme.primary.withOpacity(0.15),
                          ),
                          child: Padding(
                            padding: AppUtils.kPaddingAll12,
                            child: Text(
                              '''1. Перейдите на сайт Wildberries.\n\n2. Воспользуйтесь поиском или навигацией, чтобы найти интересующий вас товар.\n\n3. На странице товара, под его названием или рядом с описанием, вы найдете артикул — это специальный номер, который идентифицирует именно этот товар.\n\n4. Скопируйте артикул и вставьте его в нужное поле в нашем приложении для написания отзыва.\n''',
                              style: context.textStyle.regularSubheadline,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        AppUtils.kGap24,
                        ElevatedButton(
                          onPressed: () {
                            launchUrl(Uri.parse('https://www.wildberries.ru/'));
                            Navigator.of(context).pop();
                          },
                          child: const Text('Перейти на сайт Wildberries'),
                        ),
                        AppUtils.kGap12,
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(context.color.lightGrey4),
                            foregroundColor: WidgetStatePropertyAll(context.color.black),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Отмена'),
                        ),
                        AppUtils.kGap12,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
