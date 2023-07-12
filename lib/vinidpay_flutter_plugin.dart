
import 'vinidpay_flutter_plugin_platform_interface.dart';

class VinidpayFlutterPlugin {
  Future<String?> getPlatformVersion() {
    return VinidpayFlutterPluginPlatform.instance.getPlatformVersion();
  }
}
