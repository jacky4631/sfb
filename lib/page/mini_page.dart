/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/launchApp.dart';
import '../util/login_util.dart';
import '../widget/loading.dart';
import '../widget/lunbo_widget.dart';

//小样种草机
class MiniPage extends StatefulWidget {
  const MiniPage({Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<MiniPage> {
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;

  @override
  void initState() {
    super.initState();

    // 对 scrollController 进行监听
    _scrollController.addListener(() {
      // _scrollController.position.pixels 获取当前滚动部件滚动的距离
      // 当滚动距离大于 800 之后，显示回到顶部按钮
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bannerList = [
      {'img': 'https://img.bc.haodanku.com/cms/1646037895?t=1660822200000'}
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton:
          _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
              ? FloatingActionButton(
                  backgroundColor: const Color(0xfff9cc8c),
                  mini: true,
                  onPressed: () {
                    // scrollController 通过 animateTo 方法滚动到某个具体高度
                    // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                    _scrollController.animateTo(0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  },
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                )
              : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xfff9cc8c), Color(0xfff9cc8c)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(200),
            child: Stack(
              children: [
                LunboWidget(
                  bannerList,
                  value: 'img',
                  aspectRatio: 75 / 31,
                  loop: false,
                  fun: (v) {},
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: TopChild(),
          ),
        ),
      ),
    );
  }
}

class TopChild extends StatefulWidget {
  const TopChild({Key? key}) : super(key: key);
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  late String appName;
  List<Map<String, dynamic>> listData = [];
  bool isLoading = true;
  bool hasNext = true;
  String? errorMessage;
  int currentPage = 1;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName; //读取属性
    await getListData(isRef: true);
  }

  ///列表数据
  Future<void> getListData({int page = 1, bool isRef = false}) async {
    try {
      if (isRef) {
        setState(() {
          isLoading = true;
          errorMessage = null;
          currentPage = 1;
        });
      }

      var res = await BService.miniList(page);
      
      if (res != null && res.isNotEmpty) {
        setState(() {
          if (isRef) {
            listData = List<Map<String, dynamic>>.from(res);
          } else {
            listData.addAll(List<Map<String, dynamic>>.from(res));
          }
          hasNext = res.length >= 20; // 假设每页20条数据
          currentPage = page;
          isLoading = false;
        });
      } else {
        setState(() {
          hasNext = false;
          isLoading = false;
          if (isRef && listData.isEmpty) {
            errorMessage = '暂无数据';
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        if (isRef) {
          errorMessage = '网络异常，请重试';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && listData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff9cc8c)),
        ),
      );
    }

    if (errorMessage != null && listData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff9cc8c),
                foregroundColor: Colors.white,
              ),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      color: const Color(0xfff9cc8c),
      child: ListView.separated(
        controller: ScrollController(), // 使用新的控制器，避免冲突
        padding: EdgeInsets.zero,
        itemCount: listData.length + (hasNext ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          if (index >= listData.length) {
            // 加载更多指示器
            if (hasNext && !isLoading) {
              // 触发加载更多
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getListData(page: currentPage + 1);
              });
            }
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: hasNext
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    )
                  : const Text(
                      '没有更多数据了',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
            );
          }

          var data = listData[index];
          var endPrice = data['itemendprice'];
          var endPriceD = double.parse(endPrice);
          var price = data['itemprice'];
          var priceD = double.parse(price);
          String label = '大额回购券';
          if (data['new_label'] != null) {
            List labels = data['new_label'];
            if (labels.isNotEmpty) {
              label = labels[0];
            }
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  onTapDialogLogin(context, fun: () {
                    jump2Tb(data['itemid']);
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        data['itempic'],
                        width: 114,
                        height: 114,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 114,
                            height: 114,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 114,
                            height: 114,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xfff9cc8c)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getTitleWidget(data['itemshorttitle']),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              height: 32,
                              color: Colours.bg_light,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/mall/mini.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      data['shopname'] ?? '',
                                      style: const TextStyle(
                                        color: Color(0xfffd4040),
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFFFCA7E),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Color(0xfff3a731),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 8, right: 80),
                                alignment: Alignment.centerLeft,
                                child: _getPriceWidget(endPriceD, priceD),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/mall/ljq.jpg',
                                    width: 70,
                                    height: 39,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      '立即抢',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getTitleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _getPriceWidget(double endPrice, double originalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: '抢购价 ',
                style: TextStyle(
                  color: Color(0xFFFD471F),
                  fontSize: 12,
                ),
              ),
              TextSpan(
                text: '¥${endPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFFD471F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '¥${originalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }

  Future jump2Tb(itemId) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      title: '提示',
      desc: '$appName想要打开【淘宝APP】，是否继续？',
      btnOkColor: Colours.app_main,
      btnCancelColor: Colors.grey[400],
      btnOkText: '继续',
      btnCancelText: '取消',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        Loading.show(context);
        try {
          var res = await BService.getGoodsWord(itemId);
          Loading.hide(context);
          LaunchApp.launchTb(context, res['itemUrl']);
        } catch (e) {
          Loading.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('获取商品信息失败，请重试')),
          );
        }
      },
    ).show();
  }
}
