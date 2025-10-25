import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

/// Display information model
class DisplayInfo {
  final int displayId;
  final String name;
  final int? flags;
  final int? rotation;

  DisplayInfo({required this.displayId, required this.name, this.flags, this.rotation});

  factory DisplayInfo.fromJson(Map<String, dynamic> json) {
    return DisplayInfo(displayId: json['displayId'] as int, name: json['name'] as String, flags: json['flags'] as int?, rotation: json['rotation'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {'displayId': displayId, 'name': name, if (flags != null) 'flags': flags, if (rotation != null) 'rotation': rotation};
  }
}

/// External Display Plugin
class ExternalDisplay {
  static const MethodChannel _channel = MethodChannel('presentation_displays_plugin');

  static const EventChannel _eventChannel = EventChannel('presentation_displays_plugin_events');

  /// Get list of available displays
  ///
  /// [category] is optional (Android only):
  /// - null: All displays
  /// - "android.hardware.display.category.PRESENTATION": Presentation displays only
  static Future<List<DisplayInfo>> listDisplays([String? category]) async {
    try {
      final String? result = await _channel.invokeMethod('listDisplay', category);
      if (result == null || result.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(result);
      return jsonList.map((json) => DisplayInfo.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error listing displays: $e');
      return [];
    }
  }

  /// Show presentation on external display
  ///
  /// [displayId]: The display ID to show presentation on
  /// [routerName]: The route name for the Flutter view
  static Future<bool> showPresentation({required int displayId, required String routerName}) async {
    try {
      final arguments = json.encode({'displayId': displayId, 'routerName': routerName});

      final result = await _channel.invokeMethod('showPresentation', arguments);
      return result == true;
    } catch (e) {
      print('Error showing presentation: $e');
      return false;
    }
  }

  /// Hide presentation from external display
  ///
  /// [displayId]: The display ID to hide presentation from
  static Future<bool> hidePresentation(int displayId) async {
    try {
      final arguments = json.encode({'displayId': displayId});

      final result = await _channel.invokeMethod('hidePresentation', arguments);
      return result == true;
    } catch (e) {
      print('Error hiding presentation: $e');
      return false;
    }
  }

  /// Transfer data to presentation display
  ///
  /// [data]: Any JSON-serializable data to transfer
  static Future<bool> transferDataToPresentation(dynamic data) async {
    try {
      final result = await _channel.invokeMethod('transferDataToPresentation', data);
      return result == true;
    } catch (e) {
      print('Error transferring data: $e');
      return false;
    }
  }

  /// Stream of display connection events
  ///
  /// Emits:
  /// - 1: Display connected
  /// - 0: Display disconnected
  static Stream<int> get displayConnectionStream {
    return _eventChannel.receiveBroadcastStream().map((event) => event as int);
  }
}
