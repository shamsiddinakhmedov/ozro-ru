part of '../on_boarding_page.dart';

class _GoBackButton extends StatelessWidget {
  const _GoBackButton({required this.backIsActive, required this.onGoBack});

  final bool backIsActive;
  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        key: key,
        transformAlignment: Alignment.centerRight,
        width: backIsActive ? context.kSize.width / 2 : 0,
        height: backIsActive ? 50 : 0,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        padding: AppUtils.kPaddingHorizontal16.copyWith(
          right: 4,
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(AppUtils.kPaddingZero),
            backgroundColor: WidgetStatePropertyAll(
              context.color.lightGrey4,
            ),
            foregroundColor: WidgetStatePropertyAll(
              context.colorScheme.onSurface,
            ),
            textStyle: WidgetStatePropertyAll(
              context.textStyle.regularSubheadline.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onPressed: onGoBack,
          child:backIsActive? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back),
              AppUtils.kGap8,
              Text('Предыдущий'),
            ],
          ):const SizedBox(),
        ),
      );
}
