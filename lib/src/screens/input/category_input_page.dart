import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../states/category_controller.dart';

class CategoryInputPage extends StatelessWidget {
  const CategoryInputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 선택', style: Theme.of(context).textTheme.headline6),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // 첫번째 항목은 선택 불가,
              if (index != 0) {
                CategoryController.to
                    .setNewCategoryWithKor(categoriesMapEngToKor.values.elementAt(index));
                debugPrint(CategoryController.to.currentCategoryInEng);
                Get.back();
              }
            },
            title: Text(
              // none 일 경우 'desc' 항목을 보여줌,
              categoriesMapEngToKor.keys.elementAt(index) == 'none'
                  ? categoriesMapEngToKor['desc']!
                  : categoriesMapEngToKor.values.elementAt(index),
              // 현재 선택된 항목을 색상 반전으로 처리,
              style: TextStyle(
                  color: (CategoryController.to.currentCategoryInKor ==
                              categoriesMapEngToKor.values.elementAt(index) &&
                          index != 0)
                      ? Theme.of(context).primaryColor
                      : Colors.black87),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1, thickness: 1, color: Colors.grey[300]);
        },
        // 마지막 항목은 설명이므로 화면 출력에서 제외,
        itemCount: categoriesMapEngToKor.length - 1,
      ),
    );
  }
}
