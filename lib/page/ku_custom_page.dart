/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';

import '../widget/lunbo_widget.dart';
import '../widget/tab_widget.dart';

//库通用页面
class KuCustomPage extends StatefulWidget {
  final Map data;
  const KuCustomPage(this.data, {Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<KuCustomPage> {
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;

  // Tab data state management
  List _tabData = [];
  bool _isTabLoading = true;
  bool _hasTabError = false;
  String _tabErrorMessage = '';

  @override
  void initState() {
    super.initState();

    // 对 scrollController 进行监听
    _scrollController.addListener(() {
      // _scrollController.position.pixels 获取当前滚动部件滚动的距离
      // 当滚动距离大于 800 之后，显示回到顶部按钮
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
    getTabData();
  }

  ///tab数据
  Future<int> getTabData() async {
    setState(() {
      _isTabLoading = true;
      _hasTabError = false;
    });

    try {
       var res = await BService.kuCustomCate(widget.data['link']);
       if (res.isNotEmpty) {
         List content = res['content'];
         setState(() {
           _tabData = content.where((element) => element['type'] == 'list').toList();
           _isTabLoading = false;
           _hasTabError = false;
         });
         return 1;
       } else {
        setState(() {
          _isTabLoading = false;
          _hasTabError = true;
          _tabErrorMessage = '数据加载失败';
        });
        return 0;
      }
    } catch (e) {
      setState(() {
        _isTabLoading = false;
        _hasTabError = true;
        _tabErrorMessage = '网络异常';
      });
      return 0;
    }
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List imgs = [];
    Color bg = Colors.white;
    if (_tabData.isNotEmpty) {
      if (_tabData[0] is Map) {
        String imgUrl = _tabData[0]['_attr']['appUrl'];
        String bgColor = _tabData[0]['_attr']['backgroundColor'];
        if (!Global.isEmpty(bgColor)) {
          bg = Global.theColor(bgColor);
        }
        if (!imgUrl.startsWith('https')) {
          imgUrl = imgUrl.replaceFirst('http', 'https');
        }
        imgs.add({'img': imgUrl});
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bg, bg],
              ),
            ),
          ),
          Scaffold(
            floatingActionButton:
                _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                    ? FloatingActionButton(
                        backgroundColor: const Color(0xFFFF6B35),
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
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(200),
              child: Stack(
                children: [
                  _tabData.isNotEmpty
                      ? LunboWidget(
                          imgs,
                          value: 'img',
                          aspectRatio: 75 / 31,
                          loop: false,
                          fun: (v) {},
                        )
                      : const SizedBox(),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
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
                ],
              ),
            ),
            body: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isTabLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
        ),
      );
    }

    if (_hasTabError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _tabErrorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getTabData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
              ),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_tabData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '暂无数据',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    var tabList = _tabData.map<String>((m) {
      String name = (m! as Map)['_attr']['appName'];
      if (Global.isEmpty(name)) {
        name = (m! as Map)['_attr']['name'];
      }
      return name;
    }).toList();

    return TabWidget(
      tabList: tabList,
      indicatorColor: Colors.white.withValues(alpha: 0),
      tabPage: List.generate(tabList.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(
              top: 10, left: 20, right: 20, bottom: 10),
          child: TopChild(_scrollController, _tabData[i] as Map),
        );
      }),
    );
  }
}

class TopChild extends StatefulWidget {
  final ScrollController scrollController;
  final Map data;
  const TopChild(this.scrollController, this.data, {Key? key})
      : super(key: key);
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  // List data state management
  List _listData = [];
  bool _isListLoading = true;
  bool _hasListError = false;
  String _listErrorMessage = '';
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        _isListLoading = true;
        _hasListError = false;
        _currentPage = 1;
      });
    }

    try {
      Map param = widget.data['_attr']['auto_form'];
      List list = widget.data['_attr']['goodsList'];
      List<String> ids = list.map((e) => e['id'].toString()).toList();
      param['item'] = Global.listToString(ids);
      
      var res = await BService.kuCustomList(param);
       if (res.isNotEmpty) {
         setState(() {
           if (isRef) {
             _listData = res;
           } else {
             _listData.addAll(res);
           }
           _isListLoading = false;
           _hasListError = false;
           _hasMore = res.length >= 20; // 假设每页20条数据
           if (!isRef) {
             _currentPage++;
           }
         });
         return 1;
       } else {
        setState(() {
          _isListLoading = false;
          _hasListError = true;
          _listErrorMessage = '数据加载失败';
        });
        return 0;
      }
    } catch (e) {
      setState(() {
        _isListLoading = false;
        _hasListError = true;
        _listErrorMessage = '网络异常';
      });
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isListLoading && _listData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff9cc8c)),
        ),
      );
    }

    if (_hasListError && _listData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _listErrorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
              ),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_listData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '暂无商品',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      child: ListView.separated(
        controller: widget.scrollController,
        itemCount: _listData.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          if (index == _listData.length) {
            // 加载更多指示器
            if (_hasMore) {
              // 自动加载更多
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isListLoading) {
                  getListData(page: _currentPage);
                }
              });
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '没有更多数据了',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
          }

          var data = _listData[index] as Map;
          return ClipRRect(
             borderRadius: BorderRadius.circular(15),
             child: GestureDetector(
               onTap: () {
                 Global.openFadeContainer(createItem(data), ProductDetails(data));
               },
               child: createItem(data),
             ),
           );
        },
      ),
    );
  }

  Widget createItem(data) {
    var endPrice = data['itemendprice'];
    var endPriceD = double.parse(endPrice);
    var price = data['itemprice'];
    var priceD = double.parse(price);
    List<Widget> labels = getLabel(data);

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
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
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
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
                Text(
                  data['itemshorttitle'],
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 32,
                    color: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                            data['shopname'],
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
                Wrap(
                  spacing: 2,
                  children: labels,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '¥$endPriceD',
                            style: const TextStyle(
                              color: Color(0xFFFD471F),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ¥$priceD',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getLabel(data) {
    List<Widget> labels = [];
    num length = 0;
    if (data['new_label'] != null) {
      List newLabel = jsonDecode(data['new_label']) as List;
      if (newLabel.isNotEmpty) {
        for (int i = 0; i < newLabel.length; i++) {
          Map newL = newLabel[i];
          if (Global.isEmpty(newL['name'].trim())) {
            continue;
          }
          labels.add(getLabelElement(newL['name']));
          length += newL['name'].length;
          if (length >= 8) {
            break;
          }
        }
        if (labels.isEmpty) {
          initOldLabel(data, labels, length);
        }
      }
    } else {
      initOldLabel(data, labels, length);
    }
    return labels;
  }

  initOldLabel(data, labels, length) {
    List labelsStr = data['label'];
    for (int i = 0; i < labelsStr.length; i++) {
      String lbl = labelsStr[i];
      labels.add(getLabelElement(lbl));
      length += lbl.length;
      if (length >= 9) {
        break;
      }
    }
  }

  Widget getLabelElement(String label, {exp = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFFFCA7E),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xfff3a731),
          fontSize: 12,
        ),
      ),
    );
  }
}
