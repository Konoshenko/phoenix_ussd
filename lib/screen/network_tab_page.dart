import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/models/info.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';

class NetworkTabPage extends StatelessWidget {
  HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    vm ??= Provider.of<HomeViewModel>(context);
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
                onClick: () => _onClickBuy1(context)),
            ButtonUssd(
                title: 'Трафик 5Gb (100р.)',
                onClick: () {
                  vm.sendUssdRequest(Constants.buy5Gb);
                }),
            ButtonUssd(
                title: 'Купить трафик 50Gb',
                onClick: () => _onClickBuy50(context)),
          ],
        ),
        if (vm.requestList.isNotEmpty) SliverTitle(text: 'История запросов:'),
        if (vm.requestState == RequestState.Ongoing)
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
        if (vm.requestState == RequestState.Error)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Во время запроса ${vm.errorBalanceInfo.code} произошла ошибка. Повторитть запрос?',
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () => vm.retryErrorCall(),
                        child: Text('Повторить')),
                    FlatButton(
                        onPressed: () => vm.removeErrorCall(),
                        child: Text('Отменить'))
                  ],
                )
              ],
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              BalanceInfo ba = vm.requestList.elementAt(index);
              return ListTile(
                title: Text(ba.response,
                    style: TextStyle(
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
    );
  }

  _onClickBuy1(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SheetConfirmDialog(
              text:
                  'С ваше счета будет списано 50 рублей. продолжить операцию?',
              onConfirmClick: () => vm.sendUssdRequest(Constants.buy50Gb));
        });
  }

  _onClickBuy50(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SheetConfirmDialog(
              text:
                  'С ваше счета будет списано 500 рублей. продолжить операцию?',
              onConfirmClick: () => vm.sendUssdRequest(Constants.buy50Gb));
        });
  }
}
