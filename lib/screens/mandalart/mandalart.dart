import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/functions.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/screens/detail/detail.dart';
import 'package:madal_art/components/item.dart';
import 'package:madal_art/screens/mandalart/components/all_view_switch.dart';
import 'package:madal_art/screens/mandalart/components/custom_drawer.dart';
import 'package:madal_art/screens/mandalart/components/top_view_item.dart';

class MandalArtScreen extends StatefulWidget {
  @override
  _MandalArtScreenState createState() => _MandalArtScreenState();
}

enum ViewType { ALL, TOP }

class _MandalArtScreenState extends State<MandalArtScreen> {
  final DataController _dataController = Get.find<DataController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ViewType _viewType = ViewType.TOP;

  Widget _buildMandalArtItem(int index) {
    bool topView = _viewType == ViewType.TOP;

    return InkWell(
      onTap: () => _pushDetailView(index),
      child: Hero(
        tag: 'mandal-item-$index${topView ? '-4' : ''}',
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer, width: 0.5),
            color: topView && index == 4 ? Theme.of(context).colorScheme.primary : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: topView
            ? TopViewItem(index: index)
            : Item(group: index, allView: true),
        ),
      ),
    );
  }

  Widget _buildMandalArtAllView() {
    Size size = MediaQuery.of(context).size;
    final double mandalSize = Functions.getMandalSize(size);

    return SizedBox(
      width: mandalSize,
      height: mandalSize,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return _buildMandalArtItem(index);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [IconButton(
        onPressed: _openEndDrawer,
        color: Colors.grey,
        icon: Icon(Icons.menu),
      )],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AllViewSwitchButton(viewType: _viewType, onChange: _onChangeViewType),
            Obx(() {
              if (_dataController.currentMandalart == null) { return Container(); }
              return Center(child: _buildMandalArtAllView());
            }),
          ],
        ),
      ),
    );
  }

  // 상단 우측 메뉴 버튼 클릭 시
  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  // All View Switch On Changed event
  void _onChangeViewType(bool? value) {
    ViewType newViewType = value == true ? ViewType.ALL : ViewType.TOP;
    if (value == null || _viewType == newViewType) { return; }
    setState(() { _viewType = newViewType; });
  }

  // 만다라트 클릭 시, Detail View 로 이동
  void _pushDetailView(int index) {
    Get.to(() => DetailScreen(index: index), transition: Transition.fade, arguments: {
      'allView': _viewType == ViewType.ALL,
    });
  }
}
