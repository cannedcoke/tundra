import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gal/gal.dart';

class Edit extends StatefulWidget {
  final File image;
  const Edit({super.key, required this.image});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  ColorFilter? _currentFilter;

  // Create a controller — this wraps the widget you want to capture
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<int> _getAndroidVersion() async {
    final info = await DeviceInfoPlugin().androidInfo;
    return info.version.sdkInt;
  }

  // Request permission depending on Android version / iOS
  Future<void> _saveImage() async {
    PermissionStatus result;

    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 13) {
        result = await Permission.photos.request();
      } else {
        result = await Permission.storage.request();
      }
    } else {
      result = await Permission.photos.request();
    }

    if (!result.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }

    try {
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes == null) throw Exception('Failed to capture image');

      // Saveto gallery
      await Gal.putImageBytes(imageBytes);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved to gallery!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start the editing'), centerTitle: true),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: _saveImage, // ④ Hook up the save function
          child: const Icon(Icons.save),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            //  Screenshot
            child: Screenshot(
              controller: _screenshotController,
              child: ColorFiltered(
                colorFilter:
                    _currentFilter ??
                    const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    ),
                child: Image.file(widget.image, fit: BoxFit.contain),
              ),
            ),
          ),
          Row(
            children: [
              _buildSquareButton(
                "50's",
                () => _applyFilter(
                  const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                ),
              ),
              _buildSquareButton(
                "Hell",
                () => _applyFilter(
                  const ColorFilter.mode(Colors.redAccent, BlendMode.softLight),
                ),
              ),
              _buildSquareButton(
                "Ice",
                () => _applyFilter(
                  const ColorFilter.mode(
                    Colors.blueAccent,
                    BlendMode.softLight,
                  ),
                ),
              ),
              _buildSquareButton(
                "Warm",
                () => _applyFilter(
                  const ColorFilter.mode(
                    Colors.orangeAccent,
                    BlendMode.overlay,
                  ),
                ),
              ),
              _buildSquareButton(
                "green",
                () => _applyFilter(
                  const ColorFilter.mode(
                    Color.fromARGB(255, 43, 247, 7),
                    BlendMode.overlay,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyFilter(ColorFilter filter) {
    setState(() => _currentFilter = filter);
  }

  Widget _buildSquareButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 80),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(label),
      ),
    );
  }
}
