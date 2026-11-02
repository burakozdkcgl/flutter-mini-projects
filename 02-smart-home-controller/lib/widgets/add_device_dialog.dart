import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Dialog enabling users to create and add new smart devices at runtime.
///
/// Demonstrates:
/// - Dynamic object instantiation.
/// - Selecting between **Default** and **Named** constructors.
/// - Watching [SmartDevice.totalDevices] static counter update automatically.
class AddDeviceDialog extends StatefulWidget {
  final Function(SmartDevice device) onDeviceCreated;

  const AddDeviceDialog({
    super.key,
    required this.onDeviceCreated,
  });

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  String _selectedType = 'Smart Light';
  String _constructorChoice = 'Default';
  final TextEditingController _locationController = TextEditingController(text: 'Balcony');

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.add_circle_outline, color: AppTheme.primaryBlue),
          SizedBox(width: 8),
          Text(
            'Add Smart Device',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Type',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: const [
                DropdownMenuItem(value: 'Smart Light', child: Text('Smart Light')),
                DropdownMenuItem(value: 'Thermostat', child: Text('Thermostat')),
                DropdownMenuItem(value: 'Smart Speaker', child: Text('Smart Speaker')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedType = val);
                }
              },
            ),

            const SizedBox(height: 14),

            const Text(
              'Location / Room',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'e.g. Garden, Kitchen, Study',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Constructor Mode',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _constructorChoice,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: [
                const DropdownMenuItem(
                  value: 'Default',
                  child: Text('Default Constructor'),
                ),
                DropdownMenuItem(
                  value: 'Named',
                  child: Text(_getNamedConstructorLabel()),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _constructorChoice = val);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _createDevice,
          child: const Text('Create Device'),
        ),
      ],
    );
  }

  String _getNamedConstructorLabel() {
    switch (_selectedType) {
      case 'Smart Light':
        return 'Named (SmartLight.dimmed)';
      case 'Thermostat':
        return 'Named (Thermostat.eco)';
      case 'Smart Speaker':
        return 'Named (SmartSpeaker.partyMode)';
      default:
        return 'Named Constructor';
    }
  }

  void _createDevice() {
    final location = _locationController.text.trim().isEmpty
        ? 'Living Room'
        : _locationController.text.trim();
    final newId = 'dev-${DateTime.now().millisecondsSinceEpoch}';

    SmartDevice newDevice;

    if (_selectedType == 'Smart Light') {
      if (_constructorChoice == 'Named') {
        // Named constructor
        newDevice = SmartLight.dimmed(id: newId, location: location);
      } else {
        // Default constructor
        newDevice = SmartLight(
          id: newId,
          name: 'Smart Light',
          location: location,
          brightness: 80,
          isPoweredOn: true,
        );
      }
    } else if (_selectedType == 'Thermostat') {
      if (_constructorChoice == 'Named') {
        // Named constructor
        newDevice = Thermostat.eco(id: newId, location: location);
      } else {
        // Default constructor
        newDevice = Thermostat(
          id: newId,
          name: 'Thermostat',
          location: location,
          temperature: 23.0,
          isPoweredOn: true,
        );
      }
    } else {
      if (_constructorChoice == 'Named') {
        // Named constructor
        newDevice = SmartSpeaker.partyMode(id: newId, location: location);
      } else {
        // Default constructor
        newDevice = SmartSpeaker(
          id: newId,
          name: 'Smart Speaker',
          location: location,
          volume: 50,
          isPlaying: true,
        );
      }
    }

    widget.onDeviceCreated(newDevice);
    Navigator.pop(context);
  }
}
