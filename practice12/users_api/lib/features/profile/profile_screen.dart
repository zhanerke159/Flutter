import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../settings/settings_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _say(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null) return; // Cancel
      final dir = await getApplicationDocumentsDirectory();
      final saved = await File(picked.path).copy('${dir.path}/avatar.jpg');
      await FileImage(saved)
          .evict(); // same path -> drop the stale cached image
      if (!mounted) return;
      await context.read<SettingsModel>().setAvatarPath(saved.path);
    } on PlatformException {
      if (!mounted) return;
      _say('Could not get the photo');
    }
  }

  Future<void> _takePhoto() async {
    // At the moment of the tap, never in initState.
    final status = await Permission.camera.request();
    if (!mounted) return;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        await _pick(ImageSource.camera);
      case PermissionStatus.denied:
        _say(
          'The camera is needed only to take your profile photo. '
          'You can also choose one from the gallery.',
        );
      case PermissionStatus.restricted:
        _say('The camera is restricted on this device.');
      case PermissionStatus.permanentlyDenied:
        await _showSettingsDialog();
    }
  }

  Future<void> _showSettingsDialog() {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Camera access is off'),
        content: const Text(
          'To take a photo, allow the camera in the app settings. '
          'You can still choose a photo from the gallery.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await openAppSettings();
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = context.select<SettingsModel, String?>((s) => s.avatarPath);
    final file = path == null ? null : File(path);
    // existsSync(): the saved path may point to a file that is gone
    final photo = (file != null && file.existsSync()) ? FileImage(file) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundImage: photo,
              child: photo != null
                  ? null
                  : const Text('U', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _pick(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.photo_camera),
              label: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}
