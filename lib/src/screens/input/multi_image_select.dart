import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/common_size.dart';

class MultiImageSelect extends StatefulWidget {
  const MultiImageSelect({Key? key}) : super(key: key);

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  bool _isPickingImages = false;
  // final List<XFile> _images = [];
  final List<Uint8List> _images = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // SelectImageNotifier selectImageNotifier = context.watch<SelectImageNotifier>();
        Size _size = MediaQuery.of(context).size;
        var imgSize = (_size.width / 3) - padding_16 * 2;

        return SizedBox(
          height: _size.width / 3,
          // width: _size.width,
          child: ListView(
            // 기본 스크롤 방향을 위/아래 에서 좌/우로 변경해줌,
            // 사이즈를 강제로 설정해야 함. 그래서 SizedBox 로 wrapping,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                // 패딩 - 여기서는 전체를 16으로 처리해서 아래는 위/아래/오른쪽만 16 처리할 것,
                padding: const EdgeInsets.all(padding_16),
                child: InkWell(
                  // onTap 에서 이미지를 List<XFile> 타입 배열에 추가,
                  onTap: () async {
                    _isPickingImages = true;
                    setState(() {});

                    final ImagePicker _picker = ImagePicker();
                    // Pick multiple images
                    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 20);
                    if (images != null && images.isNotEmpty) {
                      _images.clear();
                      // 이미지 컨버팅을 로딩할때 처리함,
                      for (var xFile in images) {
                        _images.add(await xFile.readAsBytes());
                      }
                      // _images.addAll(images);
                      // await context.read<SelectImageNotifier>().setNewImages(images);
                    }
                    _isPickingImages = false;
                    setState(() {});
                  },
                  child: Container(
                    width: imgSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(padding_16),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
// 첫번째 사진 아이콘 부분 구현
                    child: _isPickingImages
                        ? const Padding(
                            padding: EdgeInsets.all(padding_16 * 2),
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt_rounded, color: Colors.grey),
                              Text('0/10', style: Theme.of(context).textTheme.subtitle2),
                            ],
                          ),
                  ),
                ),
              ),
// 중복되는 사진 부분 구현
// ... 으로 시작하면 기존 리스트에 새로운 결과(List.generate 결과)를 추가할 수 있다.
              ...List.generate(
                _images.length,
                (index) => Stack(
                  children: [
                    Padding(
                      // 패딩 - 위에서 전체를 16으로 처리해서 여기서는 위/아래/오른쪽만 16 처리할 것,
                      padding: const EdgeInsets.only(
                          right: padding_16, top: padding_16, bottom: padding_16),
                      // child: ExtendedImage.network(
                      // 변수(메모리)에 있는 이미지를 보여주기 위해서 ExtendedImage.memory 사용하고,
                      // 이미지를 화면에 보여주려면 컨버팅이 필요해서 FutureBuilder 로 wrapping 필요함,
                      // 이미지 컨버팅을 로딩할때 처리해서 FutureBuilder 가 필요없어서 삭제함,
                      child: ExtendedImage.memory(
                        _images[index],
                        width: imgSize,
                        height: imgSize,
                        fit: BoxFit.cover,
                        // 이미지 로딩중 각 이미지별로 인디케이터 처리함,
                        loadStateChanged: (state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return const Center(child: CircularProgressIndicator());
                            case LoadState.completed:
                              return null;
                            case LoadState.failed:
                              return const Icon(Icons.cancel);
                          }
                        },
                        // shape 을 지정해야만 borderRadius 설정이 정상 동작함,
                        borderRadius: BorderRadius.circular(padding_16),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      // IconButton 의 기본 사이즈는 24 이므로 패딩 8 을 더해서 40 으로 설정,
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          // selectImageNotifier.removeImage(index);
                          debugPrint('remove picture $index');
                          _images.removeAt(index);
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove_circle),
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
//               ...List.generate(20,
//                 // selectImageNotifier.images.length,
//                 // _images.length,
//                     (index) => Stack(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           right: padding_16, top: padding_16, bottom: padding_16),
//                       // future 타입을 변환해야 함.
//                       child: ExtendedImage.network( // memory
//                         // selectImageNotifier.images[index],
//                         'https://picsum.photos/200',
//                         width: imgSize,
//                         height: imgSize,
//                         fit: BoxFit.cover,
//                         loadStateChanged: (state) {
//                           switch (state.extendedImageLoadState) {
//                             case LoadState.loading:
//                               return Container(
//                                   width: imgSize,
//                                   height: imgSize,
//                                   padding: const EdgeInsets.all(padding_16 * 2),
//                                   child: const CircularProgressIndicator());
//                             case LoadState.completed:
//                               return null;
//                             case LoadState.failed:
//                               return const Icon(Icons.cancel);
//                           }
//                         },
//                         borderRadius: BorderRadius.circular(padding_16),
//                         shape: BoxShape.rectangle,
//                       ),
//                     ),
//                     Positioned(
//                       top: 0,
//                       right: 0,
//                       width: 40,
//                       height: 40,
//                       child: IconButton(
//                         padding: const EdgeInsets.all(8),
//                         onPressed: () {
//                           // selectImageNotifier.removeImage(index);
//                           debugPrint('remove picture $index');
//                         },
//                         icon: const Icon(Icons.remove_circle),
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
            ],
          ),
        );
      },
    );
  }
}
