import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/common_size.dart';
import '../../constants/data_keys.dart';
import '../../models/item_model.dart';

class SimilarItem extends StatelessWidget {
  final ItemModel2 _itemModel;

  const SimilarItem(this._itemModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            '/$ROUTE_ITEM_DETAIL',
            arguments: {'itemKey': _itemModel.itemKey},
            // 같은 페이지는 호출시, 중복방지가 기본설정인, false 하면 중복 호출 가능,
            preventDuplicates: false
            );
        debugPrint('itemKey: ${_itemModel.itemKey}');
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return ItemDetailPage(_itemModel.itemKey);
        // }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AspectRatio(
            aspectRatio: 5 / 4,
            child: ExtendedImage.network(
              _itemModel.imageDownloadUrls[0],
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
          ),
          Text(
            _itemModel.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: padding_08),
            child: Text(
              '${_itemModel.price.toString()}원',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}
