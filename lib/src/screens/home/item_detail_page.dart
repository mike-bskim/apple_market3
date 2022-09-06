import 'package:apple_market3/src/screens/home/similar_item.dart';
import 'package:apple_market3/src/states/category_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/common_size.dart';
import '../../constants/data_keys.dart';
import '../../models/chatroom_model.dart';
import '../../models/item_model.dart';
import '../../models/user_model.dart';
import '../../repo/chat_service.dart';
import '../../repo/item_service.dart';

import '../../states/category_controller.dart';
import '../../states/user_controller.dart';
import '../../utils/logger.dart';
import '../../utils/time_calculation.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({Key? key}) : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final PageController _pageController = PageController();

  // 스크롤이 얼마나 되었는지 알기 위해서 컨트롤러 등록,
  final ScrollController _scrollController = ScrollController();

  // isAppbarCollapsed 이미지가 화면에서 사라졌는지 확인,
  bool isAppbarCollapsed = false;
  Size? _size;

  num? _statusBarHeight;
  late String newItemKey;

  final Widget _textGap = const SizedBox(height: padding_16);

  Widget _divider(double _height) {
    return Divider(
      height: _height, //padding_16 * 2 + 1,
      thickness: 2,
      color: Colors.grey[300]!,
      // indent: padding_08,
      // endIndent: padding_08,
    );
  }

  @override
  void initState() {
    newItemKey = Get.arguments['itemKey'];
    // if (Get.arguments['itemKey'][0] == ':') {
    //   // String orgItemKey = widget.itemKey;
    //   newItemKey = Get.arguments['itemKey'].substring(1);
    // }
    // logger.d('$_size!.width, $kToolbarHeight, $_statusBarHeight, ${isAppbarCollapsed.toString()}');

    // 스크롤이 발생할때 마다 addListener 가 실행됨,
    _scrollController.addListener(() {
      if (_size == null && _statusBarHeight == null) return;
      // debugPrint(
      //     '${_size!.width}, $kToolbarHeight, $_statusBarHeight, ${_scrollController.offset.toInt()}, ${_size!.width - kToolbarHeight - _statusBarHeight!}, ${isAppbarCollapsed.toString()}');

      if (isAppbarCollapsed) {
        // 여기는 이미지가 앱바 아래로 보여지기 시작하는 시점,
        // 앱바 사이즈(kToolbarHeight), 상태바 사이즈(_statusBarHeight)
        if (_scrollController.offset < _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        }
      } else {
        // 여기는 이미지가 앱바에 위로 올라가서 안보이기 시작하는 시점,
        // 앱바 사이즈(kToolbarHeight), 상태바 사이즈(_statusBarHeight)
        if (_scrollController.offset > _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goToChatroom(ItemModel2 itemModel, UserModel1 userModel) async {
    String chatroomKey =
        ChatroomModel2.generateChatRoomKey(buyer: userModel.userKey, itemKey: newItemKey);
    // logger.d({
    //   'buyerKey': '[${userModel.userKey}]',
    //   'sellerKey': '[${itemModel.userKey}]',
    //   'newItemKey': '[$newItemKey]',
    //   'itemKey': '[${itemModel.itemKey}]',
    // });

    ChatroomModel2 _chatroomModel = ChatroomModel2(
      itemImage: itemModel.imageDownloadUrls[0],
      itemTitle: itemModel.title,
      itemKey: newItemKey,
      itemAddress: itemModel.address,
      itemPrice: itemModel.price,
      sellerKey: itemModel.userKey,
      buyerKey: userModel.userKey,
      sellerImage: 'https://minimaltoolkit.com/images/randomdata/male/101.jpg',
      buyerImage: 'https://minimaltoolkit.com/images/randomdata/female/41.jpg',
      geoFirePoint: itemModel.geoFirePoint,
      chatroomKey: chatroomKey,
      lastMsgTime: DateTime.now().toUtc(),
    );
    await ChatService().createNewChatroom(_chatroomModel);

    // context.beamToNamed('/$LOCATION_ITEM/:$newItemKey/:$chatroomKey');
    // Get.toNamed("/user/1424?name=Flutter&age=22");
    Get.toNamed("/$ROUTE_ITEM_DETAIL/$chatroomKey");
  }

  @override
  Widget build(BuildContext context) {
    // logger.d('item detail screen >> build >>> [$newItemKey]');

    return FutureBuilder<ItemModel2>(
      future: ItemService().getItem(newItemKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // FutureBuilder 의 snapshot 에서 게시글 데이터 가져오기
          ItemModel2 itemModel = snapshot.data!;
          // provider 입포트하고 고객 데이터 가져오기
          // UserModel2 userModel = context.read<UserNotifier>().userModel!;
          UserModel1 userModel = UserController.to.userModel.value!;

          return LayoutBuilder(
            builder: (context, constraints) {
              _size = MediaQuery.of(context).size;
              // 상태바 길이 가져오는 공식,
              _statusBarHeight = MediaQuery.of(context).padding.top;
              return Stack(
                // 스택에서는 하단 위젯부터 화면에서는 front 에 위치,
                // fit 은 Stack 에 있는 모든 아이콘들이 화면에 가득차게 하는 옵션,
                fit: StackFit.expand,
                children: [
                  // 메인 정보를 표시하는 영역
                  Scaffold(
                    // 화면 하단을 네비로 표시함
                    bottomNavigationBar: SafeArea(
                      // SafeArea - 전화기의 하단 메뉴바 영역과 앱 영역이 중복되는거 피하기 위해서,
                      top: false,
                      bottom: true, // 아래 영역만 피하기 위해서,
                      child: Container(
                        // Row/VerticalDivider 의 사이즈를 제한하기 위해서 Container&height 처리함,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey[300]!),
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(padding_08),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_border),
                              ),
                              const VerticalDivider(
                                thickness: 1,
                                width: padding_08 * 2 + 1,
                                indent: padding_08,
                                endIndent: padding_08,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // crossAxisAlignment: CrossAxisAlignment.auth,
                                children: [
                                  Text(
                                    itemModel.price.toString(),
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    itemModel.negotiable ? '가격제안가능' : '가격제안불가',
                                    style: itemModel.negotiable
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.blue)
                                        : Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              TextButton(
                                onPressed: () {
                                  _goToChatroom(itemModel, userModel);
                                },
                                child: const Text('채팅으로 거래하기'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 메인정보를 표시, CustomScrollView 는 listView 유사함
                    // listView 대신에 CustomScrollView 사용하는 이유는
                    // slivers 를 이용해서 화면을 구역으로 나눠서 각 구역마다 슬라이스를 구현할 수 있다,
                    body: CustomScrollView(
                      controller: _scrollController,
                      // children 을 대신하는 slivers 있고, slivers 안에는 sliver 형식의 위젯을 넣어줘야 한다
                      slivers: [
                        // 업로드한 사진 정보를 표시하는 영역
                        _imageAppBar(itemModel),
                        // 상세 텍스트 정보를 표시하는 영역
                        SliverPadding(
                          padding: const EdgeInsets.all(padding_16),
                          sliver: SliverList(
                            // SliverToBoxAdapter 로 각각 처리할수도 있고,
                            // SliverList 를 이용하여 리스트 형식으로도 처리 가능,
                            delegate: SliverChildListDelegate([
                              _userSection(itemModel),
                              _divider(padding_16 * 2 + 1),
                              Text(
                                itemModel.title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              _textGap,
                              Row(
                                children: [
                                  Text(
                                    categoriesMapEngToKor[itemModel.category] ?? '선택',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(decoration: TextDecoration.underline),
                                  ),
                                  Text(
                                    ' · ${TimeCalculation.getTimeDiff(itemModel.createdDate)}',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              _textGap,
                              Text(
                                itemModel.detail,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              _textGap,
                              Text(
                                '조회 33',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              _textGap,
                              _divider(2),
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  // 이메일로 처리하고 싶으면 flutter_email_sender 참고할 것
                                  // https://pub.dev/packages/flutter_email_sender
                                  logger.d('게시글을 신고합니다');
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '이 게시글 신고하기',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button!
                                        .copyWith(color: Colors.black87),
                                  ),
                                ),
                              ),
                              _divider(2),
                            ]),
                          ),
                        ),
                        // // SliverGrid.count 사용하는 방법,
                        // SliverPadding(
                        //   padding: const EdgeInsets.only(
                        //       left: padding_16, right: padding_16, bottom: padding_16),
                        //   sliver: SliverGrid.count(
                        //     crossAxisCount: 2,
                        //     mainAxisSpacing: padding_08,
                        //     crossAxisSpacing: padding_16,
                        //     childAspectRatio: 7 / 8,
                        //     children: List.generate(
                        //       10,
                        //       (index) => SimilarItem(itemModel),
                        //     ),
                        //   ),
                        // ),
                        // // 일반위젯을 sliver 안에 넣으러면 SliverToBoxAdapter 로 wrapping 해야 함,
                        // SliverToBoxAdapter(
                        //   child: Container(
                        //       // 스크롤 테스트를 위해서 높이를 길게 적용함,
                        //       height: _size!.height,
                        //       color: Colors.cyan,
                        //       child: Center(child: Text(newItemKey))),
                        // ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: padding_16),
                            // 판매자의 다른 상품 보기
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '판매자의 다른 상품',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  width: _size!.width / 4,
                                  child: MaterialButton(
                                    // padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '더보기',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 일반위젯을 sliver 안에 넣으러면 SliverToBoxAdapter 로 wrapping 해야 함,
                        SliverToBoxAdapter(
                          child: FutureBuilder<List<ItemModel2>>(
                            future: ItemService().getUserItems(
                              userKey: itemModel.userKey,
                              itemKey: itemModel.itemKey,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(padding_08),
                                  child: GridView.count(
                                    padding: const EdgeInsets.symmetric(horizontal: padding_08),
                                    //EdgeInsets.zero,
                                    // GridView 자체의 스크롤을 off 시키는 옵션,
                                    physics: const NeverScrollableScrollPhysics(),
                                    // 기본은 false 인데, false 면 전체화면을 차지하려하여 에러발생,
                                    // ture 면, 가져온 정보를 기초로 화면을 차지함,
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: padding_08,
                                    crossAxisSpacing: padding_16,
                                    childAspectRatio: 6 / 7,
                                    children: List.generate(snapshot.data!.length,
                                        (index) => SimilarItem(snapshot.data![index])),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 앱바 영역에 그라데이션 표현 추가
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: kToolbarHeight + _statusBarHeight!,
                    child: Container(
                      height: kToolbarHeight + _statusBarHeight!,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black45,
                            Colors.black38,
                            Colors.black26,
                            Colors.black12,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 화면 스크롤업 하면 앱바를 힌색으로 변경.
                  // 이전에 구현한 인디케이터가 appBar 타이틀위치에서 보여주던걸 숨김,
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: kToolbarHeight + _statusBarHeight!,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        centerTitle: true,
                        title: Text(
                          'User ID : [${userModel.phoneNumber}]',
                          style: TextStyle(
                              color: isAppbarCollapsed ? Colors.black87 : Colors.transparent),
                        ),
                        shadowColor: Colors.transparent,
                        backgroundColor: isAppbarCollapsed ? Colors.white : Colors.transparent,
                        foregroundColor: isAppbarCollapsed ? Colors.black87 : Colors.white,
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }
        return Container(
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  SliverAppBar _imageAppBar(ItemModel2 itemModel) {
    return SliverAppBar(
      // expandedHeight 에서는 세로 길이를 정해줄 수 있음,
      expandedHeight: _size!.width,
      // pinned: true 면 앱바 역역을 남기는 역할, false 면 스크롤시 같이 사라짐,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // title: const Text('testing', style: TextStyle(color: Colors.black)),
        // 타이틀 부분에 인디케이터 표시하고 아래에 위치함, 패키지 추가 필요함,
        title: SizedBox(
          child: SmoothPageIndicator(
              controller: _pageController,
              // PageController
              count: itemModel.imageDownloadUrls.length,
              effect: const WormEffect(
                activeDotColor: Colors.white,
                //Theme.of(context).primaryColor,
                dotColor: Colors.black45,
                //Theme.of(context).colorScheme.background,
                radius: 3,
                dotHeight: 6,
                dotWidth: 6,
              ),
              // your preferred effect
              onDotClicked: (index) {}),
        ),

        // background 로 이미지를 넣으면 됨, 이미지 표시
        background: PageView.builder(
          // 좌/우로 스크롤 가능하게 처리,
          controller: _pageController,
          // 옆페이지로 이동시 포커스를 옆페이지로 이동시켜 로딩을 미리하게 설정함,
          allowImplicitScrolling: true,
          itemBuilder: (BuildContext context, int index) {
            return ExtendedImage.network(
              itemModel.imageDownloadUrls[index],
              fit: BoxFit.cover,
              // 캐싱을 했지만 다시 로딩하는 경우가 있어서 이미지 사이즈를 줄여줌,
              scale: 0.1,
            );
          },
          itemCount: itemModel.imageDownloadUrls.length,
        ),
      ),
    );
  }

  Widget _userSection(ItemModel2 _itemModel) {
    int phoneCnt = _itemModel.userPhone.length;
    //[서울특별시, 용산구, xxx길, 11, (xxx2가)]
    //[서울특별시, 중구, 태평로x가, xx]
    List _address = _itemModel.address.split(' ');
    String _detail = _address[_address.length - 1];
    String _location = '';

    if (_detail.contains('(') && _detail.contains(')')) {
      _location = _detail.replaceAll('(', '').replaceAll(')', '');
    } else {
      _location = _address[2];
    }

    return Row(
      children: [
        ExtendedImage.network(
          'https://picsum.photos/50',
          fit: BoxFit.cover,
          width: _size!.width / 10,
          height: _size!.width / 10,
          shape: BoxShape.circle,
        ),
        const SizedBox(width: padding_16),
        SizedBox(
          height: _size!.width / 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.auth,
            children: [
              Text(
                _itemModel.userPhone.substring(phoneCnt - 4).toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                _location,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        // 매너온도를 오른쪽으로 보내기 위해서 중간에 빈박스를 Expanded 로 처리,
        Expanded(child: Container()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(
                  // 온도와 LinearProgressIndicator 를 가로 길이를 같게 하기위해서,
                  width: 42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const FittedBox(
                        child: Text(
                          '37.3 °C',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: LinearProgressIndicator(
                          color: Colors.blueAccent,
                          value: 0.365,
                          minHeight: 3,
                          backgroundColor: Colors.grey[200],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const ImageIcon(
                  ExtendedAssetImageProvider('assets/imgs/happiness.png'),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: padding_08),
            Text(
              '매너온도',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ],
        ),
        // Text('aaa'),
      ],
    );
  }
}
