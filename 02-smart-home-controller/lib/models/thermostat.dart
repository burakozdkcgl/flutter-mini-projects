import 'mixins/schedulable.dart';
import 'smart_device.dart';

/// Represents a digital smart thermostat in the smart home system.
///
/// Demonstrates:
/// - **Inheritance**: Extends the abstract base class [SmartDevice].
/// - **Mixin**: Applies [Schedulable] for scheduled heating/cooling cycles.
/// - **Constructors**: Implements both default and named constructors.
/// - **Keywords**: Uses [super] and [this].
class Thermostat extends SmartDevice with Schedulable {
  /// Target temperature in Celsius (°C).
  double temperature;

  /// Min and max allowed temperature thresholds.
  static const double minTemperature = 10.0;
  static const double maxTemperature = 32.0;

  /// Default constructor for [Thermostat].
  Thermostat({
    required super.id,
    required super.name,
    required super.location,
    super.isPoweredOn = true,
    super.isConnected = true,
    this.temperature = 22.0,
  });

  /// Named constructor for energy-saving Eco profile.
  ///
  /// Demonstrates named constructors and [super] delegation.
  Thermostat.eco({
    required super.id,
    required super.location,
  })  : temperature = 19.0,
        super(
          name: 'Thermostat',
          isPoweredOn: true,
          isConnected: true,
        );

  /// Formatted temperature display (e.g. "22°C" or "22.5°C").
  String get formattedTemperature {
    if (temperature == temperature.roundToDouble()) {
      return '${temperature.toInt()}°C';
    }
    return '${temperature.toStringAsFixed(1)}°C';
  }

  /// Overrides the abstract [getStatus] method from [SmartDevice].
  ///
  /// Returns "Heating", "Cooling", or "OFF" based on current state.
  @override
  String getStatus() {
    if (!isPoweredOn) return 'OFF';
    if (temperature >= 21.0) {
      return 'Heating';
    } else {
      return 'Cooling';
    }
  }

  /// Overrides the abstract [performAction] method from [SmartDevice].
  ///
  /// In thermostats, performing primary action toggles between eco and comfort target.
  @override
  void performAction() {
    if (temperature <= 20.0) {
      setTemperature(23.0);
    } else {
      setTemperature(19.0);
    }
  }

  /// Increases target temperature by [step] (default +1°C).
  void increaseTemperature([double step = 1.0]) {
    setTemperature(temperature + step);
  }

  /// Decreases target temperature by [step] (default -1°C).
  void decreaseTemperature([double step = 1.0]) {
    setTemperature(temperature - step);
  }

  /// Safely sets temperature within allowable bounds.
  ///
  /// Demonstrates the [this] keyword to resolve parameter shadowing.
  void setTemperature(double temperature) {
    this.temperature = temperature.clamp(minTemperature, maxTemperature);
    if (!isPoweredOn) {
      isPoweredOn = true;
    }
  }
}
