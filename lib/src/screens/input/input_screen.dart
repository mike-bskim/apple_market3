import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../constants/data_keys.dart';
import '../../models/item_model.dart';
import '../../repo/image_storage.dart';
import '../../repo/item_service.dart';
import '../../utils/logger.dart';
import '../../states/user_controller.dart';
import '../../states/category_controller.dart';
import '../../states/select_image_controller.dart';
import '../../constants/common_size.dart';
import '../../widgets/warning_dialog.dart';
import 'multi_image_select.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final dividerCustom = Divider(
      height: 1, thickness: 1, color: Colors.grey[350], indent: padding_16, endIndent: padding_16);

  final underLineBorder =
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  bool _suggestPriceSelected = false;
  bool isCreatingItem = false;

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void attemptCreateItem() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    // 완료 버튼 클릭
    isCreatingItem = true;
    // setState 해줘야 인디케이터가 동작한다,
    setState(() {
      autoValidate = AutovalidateMode.always;
    });

    final form = _fbKey.currentState;
    if (form == null || !form.validate()) {
      isCreatingItem = false;
      return;
    }
    form.save();
    final inputValues = form.value;
    debugPrint(inputValues.toString());

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String userPhone = FirebaseAuth.instance.currentUser!.phoneNumber!;
    final String itemKey = ItemModel2.generateItemKey(userKey);
    List<Uint8List> images = SelectImageController.to.images;
    // final num? price = num.tryParse(_priceController.text.replaceAll('.', '').replaceAll(' 원', ''));
    final num? price = num.tryParse(_priceController.text.replaceAll(RegExp(r'\D'), ''));
    // UserNotifier userNotifier = context.read<UserNotifier>();

    if (images.isEmpty) {
      dataWarning(context, '확인', '이미지를 선택해주세요');
      return;
    }

    if (CategoryController.to.currentCategoryInEng == 'none') {
      dataWarning(context, '확인', '카테고리를 선택해주세요');
      return;
    }

    // uploading raw data and return the Urls,
    List<String> downloadUrls = await ImageStorage.uploadImage(images, itemKey);
    logger.d('upload finished(${downloadUrls.length}) : $downloadUrls');

    ItemModel2 itemModel = ItemModel2(
      itemKey: itemKey,
      userKey: userKey,
      userPhone: userPhone,
      imageDownloadUrls: downloadUrls,
      title: _titleController.text,
      category: CategoryController.to.currentCategoryInEng,
      price: price ?? 0,
      negotiable: _suggestPriceSelected,
      detail: _detailController.text,
      address: UserController.to.userModel.value!.address,
      //userNotifier.userModel!.address,
      geoFirePoint: UserController.to.userModel.value!.geoFirePoint,
      //userNotifier.userModel!.geoFirePoint,
      createdDate: DateTime.now().toUtc(),
    );

    // await ItemService().createNewItem(itemModel, itemKey, userNotifier.user!.uid);
    await ItemService().createNewItem(itemModel, itemKey, UserController.to.user.value!.uid);
    Get.back();
  }

  Future<bool> dataWarning(BuildContext context, String title, String msg) async {
    isCreatingItem = false;
    return await showDialog<bool>(
          context: context,
          builder: (context) => WarningYesNo(
            title: title,
            msg: msg,
            yesMsg: '확인',
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              // leading 을 통해서 back 버튼을 "뒤로" 버튼으로 대체할 수 있음.
              leadingWidth: 55.0,
              leading: TextButton(
                onPressed: () {
                  debugPrint('뒤로가기 버튼 클릭');
                  Get.back();
                },
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  // backgroundColor 는 기본으로 흰색으로 설정되어 있음,
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: Text(
                  '뒤로',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              // 로딩중일때,
              bottom: PreferredSize(
                preferredSize: Size(_size.width, 3),
                child: isCreatingItem ? const LinearProgressIndicator(minHeight: 3) : Container(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: attemptCreateItem,
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                    // 완료와 뒤로 버튼 사이즈를 조정함,
                    minimumSize: const Size(55, 40),
                  ),
                  child: Text(
                    '완료',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
              title: Text(
                '중고거래 등록',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            // 컬럼으로 안하고 ListView 로 하는 이유는 스크롤 기능이 필요해서,
            body: FormBuilder(
              key: _fbKey,
              child: ListView(
                children: <Widget>[
                  // 멀티 이미지 영역
                  const MultiImageSelect(),
                  dividerCustom,
// 제목영역 ********************************************************
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding_16),
                    child: TextFormField(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '글제목은 필수입니다'),
                      ]),
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: '글제목',
                        // padding 으로 하지 않고 처리하는 방법,
                        // contentPadding: const EdgeInsets.symmetric(horizontal: padding_16),
                        border: underLineBorder,
                        enabledBorder: underLineBorder,
                        focusedBorder: underLineBorder,
                        // error 관련 border 설정
                        errorBorder: underLineBorder,
                        focusedErrorBorder: underLineBorder,
                        // errorStyle: const TextStyle(color: Colors.grey)
                      ),
                    ),
                  ),
                  dividerCustom,
// 카테고리 영역 ********************************************************
                  ListTile(
                    onTap: () {
                      debugPrint('/LOCATION_INPUT/LOCATION_CATEGORY_INPUT');
                      Get.toNamed(ROUTE_CATEGORY_INPUT);
                    },
                    dense: true,
                    title: Obx(() {
                      return Text(CategoryController.to.currentCategoryInKor);
                    }),
                    trailing: const Icon(Icons.navigate_next),
                  ),
                  dividerCustom,
                  Row(
                    children: <Widget>[
                      // Expanded 를 처리하여 전체 공간을 차지하게 처리
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: padding_16),
// 가격입력 ********************************************************
                          child: TextFormField(
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: '가격은 필수입니다'),
                            ]),
                            // 숫자만 입력가능하게 설정,
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                            onChanged: (value) {
                              if ('0 원' == value) {
                                _priceController.clear();
                              }
                              setState(() {});
                            },
                            // 입력한 숫자 형식을 지정해주는 옵션,
                            inputFormatters: [
                              MoneyInputFormatter(mantissaLength: 0, trailingSymbol: ' 원')
                            ],
                            decoration: InputDecoration(
                              hintText: '가격',
                              prefixIcon: ImageIcon(
                                const ExtendedAssetImageProvider('assets/imgs/won.png'),
                                // 숫자가 입력되면 원화표시 사이 색상이 변경된다,
                                color: (_priceController.text.isEmpty)
                                    ? Colors.grey[350]
                                    : Colors.black87,
                              ),
                              // prefixIcon 의 사이즈를 결정,
                              prefixIconConstraints: const BoxConstraints(maxWidth: 20),
                              contentPadding: const EdgeInsets.symmetric(vertical: padding_08),
                              border: underLineBorder,
                              enabledBorder: underLineBorder,
                              focusedBorder: underLineBorder,
                              // error 관련 border 설정
                              errorBorder: underLineBorder,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: padding_16),
                        child: TextButton.icon(
                          onPressed: () {
                            // 가격제안 클릭시 토글 방식으로 화면 처리,
                            setState(() {
                              _suggestPriceSelected = !_suggestPriceSelected;
                            });
                          },
                          icon: Icon(
                            _suggestPriceSelected ? Icons.check_circle : Icons.check_circle_outline,
                            color: _suggestPriceSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black54,
                          ),
                          label: Text(
                            '가격제안 받기',
                            style: TextStyle(
                              color: _suggestPriceSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            primary: Colors.black45,
                          ),
                        ),
                      )
                    ],
                  ),
                  dividerCustom,
// 올릴 게시글 내용을 작성
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding_16),
                    child: TextFormField(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '내용을 작성해주세요'),
                      ]),
                      controller: _detailController,
                      // 엔터 줄바꿈 가능하게, 줄수 제한 없애기,
                      maxLines: null,
                      // multiline 설정하면 완료키가 엔터키로 변경됨,
                      keyboardType: TextInputType.multiline,

                      decoration: InputDecoration(
                        hintText: '올릴 게시글 내용을 작성해주세요',
                        contentPadding: const EdgeInsets.symmetric(
                          // horizontal: padding_16,
                          vertical: padding_16,
                        ),
                        border: underLineBorder,
                        enabledBorder: underLineBorder,
                        focusedBorder: underLineBorder,
                        // error 관련 border 설정
                        errorBorder: underLineBorder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
