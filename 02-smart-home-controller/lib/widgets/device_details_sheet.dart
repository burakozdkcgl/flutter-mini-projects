import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Modal bottom sheet displaying detailed parameters, interactive sliders,
/// and OOP concept annotations for a selected [SmartDevice].
class DeviceDetailsSheet extends StatefulWidget {
  final SmartDevice device;
  final VoidCallback onUpdated;

  const DeviceDetailsSheet({
    super.key,
    required this.device,
    required this.onUpdated,
  });

  @override
  State<DeviceDetailsSheet> createState() => _DeviceDetailsSheetState();
}

class _DeviceDetailsSheetState extends State<DeviceDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    final dev = widget.device;

    return Container(
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header: Name & Power Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dev.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          dev.location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Power Switch
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: dev.isPoweredOn,
                  onChanged: (val) {
                    setState(() {
                      dev.togglePower();
                    });
                    widget.onUpdated();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          // Device-Specific Interactive Controls (Sliders / Steppers)
          _buildSpecializedControls(),

          const SizedBox(height: 16),

          // Mixin & Interface Feature Row (Connectable & Schedulable)
          _buildOopFeaturesSection(),

          const SizedBox(height: 16),

          // OOP Architecture Summary Card (For instructors & code inspection)
          _buildOopArchitectureCard(),
        ],
      ),
    );
  }

  Widget _buildSpecializedControls() {
    final dev = widget.device;

    if (dev is SmartLight) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Brightness Control',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                '${dev.brightness}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          Slider(
            value: dev.brightness.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: const Color(0xFFF59E0B),
            onChanged: (val) {
              setState(() {
                dev.setBrightness(val.round());
              });
              widget.onUpdated();
            },
          ),
        ],
      );
    } else if (dev is Thermostat) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Temperature',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                dev.formattedTemperature,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          Slider(
            value: dev.temperature,
            min: Thermostat.minTemperature,
            max: Thermostat.maxTemperature,
            divisions: 44, // 0.5 deg step
            activeColor: const Color(0xFFEF4444),
            onChanged: (val) {
              setState(() {
                dev.setTemperature(val);
              });
              widget.onUpdated();
            },
          ),
        ],
      );
    } else if (dev is SmartSpeaker) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Audio Volume',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                '${dev.volume}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          Slider(
            value: dev.volume.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: AppTheme.primaryBlue,
            onChanged: (val) {
              setState(() {
                dev.setVolume(val.round());
              });
              widget.onUpdated();
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.music_note, size: 18, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Track: ${dev.currentTrack}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  /// Demonstrates the [Connectable] interface and [Schedulable] mixin methods.
  Widget _buildOopFeaturesSection() {
    final dev = widget.device;

    return Row(
      children: [
        // Connectable Interface Button
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              side: BorderSide(
                color: dev.isConnected ? AppTheme.statusActiveGreen : const Color(0xFFCBD5E1),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: Icon(
              dev.isConnected ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: dev.isConnected ? AppTheme.statusActiveGreen : const Color(0xFF64748B),
            ),
            label: Text(
              dev.isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                fontSize: 12,
                color: dev.isConnected ? AppTheme.statusActiveGreen : const Color(0xFF64748B),
              ),
            ),
            onPressed: () {
              setState(() {
                if (dev.isConnected) {
                  dev.disconnect();
                } else {
                  dev.connect();
                }
              });
              widget.onUpdated();
            },
          ),
        ),

        // Schedulable Mixin Feature (if applicable)
        if (dev is Schedulable) ...[
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                side: BorderSide(
                  color: (dev as Schedulable).isScheduled
                      ? AppTheme.primaryBlue
                      : const Color(0xFFCBD5E1),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(
                Icons.schedule,
                size: 16,
                color: (dev as Schedulable).isScheduled
                    ? AppTheme.primaryBlue
                    : const Color(0xFF64748B),
              ),
              label: Text(
                (dev as Schedulable).isScheduled
                    ? (dev as Schedulable).scheduledTime!
                    : 'Set Schedule',
                style: TextStyle(
                  fontSize: 12,
                  color: (dev as Schedulable).isScheduled
                      ? AppTheme.primaryBlue
                      : const Color(0xFF64748B),
                ),
              ),
              onPressed: () => _toggleSchedule(dev as Schedulable),
            ),
          ),
        ],
      ],
    );
  }

  void _toggleSchedule(Schedulable schedulable) {
    setState(() {
      if (schedulable.isScheduled) {
        schedulable.clearSchedule();
      } else {
        schedulable.setSchedule('07:30 AM', action: 'Auto ON');
      }
    });
    widget.onUpdated();
  }

  Widget _buildOopArchitectureCard() {
    final dev = widget.device;
    final className = dev.runtimeType.toString();
    final hasSchedulable = dev is Schedulable;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OOP Implementation Details',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '• Class: $className extends SmartDevice\n'
            '• Interface: implements Connectable (isConnected: ${dev.isConnected})\n'
            '• Mixin: ${hasSchedulable ? "with Schedulable (isScheduled: ${(dev as Schedulable).isScheduled})" : "None"}\n'
            '• Abstract getStatus(): "${dev.getStatus()}"\n'
            '• Static: SmartDevice.totalDevices = ${SmartDevice.totalDevices}',
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF475569),
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
