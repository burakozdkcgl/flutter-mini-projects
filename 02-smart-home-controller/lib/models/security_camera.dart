import 'smart_device.dart';

/// Represents a smart security camera in the smart home system.
///
/// Demonstrates:
/// - **Inheritance**: Extends [SmartDevice].
/// - **Constructors**: Default and named constructors.
/// - **Keywords**: Uses [super], [this].
class SecurityCamera extends SmartDevice {
  /// Whether the camera is actively recording.
  bool isRecording;

  /// Whether motion has been detected recently.
  bool motionDetected;

  /// Camera resolution label (e.g. "1080p", "4K").
  String resolution;

  /// Default constructor for [SecurityCamera].
  SecurityCamera({
    required super.id,
    required super.name,
    required super.location,
    super.isPoweredOn = true,
    super.isConnected = true,
    this.isRecording = false,
    this.motionDetected = false,
    this.resolution = '1080p',
  });

  /// Named constructor for always-on outdoor surveillance.
  SecurityCamera.outdoor({
    required super.id,
    required super.location,
  })  : isRecording = true,
        motionDetected = false,
        resolution = '4K',
        super(
          name: 'Security Camera',
          isPoweredOn: true,
          isConnected: true,
        );

  /// Named constructor for indoor doorbell-style camera.
  SecurityCamera.doorbell({
    required super.id,
    required super.location,
  })  : isRecording = false,
        motionDetected = false,
        resolution = '1080p',
        super(
          name: 'Security Camera',
          isPoweredOn: true,
          isConnected: true,
        );

  @override
  String getStatus() {
    if (!isPoweredOn) return 'OFF';
    if (this.isRecording) return 'Recording';
    return 'Standby';
  }

  @override
  void performAction() {
    toggleRecording();
  }

  /// Toggles recording state.
  ///
  /// Demonstrates [this] keyword to access instance fields.
  void toggleRecording() {
    if (!isPoweredOn) isPoweredOn = true;
    this.isRecording = !isRecording;
  }

  /// Simulates a motion detection event.
  void triggerMotionAlert() {
    this.motionDetected = true;
    if (!isRecording) isRecording = true;
  }

  /// Clears the motion alert flag.
  void clearMotionAlert() {
    this.motionDetected = false;
  }

  @override
  void togglePower() {
    super.togglePower();
    if (!isPoweredOn) {
      isRecording = false;
      motionDetected = false;
    }
  }
}
