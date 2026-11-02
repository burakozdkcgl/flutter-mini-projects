import 'interfaces/connectable.dart';

/// Abstract base class representing a generic smart home device.
///
/// Demonstrates:
/// - **Class & Abstraction**: Declared as `abstract class SmartDevice`.
/// - **Interface**: Implements the [Connectable] interface.
/// - **Keywords**: Demonstrates `static` (tracking global device count),
///   `this` (referencing instance members), and serves as the superclass for `super`.
abstract class SmartDevice implements Connectable {
  /// Static counter tracking the total number of created smart devices.
  ///
  /// Requirement: "Display the total number of created devices. This value
  /// must come from a static variable in your class implementation."
  static int totalDevices = 0;

  /// Resets the static counter (useful for unit tests and state resets).
  static void resetDeviceCount() {
    totalDevices = 0;
  }

  /// Unique identifier for the device.
  final String id;

  /// Display name / type of the device (e.g. "Smart Light", "Thermostat").
  String name;

  /// Location / room where the device is installed (e.g. "Living Room", "Bedroom").
  String location;

  /// Primary power state of the device.
  bool isPoweredOn;

  /// Connection state fulfilling the [Connectable] interface contract.
  @override
  bool isConnected;

  /// Default constructor initializing common device properties.
  ///
  /// Demonstrates explicit use of the [this] keyword in formal parameters
  /// and increments the static [totalDevices] counter upon each instantiation.
  SmartDevice({
    required this.id,
    required this.name,
    required this.location,
    this.isPoweredOn = false,
    this.isConnected = true,
  }) {
    SmartDevice.totalDevices++;
  }

  /// Named constructor for initializing a device in an offline / disconnected state.
  ///
  /// Demonstrates named constructors and constructor redirection using [this].
  SmartDevice.offline({
    required String id,
    required String name,
    required String location,
  }) : this(
          id: id,
          name: name,
          location: location,
          isPoweredOn: false,
          isConnected: false,
        );

  /// Full display title combining name and location.
  /// e.g. "Smart Light: Living Room" as shown in the assignment PDF.
  String get displayTitle => '$name: $location';

  /// Abstract method returning the current operational status text.
  ///
  /// Examples: "ON", "OFF", "Heating", "Cooling", "Playing", "Paused".
  /// Subclasses MUST provide their own concrete implementation.
  String getStatus();

  /// Abstract method executing the primary action for the device.
  ///
  /// For example, toggling light state, adjusting thermostat, or play/pause speaker.
  void performAction();

  /// Toggles device power state.
  void togglePower() {
    isPoweredOn = !isPoweredOn;
  }

  // --- Connectable Interface Implementation ---

  @override
  void connect() {
    isConnected = true;
  }

  @override
  void disconnect() {
    isConnected = false;
  }
}
