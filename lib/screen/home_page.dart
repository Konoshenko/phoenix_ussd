import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:phoenix_ussd/screen/phone_tab_page.dart';
import 'package:phoenix_ussd/screen/ussd_tab_page.dart';
import 'package:provider/provider.dart';

import 'network_tab_page.dart';

class HomePage extends StatefulWidget {
  final tabBarNav = [
    {
      'title': Text("Баланс"),
      'icon': Icon(Icons.account_balance_wallet_outlined)
    },
    {'title': Text("Интернет"), 'icon': Icon(Icons.wifi)},
    {'title': Text("Справка"), 'icon': Icon(Icons.insert_drive_file_outlined)},
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
      initialIndex: 0,
    );
    _tabController.addListener(_tabListener);
  }

  _tabListener() {
    setState(() {
      _currentTabIndex = _tabController.index;
      if (_currentTabIndex == 1 && homeViewModel.balanceNetwork.isEmpty) {
        homeViewModel.getNetworkBalance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (homeViewModel == null) {
      homeViewModel = Provider.of<HomeViewModel>(context);
    }
    if (homeViewModel.balance.isEmpty) {
      homeViewModel.getBalance();
    }

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
              .map((e) =>
                  BottomNavigationBarItem(title: e['title'], icon: e['icon']))
              .toList()),
      body: TabBarView(
        controller: _tabController,
        children: [PhoneTabPage(), NetworkTabPage(), UssdTabPage()],
      ),
    );
  }
}
