import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:maixs_utils/model/data_model.dart';

import '../provider/provider.dart';

double defaultActionBarHeight = 56;
double defaultStatusBarHeight = 35;
double defaultBottomNavigationBarHeight = 60;

AppBar mainAppBar(
  BuildContext context,
) {
  return AppBar(
    // backgroundColor: Colors.white,
    // leading: IconButton(onPressed: () {}, icon: const Icon(HugeIcons.strokeRoundedChangeScreenMode)
    // )
    // Consumer(
    //   builder: (context, ref, child) {
    //     final setting = ref.watch(configProvider);
    //     return Text('SVIP${setting.originType.index + 1}');
    //   },
    // ),

    title: InkWell(
        splashColor: Colors.transparent, // 设置水波纹颜色为透明
        highlightColor: Colors.transparent, // 设置高亮颜色为透明
        onTap: () {
          Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
        },
        child: const AppBarTitle()),
    actions: [
      // IconButton(onPressed: () {}, icon: const Icon(HugeIcons.strokeRoundedVynil02)),

      Consumer(builder: (
        context,
        ref,
        child,
      ) {
        return IconButton(
            onPressed: () {
              ref.refresh(bannersProvider.future).then((onValue) {
                print(onValue.list);
              }).catchError((e) {
                print(e);
              });

              // Navigator.pushNamed(context, '/messageCenter');
            },
            icon: const Icon(HugeIcons.strokeRoundedMail01));
      })
    ],
  );
}

class AppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTitle({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    print(isDarkMode);

    const double iconSize = 20.0;
    const int textAlpha = 80;
    return SizedBox(
      height: defaultActionBarHeight.toDouble(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          height: defaultActionBarHeight.toDouble(),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search, size: iconSize),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  "搜索商品或粘贴宝贝标题",
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
