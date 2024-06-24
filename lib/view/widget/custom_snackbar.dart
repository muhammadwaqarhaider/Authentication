import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String title,String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 5),
    backgroundColor: Get.theme.snackBarTheme.backgroundColor,
    colorText: Get.theme.snackBarTheme.actionTextColor,
  );

  // Get.showSnackbar(GetSnackBar(
  //   backgroundColor: isError ? Colors.red : Colors.green,
  //   message: message.isNull?" ":message.isEmpty?" ":message,
  //   maxWidth: Dimensions.WEB_MAX_WIDTH,
  //   duration: Duration(seconds: 3),
  //   snackStyle: SnackStyle.FLOATING,
  //   margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
  //   borderRadius: Dimensions.RADIUS_SMALL,
  //   isDismissible: true,
  //   dismissDirection: DismissDirection.horizontal,
  // ));
}

void showConsole(text) {
  if (kDebugMode) {
    print(text);
  }
}