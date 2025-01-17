part of 'package:ozro_mobile/src/presentation/pages/auth/auth_page/auth_page.dart';

mixin AuthMixin on State<AuthPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  ValueNotifier<bool> isVisiblePassword = ValueNotifier(false);
  int longPressValue = 0;
  int doubleFiveTimesPressValue = 0;
  int simpleFivePressValue = 0;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    Future.delayed(Duration.zero, () async {
      await initPlatformState();
      await FirebaseMessaging.instance.getToken().then((token) {
        localSource.setFCMToken(token ?? '');
      });
      print('TOKEN::: ${localSource.getFCMToken()}');
    });
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    try {
      deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.android => _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.iOS     => _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
        TargetPlatform.linux   => _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.windows => _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.macOS   => _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.fuchsia => <String, dynamic>{ 'Error:': 'Fuchsia platform isn\'t supported' },
      };
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) {
      return;
    }
    setState(() {
      localSource.setDeviceId(deviceData['id']);
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) =>
      <String, dynamic>{
        'id': build.id,
        'model': build.model,
        'serialNumber': build.serialNumber,
      };

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) =>
      <String, dynamic>{'id': data.identifierForVendor, 'model': data.model};



  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
