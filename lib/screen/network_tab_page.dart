import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/models/info.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:provider/provider.dart';

import 'components/button_ussd.dart';

class NetworkTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.deepPurpleAccent,
          floating: true,
          pinned: true,
          snap: false,

          // Display a placeholder widget to visualize the shrinking size.
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                vm.balanceNetwork
                    .split('.')
                    .first
                    .replaceAll('по пакетам интернета', ''),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
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
                title: 'Остаток интернет',
                onClick: () {
                  vm.sendUssdRequest(Constants.checkInternetBalance);
                }),
            ButtonUssd(
                title: 'Трафик 1Gb (50р.)',
                onClick: () {
                  vm.sendUssdRequest(Constants.buy1Gb);
                }),
            ButtonUssd(
                title: 'Трафик 5Gb (100р.)',
                onClick: () {
                  vm.sendUssdRequest(Constants.buy5Gb);
                }),
            ButtonUssd(
                title: 'Купить трафик 50Gb',
                onClick: () {
                  vm.sendUssdRequest(Constants.buy50Gb);
                }),
          ],
        ),
        if (vm.requestList.isNotEmpty) _buildSliverTitle('История запросов:'),
        if (vm.requestState == RequestState.Ongoing) ...[
          SliverToBoxAdapter(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 2,
                    child: LinearProgressIndicator(),
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
                  title: Text(ba.response,style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                  subtitle: Text(ba.code),
                );
              },
              childCount: vm.requestList.length,
            ),
          )
        ],
        if (vm.requestState == RequestState.Success)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                BalanceInfo ba = vm.requestList.elementAt(index);
                return ListTile(
                  title: Text(ba.response,style: TextStyle(
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
                  title: Text(ba.response,style: TextStyle(
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
