import '../models/models.dart';

/// Repository managing initial and active smart home devices.
///
/// Demonstrates:
/// - Creating multiple device instances.
/// - Displaying at least one instance of each subclass (`SmartLight`, `Thermostat`, `SmartSpeaker`).
/// - Instantiating devices using **both default and named constructors**.
class DeviceRepository {
  /// Loads the default device collection matching the assignment requirements.
  ///
  /// Demonstrates both default and named constructor invocations across all classes.
  static List<SmartDevice> getInitialDevices() {
    // Reset static device count before creating the initial set
    SmartDevice.resetDeviceCount();

    return [
      // 1. SmartLight instantiated via DEFAULT constructor
      SmartLight(
        id: 'light-living-room',
        name: 'Smart Light',
        location: 'Living Room',
        brightness: 75,
        isPoweredOn: true,
      ),

      // 2. SmartLight instantiated via NAMED constructor (.standard)
      SmartLight.standard(
        id: 'light-kitchen',
        location: 'Kitchen',
        brightness: 50,
      ),

      // 3. Thermostat instantiated via DEFAULT constructor
      Thermostat(
        id: 'thermostat-bedroom',
        name: 'Thermostat',
        location: 'Bedroom',
        temperature: 22.0,
        isPoweredOn: true,
      ),

      // 4. Thermostat instantiated via NAMED constructor (.eco)
      Thermostat.eco(
        id: 'thermostat-living-room',
        location: 'Living Room',
      ),

      // 5. SmartSpeaker instantiated via DEFAULT constructor
      SmartSpeaker(
        id: 'speaker-kitchen',
        name: 'Smart Speaker',
        location: 'Kitchen',
        volume: 40,
        isPlaying: false,
      ),

      // 6. SmartSpeaker instantiated via NAMED constructor (.ambient)
      SmartSpeaker.ambient(
        id: 'speaker-office',
        location: 'Office',
      ),
    ];
  }

  /// Preset matching Sample Screen 1 from the assignment PDF (3 devices).
  static List<SmartDevice> getSample1Devices() {
    SmartDevice.resetDeviceCount();
    return [
      SmartLight(
        id: 'light-living-room',
        name: 'Smart Light',
        location: 'Living Room',
        brightness: 75,
        isPoweredOn: true,
      ),
      Thermostat(
        id: 'thermostat-bedroom',
        name: 'Thermostat',
        location: 'Bedroom',
        temperature: 22.0,
        isPoweredOn: true,
      ),
      SmartSpeaker(
        id: 'speaker-kitchen',
        name: 'Smart Speaker',
        location: 'Kitchen',
        volume: 40,
        isPlaying: false,
      ),
    ];
  }

  /// Preset matching Sample Screen 2 from the assignment PDF (5 devices).
  static List<SmartDevice> getSample2Devices() {
    SmartDevice.resetDeviceCount();
    return [
      SmartLight(
        id: 'light-living-room',
        name: 'Smart Light',
        location: 'Living Room',
        brightness: 0,
        isPoweredOn: false,
      ),
      SmartLight.standard(
        id: 'light-kitchen',
        location: 'Kitchen',
        brightness: 50,
      ),
      Thermostat(
        id: 'thermostat-bedroom',
        name: 'Thermostat',
        location: 'Bedroom',
        temperature: 24.0,
        isPoweredOn: true,
      ),
      SmartSpeaker(
        id: 'speaker-kitchen',
        name: 'Smart Speaker',
        location: 'Kitchen',
        volume: 40,
        isPlaying: true,
      ),
      SmartSpeaker.ambient(
        id: 'speaker-office',
        location: 'Office',
      ),
    ];
  }
}
