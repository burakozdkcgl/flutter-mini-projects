import 'mixins/schedulable.dart';
import 'smart_device.dart';

/// Represents a smart light bulb in the smart home system.
///
/// Demonstrates:
/// - **Inheritance**: Extends the abstract base class [SmartDevice].
/// - **Mixin**: Applies [Schedulable] to support time-based automation.
/// - **Constructors**: Implements both default and named constructors.
/// - **Keywords**: Demonstrates [super] (super parameters, constructor call, and method invocation)
///   and [this] (formal constructor parameters and disambiguation).
class SmartLight extends SmartDevice with Schedulable {
  /// Brightness percentage (0 - 100).
  int brightness;

  /// Default constructor for [SmartLight].
  ///
  /// Demonstrates [super] parameters delegating to [SmartDevice]
  /// and [this] initializing [brightness].
  SmartLight({
    required super.id,
    required super.name,
    required super.location,
    super.isPoweredOn = false,
    super.isConnected = true,
    this.brightness = 75,
  });

  /// Named constructor for a pre-configured dimmed night light.
  ///
  /// Demonstrates named constructors and explicit [super] constructor invocation.
  SmartLight.dimmed({
    required super.id,
    required super.location,
    super.name = 'Smart Light',
  })  : brightness = 20,
        super(
          isPoweredOn: true,
          isConnected: true,
        );

  /// Named constructor for a quick room light with default brightness.
  SmartLight.standard({
    required super.id,
    required super.location,
    this.brightness = 50,
  }) : super(
          name: 'Smart Light',
          isPoweredOn: true,
          isConnected: true,
        );

  /// Overrides the abstract [getStatus] method from [SmartDevice].
  ///
  /// Returns "ON" if powered on, otherwise "OFF".
  @override
  String getStatus() {
    return isPoweredOn ? 'ON' : 'OFF';
  }

  /// Overrides the abstract [performAction] method from [SmartDevice].
  ///
  /// Performs the primary light action: toggling on/off state.
  @override
  void performAction() {
    togglePower();
  }

  /// Sets brightness to a clamped range between 0 and 100.
  ///
  /// Demonstrates the [this] keyword to resolve parameter shadowing.
  void setBrightness(int brightness) {
    this.brightness = brightness.clamp(0, 100);
    if (this.brightness == 0) {
      isPoweredOn = false;
    } else if (!isPoweredOn) {
      isPoweredOn = true;
    }
  }

  /// Overrides [togglePower] and calls [super.togglePower()]
  /// to demonstrate super method invocation.
  @override
  void togglePower() {
    super.togglePower();
    if (isPoweredOn && brightness == 0) {
      brightness = 50;
    }
  }
}
