import 'mixins/schedulable.dart';
import 'smart_device.dart';

/// Represents a smart door lock in the smart home system.
///
/// Demonstrates:
/// - **Inheritance**: Extends [SmartDevice].
/// - **Mixin**: Applies [Schedulable] for timed lock/unlock schedules.
/// - **Constructors**: Default and named constructors.
/// - **Keywords**: Uses [super], [this], and [static] (via SmartDevice.totalDevices).
class SmartLock extends SmartDevice with Schedulable {
  /// Whether the lock is currently in the locked position.
  bool isLocked;

  /// Number of incorrect PIN attempts (demonstrates additional state).
  int failedAttempts;

  static const int maxFailedAttempts = 5;

  /// Default constructor for [SmartLock].
  SmartLock({
    required super.id,
    required super.name,
    required super.location,
    super.isPoweredOn = true,
    super.isConnected = true,
    this.isLocked = true,
    this.failedAttempts = 0,
  });

  /// Named constructor for a secure (locked + online) configuration.
  SmartLock.secured({
    required super.id,
    required super.location,
    super.name = 'Smart Lock',
  })  : isLocked = true,
        failedAttempts = 0,
        super(
          isPoweredOn: true,
          isConnected: true,
        );

  /// Named constructor for a guest-access (unlocked) configuration.
  SmartLock.guestMode({
    required super.id,
    required super.location,
    super.name = 'Smart Lock',
  })  : isLocked = false,
        failedAttempts = 0,
        super(
          isPoweredOn: true,
          isConnected: true,
        );

  @override
  String getStatus() {
    if (!isPoweredOn) return 'OFF';
    return isLocked ? 'Locked' : 'Unlocked';
  }

  @override
  void performAction() {
    toggleLock();
  }

  /// Toggles the lock between locked and unlocked.
  ///
  /// Demonstrates [this] keyword usage.
  void toggleLock() {
    this.isLocked = !isLocked;
    if (!isPoweredOn) isPoweredOn = true;
  }

  /// Records a failed unlock attempt.
  void recordFailedAttempt() {
    this.failedAttempts++;
    if (this.failedAttempts >= maxFailedAttempts) {
      isLocked = true; // auto-lock on too many failures
    }
  }

  /// Resets failed attempt counter.
  void resetFailedAttempts() {
    failedAttempts = 0;
  }

  @override
  void togglePower() {
    super.togglePower();
    if (!isPoweredOn) isLocked = true; // always lock when powered off
  }
}
