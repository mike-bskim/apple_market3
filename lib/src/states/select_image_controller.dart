import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageController extends GetxController {
  static SelectImageController get to => Get.find();

  final RxList<Uint8List> _images = <Uint8List>[].obs;

  RxList<Uint8List> get images => _images;

  Future setNewImages(List<XFile>? newImages) async {
    if (newImages != null && newImages.isNotEmpty) {
      _images.clear();
      for (var xFile in newImages) {
        _images.add(await xFile.readAsBytes());
      }
    }
  }

  void removeImage(int index) {
    if (_images.length >= index) {
      _images.removeAt(index);
    }
  }
}
