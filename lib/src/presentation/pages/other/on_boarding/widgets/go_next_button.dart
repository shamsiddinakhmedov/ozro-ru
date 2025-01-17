part of '../on_boarding_page.dart';

class _GoNextButton extends StatelessWidget {
  const _GoNextButton({
    required this.isNext,
    required this.onGoBack,
    required this.backIsActive,
  });

  final bool isNext;
  final bool backIsActive;
  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        key: key,
        transformAlignment: Alignment.centerRight,
        width: backIsActive ? context.kSize.width / 2 : context.kSize.width,
        height: 50,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: AppUtils.kPaddingHorizontal16.copyWith(
          left: backIsActive ? 4 : 16,
        ),
        child: ElevatedButton(
          onPressed: onGoBack,
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(AppUtils.kPaddingZero),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isNext ? 'Следующий' : 'Начать'),
              if (isNext) ...[
                AppUtils.kGap8,
                Icon(
                  Icons.arrow_forward,
                  color: context.colorScheme.surface,
                ),
              ],
            ],
          ),
        ),
      );
}
