part of '../main_page.dart';

mixin MainMixin on State<MainPage> {
  late AppLifecycleState lifeCycleState = AppLifecycleState.resumed;

  // late MainBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) return;
  }


}
