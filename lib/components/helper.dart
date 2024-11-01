import 'package:flutter/services.dart';

class ScreenSizeHelper {
  static const MethodChannel _channel = MethodChannel('overlay_channel');

  static Future<Map<String, double>> getScreenSize() async {
    final size = await _channel.invokeMethod('getScreenSize');
    return {
      'width': size['width'],
      'height': size['height'],
    };
  }
}
