import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class TabPageViewDemo extends StatefulWidget {
  const TabPageViewDemo({Key? key}) : super(key: key);

  @override
  State<TabPageViewDemo> createState() => _TabPageViewDemoState();
}

class _TabPageViewDemoState extends State<TabPageViewDemo> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  final List<String> _tabs = ['首页', '分类', '购物车', '我的'];
  final List<Color> _colors = [
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.orange.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();

    // 监听 TabController 变化，同步 PageView
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 自定义 Tab 栏
          Container(
            color: Colors.blue,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 0,
            ),
            child: TabBar(
              controller: _tabController,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
            ),
          ),
          // PageView 内容区域
          Expanded(
            child: _buildPageView(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _tabs.asMap().entries.map((entry) {
            int index = entry.key;
            String tab = entry.value;
            return GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _tabController.index == index ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: _tabController.index == index ? Colors.white : Colors.grey.shade600,
                    fontWeight: _tabController.index == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _tabs.length,
      onPageChanged: (index) {
        // 监听 PageView 变化，同步 TabController
        _tabController.animateTo(index);
      },
      itemBuilder: (context, index) {
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: EasyRefresh(
            onRefresh: () {},
            onLoad: () {},
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, listIndex) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _colors[index],
                      child: Icon(
                        _getIconForIndex(index),
                        color: Colors.grey.shade700,
                      ),
                    ),
                    title: Text("${_tabs[index]} - 项目 $listIndex"),
                    subtitle: Text(
                      "这是${_tabs[index]}页面的第$listIndex个项目",
                      maxLines: 1,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return SizedBox(height: 8);
              },
              itemCount: 20,
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.category;
      case 2:
        return Icons.shopping_cart;
      case 3:
        return Icons.person;
      default:
        return Icons.help;
    }
  }
}

// 使用示例
class TabPageViewDemoApp extends StatelessWidget {
  const TabPageViewDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab PageView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TabPageViewDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 如果要单独运行这个 demo，可以使用以下 main 函数
// void main() {
//   runApp(const TabPageViewDemoApp());
// }
