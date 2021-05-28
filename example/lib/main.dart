import 'package:flutter/material.dart';
import 'package:tab_bar_builder/tab_bar_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    tabs.addAll([
      _getTabContent('1'),
      _getTabContent('2'),
      _getTabContent('3'),
    ]);
  }

  Widget _getTabContent(String text) {
    return Center(child: Text(text, overflow: TextOverflow.ellipsis));
  }

  void addTab() {
    setState(() {
      tabs.add(
        _getTabContent(
          '${tabs.length + 1}',
        ),
      );
    });
  }

  void removeTab() {
    setState(() {
      tabs.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Example TabBarBuilder'),
          actions: [
            IconButton(
              onPressed: addTab,
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: removeTab,
              icon: Icon(Icons.remove),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (_, constraints) {
            return TabBarBuilder(
              // enableArrows: false,
              /// base tab width will be increased to accomodate for available
              /// widths larger than the combined width of all tabs
              // expandableTabWidth: constraints.maxWidth,
              tabWidth: 50,

              /// isScrollable = false will override tab sizes and attempt to
              /// auto calculate sizes
              /// isScrollable: false,
              backgroundColor: theme.canvasColor,
              indicatorColor: theme.primaryColor,
              labelColor: theme.primaryColor,
              tabs: tabs,
              pageBuilder: (_, index) {
                return PersistStateWidget(
                  child: Center(
                    child: TextFormField(
                      initialValue: 'Tab Page: ${index + 1}',
                    ),
                  ),
                );
              },
              onTap: (index) {
                // print('Tab: ${index + 1} pressed');
              },
            );
          },
        ),
      ),
    );
  }
}
