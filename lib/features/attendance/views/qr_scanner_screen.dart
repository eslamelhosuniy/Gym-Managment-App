import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          if (scanned) return;

          final Barcode? barcode = capture.barcodes.firstOrNull;
          final String? code = barcode?.rawValue;

          if (code != null) {
            scanned = true;

            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}