import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/chat_model.dart';
import '../../models/chatroom_model.dart';
import '../../models/user_model.dart';
import '../../states/chat_controller.dart';
import '../../states/user_controller.dart';
import '../../utils/logger.dart';
import 'chat.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  late String chatroomKey;
  final TextEditingController _textEditingController = TextEditingController();
  late final ChatController chatController;

  // late ChatNotifier _chatNotifier;

  @override
  void initState() {
    // TODO: implement initState
    chatroomKey = Get.parameters['chatroomKey']!;
    chatController = Get.put(ChatController(chatroomKey));
    logger.d(chatroomKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // logger.d('${Get.parameters['chatroomKey']}');
    Size _size = MediaQuery.of(context).size;
    UserModel1 userModel = UserController.to.userModel.value!;
    // List<ChatModel2> _chatList = ChatController.to.chatList;
    // Rxn<ChatroomModel2> chatroomModel = ChatController.to.chatroomModel;

    // ChatController 내부의 chatList, chatroomModel 변수를 접근하기 위해서,
    return GetBuilder<ChatController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(),
          backgroundColor: Colors.grey[200],
          // 화면 하단의 메뉴바 때문에 SafeArea 로 wrapping 해야 오동작을 방지함.
          body: SafeArea(
            child: Column(
              children: [
                // 게시글 정보를 간략히 표시
                _buildItemInfo(context),
                // 채팅 메시지 표시 부분
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    // 최신 메시지가 아래에 위치하게 설정,
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      bool _isMine = controller.chatList[index].userKey == userModel.userKey;
                      // return ListTile(
                      //   dense: true,
                      //   title: Text(_chatList[index].msg +
                      //       ' - ' +
                      //       DateFormat('yyyy-MM-dd').format(_chatList[index].createdDate)),
                      //   // subtitle: Text(chatroomModel.value!.lastMsg),
                      //   contentPadding: EdgeInsets.zero,
                      //   horizontalTitleGap: 0.0,
                      //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      //   minVerticalPadding: 0,
                      // );
                      return Chat(
                        size: _size,
                        isMine: _isMine,
                        chatModel: controller.chatList[index], //chatNotifier.chatList[index],
                      );
                    },
                    // 날짜가 다르면 디바이터 대신 일장 정보를 표시하게 함,
                    separatorBuilder: (context, index) {
                      if (DateFormat('yyyy-MM-dd').format(controller.chatList[index].createdDate) ==
                          DateFormat('yyyy-MM-dd')
                              .format(controller.chatList[index + 1].createdDate)) {
                        return const SizedBox(height: 12);
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(controller.chatList[index].createdDate),
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: controller.chatList.length, //chatNotifier.chatList.length,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                // 메시지 입력 창
                _buildInputBar(userModel)
              ],
            ),
          ),
        );
      },
    );
  }

  // 컬럼내부에 리스트타일(높이 관련 오류가 있어서 나중에 row+column 조함으로 변경함)과 버튼으로 구성 예정
  MaterialBanner _buildItemInfo(BuildContext context) {
    Rxn<ChatroomModel2> _chatroomModel = ChatController.to.chatroomModel;

    return MaterialBanner(
      // 공간 조절을 위해서 패딩을 수정함
      padding: EdgeInsets.zero,
      leadingPadding: EdgeInsets.zero,
      // actions 는 빈칸
      actions: [Container()],
      // content 에만 위젯을 넣어서 표시 예정임.
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                child: _chatroomModel.value == null
                    ? Shimmer.fromColors(
                        highlightColor: Colors.grey[200]!,
                        baseColor: Colors.grey,
                        child: Container(
                          width: 48,
                          height: 48,
                          color: Colors.white,
                        ),
                      )
                    : ExtendedImage.network(
                        _chatroomModel.value!.itemImage,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    // todo: 거래완료 여부 확인 필드 추가
                    text: TextSpan(
                        text: '거래완료',
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                              text: _chatroomModel.value == null
                                  ? ''
                                  : ' ' + _chatroomModel.value!.itemTitle,
                              // text: ' 복숭아 떨이',
                              style: Theme.of(context).textTheme.bodyText2)
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        text: _chatroomModel.value == null
                            ? ''
                            : _chatroomModel.value!.itemPrice
                                .toCurrencyString(mantissaLength: 0, trailingSymbol: '원'),
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                            text: _chatroomModel.value == null
                                ? ''
                                : _chatroomModel.value!.negotiable
                                    ? '  (가격제안가능)'
                                    : '  (가격제안불가)',
                            style: _chatroomModel.value == null
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: Colors.black26)
                                : _chatroomModel.value!.negotiable
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: Colors.blue)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: Colors.black26),
                          )
                        ]),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            // 버튼 사이즈를 줄이기 위해서 SizedBox 추가
            child: SizedBox(
              height: 32,
              child: TextButton.icon(
                onPressed: () {
                  debugPrint('후기남기기 클릭~~');
                },
                icon: const Icon(
                  Icons.edit,
                  // 버튼 사이즈를 줄이기 위해서 size 추가 설정,
                  size: 16,
                  color: Colors.black87,
                ),
                label: Text(
                  '후기 남기기',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black87),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.grey[300]!, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(UserModel1 userModel) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                // 메시지 입력박스를 조금 작게 줄임,
                isDense: true,
                // fillColor & filled 동시에 설정해야함.
                fillColor: Colors.white,
                filled: true,
                suffixIcon: GestureDetector(
                  onTap: () {
                    logger.d('Icon clicked');
                  },
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.grey,
                  ),
                ),
                // 아이콘때문에 입력 박스가 커져서 줄여줌 설정,
                suffixIconConstraints: BoxConstraints.tight(const Size(40, 40)),
                // 입력 박스의 패딩 공간을 줄임, 미설정시 16쯤 됨,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              ChatModel2 chatModel = ChatModel2(
                userKey: userModel.userKey,
                msg: _textEditingController.text,
                createdDate: DateTime.now(), // addNewChat->toJson 에서 toUtc() 재처리함.
              );

              // await ChatService().createNewChat(chatroomKey, chatModel);
              // Obs 처리하여 삭제시에도 바로 반영된다. 그래서 삭제시 화면에 바로 반영되서 기존것으로 원복함.
              ChatController.to.addNewChat(chatModel);
              // logger.d(_textEditingController.text.toString());
              _textEditingController.clear();
            },
            icon: const Icon(
              Icons.send,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
