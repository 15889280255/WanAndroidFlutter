import 'package:flutter/material.dart';
import 'package:wanandroidflutter/page/tabs/project_page.dart';
import 'package:wanandroidflutter/page/tabs/home_page.dart';
import 'package:wanandroidflutter/page/tabs/mine_page.dart';
import 'package:wanandroidflutter/util/size_util.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  PageController _pageController = PageController();

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItem = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
    BottomNavigationBarItem(icon: Icon(Icons.transfer_within_a_station), title: Text('项目')),
    BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我的')),
  ];

  @override
  Widget build(BuildContext context) {
    print('RootBuild');
    SizeUtil.initSize(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[HomePage(), ProjectPage(), MinePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        items: bottomItem,
        onTap: (int index) {
          interceptors(index);
          setState(() {
            currentIndex = index;
            _pageController.jumpToPage(currentIndex);
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  interceptors(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      default:
        break;
    }
  }
}
