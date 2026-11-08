import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image, copies it into the app's documents directory,
  /// and returns the new path (or null if cancelled or on web).
  Future<String?> pickAndSave(ImageSource source) async {
    if (kIsWeb) return null; // no documents directory on web

    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      imageQuality: 80,
    );
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final name =
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    final saved = await File(picked.path).copy(p.join(dir.path, name));
    return saved.path;
  }
}