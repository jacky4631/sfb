import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/global.dart';
import 'menu_data.dart';

///菜单组件
class MenuWidget extends StatefulWidget {
  final Function? fun;
  final int count;
  const MenuWidget({
    Key? key,
    this.count = 10,
    this.fun,
  }) : super(key: key);
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  int page = 0;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    List data = menuData;
    // if(Global.userinfo == null || Global.userinfo?.level==1) {
    //   data[1].removeWhere((element) {
    //     return element['title'] == '美团外卖' || element['title'] == '饿了么';
    //   });
    // }

    if (_isLoading) {
      return Container(
        width: double.infinity,
        height: 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return GestureDetector(
        onTap: () => widget.fun?.call(),
        child: Container(
          width: double.infinity,
          height: 200,
          child: Center(child: Text('Error: $_error')),
        ),
      );
    }

    if (data.isEmpty || data.length < 2) {
      return const SizedBox.shrink();
    }

    List topIcons = data[0] as List;
    List bottomIcons = data[1] as List;
    var count = (bottomIcons.length / widget.count).ceil();

    return Column(
      children: [
        // Top icons section
        if (topIcons.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: Wrap(
              children: List.generate(topIcons.length, (i) {
                var wh = (MediaQuery.of(context).size.width - 16) / 5;
                var icon = topIcons[i] as Map;
                return createItem(icon, wh);
              }),
            ),
          ),
        // Bottom icons PageView section
        Container(
          height: 160,
          padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          child: PageView.builder(
            itemCount: count,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => page = i),
            itemBuilder: (_, i) {
              var isToEnd = (bottomIcons.length > ((i + 1) * widget.count));
              List sublist = bottomIcons.sublist(i * widget.count, isToEnd ? (i + 1) * widget.count : null);
              return Wrap(
                children: List.generate(sublist.length, (i) {
                  var wh = (MediaQuery.of(context).size.width - 16) / (widget.count / 2);
                  var icon = sublist[i];
                  return createItem(icon, wh);
                }),
              );
            },
          ),
        ),
        // Page indicators
        if (count > 1) const SizedBox(height: 8),
        if (count > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              count,
              (i) => Container(
                width: 16,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: page == i ? 1 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget createItem(Map icon, double wh) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => onTap(icon),
          child: Container(
            width: wh,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getImages(icon),
                const Spacer(),
                Text(
                  '${icon['title']}',
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        if (icon['arrow'] != null)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Colors.red, width: 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(1),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                icon['arrow'],
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ),
      ],
    );
  }

  Widget getImages(Map data) {
    String? path = data['path'];
    Widget image;
    if (path != null) {
      if (path.endsWith('.svg')) {
        image = Container(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(
            path,
            width: 48,
            height: 48,
            colorFilter: data['color'] != null ? ColorFilter.mode(data['color'], BlendMode.srcIn) : null,
          ),
        );
      } else {
        image = Container(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            path,
            width: 48,
            height: 48,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 48);
            },
          ),
        );
      }
    } else {
      image = Container(
        padding: const EdgeInsets.all(4),
        child: Image.network(
          data['img'] ?? '',
          width: 56,
          height: 56,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 56);
          },
        ),
      );
    }
    return image;
  }

  void onTap(Map v) {
    if (v['type'] == '1') {
      Navigator.pushNamed(context, v['url']);
    } else {
      ///点击事件
      switch (v['title']) {
        case '美团外卖':
          //打开微信美团小程序
          Global.launchMeituanWechat(context);
          break;
        case '饿了么':
          Global.openEle(context);
          break;
      }
    }
  }
}
