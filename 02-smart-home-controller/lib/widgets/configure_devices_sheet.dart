import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Returns device type label string for a given SmartDevice.
String deviceTypeLabel(SmartDevice d) {
  if (d is SmartLight) return 'Smart Light';
  if (d is Thermostat) return 'Thermostat';
  if (d is SmartSpeaker) return 'Smart Speaker';
  if (d is SmartLock) return 'Smart Lock';
  if (d is SmartFan) return 'Smart Fan';
  if (d is SecurityCamera) return 'Security Camera';
  return 'Device';
}

/// Returns the accent color for a device type.
Color deviceAccentColor(SmartDevice d) {
  if (d is SmartLight) return AppTheme.lightAccent;
  if (d is Thermostat) return AppTheme.thermoAccent;
  if (d is SmartSpeaker) return AppTheme.speakerAccent;
  if (d is SmartLock) return const Color(0xFF0EA5E9);
  if (d is SmartFan) return const Color(0xFF14B8A6);
  if (d is SecurityCamera) return const Color(0xFFF97316);
  return AppTheme.primary;
}

/// Returns the icon for a device.
IconData deviceIcon(SmartDevice d) {
  if (d is SmartLight) return d.isPoweredOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded;
  if (d is Thermostat) return Icons.thermostat_rounded;
  if (d is SmartSpeaker) return d.isPlaying ? Icons.graphic_eq_rounded : Icons.speaker_rounded;
  if (d is SmartLock) return d.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded;
  if (d is SmartFan) return Icons.air_rounded;
  if (d is SecurityCamera) return d.isRecording ? Icons.videocam_rounded : Icons.videocam_off_rounded;
  return Icons.devices_other_rounded;
}

/// Bottom sheet for managing all smart devices:
/// add, edit name/location, or remove any device.
class ConfigureDevicesSheet extends StatefulWidget {
  final List<SmartDevice> devices;
  final VoidCallback onRefresh;
  final void Function(SmartDevice) onAdd;
  final void Function(SmartDevice, String name, String location) onEdit;
  final void Function(SmartDevice) onRemove;

  const ConfigureDevicesSheet({
    super.key,
    required this.devices,
    required this.onRefresh,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  State<ConfigureDevicesSheet> createState() => _ConfigureDevicesSheetState();
}

class _ConfigureDevicesSheetState extends State<ConfigureDevicesSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle + Title ──────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(bottom: BorderSide(color: Color(0xFFE8EDF2))),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        gradient: AppTheme.headerGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Configure Devices',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                          Text('Add, edit or remove devices',
                              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Device list ─────────────────────────────────────────────────
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: widget.devices.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No devices yet. Add one below!',
                          style: TextStyle(color: Color(0xFF94A3B8))),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: widget.devices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final device = widget.devices[index];
                      return _DeviceManageRow(
                        device: device,
                        onEdit: () => _openEditDialog(device),
                        onRemove: () => _confirmRemove(device),
                      );
                    },
                  ),
          ),

          // ── Add Device button ───────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE8EDF2))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppTheme.headerGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: const Text('Add Device',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                  onPressed: () => _openAddDialog(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Add ─────────────────────────────────────────────────────────────────
  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _AddDeviceDialog(
        onCreated: (device) {
          widget.onAdd(device);
          setState(() {});
        },
      ),
    );
  }

  // ── Edit ────────────────────────────────────────────────────────────────
  void _openEditDialog(SmartDevice device) {
    showDialog(
      context: context,
      builder: (ctx) => _EditDeviceDialog(
        device: device,
        onSaved: (name, location) {
          widget.onEdit(device, name, location);
          setState(() {});
        },
      ),
    );
  }

  // ── Remove ──────────────────────────────────────────────────────────────
  void _confirmRemove(SmartDevice device) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Device', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text(
          'Remove "${device.name}" from ${device.location}?\nThis action cannot be undone.',
          style: const TextStyle(color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: const Text('Remove'),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onRemove(device);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

// ── Per-device row inside the sheet ─────────────────────────────────────────
class _DeviceManageRow extends StatelessWidget {
  final SmartDevice device;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _DeviceManageRow({
    required this.device,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final accent = deviceAccentColor(device);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EDF2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(deviceIcon(device), color: accent, size: 22),
        ),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A)),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 11, color: Color(0xFF94A3B8)),
            const SizedBox(width: 2),
            Text(device.location,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                deviceTypeLabel(device),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: accent),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit
            _iconBtn(Icons.edit_rounded, const Color(0xFF64748B), onEdit),
            const SizedBox(width: 4),
            // Remove
            _iconBtn(Icons.delete_outline_rounded, const Color(0xFFEF4444), onRemove),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onPressed) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }
}

// ── Edit Dialog ──────────────────────────────────────────────────────────────
class _EditDeviceDialog extends StatefulWidget {
  final SmartDevice device;
  final void Function(String name, String location) onSaved;

  const _EditDeviceDialog({required this.device, required this.onSaved});

  @override
  State<_EditDeviceDialog> createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<_EditDeviceDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _locationCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.device.name);
    _locationCtrl = TextEditingController(text: widget.device.location);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = deviceAccentColor(widget.device);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.edit_rounded, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Edit Device',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          // Type — read-only
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Icon(Icons.category_rounded, size: 16, color: accent),
                const SizedBox(width: 8),
                Text(deviceTypeLabel(widget.device),
                    style: TextStyle(fontWeight: FontWeight.w600, color: accent, fontSize: 13)),
                const Spacer(),
                const Icon(Icons.lock_rounded, size: 13, color: Color(0xFFCBD5E1)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Name
          _field(controller: _nameCtrl, label: 'Device Name', icon: Icons.label_rounded),
          const SizedBox(height: 10),
          // Location
          _field(controller: _locationCtrl, label: 'Location / Room', icon: Icons.location_on_rounded),
        ],
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            final name = _nameCtrl.text.trim().isEmpty ? widget.device.name : _nameCtrl.text.trim();
            final loc = _locationCtrl.text.trim().isEmpty ? widget.device.location : _locationCtrl.text.trim();
            widget.onSaved(name, loc);
            Navigator.pop(context);
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryLight, width: 1.5),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
      ),
    );
  }
}

