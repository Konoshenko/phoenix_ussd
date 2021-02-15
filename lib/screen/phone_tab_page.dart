import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/models/info.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:provider/provider.dart';

import 'components/button_ussd.dart';

class PhoneTabPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          // Allows the user to reveal the app bar if they begin scrolling back
          // up the list of items.
          backgroundColor: Colors.deepPurpleAccent,
          floating: true,
          pinned: true,
          snap: false,
          // Display a placeholder widget to visualize the shrinking size.
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              vm.balance,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          // Make the initial height of the SliverAppBar larger than normal.
          expandedHeight: 200,
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverGrid.count(
          crossAxisCount: 2,
          childAspectRatio: 3 / 1,
          children: [
            ButtonUssd(
                title: 'Проверить счет',
                onClick: () {
                  vm.sendUssdRequest(Constants.checkBalance);
                }),
            ButtonUssd(
                title: 'Узнать свой номер',
                onClick: () {
                  vm.sendUssdRequest(Constants.getMyPhoneNumber);
                }),
            ButtonUssd(
                title: 'Отложеный (50р.)',
                onClick: () {
                  vm.sendUssdRequest(Constants.get50Money);
                }),
            ButtonUssd(
                title: 'Отложеный (100р.)',
                onClick: () {
                  vm.sendUssdRequest(Constants.get100Money);
                }),
          ],
        ),
       if(vm.requestList.isNotEmpty) _buildSliverTitle('История запросов:'),
        if (vm.requestState == RequestState.Ongoing) ...[
          SliverToBoxAdapter(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 4,
                    child: LinearProgressIndicator(

                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                BalanceInfo ba = vm.requestList.elementAt(index);
                return ListTile(
                  title: Text(ba.response,  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                  subtitle: Text(ba.code),
                );
              },
              childCount: vm.requestList.length,
            ),
          ),
        ],
        if (vm.requestState == RequestState.Success)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                BalanceInfo ba = vm.requestList.elementAt(index);
                return ListTile(
                  title: Text(ba.response,  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                  subtitle: Text(ba.code),
                );
              },
              childCount: vm.requestList.length,
            ),
          ),
        if (vm.requestState == RequestState.Error)
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                BalanceInfo ba = vm.requestList.elementAt(index);
                return ListTile(
                  title: Text(ba.response,  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                  subtitle: Text(ba.code),
                );
              },
              childCount: vm.requestList.length,
            ),
          ),
      ],
    );
  }

  SliverToBoxAdapter _buildSliverTitle(String s) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          s,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
      ),
    );
  }
}
