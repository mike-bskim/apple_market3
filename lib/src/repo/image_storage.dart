import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/logger.dart';

class ImageStorage {

  static Future<List<String>> uploadImage(List<Uint8List> images, String itemKey) async {

    // 이미지 타입지정,
    var metaData = SettableMetadata(contentType: 'image/jpeg');
    List<String> downloadUrls = [];

    for (var i = 0; i < images.length; i++) {
      // 저장위치 설정 ref('images/$itemKey/$i.jpg')
      // 참고자료 - "https://firebase.google.com/docs/storage/android/create-reference?authuser=0"
      Reference ref =
      FirebaseStorage.instance.ref('images/$itemKey/$i.jpg');
      if (images.isNotEmpty) {
        // 데이터 업로드,
        await ref.putData(images[i], metaData).catchError((onError){
          logger.e('picture uploading error: ' + onError.toString());
        });
        // 업로드 완료된 파일 위치 저장,
        downloadUrls.add(await ref.getDownloadURL());
      }
    }

    return downloadUrls;
  }
}
