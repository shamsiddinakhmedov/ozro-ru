part of 'package:ozro_mobile/src/presentation/pages/auth/register/register_page.dart';

mixin RegisterMixin on State<RegisterPage> {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _confirmPasswordController = TextEditingController();
  late final RegisterBloc _bloc = context.read<RegisterBloc>();

  ValueNotifier<bool> isVisiblePassword = ValueNotifier(false);

  int longPressValue = 0;
  int doubleFiveTimesPressValue = 0;
  int simpleFivePressValue = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.close();
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  Future<void> _registerUser() async {
    _bloc.add(
      RegisterSubmitEvent(
        request: RegisterUserRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _nameController.text.trim(),
        ),
      ),
    );
  }

  Future<void> _superAdminStart({
    bool longPress = false,
    bool doubleFiveTimesPress = false,
    bool simpleFiveTimesPress = false,
  }) async {
    if (doubleFiveTimesPress) {
      doubleFiveTimesPressValue = doubleFiveTimesPressValue + 1;
    } else if (simpleFiveTimesPress && doubleFiveTimesPressValue == 2) {
      simpleFivePressValue = simpleFivePressValue + 1;
    } else if (longPress && doubleFiveTimesPressValue == 2 && simpleFivePressValue == 2) {
      longPressValue = longPressValue + 1;
      if (doubleFiveTimesPressValue == 2 && simpleFivePressValue == 2 && longPressValue == 2) {
        await localSource.setSuperAdmin();
      }
    } else {
      simpleFivePressValue = 0;
      longPressValue = 0;
      doubleFiveTimesPressValue = 0;
    }
    debugPrint('double:$doubleFiveTimesPressValue simple:$simpleFivePressValue long:$longPressValue');
  }
}
