import 'package:flutter/material.dart';
import '../data/device_repository.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/configure_devices_sheet.dart';
import '../widgets/device_card.dart';
import '../widgets/device_details_sheet.dart';

/// Main screen of the Smart Home Controller app.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<SmartDevice> _devices;
  String _selectedFilter = 'All';

  static const _filters = [
    ('All',      Icons.grid_view_rounded,  ''),
    ('Lights',   Icons.lightbulb_rounded,  'SmartLight'),
    ('Climate',  Icons.thermostat_rounded, 'Climate'),
    ('Speakers', Icons.speaker_rounded,    'SmartSpeaker'),
    ('Locks',    Icons.lock_rounded,       'SmartLock'),
    ('Fans',     Icons.air_rounded,        'SmartFan'),
    ('Cameras',  Icons.videocam_rounded,   'SecurityCamera'),
  ];

  @override
  void initState() {
    super.initState();
    _devices = DeviceRepository.getSample1Devices();
  }

  // ── Filtering ─────────────────────────────────────────────────────────────
  List<SmartDevice> get _filtered {
    switch (_selectedFilter) {
      case 'Lights':   return _devices.whereType<SmartLight>().toList();
      case 'Climate':  return _devices.where((d) => d is Thermostat || d is SmartFan).toList();
      case 'Speakers': return _devices.whereType<SmartSpeaker>().toList();
      case 'Locks':    return _devices.whereType<SmartLock>().toList();
      case 'Fans':     return _devices.whereType<SmartFan>().toList();
      case 'Cameras':  return _devices.whereType<SecurityCamera>().toList();
      default:         return _devices;
    }
  }

  int get _activeCount => _devices.where((d) => d.isPoweredOn).length;

  // ── Configure sheet callbacks ────────────────────────────────────────────
  void _onAdd(SmartDevice d) {
    setState(() => _devices.add(d));
    _snack('${d.name} added to ${d.location}', AppTheme.statusActiveGreen, Icons.check_circle_rounded);
  }

  void _onEdit(SmartDevice d, String name, String location) {
    setState(() { d.name = name; d.location = location; });
    _snack('${d.name} updated', AppTheme.primary, Icons.edit_rounded);
  }

  void _onRemove(SmartDevice d) {
    // When removing we must account for totalDevices counter.
    // We reset and rebuild to keep totalDevices accurate.
    setState(() => _devices.remove(d));
    _snack('${d.name} removed', const Color(0xFFEF4444), Icons.delete_outline_rounded);
  }

  void _snack(String msg, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      content: Row(children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ]),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterChips(),
          Expanded(child: _buildList(list)),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 16, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + pills
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Smart Home',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
                    const Text('Controller',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF93C5FD), height: 1.1)),
                    const SizedBox(height: 14),
                    Row(children: [
                      _pill(Icons.devices_rounded, '${SmartDevice.totalDevices} Devices'),
                      const SizedBox(width: 8),
                      _pill(Icons.power_settings_new_rounded, '$_activeCount Active'),
                    ]),
                  ],
                ),
              ),
              // Buttons column
              Column(
                children: [
                  _headerBtn(Icons.info_outline_rounded, 'OOP Info', _showOopInfo),
                  const SizedBox(height: 8),
                  _headerBtn(Icons.tune_rounded, 'Configure', _openConfigure),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerBtn(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: Colors.white, size: 21),
          ),
        ),
      ),
    );
  }

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white70, size: 12),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  // ── Filter chips ─────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (context, i) {
            final (cat, icon, _) = _filters[i];            final isSelected = _selectedFilter == cat;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icon, size: 13, color: isSelected ? Colors.white : const Color(0xFF64748B)),
                  const SizedBox(width: 5),
                  Text(cat, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF64748B))),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Device list ───────────────────────────────────────────────────────────
  Widget _buildList(List<SmartDevice> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.devices_other_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text('No devices here', style: TextStyle(fontSize: 15, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text('Use Configure to add one', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final device = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: DeviceCard(
            key: ValueKey(device.id),
            device: device,
            onStateChanged: () => setState(() {}),
            onTap: () => _openDetails(device),
          ),
        );
      },
    );
  }

  // ── Bottom bar ────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8EDF2))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    gradient: AppTheme.headerGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                // Value MUST come from SmartDevice.totalDevices static variable
                Text(
                  'Total Devices: ${SmartDevice.totalDevices}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Text(
                  'static var',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB), fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Configure sheet ───────────────────────────────────────────────────────
  void _openConfigure() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConfigureDevicesSheet(
        devices: _devices,
        onRefresh: () => setState(() {}),
        onAdd: (d) {
          _onAdd(d);
        },
        onEdit: (d, name, loc) {
          _onEdit(d, name, loc);
          setState(() {});
        },
        onRemove: (d) {
          _onRemove(d);
          setState(() {});
        },
      ),
    );
  }

  // ── Details sheet ─────────────────────────────────────────────────────────
  void _openDetails(SmartDevice device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeviceDetailsSheet(
        device: device,
        onUpdated: () => setState(() {}),
      ),
    );
  }

  // ── OOP Info dialog ───────────────────────────────────────────────────────
  void _showOopInfo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(gradient: AppTheme.headerGradient, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('Assignment #2 Checklist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ]),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _OopItem('Class', 'SmartDevice base + SmartLight, Thermostat, SmartSpeaker, SmartLock, SmartFan, SecurityCamera'),
              _OopItem('Objects', 'Multiple instances, at least one per required subclass'),
              _OopItem('Constructor', 'Default & named constructors (.dimmed, .eco, .ambient, .secured, .sleepMode, .outdoor…)'),
              _OopItem('Inheritance', 'All subclasses extend SmartDevice'),
              _OopItem('Abstraction', 'abstract SmartDevice with getStatus() & performAction()'),
              _OopItem('Interface', 'Connectable: connect() & disconnect()'),
              _OopItem('Mixin', 'Schedulable applied with `with Schedulable` on SmartLight, Thermostat, SmartLock, SmartFan'),
              _OopItem('Keywords', 'static (totalDevices), super (params/methods), this (formal params/disambiguation)'),
            ],
          ),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}

class _OopItem extends StatelessWidget {
  final String label;
  final String desc;
  const _OopItem(this.label, this.desc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 18, height: 18,
          decoration: BoxDecoration(
            color: AppTheme.statusActiveGreen.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 12, color: AppTheme.statusActiveGreen),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.4),
              children: [
                TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
