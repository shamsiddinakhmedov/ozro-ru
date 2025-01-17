part of '../edit_my_comment_page.dart';

class _SelectArticleWidget extends StatelessWidget {
  const _SelectArticleWidget({required this.articleController, required this.articleForm});

  final TextEditingController articleController;
  final GlobalKey<FormState> articleForm;

  @override
  Widget build(BuildContext context) => Form(
    key: articleForm,
    child: CustomTextField(
      isRequired: true,
      titleText: 'Артикул товара',
      hintText: 'Введите',
      filled: true,
      fillColor: context.color.lightGrey4,
      controller: articleController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (p0) {
        if (articleController.text.isNotEmpty) {
          articleForm.currentState!.validate();
        }
      },
      validator: (p0) {
        if (p0 == null || p0.isEmpty) {
          return 'Введите артикул';
        }
        return null;
      },
    ),
  );
}
