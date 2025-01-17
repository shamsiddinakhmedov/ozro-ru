part of '../edit_my_comment_page.dart';
class _SelectReviewWidget extends StatelessWidget {
  const _SelectReviewWidget({
    required this.reviewForm,
    required this.reviewController,
    required this.title,
  });

  final GlobalKey<FormState> reviewForm;
  final TextEditingController reviewController;
  final String title;

  @override
  Widget build(BuildContext context) => Form(
        key: reviewForm,
        child: CustomTextField(
          isRequired: true,
          // contentPadding: AppUtils.kPaddingVertical32,
          titleText: title,
          hintText: 'Введите',
          controller: reviewController,
          onChanged: (p0) {
            if (reviewController.text.isNotEmpty) {
              reviewForm.currentState!.validate();
            }
          },
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return 'Введите ${title.toLowerCase()}';
            }
            return null;
          },
          filled: true,
          fillColor: context.color.lightGrey4,
          maxLines: 10,
        ),
      );
}
