part of '../on_boarding_page.dart';

mixin _OnBoardingMixin on State<OnBoardingPage> {
  late final PageController _pageController;
  ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<OnBoardingModel> _boards = <OnBoardingModel>[
    const OnBoardingModel(
      imagePath: Assets.pngBike,
      title: 'Реальные отзывы. Честные рекомендации.',
      description: 'Откройте для себя товары с отзывами от реальных покупателей',
    ),
    const OnBoardingModel(
      imagePath: Assets.pngGuitar,
      title: 'Реальные отзывы. Честные рекомендации.',
      description:
          'Ozro.ru — это мобильное приложение, которое помогает принимать решение о покупке на основе реальных отзывов.',
    ),
    const OnBoardingModel(
      imagePath: Assets.pngStopwatch,
      title: 'Реальные отзывы. Честные рекомендации.',
      description:
          'Наши пользователи могут оценивать, комментировать и делиться товарами, что делает процесс принятия решения о покупке проще',
    ),
  ];
}

class OnBoardingModel {
  const OnBoardingModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;
}
