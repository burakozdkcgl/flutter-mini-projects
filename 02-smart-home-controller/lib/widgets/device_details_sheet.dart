import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'configure_devices_sheet.dart';

/// Modal bottom sheet with detailed controls for a selected [SmartDevice].
class DeviceDetailsSheet extends StatefulWidget {
  final SmartDevice device;
  final VoidCallback onUpdated;

  const DeviceDetailsSheet({super.key, required this.device, required this.onUpdated});

  @override
  State<DeviceDetailsSheet> createState() => _DeviceDetailsSheetState();
}

class _DeviceDetailsSheetState extends State<DeviceDetailsSheet> {
  SmartDevice get dev => widget.device;
  Color get accent => deviceAccentColor(dev);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scroll) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            // Handle
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
              ),
            ),
            // Hero card
            _buildHero(),
            const SizedBox(height: 16),
            // Controls
            _sectionLabel('Controls'),
            const SizedBox(height: 8),
            _buildControls(),
            const SizedBox(height: 16),
            // Features (Connectable + Schedulable)
            _sectionLabel('Features'),
            const SizedBox(height: 8),
            _buildFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
          letterSpacing: 0.9, color: Color(0xFF94A3B8)));

  // ── Hero ──────────────────────────────────────────────────────────────────
  Widget _buildHero() {
    final status = dev.getStatus();
    final isActive = !['OFF', 'Paused', 'Standby'].contains(status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(deviceIcon(dev), color: accent, size: 32),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dev.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.location_on_rounded, size: 13, color: Color(0xFF94A3B8)),
              const SizedBox(width: 2),
              Text(dev.location, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            ]),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? accent.withValues(alpha: 0.15) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 6, height: 6,
                    decoration: BoxDecoration(
                        color: isActive ? AppTheme.statusActiveGreen : AppTheme.statusInactiveGrey,
                        shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                    color: isActive ? accent : const Color(0xFF64748B))),
              ]),
            ),
          ],
        )),
        // Power toggle
        Column(children: [
          const Text('Power', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Switch(
            value: dev.isPoweredOn,
            activeTrackColor: accent,
            thumbColor: WidgetStateProperty.all(Colors.white),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            onChanged: (_) { setState(() => dev.togglePower()); widget.onUpdated(); },
          ),
        ]),
      ]),
    );
  }

  // ── Controls (device-specific) ────────────────────────────────────────────
  Widget _buildControls() {
    if (dev is SmartLight) return _lightControls(dev as SmartLight);
    if (dev is Thermostat) return _thermoControls(dev as Thermostat);
    if (dev is SmartSpeaker) return _speakerControls(dev as SmartSpeaker);
    if (dev is SmartLock) return _lockControls(dev as SmartLock);
    if (dev is SmartFan) return _fanControls(dev as SmartFan);
    if (dev is SecurityCamera) return _cameraControls(dev as SecurityCamera);
    return const SizedBox.shrink();
  }

  Widget _sliderCard({
    required IconData icon, required String label, required String valueLabel,
    required double value, required double min, required double max,
    required int divisions, required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF2)),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF334155))),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(valueLabel, style: TextStyle(fontWeight: FontWeight.w700, color: accent, fontSize: 13)),
          ),
        ]),
        Slider(value: value, min: min, max: max, divisions: divisions,
            activeColor: accent, inactiveColor: accent.withValues(alpha: 0.15),
            onChanged: onChanged),
      ]),
    );
  }

  Widget _lightControls(SmartLight d) => _sliderCard(
    icon: Icons.brightness_6_rounded, label: 'Brightness', valueLabel: '${d.brightness}%',
    value: d.brightness.toDouble(), min: 0, max: 100, divisions: 20,
    onChanged: (v) { setState(() => d.setBrightness(v.round())); widget.onUpdated(); },
  );

  Widget _thermoControls(Thermostat d) => Column(children: [
    _sliderCard(
      icon: Icons.thermostat_rounded, label: 'Target Temperature', valueLabel: d.formattedTemperature,
      value: d.temperature, min: Thermostat.minTemperature, max: Thermostat.maxTemperature, divisions: 44,
      onChanged: (v) { setState(() => d.setTemperature(v)); widget.onUpdated(); },
    ),
    const SizedBox(height: 10),
    Row(children: [
      Expanded(child: _quickBtn(Icons.ac_unit_rounded, 'Eco  19°C', const Color(0xFF0EA5E9),
          () { setState(() => d.setTemperature(19)); widget.onUpdated(); })),
      const SizedBox(width: 10),
      Expanded(child: _quickBtn(Icons.local_fire_department_rounded, 'Comfort  23°C', AppTheme.thermoAccent,
          () { setState(() => d.setTemperature(23)); widget.onUpdated(); })),
    ]),
  ]);

  Widget _speakerControls(SmartSpeaker d) => Column(children: [
    _sliderCard(
      icon: Icons.volume_up_rounded, label: 'Volume', valueLabel: '${d.volume}%',
      value: d.volume.toDouble(), min: 0, max: 100, divisions: 20,
      onChanged: (v) { setState(() => d.setVolume(v.round())); widget.onUpdated(); },
    ),
    const SizedBox(height: 10),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EDF2))),
      child: Row(children: [
        Container(width: 40, height: 40,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.music_note_rounded, color: accent, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Now Playing', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          Text(d.currentTrack, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              overflow: TextOverflow.ellipsis),
        ])),
        GestureDetector(
          onTap: () { setState(() => d.togglePlayback()); widget.onUpdated(); },
          child: Container(width: 38, height: 38,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: Icon(d.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 22)),
        ),
      ]),
    ),
  ]);

  Widget _lockControls(SmartLock d) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF2))),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 72, height: 72,
            decoration: BoxDecoration(
              color: d.isLocked ? accent.withValues(alpha: 0.1) : AppTheme.statusActiveGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(d.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                color: d.isLocked ? accent : AppTheme.statusActiveGreen, size: 36)),
      ]),
      const SizedBox(height: 12),
      Text(d.isLocked ? 'Door is Locked' : 'Door is Unlocked',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
              color: d.isLocked ? accent : AppTheme.statusActiveGreen)),
      const SizedBox(height: 14),
      SizedBox(width: double.infinity, child: _quickBtn(
        d.isLocked ? Icons.lock_open_rounded : Icons.lock_rounded,
        d.isLocked ? 'Unlock' : 'Lock',
        d.isLocked ? AppTheme.statusActiveGreen : accent,
        () { setState(() => d.toggleLock()); widget.onUpdated(); },
      )),
      if (d.failedAttempts > 0) ...[
        const SizedBox(height: 8),
        Text('Failed attempts: ${d.failedAttempts}',
            style: const TextStyle(fontSize: 12, color: Color(0xFFEF4444))),
      ],
    ]),
  );

  Widget _fanControls(SmartFan d) => Column(children: [
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EDF2))),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(Icons.air_rounded, size: 16, color: accent),
            const SizedBox(width: 8),
            const Text('Fan Speed', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(d.speedLabel, style: TextStyle(fontWeight: FontWeight.w700, color: accent, fontSize: 13)),
          ),
        ]),
        Slider(value: d.speedLevel.toDouble(), min: 0, max: 3, divisions: 3,
            activeColor: accent, inactiveColor: accent.withValues(alpha: 0.15),
            label: d.speedLabel,
            onChanged: (v) { setState(() => d.setSpeedLevel(v.round())); widget.onUpdated(); }),
      ]),
    ),
    const SizedBox(height: 10),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EDF2))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Icon(Icons.rotate_right_rounded, color: d.isOscillating ? accent : const Color(0xFFCBD5E1), size: 20),
          const SizedBox(width: 8),
          const Text('Oscillation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ]),
        Switch(value: d.isOscillating, activeTrackColor: accent,
            thumbColor: WidgetStateProperty.all(Colors.white),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            onChanged: (v) { setState(() => d.isOscillating = v); widget.onUpdated(); }),
      ]),
    ),
  ]);

  Widget _cameraControls(SecurityCamera d) => Column(children: [
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EDF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(width: 8, height: 8,
                decoration: BoxDecoration(
                    color: d.isRecording ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1),
                    shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(d.isRecording ? 'Recording' : 'Standby',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14,
                    color: d.isRecording ? const Color(0xFFEF4444) : const Color(0xFF64748B))),
          ]),
          Text(d.resolution, style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: _quickBtn(
          d.isRecording ? Icons.stop_rounded : Icons.fiber_manual_record_rounded,
          d.isRecording ? 'Stop Recording' : 'Start Recording',
          d.isRecording ? const Color(0xFFEF4444) : accent,
          () { setState(() => d.toggleRecording()); widget.onUpdated(); },
        )),
        if (d.motionDetected) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFED7AA))),
            child: Row(children: [
              const Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFF97316)),
              const SizedBox(width: 6),
              const Text('Motion detected!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF97316))),
              const Spacer(),
              GestureDetector(
                onTap: () { setState(() => d.clearMotionAlert()); widget.onUpdated(); },
                child: const Text('Dismiss', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ),
            ]),
          ),
        ],
      ]),
    ),
  ]);

  Widget _quickBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        ]),
      ),
    );
  }

  // ── Features (Connectable + Schedulable) ──────────────────────────────────
  Widget _buildFeatures() {
    return Row(children: [
      Expanded(child: _featureCard(
        icon: dev.isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
        label: dev.isConnected ? 'Connected' : 'Disconnected',
        sub: 'Connectable interface',
        active: dev.isConnected,
        color: AppTheme.statusActiveGreen,
        onTap: () { setState(() { dev.isConnected ? dev.disconnect() : dev.connect(); }); widget.onUpdated(); },
      )),
      if (dev is Schedulable) ...[
        const SizedBox(width: 10),
        Expanded(child: _featureCard(
          icon: Icons.schedule_rounded,
          label: (dev as Schedulable).isScheduled ? (dev as Schedulable).scheduledTime! : 'Set Schedule',
          sub: 'Schedulable mixin',
          active: (dev as Schedulable).isScheduled,
          color: AppTheme.primary,
          onTap: () {
            setState(() {
              final s = dev as Schedulable;
              s.isScheduled ? s.clearSchedule() : s.setSchedule('07:30 AM', action: 'Auto ON');
            });
            widget.onUpdated();
          },
        )),
      ],
    ]);
  }

  Widget _featureCard({
    required IconData icon, required String label, required String sub,
    required bool active, required Color color, required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.07) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? color.withValues(alpha: 0.25) : const Color(0xFFE8EDF2)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 20, color: active ? color : const Color(0xFF94A3B8)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
              color: active ? color : const Color(0xFF94A3B8))),
          Text(sub, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
        ]),
      ),
    );
  }
}
