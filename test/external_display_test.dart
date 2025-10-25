import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:external_screen/external_display.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('presentation_displays_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'listDisplay':
          return '[{"displayId":0,"name":"Built-in Display","flags":0,"rotation":0}]';
        case 'showPresentation':
          return true;
        case 'hidePresentation':
          return true;
        case 'transferDataToPresentation':
          return true;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('ExternalDisplay Tests', () {
    test('listDisplays returns display list', () async {
      final displays = await ExternalDisplay.listDisplays();
      expect(displays, isNotEmpty);
      expect(displays.first.displayId, 0);
      expect(displays.first.name, 'Built-in Display');
    });

    test('showPresentation returns true', () async {
      final result = await ExternalDisplay.showPresentation(displayId: 1, routerName: '/presentation');
      expect(result, true);
    });

    test('hidePresentation returns true', () async {
      final result = await ExternalDisplay.hidePresentation(1);
      expect(result, true);
    });

    test('transferDataToPresentation returns true', () async {
      final result = await ExternalDisplay.transferDataToPresentation({'message': 'Hello External Display'});
      expect(result, true);
    });

    test('DisplayInfo fromJson creates valid object', () {
      final json = {'displayId': 1, 'name': 'External Monitor', 'flags': 8, 'rotation': 0};

      final display = DisplayInfo.fromJson(json);
      expect(display.displayId, 1);
      expect(display.name, 'External Monitor');
      expect(display.flags, 8);
      expect(display.rotation, 0);
    });

    test('DisplayInfo toJson creates valid map', () {
      final display = DisplayInfo(displayId: 2, name: 'Test Display', flags: 4, rotation: 90);

      final json = display.toJson();
      expect(json['displayId'], 2);
      expect(json['name'], 'Test Display');
      expect(json['flags'], 4);
      expect(json['rotation'], 90);
    });
  });
}
