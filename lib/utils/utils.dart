import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//This method takes a paremeter from SelectImage method in signupScreen.dart and returns the file as Xfile which is compatible with Uint8List.
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No file selected');
}

//Shows snackbar with error message ( popup )
showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
