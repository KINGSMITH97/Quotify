import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageService {
  Future<String?> saveImage(Uint8List bytes) async {
    // Request storage permission
    await [Permission.storage].request();

    // Generate a unique name for the image
    String name = "quotes${DateTime.now().millisecondsSinceEpoch}";

    // Save the image
    AssetEntity? result =
        await PhotoManager.editor.saveImage(bytes, filename: name);

    // Check if the result is not null and return the file path
    if (result != null) {
      // Retrieve the file path of the saved image
      final file = await result.file;
      return file?.path; // Return the file path
    } else {
      return null; // Return null if saving failed
    }
  }

  Future<String?> shareImage(Uint8List bytes) async {
    // Request storage permission
    await [Permission.storage].request();

    // Generate a unique name for the image
    String name = "quotes${DateTime.now().millisecondsSinceEpoch}";

    // Save the image
    AssetEntity? result =
        await PhotoManager.editor.saveImage(bytes, filename: name);

    // Check if the result is not null and return the file path
    if (result != null) {
      // Retrieve the file path of the saved image
      final file = await result.file;
      return file?.path; // Return the file path
    } else {
      return null; // Return null if saving failed
    }
  }
}
