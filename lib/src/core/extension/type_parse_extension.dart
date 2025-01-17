part of 'extension.dart';

extension GetStatusExtension on List<String>? {
  String get getStatus => (this ?? <String>[]).firstOrNull?.replaceAll('[', '').replaceAll(']', '') ?? '';
}

extension IntExtension on num? {
  num get multiplyTo10Thousand => (this ?? 0) * 10000;

}

/// When the init state function is running, the selected item in the state will be empty, so it must be entered during the build.
extension TextEditingControllerExtension on TextEditingController? {
  TextEditingController? setText({String? text}) {
    this?.text = text ?? '';
    return this;
  }
}

extension AppLifecycleStateX on AppLifecycleState {
  bool get isResumed => this == AppLifecycleState.resumed;

  bool get isPaused => this == AppLifecycleState.paused;

  bool get isDetached => this == AppLifecycleState.detached;

  bool get isInactive => this == AppLifecycleState.inactive;

  bool get isHidden => this == AppLifecycleState.hidden;
}
