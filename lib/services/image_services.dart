import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../view/widget/custom_snackbar.dart';

class ImageService {
  File? image;
  final _picker = ImagePicker();

  Future<File?> getImage(ImageSource imageSource) async {
    final pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return image;
    } else {
      showConsole("No Image: Image not Selected");
      showCustomSnackBar("No Image", "Image not Selected");
      return null;
    }
  }
}
