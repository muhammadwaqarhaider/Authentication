import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../view/widget/custom_snackbar.dart';
import '../view/widget/loading_dialog.dart';

class StorageServices {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadToStorage(File image,String path) async {
    showLoadingDialog();
    try {
      String downloadUrl = '';
      TaskSnapshot snapshot = await firebaseStorage
          .ref()
          .child('$path/${DateTime.now()}')
          .putFile(image);
      downloadUrl = await snapshot.ref.getDownloadURL();
      dismissLoadingDialog();
      return downloadUrl;
    } on Exception catch (e) {
      dismissLoadingDialog();
      showConsole("Upload Failed: $e");
      showCustomSnackBar("Upload Failed", e.toString());
      return null;
    }
  }
}