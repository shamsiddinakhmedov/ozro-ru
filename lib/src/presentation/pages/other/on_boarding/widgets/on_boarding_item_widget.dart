part of '../on_boarding_page.dart';

class _OnBoardingItemWidget extends StatelessWidget {
  const _OnBoardingItemWidget({super.key, required this.board, required this.onSkipPressed});

  final OnBoardingModel board;
  final VoidCallback onSkipPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppUtils.kPaddingAll16.copyWith(bottom: 0),
        child: Column(
          key: key,
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppUtils.kBorderRadius16,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.colorScheme.primary.withOpacity(0.7),
                    context.colorScheme.primary.withOpacity(0.8),
                    context.colorScheme.primary.withOpacity(0.9),
                    context.colorScheme.primary,
                    context.colorScheme.primary,
                    context.colorScheme.primary,
                  ],
                ),
              ),
              child: Padding(
                padding: AppUtils.kPaddingAll16,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: onSkipPressed,
                        child: Text(
                          'Пропустить',
                          style: context.textStyle.regularSubheadline.copyWith(
                            color: context.colorScheme.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage(
                        board.imagePath,
                      ),
                    ),
                    AppUtils.kGap28,
                  ],
                ),
              ),
            ),
            AppUtils.kGap12,

            /// TITLE
            Text(
              board.title,
              textAlign: TextAlign.center,
              style: context.textStyle.appBarTitle,
            ),
            AppUtils.kGap8,

            /// CONTENT
            Text(
              board.description,
              textAlign: TextAlign.center,
              style: context.textStyle.regularSubheadline.copyWith(
                color: context.color.darkGrey2,
              ),
            ),
          ],
        ),
      );
}
