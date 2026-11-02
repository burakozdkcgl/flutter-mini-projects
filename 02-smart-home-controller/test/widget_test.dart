import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_controller/main.dart';
import 'package:smart_home_controller/models/models.dart';

void main() {
  group('Smart Device OOP Principles Tests', () {
    setUp(() {
      SmartDevice.resetDeviceCount();
    });

    test('Static totalDevices increments with constructors', () {
      expect(SmartDevice.totalDevices, 0);

      // Default constructor
      final light = SmartLight(
        id: 'light-1',
        name: 'Smart Light',
        location: 'Living Room',
      );
      expect(SmartDevice.totalDevices, 1);
      expect(light.getStatus(), 'OFF');

      // Named constructor
      final ecoThermostat = Thermostat.eco(
        id: 'thermo-1',
        location: 'Bedroom',
      );
      expect(SmartDevice.totalDevices, 2);
      expect(ecoThermostat.temperature, 19.0);
      expect(ecoThermostat.getStatus(), 'Cooling');

      // Another named constructor
      final partySpeaker = SmartSpeaker.partyMode(
        id: 'speaker-1',
        location: 'Hall',
      );
      expect(SmartDevice.totalDevices, 3);
      expect(partySpeaker.volume, 80);
      expect(partySpeaker.isPlaying, isTrue);
      expect(partySpeaker.getStatus(), 'Playing');
    });

    test('Inheritance and Abstraction contracts', () {
      final SmartDevice light = SmartLight(
        id: 'l1',
        name: 'Desk Light',
        location: 'Study',
        isPoweredOn: true,
      );

      // Polymorphic method calls
      expect(light.getStatus(), 'ON');
      light.performAction();
      expect(light.getStatus(), 'OFF');
    });

    test('Connectable Interface implementation', () {
      final SmartDevice speaker = SmartSpeaker(
        id: 's1',
        name: 'HiFi',
        location: 'Lounge',
      );

      expect(speaker.isConnected, isTrue);
      speaker.disconnect();
      expect(speaker.isConnected, isFalse);
      speaker.connect();
      expect(speaker.isConnected, isTrue);
    });

    test('Schedulable Mixin functionality', () {
      final light = SmartLight(
        id: 'l2',
        name: 'Porch Light',
        location: 'Entrance',
      );

      expect(light.isScheduled, isFalse);
      light.setSchedule('08:00 PM', action: 'Turn ON');
      expect(light.isScheduled, isTrue);
      expect(light.scheduledTime, '08:00 PM');
      expect(light.scheduledAction, 'Turn ON');

      light.clearSchedule();
      expect(light.isScheduled, isFalse);
    });

    test('Thermostat temperature controls', () {
      final thermo = Thermostat(
        id: 't1',
        name: 'AC',
        location: 'Bedroom',
        temperature: 22.0,
      );

      expect(thermo.formattedTemperature, '22°C');
      thermo.increaseTemperature();
      expect(thermo.temperature, 23.0);
      expect(thermo.getStatus(), 'Heating');

      thermo.decreaseTemperature(4.0);
      expect(thermo.temperature, 19.0);
      expect(thermo.getStatus(), 'Cooling');
    });
  });

  group('UI Screens & Widgets Smoke Test', () {
    testWidgets('Renders devices, controls, and bottom static counter', (tester) async {
      await tester.pumpWidget(const SmartHomeControllerApp());
      await tester.pumpAndSettle();

      // Verify AppBar
      expect(find.text('Smart Home Controller'), findsOneWidget);

      // Verify Sample 1 device cards
      expect(find.text('Smart Light: Living Room'), findsOneWidget);
      expect(find.text('Thermostat: Bedroom'), findsOneWidget);
      expect(find.text('Smart Speaker: Kitchen'), findsOneWidget);

      // Verify Bottom bar static device counter
      expect(find.text('Total Devices: 3'), findsOneWidget);

      // Verify Switch interaction for light
      final lightSwitch = find.byType(Switch).first;
      expect(lightSwitch, findsOneWidget);
      await tester.tap(lightSwitch);
      await tester.pumpAndSettle();

      // Verify Thermostat [+] button
      expect(find.byIcon(Icons.add), findsWidgets);
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();
      expect(find.text('Temperature: 23°C'), findsOneWidget);

      // Verify Speaker Play button
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.text('Status: Playing'), findsOneWidget);
    });
  });
}
