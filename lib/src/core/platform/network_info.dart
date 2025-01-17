import 'package:ozro_mobile/src/core/connectivity/internet_connection_checker.dart';

abstract class NetworkInfo {
  const NetworkInfo();

  Future<bool> get isConnected;

  Stream<InternetConnectionStatus> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this.internetConnection);

  final InternetConnectionChecker internetConnection;

  /// network info is not working [Future.value(true)]

  @override
  Future<bool> get isConnected => Future.value(true);

  @override
  Stream<InternetConnectionStatus> get onStatusChange => internetConnection.onStatusChange;

  @override
  String toString() => 'NetworkInfoImpl($internetConnection)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NetworkInfoImpl && other.internetConnection == internetConnection;
  }

  @override
  int get hashCode => internetConnection.hashCode;
}
