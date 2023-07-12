import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vinidpay_flutter_plugin_platform_interface.dart';

/// An implementation of [VinidpayFlutterPluginPlatform] that uses method channels.
class MethodChannelVinidpayFlutterPlugin extends VinidpayFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vinidpay_flutter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
