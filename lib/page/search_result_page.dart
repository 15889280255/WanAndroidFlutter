import 'package:flutter/material.dart';
import 'package:wanandroidflutter/api/view_model/search_result_view_model.dart';
import 'package:wanandroidflutter/common/global.dart';
import 'package:wanandroidflutter/util/navigator_util.dart';
import 'package:wanandroidflutter/widget/base/base_widget.dart';
import 'package:wanandroidflutter/widget/base/error_widget.dart';
import 'package:wanandroidflutter/widget/base/loading_widget.dart';

class SearchResultPage extends StatefulWidget {
  final String keys;
  SearchResultPage({@required this.keys});
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  SearchResultViewModel _searchResultViewModel = SearchResultViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.keys}'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            NavigatorUtil.maybePop();
          },
        ),
      ),
      body: BaseWidget<SearchResultViewModel>(
        viewModel: _searchResultViewModel,
        onFirstLoading: (v) {
          v.getSearchResultData(key:widget.keys);
        },
        builder: (context, viewModel, child) {
          if (viewModel.getReqStatus == ReqStatus.error) {
            return ErrorWidgetPage();
          }
          if (viewModel.getReqStatus == ReqStatus.loading &&
              viewModel.getSearchResultList.isEmpty) {
            return LoadingWidget();
          } else {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Wrap(
                spacing: 20,
                children: viewModel.getSearchResultList.map((e) {
                  return InkWell(
                    child: Chip(
                      elevation: 3,
                      backgroundColor: Colors.white,
                      label: Text(e.title),
                    ),
                    onTap: ()=>viewModel.searchOnTap(key: e.title),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}