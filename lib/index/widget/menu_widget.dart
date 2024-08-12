import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/custom_scroll_physics.dart';
import 'package:maixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import '../../util/global.dart';
import '../../util/launchApp.dart';
import '../../util/paixs_fun.dart';
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
  @override
  Widget build(BuildContext context) {
    List data = menuData;
    // if(Global.userinfo == null || Global.userinfo?.level==1) {
    //   data[1].removeWhere((element) {
    //     return element['title'] == '美团外卖' || element['title'] == '饿了么';
    //   });
    // }
    DataModel menuModel = DataModel(value: data);
    menuModel.addList([{}], true, 0);
    return AnimatedSwitchBuilder(
      value: menuModel,
      errorOnTap: () => widget.fun!(),
      noDataView: PWidget.boxh(0),
      errorView: PWidget.boxh(0),
      initialState: PWidget.container(null, [double.infinity]),
      isAnimatedSize: false,
      valueBuilder: (v) {
        var count = (v.last.length / widget.count).ceil();
        return PWidget.column([
          Builder(builder: (context) {
            var icons = v.first as List;
            return PWidget.container(
              Wrap(
                children: List.generate(icons.length, (i) {
                  var wh = (pmSize.width - 16) / 5;
                  var icon = icons[i] as Map;
                  return createItem(icon, wh);
                }),
              ),
              {'pd': PFun.lg(0, 0, 8, 8)},
            );
          }),
          PWidget.container(
            PageView.builder(
              itemCount: count,
              physics: PagePhysics(parent: MyBouncingScrollPhysics()),
              onPageChanged: (i) => setState(() => page = i),
              itemBuilder: (_, i) {
                var isToEnd = (v.last.length > ((i + 1) * widget.count));
                // List sublist = widget.list.sublist(10 * i, (widget.list.length > ((i + 1) * 10)) ? 10 : null);
                List sublist = v.last.sublist(
                    i * widget.count, isToEnd ? (i + 1) * widget.count : null);
                return Wrap(
                  children: List.generate(sublist.length, (i) {
                    var wh = (pmSize.width - 16) / (widget.count / 2);
                    var icon = sublist[i];
                    return createItem(icon, wh);
                  }),
                );
              },
            ),
            [null, 160],
            {'pd': PFun.lg(0, 0, 8, 8)},
          ),
          if(count > 1)
            PWidget.boxh(8),
          if(count > 1)
            PWidget.row(
              List.generate(
                  count,
                  (i) => PWidget.container(
                      null,
                      [16, 4, Colors.red.withOpacity(page == i ? 1 : 0.1)],
                      {'br': 8, 'mg': 2})),
              '221'),
        ]);
      },
    );
  }

  Widget createItem(icon, wh) {
    return Stack(
      children: [
        PWidget.container(
          PWidget.ccolumn([
            getImages(icon),
            PWidget.spacer(),
            PWidget.textNormal('${icon['title']}', [Colors.black, 13]),
            PWidget.spacer(),
          ]),
          [wh, 80],
          {'fun': () => onTap(icon)},
        ),
        if(icon['arrow'] != null)
        PWidget.positioned(
            PWidget.container(
              PWidget.textNormal(icon['arrow'], [Colors.white, 9]),
              [null, null, Colors.red],
              {'bd': PFun.bdAllLg(Colors.red, 0.5),'pd':PFun.lg(1, 1, 2, 2), 'br': PFun.lg(8, 8, 1, 8)},
            ),
            [2, null, null, 2])
      ],
    );
  }

  Widget getImages(Map data) {
    String path = data['path'];
    Widget image;
    if (path != null) {
      if (path.endsWith('.svg')) {
        image = PWidget.container(
            SvgPicture.asset(
              path,
              width: 48,
              height: 48,
              color: data['color'],
            ),
            {'pd': 4});
        ;
      } else {
        image = PWidget.container(PWidget.image(path, [48, 48]), {'pd': 4});
      }
    } else {
      image = PWidget.wrapperImage(data['img'], [56, 56], {'pd': 4});
    }
    return image;
  }

  onTap(v) {
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
