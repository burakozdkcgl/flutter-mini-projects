import 'mixins/schedulable.dart';
import 'smart_device.dart';

/// Speed levels for [SmartFan].
enum FanSpeed { off, low, medium, high }

/// Represents a smart ceiling/desk fan in the smart home system.
///
/// Demonstrates:
/// - **Inheritance**: Extends [SmartDevice].
/// - **Mixin**: Applies [Schedulable] for scheduled auto-off.
/// - **Constructors**: Default and named constructors.
/// - **Keywords**: Uses [super], [this], and [static] (FanSpeed enum + SmartDevice.totalDevices).
class SmartFan extends SmartDevice with Schedulable {
  /// Current fan speed setting.
  FanSpeed speed;

  /// Whether the oscillation (rotation) mode is active.
  bool isOscillating;

  /// Default constructor for [SmartFan].
  SmartFan({
    required super.id,
    required super.name,
    required super.location,
    super.isPoweredOn = false,
    super.isConnected = true,
    this.speed = FanSpeed.low,
    this.isOscillating = false,
  });

  /// Named constructor for a sleep mode (low speed, no oscillation).
  SmartFan.sleepMode({
    required super.id,
    required super.location,
    super.name = 'Smart Fan',
  })  : speed = FanSpeed.low,
        isOscillating = false,
        super(
          isPoweredOn: true,
          isConnected: true,
        );

  /// Named constructor for a turbo/high-speed configuration.
  SmartFan.turbo({
    required super.id,
    required super.location,
    super.name = 'Smart Fan',
  })  : speed = FanSpeed.high,
        isOscillating = true,
        super(
          isPoweredOn: true,
          isConnected: true,
        );

  /// Human-readable speed label.
  String get speedLabel {
    switch (this.speed) {
      case FanSpeed.off:
        return 'Off';
      case FanSpeed.low:
        return 'Low';
      case FanSpeed.medium:
        return 'Medium';
      case FanSpeed.high:
        return 'High';
    }
  }

  /// Speed as a 0–3 integer (useful for sliders).
  int get speedLevel => this.speed.index;

  /// Sets speed from an integer 0–3.
  void setSpeedLevel(int level) {
    this.speed = FanSpeed.values[level.clamp(0, 3)];
    isPoweredOn = this.speed != FanSpeed.off;
  }

  @override
  String getStatus() {
    return (isPoweredOn && speed != FanSpeed.off) ? 'ON' : 'OFF';
  }

  @override
  void performAction() {
    // Cycle through: off → low → medium → high → off
    final nextIndex = (speedLevel + 1) % 4;
    setSpeedLevel(nextIndex);
  }

  @override
  void togglePower() {
    super.togglePower();
    if (!isPoweredOn) {
      this.speed = FanSpeed.off;
    } else if (this.speed == FanSpeed.off) {
      this.speed = FanSpeed.low;
    }
  }
}