// ── Add Device Dialog ────────────────────────────────────────────────────────
class _AddDeviceDialog extends StatefulWidget {
  final void Function(SmartDevice) onCreated;
  const _AddDeviceDialog({required this.onCreated});

  @override
  State<_AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<_AddDeviceDialog> {
  String _selectedType = 'Smart Light';
  String _constructorMode = 'Default';
  late final TextEditingController _nameCtrl;
  final _locationCtrl = TextEditingController(text: 'Living Room');

  static const _types = [
    ('Smart Light', Icons.lightbulb_rounded, AppTheme.lightAccent),
    ('Thermostat', Icons.thermostat_rounded, AppTheme.thermoAccent),
    ('Smart Speaker', Icons.speaker_rounded, AppTheme.speakerAccent),
    ('Smart Lock', Icons.lock_rounded, Color(0xFF0EA5E9)),
    ('Smart Fan', Icons.air_rounded, Color(0xFF14B8A6)),
    ('Security Camera', Icons.videocam_rounded, Color(0xFFF97316)),
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: 'Main Light');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  String _defaultNameFor(String type) {
    switch (type) {
      case 'Smart Light':     return 'Ceiling Light';
      case 'Thermostat':      return 'Main Thermostat';
      case 'Smart Speaker':   return 'Sound System';
      case 'Smart Lock':      return 'Door Lock';
      case 'Smart Fan':       return 'Ceiling Fan';
      case 'Security Camera': return 'Security Camera';
      default:                return 'Smart Device';
    }
  }

  void _selectType(String type) {
    setState(() {
      _selectedType = type;
      _nameCtrl.text = _defaultNameFor(type);
    });
  }

  Widget _buildTypeBtn((String, IconData, Color) entry) {
    final (type, icon, color) = entry;
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _selectType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color.withValues(alpha: 0.6) : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? color : const Color(0xFF94A3B8), size: 22),
              const SizedBox(height: 4),
              Text(
                type.split(' ').last,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Text('Add Device',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const Text('Device Type',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      letterSpacing: 0.8, color: Color(0xFF94A3B8))),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTypeBtn(_types[0]),
                  const SizedBox(width: 8),
                  _buildTypeBtn(_types[1]),
                  const SizedBox(width: 8),
                  _buildTypeBtn(_types[2]),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTypeBtn(_types[3]),
                  const SizedBox(width: 8),
                  _buildTypeBtn(_types[4]),
                  const SizedBox(width: 8),
                  _buildTypeBtn(_types[5]),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Device Name',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      letterSpacing: 0.8, color: Color(0xFF94A3B8))),
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. Reading Lamp, Ceiling Fan…',
                  prefixIcon: const Icon(Icons.label_rounded, size: 18, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryLight, width: 1.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Location',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      letterSpacing: 0.8, color: Color(0xFF94A3B8))),
              const SizedBox(height: 8),
              TextField(
                controller: _locationCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. Kitchen, Bedroom…',
                  prefixIcon: const Icon(Icons.location_on_rounded, size: 18, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryLight, width: 1.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Constructor Mode',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      letterSpacing: 0.8, color: Color(0xFF94A3B8))),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _ctorBtn('Default', Icons.build_rounded)),
                  const SizedBox(width: 8),
                  Expanded(child: _ctorBtn('Named', Icons.auto_fix_high_rounded)),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _create,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Widget _ctorBtn(String value, IconData icon) {
    final isSelected = _constructorMode == value;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _constructorMode = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.07) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? AppTheme.primary : const Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.primary : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _create() {
    final rawName = _nameCtrl.text.trim();
    final name = rawName.isEmpty ? _defaultNameFor(_selectedType) : rawName;
    final location = _locationCtrl.text.trim().isEmpty ? 'Living Room' : _locationCtrl.text.trim();
    final id = 'dev-${DateTime.now().millisecondsSinceEpoch}';
    final named = _constructorMode == 'Named';

    SmartDevice device;
    switch (_selectedType) {
      case 'Smart Light':
        device = named
            ? SmartLight.dimmed(id: id, name: name, location: location)
            : SmartLight(id: id, name: name, location: location, brightness: 80, isPoweredOn: true);
        break;
      case 'Thermostat':
        device = named
            ? Thermostat.eco(id: id, name: name, location: location)
            : Thermostat(id: id, name: name, location: location, temperature: 22.0, isPoweredOn: true);
        break;
      case 'Smart Speaker':
        device = named
            ? SmartSpeaker.ambient(id: id, name: name, location: location)
            : SmartSpeaker(id: id, name: name, location: location, volume: 40, isPlaying: false);
        break;
      case 'Smart Lock':
        device = named
            ? SmartLock.secured(id: id, name: name, location: location)
            : SmartLock(id: id, name: name, location: location, isLocked: true);
        break;
      case 'Smart Fan':
        device = named
            ? SmartFan.sleepMode(id: id, name: name, location: location)
            : SmartFan(id: id, name: name, location: location, isPoweredOn: true, speed: FanSpeed.low);
        break;
      case 'Security Camera':
      default:
        device = named
            ? SecurityCamera.outdoor(id: id, name: name, location: location)
            : SecurityCamera(id: id, name: name, location: location, isRecording: false);
        break;
    }

    Navigator.pop(context);
    widget.onCreated(device);
  }
}
