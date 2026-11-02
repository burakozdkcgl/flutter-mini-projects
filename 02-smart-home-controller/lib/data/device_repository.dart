import '../models/models.dart';

/// Repository managing initial and active smart home devices.
///
/// Demonstrates creating multiple device instances using both
/// default and named constructors across all device subclasses.
class DeviceRepository {
  /// Initial 3-device set matching the assignment minimum requirement.
  static List<SmartDevice> getSample1Devices() {
    SmartDevice.resetDeviceCount();
    return [
      // Default constructor
      SmartLight(
        id: 'light-living',
        name: 'Smart Light',
        location: 'Living Room',
        brightness: 75,
        isPoweredOn: true,
      ),
      // Default constructor
      Thermostat(
        id: 'thermo-bedroom',
        name: 'Thermostat',
        location: 'Bedroom',
        temperature: 22.0,
        isPoweredOn: true,
      ),
      // Default constructor
      SmartSpeaker(
        id: 'speaker-kitchen',
        name: 'Smart Speaker',
        location: 'Kitchen',
        volume: 40,
        isPlaying: false,
      ),
    ];
  }

  /// Full showcase with all 6 device types, using both default & named ctors.
  static List<SmartDevice> getInitialDevices() {
    SmartDevice.resetDeviceCount();
    return [
      // SmartLight – default constructor
      SmartLight(
        id: 'light-living',
        name: 'Smart Light',
        location: 'Living Room',
        brightness: 75,
        isPoweredOn: true,
      ),
      // SmartLight – named constructor
      SmartLight.dimmed(
        id: 'light-bedroom',
        location: 'Bedroom',
      ),
      // Thermostat – default constructor
      Thermostat(
        id: 'thermo-bedroom',
        name: 'Thermostat',
        location: 'Bedroom',
        temperature: 22.0,
        isPoweredOn: true,
      ),
      // Thermostat – named constructor (.eco)
      Thermostat.eco(
        id: 'thermo-living',
        location: 'Living Room',
      ),
      // SmartSpeaker – default constructor
      SmartSpeaker(
        id: 'speaker-kitchen',
        name: 'Smart Speaker',
        location: 'Kitchen',
        volume: 40,
        isPlaying: false,
      ),
      // SmartSpeaker – named constructor (.ambient)
      SmartSpeaker.ambient(
        id: 'speaker-office',
        location: 'Office',
      ),
      // SmartLock – named constructor (.secured)
      SmartLock.secured(
        id: 'lock-front',
        location: 'Front Door',
      ),
      // SmartLock – named constructor (.guestMode)
      SmartLock.guestMode(
        id: 'lock-garage',
        location: 'Garage',
      ),
      // SmartFan – default constructor
      SmartFan(
        id: 'fan-bedroom',
        name: 'Smart Fan',
        location: 'Bedroom',
        isPoweredOn: true,
        speed: FanSpeed.medium,
        isOscillating: true,
      ),
      // SmartFan – named constructor (.sleepMode)
      SmartFan.sleepMode(
        id: 'fan-nursery',
        location: 'Nursery',
      ),
      // SecurityCamera – named constructor (.outdoor)
      SecurityCamera.outdoor(
        id: 'cam-garden',
        location: 'Garden',
      ),
      // SecurityCamera – named constructor (.doorbell)
      SecurityCamera.doorbell(
        id: 'cam-door',
        location: 'Front Door',
      ),
    ];
  }

  /// 5-device multi-room preset (assignment sample 2 equivalent).
  static List<SmartDevice> getSample2Devices() {
    SmartDevice.resetDeviceCount();
    return [
      SmartLight(
        id: 'light-living',
        name: 'Smart Light',
        location: 'Living Room',
        brightness: 0,
        isPoweredOn: false,
      ),
      SmartLight.standard(id: 'light-kitchen', location: 'Kitchen', brightness: 50),
      Thermostat(id: 'thermo-bedroom', name: 'Thermostat', location: 'Bedroom', temperature: 24.0, isPoweredOn: true),
      SmartSpeaker(id: 'speaker-kitchen', name: 'Smart Speaker', location: 'Kitchen', volume: 40, isPlaying: true),
      SmartLock.secured(id: 'lock-front', location: 'Front Door'),
    ];
  }
}
