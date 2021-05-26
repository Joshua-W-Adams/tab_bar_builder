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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (_, constraints) {
            return TabBarBuilder(
              // enableArrows: false,
              /// base tab width will be increased to accomodate for available
              /// widths larger than the combined width of all tabs
              expandableTabWidth: constraints.maxWidth,
              tabWidth: 50,

              /// isScrollable = false will override tab sizes and attempt to
              /// auto calculate sizes
              /// isScrollable: false,
              backgroundColor: theme.canvasColor,
              indicatorColor: theme.primaryColor,
              labelColor: theme.primaryColor,
              tabs: [
                Center(child: Text('1', overflow: TextOverflow.ellipsis)),
                Center(child: Text('2', overflow: TextOverflow.ellipsis)),
                Center(child: Text('3', overflow: TextOverflow.ellipsis)),
              ],
              pageBuilder: (_, index) {
                return Center(
                  child: Text('Tab Page: ${index + 1}'),
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
