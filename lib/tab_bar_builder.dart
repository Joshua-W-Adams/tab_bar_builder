library tab_bar_builder;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabBarBuilder extends StatefulWidget {
  final List<Widget> tabs;
  final Widget Function(BuildContext context, int index) pageBuilder;
  final Function(int index)? onTap;
  final Function(int index)? onTabChange;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? labelColor;
  final double tabWidth;
  final double? expandableTabWidth;
  final bool enableArrows;
  final bool isScrollable;
  final ScrollPhysics? physics;

  TabBarBuilder({
    Key? key,
    required this.tabs,
    required this.pageBuilder,
    this.onTap,
    this.onTabChange,
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.tabWidth = 70,
    this.expandableTabWidth,
    this.enableArrows = true,
    this.isScrollable = true,
    this.physics,
  }) : super(key: key);

  @override
  _TabBarBuilderState createState() => _TabBarBuilderState();
}

class _TabBarBuilderState extends State<TabBarBuilder>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    setTabController();
  }

  @override
  void didUpdateWidget(TabBarBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != _tabController.length) {
      /// list of tabs changed, new controller required
      _tabController.dispose();
      int newTabLength = widget.tabs.length - 1;
      if (_tabController.index > newTabLength) {
        /// current index being preserved is greater than the new total number
        /// of tabs. i.e. the last tab was deleted while viewing it.
        setTabController(index: newTabLength);
      } else {
        setTabController(index: _tabController.index);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setTabController({int index = 0}) {
    _tabController = new TabController(
      vsync: this,
      length: widget.tabs.length,
      initialIndex: index,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      widget.onTabChange?.call(_tabController.index);
    }
  }

  double _getTabWidth() {
    if (widget.expandableTabWidth != null) {
      double iconButtonSize = kMinInteractiveDimension * 2;
      if (kIsWeb) {
        iconButtonSize = 88;
      }
      double expandedTabWidth = (widget.expandableTabWidth! -
              (widget.enableArrows == true ? iconButtonSize * 2 : 0)) /
          this.widget.tabs.length;
      return expandedTabWidth < widget.tabWidth
          ? widget.tabWidth
          : expandedTabWidth;
    }
    return widget.tabWidth;
  }

  Tab _createTab(BuildContext context, Widget tabContent) {
    return Tab(
      child: Container(
        width: _getTabWidth(),
        child: tabContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabList = [];
    final List<Widget> tabPages = [];

    for (var i = 0; i < widget.tabs.length; i++) {
      // create all tabs
      tabList.add(
        _createTab(
          context,
          widget.tabs[i],
        ),
      );
      // create all pages
      tabPages.add(
        widget.pageBuilder(
          context,
          i,
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        child: ArrowTabBar(
          enableArrows: widget.enableArrows,
          backgroundColor: widget.backgroundColor,
          arrowColor: widget.labelColor,
          tabBar: TabBar(
            controller: _tabController,
            tabs: tabList,
            // tab bar can scroll horizontally
            isScrollable: widget.isScrollable,
            onTap: widget.onTap,
            indicatorColor: widget.indicatorColor,
            labelColor: widget.labelColor,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabPages,
        physics: widget.physics,
      ),
    );
  }
}

class CustomAppBar extends Container implements PreferredSizeWidget {
  final Widget child;

  CustomAppBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ArrowTabBar extends StatelessWidget {
  final bool enableArrows;
  final Icon leftIcon;
  final Icon rightIcon;
  final Color? backgroundColor;
  final Color? arrowColor;
  final TabBar tabBar;

  ArrowTabBar({
    this.enableArrows = true,
    this.leftIcon = const Icon(Icons.chevron_left),
    this.rightIcon = const Icon(Icons.chevron_right),
    this.backgroundColor,
    this.arrowColor,
    required this.tabBar,
  });

  void moveNext(TabController? controller) {
    /// preconditions
    if (controller != null) {
      // get current index of tab bar
      int index = controller.index;

      if (index == controller.length - 1) {
        /// case 1 - end position
      } else {
        /// case 2 - anywhere but end position
        controller.animateTo(index + 1);
      }
    }
  }

  void movePrevious(TabController? controller) {
    /// preconditions
    if (controller != null) {
      // get current index of tab bar
      int index = controller.index;

      if (index == 0) {
        /// case 1 - start position
      } else {
        /// case 2 - anywhere but start position
        controller.animateTo(index - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController? _controller = tabBar.controller;
    return Container(
      color: backgroundColor,
      child: Row(
        children: [
          if (enableArrows) ...[
            IconButton(
              color: arrowColor,
              onPressed: () {
                movePrevious(_controller);
              },
              icon: leftIcon,
            )
          ],
          Expanded(
            child: tabBar,
          ),
          if (enableArrows) ...[
            IconButton(
              color: arrowColor,
              onPressed: () {
                moveNext(_controller);
              },
              icon: rightIcon,
            )
          ],
        ],
      ),
    );
  }
}

class PersistStateWidget extends StatefulWidget {
  final Widget child;

  PersistStateWidget({required this.child});

  @override
  _PersistStateWidgetState createState() => _PersistStateWidgetState();
}

class _PersistStateWidgetState extends State<PersistStateWidget>
    with AutomaticKeepAliveClientMixin {
  // AutomaticKeepAlive ??? allows subtrees to request to be kept alive in a lazy
  // list
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
