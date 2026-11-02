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

      final light = SmartLight(
        id: 'light-1',
        name: 'Desk Light',
        location: 'Living Room',
      );
      expect(SmartDevice.totalDevices, 1);
      expect(light.getStatus(), 'OFF');

      final ecoThermostat = Thermostat.eco(
        id: 'thermo-1',
        name: 'Eco AC',
        location: 'Bedroom',
      );
      expect(SmartDevice.totalDevices, 2);
      expect(ecoThermostat.temperature, 19.0);
      expect(ecoThermostat.getStatus(), 'Cooling');

      final partySpeaker = SmartSpeaker.partyMode(
        id: 'speaker-1',
        location: 'Hall',
      );
      expect(SmartDevice.totalDevices, 3);
      expect(partySpeaker.volume, 80);
      expect(partySpeaker.isPlaying, isTrue);
      expect(partySpeaker.getStatus(), 'Playing');

      final lock = SmartLock.secured(id: 'lock-1', location: 'Front Door');
      expect(SmartDevice.totalDevices, 4);
      expect(lock.isLocked, isTrue);
      expect(lock.getStatus(), 'Locked');

      final fan = SmartFan.sleepMode(id: 'fan-1', location: 'Bedroom');
      expect(SmartDevice.totalDevices, 5);
      expect(fan.speed, FanSpeed.low);
      expect(fan.getStatus(), 'Low');

      final cam = SecurityCamera.outdoor(id: 'cam-1', location: 'Garden');
      expect(SmartDevice.totalDevices, 6);
      expect(cam.isRecording, isTrue);
      expect(cam.getStatus(), 'Recording');
    });

    test('Inheritance and Abstraction contracts', () {
      final SmartDevice light = SmartLight(
        id: 'l1',
        name: 'Desk Light',
        location: 'Study',
        isPoweredOn: true,
      );

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

    test('SmartLock toggling and failed attempts', () {
      final lock = SmartLock.secured(id: 'l3', location: 'Back Door');
      expect(lock.isLocked, isTrue);
      lock.performAction();
      expect(lock.isLocked, isFalse);
      expect(lock.getStatus(), 'Unlocked');
    });

    test('SmartFan speed cycling', () {
      final fan = SmartFan(id: 'f1', name: 'Smart Fan', location: 'Office');
      expect(fan.speed, FanSpeed.low);
      fan.performAction();
      expect(fan.speed, FanSpeed.medium);
    });
  });

  group('UI Screens & Widgets Smoke Test', () {
    testWidgets('Renders exactly one of each category, controls, and bottom static counter', (tester) async {
      await tester.pumpWidget(const SmartHomeControllerApp());
      await tester.pumpAndSettle();

      // Verify Header Titles
      expect(find.text('Smart Home'), findsOneWidget);
      expect(find.text('Controller'), findsOneWidget);

      // Verify Initial device cards in viewport (1 of each category)
      expect(find.text('Living Room Chandelier'), findsOneWidget);
      expect(find.text('Bedroom Climate Unit'), findsOneWidget);
      expect(find.text('Kitchen Audio Station'), findsOneWidget);

      // Verify Bottom bar static device counter (exactly 6 devices = 1 per category)
      expect(find.text('Total Devices: 6'), findsOneWidget);

      // Verify Switch interaction for light
      final lightSwitch = find.byType(Switch).first;
      expect(lightSwitch, findsOneWidget);
      await tester.tap(lightSwitch);
      await tester.pumpAndSettle();

      // Verify Thermostat [+] button
      expect(find.byIcon(Icons.add_rounded), findsWidgets);
      await tester.tap(find.byIcon(Icons.add_rounded).first);
      await tester.pumpAndSettle();
      expect(find.text('Temp: 20°C'), findsOneWidget);

      // Verify Speaker Play button
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });

    testWidgets('Can open Configure sheet and Add a new device with custom name', (tester) async {
      await tester.pumpWidget(const SmartHomeControllerApp());
      await tester.pumpAndSettle();

      // Tap Configure button in header
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      // Configure sheet should be open
      expect(find.text('Configure Devices'), findsOneWidget);

      // Tap Add Device button inside configure sheet
      final addBtn = find.widgetWithText(ElevatedButton, 'Add Device');
      expect(addBtn, findsOneWidget);
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      // Add Device dialog should be open
      expect(find.text('Device Type'), findsOneWidget);
      expect(find.text('Lock'), findsOneWidget);

      // Select 'Lock' category
      await tester.tap(find.text('Lock'));
      await tester.pumpAndSettle();

      // Enter custom device name
      final nameField = find.widgetWithText(TextField, 'Door Lock');
      expect(nameField, findsOneWidget);
      await tester.enterText(nameField, 'Garage Smart Bolt');
      await tester.pumpAndSettle();

      // Tap 'Create'
      final createBtn = find.widgetWithText(FilledButton, 'Create');
      expect(createBtn, findsOneWidget);
      await tester.tap(createBtn);
      await tester.pumpAndSettle();

      // Verify Total Devices incremented to 7 and snackbar appeared with custom name
      expect(find.text('Total Devices: 7'), findsOneWidget);
      expect(find.text('Garage Smart Bolt added to Living Room'), findsOneWidget);
    });
  });
}
