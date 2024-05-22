import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jni/jni.dart';
import 'package:qr_scanner_api/scanner.dart';

void main() {
  // Jni.spawn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.qr_scanner_api');
  String result = "";

  /// This method won't work because the getCode method was removed from the
  /// Scanner kotlin class.
  void _getScanner() async {
    String? scanned;
    try {
      // final scanner = await Scanner()
      //     .getCode(JObject.fromReference(Jni.getCachedApplicationContext()));
      // scanned = scanner.toDartString();
      // log(scanned.toString(), name: "Scanned Result:");
      
    } on PlatformException catch (e) {
      scanned = "";
      log(e.message.toString(), name: "Error:");
    }
    setState(() {
      result = scanned ?? "";
    });
  }

  void _getScanner2() async {
    String? scanned;
    try {
      final scanner = GmsBarcodeScanning.getClient(
          JObject.fromReference(Jni.getCachedApplicationContext()));
      final result = await Scanner().await0(scanner.startScan());
      scanned = result.getRawValue().toDartString();
    } on PlatformException catch (e) {
      scanned = "";
      log(e.message.toString(), name: "Error:");
    }
    setState(() {
      result = scanned ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ScanResult: ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: Text(
                  result,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getScanner2();
        },
        tooltip: 'Scan',
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
