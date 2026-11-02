import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'configure_devices_sheet.dart';

/// Card widget rendering a polymorphic [SmartDevice] and its device-specific controls.
class DeviceCard extends StatelessWidget {
  final SmartDevice device;
  final VoidCallback onStateChanged;
  final VoidCallback? onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onStateChanged,
    this.onTap,
  });

  Color get _accent => deviceAccentColor(device);

  LinearGradient get _cardGradient {
    final c = _accent;
    if (!device.isPoweredOn) {
      return const LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)]);
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [c.withValues(alpha: 0.06), c.withValues(alpha: 0.12)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOn = device.isPoweredOn;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: _cardGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isOn ? _accent.withValues(alpha: 0.28) : const Color(0xFFE8EDF2),
            width: 1.5,
          ),
          boxShadow: isOn
              ? [BoxShadow(color: _accent.withValues(alpha: 0.10), blurRadius: 14, offset: const Offset(0, 5))]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 12),
              Expanded(child: _buildInfo()),
              const SizedBox(width: 8),
              _buildControl(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Left icon ────────────────────────────────────────────────────────────
  Widget _buildIcon() {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
        color: device.isPoweredOn ? _accent.withValues(alpha: 0.15) : const Color(0xFFEEF2F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        deviceIcon(device),
        color: device.isPoweredOn ? _accent : const Color(0xFFCBD5E1),
        size: 26,
      ),
    );
  }

  // ── Center info ──────────────────────────────────────────────────────────
  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          device.name,
          style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700,
            color: device.isPoweredOn ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Row(children: [
          const Icon(Icons.location_on_rounded, size: 11, color: Color(0xFF94A3B8)),
          const SizedBox(width: 2),
          Text(device.location, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ]),
        const SizedBox(height: 6),
        _buildProperty(),
        const SizedBox(height: 4),
        _buildStatus(),
      ],
    );
  }

  Widget _buildProperty() {
    String text;
    IconData icon;
    if (device is SmartLight) {
      text = 'Brightness: ${(device as SmartLight).brightness}%';
      icon = Icons.brightness_6_rounded;
    } else if (device is Thermostat) {
      text = 'Temp: ${(device as Thermostat).formattedTemperature}';
      icon = Icons.thermostat_rounded;
    } else if (device is SmartSpeaker) {
      text = 'Volume: ${(device as SmartSpeaker).volume}%';
      icon = Icons.volume_up_rounded;
    } else if (device is SmartLock) {
      final lock = device as SmartLock;
      text = lock.isLocked ? 'Locked' : 'Unlocked';
      icon = Icons.security_rounded;
    } else if (device is SmartFan) {
      text = 'Speed: ${(device as SmartFan).speedLabel}';
      icon = Icons.air_rounded;
    } else if (device is SecurityCamera) {
      text = '${(device as SecurityCamera).resolution} · ${device.getStatus()}';
      icon = Icons.videocam_rounded;
    } else {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: _accent),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _accent)),
      ],
    );
  }

  Widget _buildStatus() {
    final status = device.getStatus();
    final isActive = !['OFF', 'Paused', 'Standby', 'Unlocked'].contains(status);
    final dot = isActive ? AppTheme.statusActiveGreen : AppTheme.statusInactiveGrey;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(
            color: dot, shape: BoxShape.circle,
            boxShadow: isActive
                ? [BoxShadow(color: dot.withValues(alpha: 0.4), blurRadius: 4, spreadRadius: 1)]
                : [],
          ),
        ),
        const SizedBox(width: 5),
        Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFF334155) : const Color(0xFF94A3B8))),
      ],
    );
  }

  // ── Right control ────────────────────────────────────────────────────────
  Widget _buildControl(BuildContext context) {
    final dev = device;

    if (dev is SmartLight) {
      return Switch(
        value: dev.isPoweredOn,
        activeTrackColor: _accent,
        inactiveTrackColor: const Color(0xFFE2E8F0),
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        onChanged: (_) { dev.performAction(); onStateChanged(); },
      );
    }

    if (dev is Thermostat) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circleBtn(Icons.add_rounded, _accent, () { dev.increaseTemperature(); onStateChanged(); }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(dev.formattedTemperature,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _accent)),
          ),
          _circleBtn(Icons.remove_rounded, _accent, () { dev.decreaseTemperature(); onStateChanged(); }),
        ],
      );
    }

    if (dev is SmartSpeaker) {
      return _roundBtn(
        dev.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        _accent,
        () { dev.performAction(); onStateChanged(); },
      );
    }

    if (dev is SmartLock) {
      return _roundBtn(
        dev.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
        _accent,
        () { dev.performAction(); onStateChanged(); },
      );
    }

    if (dev is SmartFan) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circleBtn(Icons.add_rounded, _accent, () { dev.performAction(); onStateChanged(); }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(dev.speedLabel,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _accent)),
          ),
          _circleBtn(Icons.remove_rounded, _accent, () {
            dev.setSpeedLevel(dev.speedLevel > 0 ? dev.speedLevel - 1 : 0);
            onStateChanged();
          }),
        ],
      );
    }

    if (dev is SecurityCamera) {
      return _roundBtn(
        dev.isRecording ? Icons.stop_rounded : Icons.fiber_manual_record_rounded,
        _accent,
        () { dev.performAction(); onStateChanged(); },
      );
    }

    return IconButton(
      icon: const Icon(Icons.power_settings_new_rounded),
      onPressed: () { device.performAction(); onStateChanged(); },
    );
  }

  Widget _circleBtn(IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 30, height: 30,
      child: Material(
        color: color.withValues(alpha: 0.10),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, size: 15, color: color),
        ),
      ),
    );
  }

  Widget _roundBtn(IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 42, height: 42,
      child: Material(
        color: color.withValues(alpha: 0.12),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, size: 22, color: color),
        ),
      ),
    );
  }
}
