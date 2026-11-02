/// Interface for devices that support network connectivity.
///
/// Demonstrates the Dart Interface concept: any class implementing
/// [Connectable] must provide concrete implementations of [isConnected],
/// [connect], and [disconnect].
abstract class Connectable {
  /// Whether the device is currently connected to the network / bridge.
  bool get isConnected;

  /// Connects the device to the network.
  void connect();

  /// Disconnects the device from the network.
  void disconnect();
}
