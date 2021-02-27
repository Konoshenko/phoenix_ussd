import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:phoenix_ussd/screen/network_tab_page.dart';
import 'package:phoenix_ussd/screen/phone_tab_page.dart';
import 'package:phoenix_ussd/screen/ussd_tab_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  final tabBarNav = [
    {
      'title': 'Баланс',
      'icon': const Icon(Icons.account_balance_wallet_outlined)
    },
    {'title': 'Интернет', 'icon': const Icon(Icons.wifi)},
    {'title': 'Справка', 'icon': const Icon(Icons.insert_drive_file_outlined)},
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentTabIndex = 0;
  HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    _tabController = TabController(
      length: widget.tabBarNav.length,
      vsync: this,
    )..addListener(_tabListener);
  }

  void _tabListener() {
    setState(() {
      _currentTabIndex = _tabController.index;
      if (_currentTabIndex == 1 && homeViewModel.balanceNetwork.isEmpty) {
        homeViewModel.getNetworkBalance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    homeViewModel ??= Provider.of<HomeViewModel>(context);
    if (homeViewModel.balance.isEmpty) {
      homeViewModel.getBalance();
    }

    final List<Widget> pages = [
      const PhoneTabPage(),
      const NetworkTabPage(),
      const UssdTabPage()
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _tabController.index = index;
              _currentTabIndex = index;
            });
          },
          items: widget.tabBarNav
              .map((e) => BottomNavigationBarItem(
                  label: e['title'] as String, icon: e['icon'] as Icon))
              .toList()),
      body: TabBarView(
        controller: _tabController,
        children: pages,
      ),
    );
  }
}
