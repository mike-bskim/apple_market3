import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();

  final RxString _selectedCategoryInEng = 'none'.obs;
  String get currentCategoryInEng => _selectedCategoryInEng.value;
  String get currentCategoryInKor => categoriesMapEngToKor[_selectedCategoryInEng.value]!;

  // 키로 _selectedCategoryInEng 값 설정
  void setNewCategoryWithEng(String newCategory) {
    if (categoriesMapEngToKor.keys.contains(newCategory)) {
      _selectedCategoryInEng.value = newCategory;
    }
  }

  // 값으로 _selectedCategoryInEng 값 설정
  void setNewCategoryWithKor(String newCategory) {
    if (categoriesMapEngToKor.values.contains(newCategory)) {
      _selectedCategoryInEng.value = categoriesMapKorToEng[newCategory]!;
    }
  }
}

const Map<String, String> categoriesMapEngToKor = {
  'none': '카테고리 선택',
  'furniture': '가구',
  'electronics': '전자기기',
  'kids': '유아동',
  'sports': '스포츠/레저',
  'woman': '여성',
  'man': '남성',
  'makeup': '메이크업',
  'desc': '아래 항목중에서 선택하세요',
};

Map<String, String> categoriesMapKorToEng =
    categoriesMapEngToKor.map((key, value) => MapEntry(value, key));
