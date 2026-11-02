import '../models/models.dart';

/// Repository managing initial and active smart home devices.
///
/// Demonstrates creating device instances using both default and named
/// constructors, displaying exactly one instance of each device category.
class DeviceRepository {
  /// Initial device collection: exactly one of each category (6 devices),
  /// demonstrating both default and named constructors.
  static List<SmartDevice> getInitialDevices() {
    SmartDevice.resetDeviceCount();
    return [
      // 1. SmartLight – Default constructor
      SmartLight(
        id: 'light-chandelier',
        name: 'Living Room Chandelier',
        location: 'Living Room',
        brightness: 75,
        isPoweredOn: true,
      ),

      // 2. Thermostat – Named constructor (.eco)
      Thermostat.eco(
        id: 'thermo-bedroom',
        name: 'Bedroom Climate Unit',
        location: 'Bedroom',
      ),

      // 3. SmartSpeaker – Default constructor
      SmartSpeaker(
        id: 'speaker-kitchen',
        name: 'Kitchen Audio Station',
        location: 'Kitchen',
        volume: 40,
        isPlaying: false,
      ),

      // 4. SmartLock – Named constructor (.secured)
      SmartLock.secured(
        id: 'lock-entrance',
        name: 'Front Door Lock',
        location: 'Entrance',
      ),

      // 5. SmartFan – Default constructor
      SmartFan(
        id: 'fan-bedroom',
        name: 'Master Ceiling Fan',
        location: 'Master Bedroom',
        isPoweredOn: true,
        speed: FanSpeed.medium,
        isOscillating: true,
      ),

      // 6. SecurityCamera – Named constructor (.outdoor)
      SecurityCamera.outdoor(
        id: 'cam-garden',
        name: 'Garden Security Cam',
        location: 'Backyard',
      ),
    ];
  }

  /// Alias returning initial 6 devices (1 of each category).
  static List<SmartDevice> getSample1Devices() => getInitialDevices();
}
