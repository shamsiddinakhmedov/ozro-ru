part of '../edit_profile_page.dart';

mixin _EditProfilePageMixin on State<EditProfilePage> {
  int longPressValue = 0;
  int doubleFiveTimesPressValue = 0;
  int simpleFivePressValue = 0;

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
