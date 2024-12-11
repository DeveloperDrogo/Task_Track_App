import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker{
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl extends ConnectionChecker{
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);
  @override

  Future<bool> get isConnected async => internetConnection.hasInternetAccess;
}