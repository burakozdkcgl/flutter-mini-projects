/// Mixin providing automated timer and scheduling functionality.
///
/// Demonstrates Dart Mixin capabilities (`with Schedulable`) to add
/// scheduling behaviour across different device types without duplicating code.
mixin Schedulable {
  /// Scheduled operational time string (e.g. "07:30 AM" or "23:00").
  String? scheduledTime;

  /// Target action to trigger on scheduled time (e.g. "Turn ON", "Eco Mode").
  String? scheduledAction;

  /// Whether a schedule is currently active for this device.
  bool get isScheduled => scheduledTime != null && scheduledTime!.isNotEmpty;

  /// Schedules an automated action at the specified [scheduledTime].
  ///
  /// Uses [this] to differentiate between instance fields and parameter names.
  void setSchedule(String scheduledTime, {String action = 'Toggle'}) {
    this.scheduledTime = scheduledTime;
    scheduledAction = action;
  }

  /// Cancels and clears any active schedule on the device.
  void clearSchedule() {
    scheduledTime = null;
    scheduledAction = null;
  }
}
