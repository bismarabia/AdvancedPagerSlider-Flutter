import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SliderIndicatorPosition {
  TOP,
  BOTTOM,
}

class PageSlider extends StatefulWidget {
  final List<Widget> widgets;
  final bool hideSliderIndicator;
  final bool hidePaginationIndexer;
  final bool overlaySliderIndicator;
  final bool disableSWiping;
  final bool pageSnapping;
  final bool reverse;
  final double height;
  final SliderIndicatorPosition sliderIndicatorPosition;
  final Function(int value) onPageChanged;

  final int initialPage;

  @override
  _PageSliderState createState() => _PageSliderState();

  const PageSlider({
    Key key,
    this.widgets,
    this.hideSliderIndicator = false,
    this.hidePaginationIndexer = false,
    this.overlaySliderIndicator = false,
    this.disableSWiping = false,
    this.reverse = false,
    this.pageSnapping = true,
    this.onPageChanged,
    this.height,
    this.initialPage,
    this.sliderIndicatorPosition = SliderIndicatorPosition.BOTTOM,
  }) : super(key: key);
}

class _PageSliderState extends State<PageSlider> {
  PageController pageController;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      //initialPage: widget.initialPage ?? 0,
    );
    _currentIndex = widget.initialPage ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    bool isFullScreen = widget.height == null;
    Widget _sliderPagination =
        getSliderPagination(_currentIndex, widget.widgets.length);
    Widget sliderIndicator = widget.hideSliderIndicator
        ? Container()
        : isFullScreen
            ? Expanded(child: _sliderPagination, flex: 1)
            : _sliderPagination;

    List<Widget> widgetsListForColumn = <Widget>[
      !isFullScreen
          ? _indexedStack(null)
          : Expanded(child: _indexedStack(null), flex: 20),
      sliderIndicator,
    ];

    return widget.overlaySliderIndicator
        ? Column(
            children: <Widget>[
              !isFullScreen
                  ? _indexedStack(sliderIndicator)
                  : Expanded(child: _indexedStack(sliderIndicator), flex: 20)
            ],
          )
        : Column(
            children:
                widget.sliderIndicatorPosition == SliderIndicatorPosition.BOTTOM
                    ? widgetsListForColumn
                    : widgetsListForColumn.reversed.toList(),
          );
  }

  Widget _indexedStack(Widget sliderIndicator) {
    return Container(
      color: Colors.grey,
      height: widget.height,
      child: Stack(
        children: <Widget>[
          PageView(
            controller: pageController,
            physics:
                widget.disableSWiping ? NeverScrollableScrollPhysics() : null,
            pageSnapping: widget.pageSnapping,
            reverse: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (page) {
              setState(() {
                _currentIndex = page;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged(page);
              }
            },
            children: widget.widgets,
          ),
          widget.hidePaginationIndexer
              ? Container()
              : Container(
                  height: widget.height,
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          getIndexer(
                            Icons.navigate_before,
                            () {
                              if (_currentIndex > 0) {
                                setState(() {
                                  --_currentIndex;
                                });
                                animateTo(_currentIndex);
                              }
                            },
                          ),
                          getIndexer(
                            Icons.navigate_next,
                            () {
                              print("$_currentIndex");
                              if (_currentIndex < widget.widgets.length - 1) {
                                setState(() {
                                  ++_currentIndex;
                                });
                                animateTo(_currentIndex);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          Container(
            height: widget.height,
            child: Column(
              mainAxisAlignment: widget.sliderIndicatorPosition ==
                      SliderIndicatorPosition.BOTTOM
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[sliderIndicator ?? Container()],
            ),
          )
        ],
      ),
    );
  }

  void animateTo(int page) {
    pageController.animateToPage(_currentIndex,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }

  Widget getIndexer(IconData icon, Function onPressed) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Color.fromRGBO(128, 128, 128, 0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(0.0),
        onPressed: onPressed,
      ),
    );
  }

  Widget getSliderPagination(int currentIndex, int length) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Padding>.generate(length, (i) {
          return Padding(
            padding: EdgeInsets.only(right: 3),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 10,
                width: 10,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == i ? Colors.grey : Color(0xffe2e2e2),
                ),
              ),
              onTap: () {
                setState(() {
                  _currentIndex = i;
                });
                animateTo(_currentIndex);
              },
            ),
          );
        }),
      ),
    );
  }
}
