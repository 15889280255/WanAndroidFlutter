import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroidflutter/api/api.dart';
import 'package:wanandroidflutter/common/global.dart';
import 'package:wanandroidflutter/model/home_article_model.dart';
import 'package:wanandroidflutter/page/web_view_page.dart';
import 'package:wanandroidflutter/util/navigator_util.dart';
import 'package:wanandroidflutter/widget/base/base_model.dart';

class HomeArticleViewModel extends BaseModel {
  List<HomeArticleModel> _articleList = List();

  EasyRefreshController _easyRefreshController = EasyRefreshController();

  int currentPage = 0;

  int totalPage = 0;

  List<HomeArticleModel> get getArticleList => _articleList;

  EasyRefreshController get getEasyRefreshController => _easyRefreshController;

  void getHomeArticleData({int page = 0}) {
    Api.getHomeArticleList(page: page).then((value) {
      if (value['data'] == null) throw Exception('${value['errorMsg']}');
      if (value != null && value['errorCode'] == 0) {
        totalPage = ((value['data']['total']) / 20).round();
        value['data']['datas'].map((m) {
          HomeArticleModel model = HomeArticleModel.fromJson(m);
          _articleList.add(model);
        }).toList();
        setState(ReqStatus.success);
      }
    }).catchError((e) {
      setState(ReqStatus.error);
      print("error+==========${e.toString()}");
    });
  }

  Future<void> onRefresh() {
    _articleList.clear();
    currentPage = 0;
    getHomeArticleData(page: currentPage);
    _easyRefreshController.finishLoad();
    return Future.value();
  }

  Future<void> onLoad() {
    if (currentPage < totalPage) {
      currentPage++;
      getHomeArticleData(page: currentPage);
    }
    return Future.value();
  }

  /// =============== Route =================
  void cardOnTap({url, title}) {
    NavigatorUtil.push(WebViewPage(
      openUrl: url,
      title: title,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
  }
}
