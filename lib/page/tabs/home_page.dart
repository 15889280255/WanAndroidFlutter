import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroidflutter/api/view_model/home_view_model.dart';
import 'package:wanandroidflutter/common/global.dart';
import 'package:wanandroidflutter/widget/base/base_widget.dart';
import 'package:wanandroidflutter/widget/loading_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final HomeViewModel viewModel = HomeViewModel();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: EasyRefresh.custom(
          controller: viewModel.getEasyRefreshController,
          footer: ClassicalFooter(
              bgColor: Colors.white,
              noMoreText: '没有更多了',
              loadingText: '正在加载',
              loadedText: '加载完成'),
          header: ClassicalHeader(
              refreshedText: '正在刷新',
              refreshReadyText: '刷新',
              refreshText: '下拉刷新'),
          onRefresh: () => viewModel.onRefresh(),
          onLoad: () => viewModel.onLoad(),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.grey[100],
              expandedHeight: 200.px,
              flexibleSpace: FlexibleSpaceBar(
                background: BannerWidget(viewModel: viewModel),
              ),
            ),
            SliverToBoxAdapter(child: ArticleListWidget(viewModel: viewModel)),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BannerWidget extends StatelessWidget {
  final HomeViewModel viewModel;
  BannerWidget({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      viewModel: viewModel,
      onFirstLoading: (v) {
        v.getBannerData();
      },
      builder: (context, model, child) {
        if (model.reqStatus == ReqStatus.success) {
          return Swiper(
            viewportFraction: 0.7,
            scale: 1,
            layout: SwiperLayout.STACK,
            itemWidth: winWidth * 0.90,
            itemHeight: winHeight * 0.28.px,
            itemCount: model.getBannerList.length,
            itemBuilder: (BuildContext context, int index) {
              String url = model.getBannerList[index].imagePath;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(10),
                ),
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(url))),
                ),
              );
            },
            onTap: (index) {
              model.cardOnTap(url: model?.getBannerList[index].url,title: model?.getBannerList[index].title);
            },
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}

class ArticleListWidget extends StatelessWidget {
  final HomeViewModel viewModel;
  ArticleListWidget({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      viewModel: viewModel,
      onFirstLoading: (v) {
        v.getHomeArticleData();
      },
      builder: (context, model, child) {
        if (model.reqStatus == ReqStatus.success) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 5.px),
            itemCount: model.getArticleList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                child: Card(
                  color: Colors.blueGrey[400],
                  elevation: 8,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.px, horizontal: 10.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(model.getArticleList[index].title,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  maxLines: 2),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Visibility(
                              visible:
                                  model?.getArticleList[index]?.author == ''
                                      ? false
                                      : true,
                              child: Text(
                                  'by：${model?.getArticleList[index]?.author}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Spacer(),
                            Text(model?.getArticleList[index]?.niceDate,
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () => model.cardOnTap(
                    url: model?.getArticleList[index]?.link,
                    title: model?.getArticleList[index]?.title),
              );
            },
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}
