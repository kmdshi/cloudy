import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List?> imagePicker() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    final imageBytes = await image.readAsBytes();
    return imageBytes;
  }
  return null;
}
