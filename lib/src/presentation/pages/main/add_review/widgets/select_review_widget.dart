part of '../add_review_page.dart';

class _SelectReviewWidget extends StatelessWidget {
  const _SelectReviewWidget({
    required this.reviewForm,
    required this.reviewController,
  });

  final GlobalKey<FormState> reviewForm;
  final TextEditingController reviewController;

  @override
  Widget build(BuildContext context) => Form(
        key: reviewForm,
        child: CustomTextField(
          isRequired: true,
          // contentPadding: AppUtils.kPaddingVertical32,
          titleText: 'Oтзыв',
          hintText: 'Введите',
          controller: reviewController,
          onChanged: (p0) {
            if (reviewController.text.isNotEmpty) {
              reviewForm.currentState!.validate();
            }
          },
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return 'Введите отзыв';
            }
            return null;
          },
          filled: true,
          fillColor: context.color.lightGrey4,
          maxLines: 10,
        ),
      );
}
