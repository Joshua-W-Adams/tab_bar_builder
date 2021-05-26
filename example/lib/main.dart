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
        body: TabBarBuilder(
          backgroundColor: theme.canvasColor,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          tabs: [
            Text('1', overflow: TextOverflow.ellipsis),
            Text('2', overflow: TextOverflow.ellipsis),
            Text('3', overflow: TextOverflow.ellipsis),
          ],
          pageBuilder: (_, index) {
            return Center(
              child: Text('index: $index'),
            );
          },
        ),
      ),
    );
  }
}
