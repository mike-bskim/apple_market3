import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/chat_model.dart';

const roundedCorner = Radius.circular(20);

class Chat extends StatelessWidget {
  final Size size;
  final bool isMine;
  final ChatModel2 chatModel;

  const Chat(
      {Key? key,
        required this.size,
        required this.isMine,
        required this.chatModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMine ? _buildMyMsg(context) : _buildOthersMsg(context);
  }

  Widget _buildMyMsg(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(DateFormat('HH:mm').format(chatModel.createdDate)),
        const SizedBox(
          width: 8,
        ),
        Container(
          child: Text(
            chatModel.msg,
            style: Theme.of(context).textTheme.bodyText1!
                .copyWith(color: Colors.white),
          ),
          // 발품선의 여백 설정
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          // 말풍선의 최소 높이 40, 화면 폭의 60% 사이즈,
          constraints: BoxConstraints(
            minHeight: 40,
            maxWidth: size.width * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
              topLeft: roundedCorner,
              topRight: Radius.circular(2),
              bottomRight: roundedCorner,
              bottomLeft: roundedCorner,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOthersMsg(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExtendedImage.network(
          'https://randomuser.me/api/portraits/women/26.jpg',
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        const SizedBox(width: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: Text(
                chatModel.msg,
                style: Theme.of(context).textTheme.bodyText1!
                    .copyWith(color: Colors.white),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              constraints: BoxConstraints(
                minHeight: 40,
                maxWidth: size.width * 0.55,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300]!,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: roundedCorner,
                  bottomRight: roundedCorner,
                  bottomLeft: roundedCorner,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(DateFormat('HH:mm').format(chatModel.createdDate)),
          ],
        ),
      ],
    );
  }
}
