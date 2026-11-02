import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Card widget rendering a polymorphic [SmartDevice] and its device-specific controls.
///
/// Demonstrates runtime polymorphism: receives a base [SmartDevice] reference
/// and renders specialized icons, properties, and controls based on the dynamic subclass.
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: device.isPoweredOn
              ? AppTheme.primaryBlue.withValues(alpha: 0.18)
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Device Icon Container
              _buildDeviceIcon(),
              const SizedBox(width: 14),

              // Device Information (Title, Property, Status)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      device.displayTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _getPropertyText(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _buildStatusIndicator(),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Device-specific Action Control
              _buildDeviceControl(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the left circular device icon with category-specific tinting.
  Widget _buildDeviceIcon() {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    if (device is SmartLight) {
      final isLightOn = device.isPoweredOn;
      iconData = isLightOn ? Icons.lightbulb : Icons.lightbulb_outline;
      iconColor = isLightOn ? const Color(0xFFEAB308) : const Color(0xFF94A3B8);
      bgColor = isLightOn
          ? const Color(0xFFFEF3C7)
          : const Color(0xFFF1F5F9);
    } else if (device is Thermostat) {
      iconData = Icons.thermostat;
      iconColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEE2E2);
    } else if (device is SmartSpeaker) {
      final isPlaying = (device as SmartSpeaker).isPlaying;
      iconData = isPlaying ? Icons.speaker_group : Icons.speaker;
      iconColor = const Color(0xFF2563EB);
      bgColor = const Color(0xFFDBEAFE);
    } else {
      iconData = Icons.devices_other;
      iconColor = const Color(0xFF64748B);
      bgColor = const Color(0xFFF1F5F9);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 26,
      ),
    );
  }

  /// Returns the device-specific property string (Brightness, Temperature, or Volume).
  String _getPropertyText() {
    final dev = device;
    if (dev is SmartLight) {
      return 'Brightness: ${dev.brightness}%';
    } else if (dev is Thermostat) {
      return 'Temperature: ${dev.formattedTemperature}';
    } else if (dev is SmartSpeaker) {
      return 'Volume: ${dev.volume}%';
    }
    return '';
  }

  /// Builds the status text accompanied by an active/inactive colored dot.
  Widget _buildStatusIndicator() {
    final status = device.getStatus();
    final isActive = status == 'ON' || status == 'Heating' || status == 'Playing';
    final dotColor = isActive
        ? AppTheme.statusActiveGreen
        : AppTheme.statusInactiveGrey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'Status: $status',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFF334155) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// Builds device-specific interactive controls:
  /// - Switch for Smart Light
  /// - [-] and [+] buttons for Thermostat
  /// - Play/Pause button for Smart Speaker
  Widget _buildDeviceControl(BuildContext context) {
    final dev = device;

    if (dev is SmartLight) {
      return Switch(
        value: dev.isPoweredOn,
        onChanged: (bool value) {
          dev.performAction();
          onStateChanged();
        },
      );
    } else if (dev is Thermostat) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Temperature Button (-)
          _buildCircleButton(
            icon: Icons.remove,
            onPressed: () {
              dev.decreaseTemperature();
              onStateChanged();
            },
          ),
          const SizedBox(width: 8),
          // Increase Temperature Button (+)
          _buildCircleButton(
            icon: Icons.add,
            onPressed: () {
              dev.increaseTemperature();
              onStateChanged();
            },
          ),
        ],
      );
    } else if (dev is SmartSpeaker) {
      final isPlaying = dev.isPlaying;
      return Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: AppTheme.primaryBlue,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 22,
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () {
            dev.performAction();
            onStateChanged();
          },
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.power_settings_new),
      onPressed: () {
        device.performAction();
        onStateChanged();
      },
    );
  }

  /// Circular helper button for adjustment controls like [-] and [+].
  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        color: Colors.white,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: const Color(0xFF475569)),
        onPressed: onPressed,
      ),
    );
  }
}
