import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinidpay_flutter_plugin/vinidpay_sdk.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _paymentStatus = 'Unknown';
  final bool _sandboxMode = false;
  final _orderIdController = TextEditingController();
  final _signatureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VinIDPay SDK'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _orderIdController,
                  decoration: const InputDecoration(
                    labelText: 'Order ID',
                  ),
                ),
                TextField(
                  controller: _signatureController,
                  decoration: const InputDecoration(
                    labelText: 'Signature',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_orderIdController.text == '' ||
                        _signatureController.text == '') {
                      return;
                    }

                    final String _orderId = _orderIdController.text;
                    final String _signature = _signatureController.text;

                    proceedPayment(
                      _orderId,
                      _signature,
                      _sandboxMode,
                    );
                  },
                  child: Container(
                    color: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: const Text(
                      'Proceed Payment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    isVinIdAppInstalled(_sandboxMode);
                  },
                  child: Container(
                    color: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: const Text(
                      'isVinIdAppInstalled ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    openVinIDInstallPage(_sandboxMode);
                  },
                  child: Container(
                    color: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: const Text(
                      'openVinIDInstallPage',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Sandbox Mode: $_sandboxMode'),
                const SizedBox(height: 8),
                Text('Payment Status: $_paymentStatus'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> proceedPayment(
    String orderId,
    String signature,
    bool sandboxMode,
  ) async {
    VinidpaySdkStatus _status;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _status = await VinidpaySdk.proceedPayment(
        orderId,
        signature,
        sandboxMode,
      );
    } catch (e) {
      print('--------------------- PlatformException $e');
      _status = VinidpaySdkStatus.UNKNOW;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

//    switch (_status) {
//      case VinidpaySdkStatus.SUCCESS:
//
//      case VinidpaySdkStatus.ABORT:
//
//      case VinidpaySdkStatus.FAIL:
//
//      case VinidpaySdkStatus.UNKNOW:
//
//      default:
//
//    }

    setState(() {
      _paymentStatus = _status.toString();
    });
  }

  Future<void> isVinIdAppInstalled(bool sandboxMode) async {
    bool _status;
    _status = await VinidpaySdk.isVinIdAppInstalled(sandboxMode);
    print(_status);
  }

  void openVinIDInstallPage(bool sandboxMode) {
    VinidpaySdk.openVinIDInstallPage(sandboxMode);
  }
}
