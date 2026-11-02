import 'smart_device.dart';

/// Represents a wireless smart speaker in the smart home system.
///
/// Demonstrates:
/// - **Inheritance**: Extends the abstract base class [SmartDevice].
/// - **Constructors**: Implements both default and named constructors.
/// - **Keywords**: Uses [super] to initialize superclass properties and [this]
///   for instance member assignments.
class SmartSpeaker extends SmartDevice {
  /// Volume percentage (0 - 100).
  int volume;

  /// Playback state.
  bool isPlaying;

  /// Currently playing audio track or station name.
  String currentTrack;

  /// Default constructor for [SmartSpeaker].
  SmartSpeaker({
    required super.id,
    required super.name,
    required super.location,
    super.isPoweredOn = true,
    super.isConnected = true,
    this.volume = 40,
    this.isPlaying = false,
    this.currentTrack = 'Lo-Fi Study Beats',
  });

  /// Named constructor for a high-volume party configuration.
  ///
  /// Demonstrates named constructors and [super] delegation.
  SmartSpeaker.partyMode({
    required super.id,
    required super.location,
  })  : volume = 80,
        isPlaying = true,
        currentTrack = 'Upbeat Electronic Mix',
        super(
          name: 'Smart Speaker',
          isPoweredOn: true,
          isConnected: true,
        );

  /// Named constructor for a quiet ambient configuration.
  SmartSpeaker.ambient({
    required super.id,
    required super.location,
  })  : volume = 25,
        isPlaying = false,
        currentTrack = 'Nature Sounds & Rain',
        super(
          name: 'Smart Speaker',
          isPoweredOn: true,
          isConnected: true,
        );

  /// Overrides the abstract [getStatus] method from [SmartDevice].
  ///
  /// Returns "Playing" if actively streaming, "Paused" if paused, or "OFF".
  @override
  String getStatus() {
    if (!isPoweredOn) return 'OFF';
    return isPlaying ? 'Playing' : 'Paused';
  }

  /// Overrides the abstract [performAction] method from [SmartDevice].
  ///
  /// Toggles the speaker's playback state between play and pause.
  @override
  void performAction() {
    togglePlayback();
  }

  /// Toggles playback between playing and paused.
  void togglePlayback() {
    if (!isPoweredOn) {
      isPoweredOn = true;
    }
    isPlaying = !isPlaying;
  }

  /// Sets audio volume between 0 and 100.
  ///
  /// Demonstrates [this] to resolve parameter shadowing.
  void setVolume(int volume) {
    this.volume = volume.clamp(0, 100);
  }
}
