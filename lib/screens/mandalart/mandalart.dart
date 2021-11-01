import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/fuctions.dart';
import 'package:madal_art/screens/detail/detail.dart';
import 'package:madal_art/screens/mandalart/components/item.dart';

class MandalArtScreen extends StatefulWidget {
  @override
  _MandalArtScreenState createState() => _MandalArtScreenState();
}

class _MandalArtScreenState extends State<MandalArtScreen> {
  late Size size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    final double mandalSize = Functions.getMandalSize(size);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
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
                return InkWell(
                  onTap: () {
                    _pushDetailView(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                    ),
                    child: Hero(
                      tag: 'mandal-item-$index',
                      child: Item(
                        group: index,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _pushDetailView(int index) {
    Get.to(DetailScreen(index: index), transition: Transition.fade);
  }
}
