import 'package:flutter/material.dart';
import '../data/device_repository.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/add_device_dialog.dart';
import '../widgets/device_card.dart';
import '../widgets/device_details_sheet.dart';

/// Main screen displaying the Smart Home Controller dashboard.
///
/// Implements:
/// - **Device List**: Displays cards for Smart Light, Thermostat, and Smart Speaker.
/// - **Device Information**: Shows title, property (brightness/temperature/volume), and status.
/// - **Interaction**: Controls for each device type (Switch, [+/-], Play/Pause).
/// - **Bottom Text**: Displays total created devices retrieved from the static
///   property [SmartDevice.totalDevices].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<SmartDevice> _devices;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Initialize with Sample 1 (3 devices) matching assignment PDF figure 1
    _devices = DeviceRepository.getSample1Devices();
  }

  void _loadPreset(int sampleNumber) {
    setState(() {
      if (sampleNumber == 1) {
        _devices = DeviceRepository.getSample1Devices();
      } else if (sampleNumber == 2) {
        _devices = DeviceRepository.getSample2Devices();
      } else {
        _devices = DeviceRepository.getInitialDevices();
      }
    });
  }

  void _addNewDevice(SmartDevice newDevice) {
    setState(() {
      _devices.add(newDevice);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Created ${newDevice.name} at ${newDevice.location}'),
        backgroundColor: AppTheme.primaryBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<SmartDevice> get _filteredDevices {
    if (_selectedFilter == 'Lights') {
      return _devices.whereType<SmartLight>().toList();
    } else if (_selectedFilter == 'Thermostats') {
      return _devices.whereType<Thermostat>().toList();
    } else if (_selectedFilter == 'Speakers') {
      return _devices.whereType<SmartSpeaker>().toList();
    }
    return _devices;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredDevices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Controller'),
        actions: [
          // Preset selector to easily showcase Sample 1 (3 devices) & Sample 2 (5 devices)
          PopupMenuButton<int>(
            icon: const Icon(Icons.tune),
            tooltip: 'Load Sample Presets',
            onSelected: _loadPreset,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 1,
                child: Text('Sample 1 (3 Devices - Initial)'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Sample 2 (5 Devices - Multi-room)'),
              ),
              PopupMenuItem(
                value: 3,
                child: Text('Full Showcase (6 Devices)'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'OOP Architecture Info',
            onPressed: _showOopInfoDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          _buildFilterChips(),

          // Device Cards List
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'No devices found for this filter.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final device = filteredList[index];
                      return DeviceCard(
                        key: ValueKey(device.id),
                        device: device,
                        onStateChanged: () => setState(() {}),
                        onTap: () => _openDeviceDetails(device),
                      );
                    },
                  ),
          ),

          // Bottom Bar displaying Total Devices from static variable
          _buildBottomBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add),
        label: const Text('Add Device'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddDeviceDialog(
              onDeviceCreated: _addNewDevice,
            ),
          );
        },
      ),
    );
  }

  /// Horizontal category filter row.
  Widget _buildFilterChips() {
    final categories = ['All', 'Lights', 'Thermostats', 'Speakers'];

    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedFilter == cat;
          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.12),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppTheme.primaryBlue : const Color(0xFF475569),
            ),
            side: BorderSide(
              color: isSelected ? AppTheme.primaryBlue : const Color(0xFFE2E8F0),
            ),
            backgroundColor: Colors.white,
            onSelected: (_) {
              setState(() => _selectedFilter = cat);
            },
          );
        },
      ),
    );
  }

  /// Bottom text bar displaying total created devices.
  ///
  /// Requirement: "Bottom Text: Display the total number of created devices.
  /// This value must come from a static variable in your class implementation."
  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // MUST come directly from SmartDevice.totalDevices static variable
              'Total Devices: ${SmartDevice.totalDevices}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Static variable',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDeviceDetails(SmartDevice device) {
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

  void _showOopInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('BIM493 Assignment #2 Checklist'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Object-Oriented Programming Principles Applied:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 8),
              Text(
                '✔ Class: Base class SmartDevice and subclasses SmartLight, Thermostat, SmartSpeaker.\n\n'
                '✔ Objects: Multiple instances created, at least one per subclass.\n\n'
                '✔ Constructor: Both default and named constructors (e.g. .standard, .eco, .ambient, .dimmed).\n\n'
                '✔ Inheritance: SmartLight, Thermostat, SmartSpeaker extend SmartDevice.\n\n'
                '✔ Abstraction: SmartDevice is abstract with getStatus() & performAction().\n\n'
                '✔ Interface: Connectable interface implemented with connect() & disconnect().\n\n'
                '✔ Mixin: Schedulable mixin applied with `with Schedulable`.\n\n'
                '✔ Keywords: `static` (SmartDevice.totalDevices), `super`, and `this` explicitly utilized.',
                style: TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF334155)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
