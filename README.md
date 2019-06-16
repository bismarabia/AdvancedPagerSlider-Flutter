# AdvancedPagerSlider-Flutter

An Advanced version of Flutter [PageView] [github-link] with more extra awesome widgets.

## Usage

```dart
import 'package:advanced_page_slider/advanced_page_slider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced PageView Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Advanced PageView Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageSlider(
        //height: MediaQuery.of(context).size.height / 2,
        initialPage: 0,
        hidePaginationIndexer: false,
        disableSWiping: false,
        hideSliderIndicator: false,
        sliderIndicatorPosition: SliderIndicatorPosition.BOTTOM,
        overlaySliderIndicator: true,
        onPageChanged: (page) => print("page $page"),
        reverse: false,
        scrollDirection: Axis.horizontal,
        widgets: [
          Container(
            child: Center(
              child: Text("text 1"),
            ),
          ),
          Container(
            child: Center(
              child: Text("text 2"),
            ),
          ),
          Container(
            child: Center(
              child: Text("text 3"),
            ),
          ),
        ],
      ),
    );
  }
}
```

## License

MIT


[github-link]: <https://github.com/bismarabia/AdvancedPagerSlider-Flutter>