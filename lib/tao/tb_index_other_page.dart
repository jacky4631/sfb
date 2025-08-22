/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../service.dart';
import '../util/global.dart';
import '../util/tao_util.dart';
import '../page/product_details.dart';

///其它分类页面
class TbIndexOtherPage extends StatefulWidget {
  final Map data;

  const TbIndexOtherPage(this.data, {Key? key}) : super(key: key);
  @override
  _TbIndexOtherPageState createState() => _TbIndexOtherPageState();
}

class _TbIndexOtherPageState extends State<TbIndexOtherPage> {
  List<dynamic> _goodsList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasNext = true;
  int _currentPage = 1;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  Future<void> getListData({int? sort, int page = 1, bool isRef = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      if (isRef) {
        _currentPage = 1;
      }
    });

    try {
      var res = await BService.getGoodsList(page, cid: widget.data['cid']);
      setState(() {
        if (isRef) {
          _goodsList = List<dynamic>.from(res['list'] ?? []);
        } else {
          _goodsList.addAll(List<dynamic>.from(res['list'] ?? []));
        }
        _hasNext = (res['list'] as List?)?.isNotEmpty == true;
        _currentPage = page;
      });

      if (isRef) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = '网络异常';
      });
      if (isRef) {
        _refreshController.refreshFailed();
      } else {
        _refreshController.loadFailed();
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onRefresh() async {
    await getListData(isRef: true);
  }

  void _onLoading() async {
    if (_hasNext) {
      await getListData(page: _currentPage + 1);
    } else {
      _refreshController.loadNoData();
    }
  }

  Widget _buildTbFadeContainer(BuildContext context, int index, dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Global.openFadeContainer(
        _buildItemContent(index, item),
        ProductDetails(item),
      ),
    );
  }

  Widget _buildItemContent(int index, dynamic item) {
    num fee = (item['commissionRate'] ?? 0) * (item['actualPrice'] ?? 0) / 100;
    String shopType = (item['shopType'] == 1) ? '天猫' : '淘宝';
    String sales = BService.formatNum(item['monthSales'] ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商品图片
        AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              getTbMainPic(item),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        // 商品信息
        Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品标题
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item['dtitle'] ?? '',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // 价格信息
              Row(
                children: [
                  Text(
                    '¥${item['actualPrice'] ?? 0}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (item['originalPrice'] != null && item['originalPrice'] > item['actualPrice']) ...[
                    SizedBox(width: 8),
                    Text(
                      '¥${item['originalPrice']}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
              if (fee > 0) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    '返¥${fee.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
              SizedBox(height: 8),
              // 店铺信息
              Text(
                '$shopType | ${item['shopName'] ?? ''}',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
              SizedBox(height: 8),
              // 销量信息
              Text(
                '月销 $sales',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F6),
      body: _hasError
          ? _buildErrorWidget()
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: _hasNext,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              header: ClassicHeader(
                textStyle: TextStyle(color: Colors.grey),
                failedText: '刷新失败',
                completeText: '刷新完成',
                idleText: '下拉刷新',
                releaseText: '释放刷新',
                refreshingText: '刷新中...',
              ),
              footer: ClassicFooter(
                textStyle: TextStyle(color: Colors.grey),
                failedText: '加载失败',
                idleText: '上拉加载',
                loadingText: '加载中...',
                noDataText: '没有更多数据',
                canLoadingText: '释放加载更多',
              ),
              child: _goodsList.isEmpty && _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.54,
                      ),
                      itemCount: _goodsList.length,
                      itemBuilder: (context, index) {
                        return _buildTbFadeContainer(context, index, _goodsList[index]);
                      },
                    ),
            ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(_errorMessage, style: TextStyle(color: Colors.grey, fontSize: 16)),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => getListData(isRef: true),
            child: Text('重试'),
          ),
        ],
      ),
    );
  }
}
