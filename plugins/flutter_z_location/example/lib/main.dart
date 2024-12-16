import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_z_location/flutter_z_location.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  double latitude = 0;
  double longitude = 0;
  String geocodeStr = '';

  String ipInfo = 'ip: ,\ngeocode: ';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterZLocation.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text('Running on: $_platformVersion\n'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  Permission.location.request().then((value) async {
                    final res = await FlutterZLocation.getCoordinate(accuracy: 1);
                    debugPrint(res.toString());
                    setState(() {
                      latitude = res.latitude;
                      longitude = res.longitude;
                      geocodeCoordinate();
                    });
                  });
                },
                child: const Text('getCoordinate'),
              ),
              const SizedBox(height: 12),
              Text(
                'latitude: $latitude \nlongitude: $longitude \ngeocode:$geocodeStr',
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              OutlinedButton(
                onPressed: () async {
                  // 获取ip地址
                  final ipStr = await FlutterZLocation.getIp();
                  // ip反编码出地址
                  final res = await FlutterZLocation.geocodeIp(
                    ipStr,
                    pathHead: 'assets/',
                    hasGetCoordinate: true,
                  );
                  debugPrint(ipStr);
                  debugPrint(res.toString());
                  setState(() {
                    ipInfo = 'ip: $ipStr,\ngeocode: ${res.address}';
                  });
                },
                child: const Text('get ip'),
              ),
              Text(
                ipInfo,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> geocodeCoordinate() async {
    final res = await FlutterZLocation.geocodeCoordinate(latitude, longitude);
    if (kDebugMode) {
      print(res);
    }
    setState(() {
      geocodeStr = res.address;
    });
  }
}
