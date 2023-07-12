import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'vinidpay_flutter_plugin_method_channel.dart';

abstract class VinidpayFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a VinidpayFlutterPluginPlatform.
  VinidpayFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static VinidpayFlutterPluginPlatform _instance = MethodChannelVinidpayFlutterPlugin();

  /// The default instance of [VinidpayFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelVinidpayFlutterPlugin].
  static VinidpayFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VinidpayFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(VinidpayFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
