import 'package:flutter_test/flutter_test.dart';
import 'package:vinidpay_flutter_plugin/vinidpay_flutter_plugin.dart';
import 'package:vinidpay_flutter_plugin/vinidpay_flutter_plugin_platform_interface.dart';
import 'package:vinidpay_flutter_plugin/vinidpay_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVinidpayFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements VinidpayFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VinidpayFlutterPluginPlatform initialPlatform = VinidpayFlutterPluginPlatform.instance;

  test('$MethodChannelVinidpayFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVinidpayFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    VinidpayFlutterPlugin vinidpayFlutterPlugin = VinidpayFlutterPlugin();
    MockVinidpayFlutterPluginPlatform fakePlatform = MockVinidpayFlutterPluginPlatform();
    VinidpayFlutterPluginPlatform.instance = fakePlatform;

    expect(await vinidpayFlutterPlugin.getPlatformVersion(), '42');
  });
}
