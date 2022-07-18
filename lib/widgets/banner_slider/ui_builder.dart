import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kegi_sudo/models/banner_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'block.dart';

class BannerSliderUIBuilder extends StatefulWidget {
  const BannerSliderUIBuilder({Key? key, @required this.data}) : super(key: key);
  final Stream<BannerListModel>? data;

  @override
  _BannerSliderUIBuilderState createState() => _BannerSliderUIBuilderState();
}

class _BannerSliderUIBuilderState extends State<BannerSliderUIBuilder> {
  PageController? _pageController;
  int _currentPage = 0;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 1.0);
    Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController!.hasClients) {
        _pageController!.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeOutSine,
        );
      }
    });
  }

  AnimatedBuilder _movieSelector(BannerListModel data, int index) {
    return AnimatedBuilder(
      animation: _pageController!,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController!.position.haveDimensions) {
          value = _pageController!.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0) as double;
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 270.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {

        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Center(
                  child: Hero(
                    tag: data.result!.bannerIds![index],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: BannerSliderBlock(
                        data: data.result!.bannerIds![index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: StreamBuilder<BannerListModel>(
        stream: widget.data,
        builder:
            (BuildContext context, AsyncSnapshot<BannerListModel> snapshot) {
          if (snapshot.hasData) {
            return PageView.builder(
              controller: _pageController,
              itemCount: snapshot.data!.result!.bannerIds!.length,
              itemBuilder: (BuildContext context, int index) {
                return _movieSelector(snapshot.data!, index);
              },
              onPageChanged: (int index) {
                _currentPageNotifier.value = index;
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.white60,
              child: Row(
                children: <Widget>[
                  Container(
                  //  padding: EdgeInsets.only(left: 8,right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),),
                    height: 200.0,
                    width: 95.w,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
