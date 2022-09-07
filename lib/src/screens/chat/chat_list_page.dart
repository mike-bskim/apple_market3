import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/data_keys.dart';
import '../../models/chatroom_model.dart';
import '../../repo/chat_service.dart';
import '../../utils/logger.dart';
import '../../utils/time_calculation.dart';

class ChatListPage extends StatelessWidget {
  final String userKey;

  const ChatListPage({Key? key, required this.userKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String userKey = context.read<UserNotifier>().userModel!.userKey;

    return FutureBuilder<List<ChatroomModel2>>(
        future: ChatService().getMyChatList(userKey),
        builder: (context, snapshot) {
          Size _size = MediaQuery.of(context).size;

          return Scaffold(
            body: ListView.separated(
                itemBuilder: (context, index) {
                  ChatroomModel2 chatroomModel = snapshot.data![index];
                  // bool iamBuyer = chatroomModel.buyerKey == userKey;

                  // 현재 시간과 작성시간의 차이 계산
                  String gapTime = TimeCalculation.getTimeDiff(chatroomModel.lastMsgTime);
                  // 화면 표시용 지역명 표시
                  List _address = chatroomModel.itemAddress.split(' ');
                  String _detail = _address[_address.length - 1];
                  String _location = '';
                  if (_detail.contains('(') && _detail.contains(')')) {
                    _location = _detail.replaceAll('(', '').replaceAll(')', '');
                  } else {
                    _location = _address[2];
                  }

                  return ListTile(
                    onTap: () {
                      logger.d(chatroomModel.chatroomKey);
                      Get.toNamed("/$ROUTE_ITEM_DETAIL/${chatroomModel.chatroomKey}");
                      // context.beamToNamed('/${chatroomModel.chatroomKey}');
                    },
                    // 작성자 이미지가 없으므로 임시 이미지로 표시
                    leading: ExtendedImage.network(
                      'https://randomuser.me/api/portraits/women/18.jpg',
                      height: _size.height / 8,
                      width: _size.width / 8,
                      fit: BoxFit.cover,
                      shape: BoxShape.circle,
                    ),
                    // 제품 이미지 표시
                    trailing: ExtendedImage.network(
                      chatroomModel.itemImage,
                      height: _size.height / 8,
                      width: _size.width / 8,
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // title: RichText(
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   text: TextSpan(
                    //     text: iamBuyer?chatroomModel.sellerKey:chatroomModel.buyerKey,
                    //     style: Theme.of(context).textTheme.subtitle1,
                    //     children: [
                    //       TextSpan(text: ' '),
                    //       TextSpan(
                    //         text: chatroomModel.itemAddress,
                    //         style: Theme.of(context).textTheme.subtitle2,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    title: Row(
                      children: [
                        // 게시글 타이틀 표시
                        Expanded(
                          child: Text(
                            chatroomModel.itemTitle,
                            maxLines: 1,
                            // 1줄 이상이면 ... 으로 표시
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        // 간략 주소 및 (현제일자-작성일자) 표시,
                        Text(
                          _location == '+'
                              ? _address[0] + '/' + gapTime
                              : _location + '/' + gapTime,
                          //chatroomModel.itemAddress,
                          maxLines: 1,
                          // 1줄 이상이면 ... 으로 표시
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    // 마지막 메시지 표시
                    subtitle: Text(
                      chatroomModel.lastMsg,
                      maxLines: 1,
                      // 1줄 이상이면 ... 으로 표시
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(thickness: 1, height: 1, color: Colors.grey[300]);
                },
                itemCount: snapshot.hasData ? snapshot.data!.length : 0),
          );
        });
  }
}
