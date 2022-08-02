import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/common_size.dart';

class ItemsPage extends StatefulWidget {
  // final String userKey;
  const ItemsPage({Key? key}) : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    // 사진 사이즈를 화면 비율에 맞춰서 비례적으로 주기 위해서 LayoutBuilder 사용함,
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;

        return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 5)),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: (snapshot.connectionState == ConnectionState.done)
                    ? _listView(imgSize)
                    : _shimmerListView(imgSize),
              );
            });
      },
    );
  }

  Widget _listView(double imgSize) {
    return ListView.separated(
      padding: const EdgeInsets.all(padding_16),
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 1,
          // 실제 라인 두께
          color: Colors.grey[400],
          height: padding_16 * 2 + 1,
          // 라인 위/아래의 공간
          indent: padding_16,
          // 시작 부분 공간
          endIndent: padding_16, // 끝나는 부분 공간
        );
      },
      itemCount: 10,
      itemBuilder: (context, index) {
        return InkWell(//InkWell
          onTap: () {
            // UserService().fireStoreTest();
            // UserService().fireStoreReadTest();
            //
          },
          child: SizedBox(
            height: imgSize,
            child: Row(
              children: <Widget>[
                SizedBox(
                    height: imgSize,
                    width: imgSize,
                    child: ExtendedImage.network(
                      'https://picsum.photos/200',
                      fit: BoxFit.cover,
                      // borderRadius 를 사용하기 위해서는, BoxShape.rectangle 설정도 같이 해야함,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                const SizedBox(
                  width: padding_16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('제목', style: Theme.of(context).textTheme.subtitle1),
                      Text(
                        '50일전',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const Text('300 원'),
                      // 금액과 하트 사이에 공백을 최대한 주기위해서 Expanded 사용함,
                      Expanded(child: Container()),
                      // Row 가 2번 사용된 이유는 아래와 같다.
                      Row(
                        // 오론쪽 끝으로 정렬하기
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 폰트 사이즈를 줄이기 위해서 사이즈박스로 처리
                          SizedBox(
                            height: 16,
                            // 이걸로 다시 FittedBox 로 감싸면, 위젯 밖으로 나가지 못한다.
                            // 하지만 하위에 위치한 Row 정렬이 제 기능을 하지 못한다.
                            // 그래서 SizedBox 를 다시 한번더 Row 로 감싸고 정렬을 추가한다
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(CupertinoIcons.chat_bubble_2, color: Colors.grey),
                                  Text('23', style: TextStyle(color: Colors.grey)),
                                  Icon(CupertinoIcons.heart, color: Colors.grey),
                                  Text('123', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerListView(double imgSize) {
    // BoxDecoration 에서 색상을 설정시, Container 에서는 색상정보를 제거해야 한다,
    BoxDecoration containerDeco({required double radius}) {
      return BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius));
    }

    _containerSample({required double height, required double width, required double radius}) {
      return Container(height: height, width: width, decoration: containerDeco(radius: radius));
    }

    return Shimmer.fromColors(
      highlightColor: Colors.grey[100]!,
      enabled: true,
      baseColor: Colors.grey[300]!,
      period: const Duration(seconds: 2),
      child: ListView.separated(
        padding: const EdgeInsets.all(padding_16),
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
            color: Colors.black26,
            height: padding_16 * 2 + 1,
            indent: padding_16,
            endIndent: padding_16,
          );
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          return SizedBox(
            height: imgSize,
            child: Row(
              children: <Widget>[
                _containerSample(height: imgSize, width: imgSize, radius: 12.0),
                const SizedBox(width: padding_16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizeTransitionAnimation(key: UniqueKey(), height: 14, width: 140, radius: 4),
                      const SizedBox(height: 8),
                      SizeTransitionAnimation(key: UniqueKey(), height: 12, width: 70, radius: 4),
                      const SizedBox(height: 8),
                      SizeTransitionAnimation(key: UniqueKey(), height: 14, width: 100, radius: 4),
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizeTransitionAnimation(key: UniqueKey(), height: 14, width: 150, radius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SizeTransitionAnimation extends StatefulWidget {
  final double height;
  final double width;
  final double radius;

  const SizeTransitionAnimation({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
  }) : super(key: key);

  @override
  State<SizeTransitionAnimation> createState() => _SizeTransitionAnimationState();
}

class _SizeTransitionAnimationState extends State<SizeTransitionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: 0.7,
  )..repeat(reverse: true);

  late Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOut ,// Curve.~Cubic(0.9, 0.9, 0.9, 1.0)
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  BoxDecoration containerDeco({required double radius}) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      // Shimmer 때문에, 실제 gradient 는 동작하지 않음,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepOrange,
          Colors.deepPurple,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      axisAlignment: 0.5,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: containerDeco(radius: widget.radius),
      ),
    );
  }
}
