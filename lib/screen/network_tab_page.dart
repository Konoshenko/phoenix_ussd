import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:phoenix_ussd/screen/components/components.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NetworkTabPage extends StatefulWidget {
  const NetworkTabPage({Key key}) : super(key: key);

  @override
  _NetworkTabPageState createState() => _NetworkTabPageState();
}

class _NetworkTabPageState extends State<NetworkTabPage> {
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

          // Display a placeholder widget to visualize the shrinking size.
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _mapNetworkStateToWidget(vm),
              ),
            ),
          ),
          // Make the initial height of the SliverAppBar larger than normal.
          expandedHeight: 200,
        ),
        const SliverToBoxAdapter(
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
                },
                isDisable: vm.requestState == RequestState.ongoing),
            ButtonUssd(
                title: 'Трафик 1Gb (50р.)',
                onClick: () => _onClickSendUssd(context, Constants.buy1Gb),
                isDisable: vm.requestState == RequestState.ongoing),
            ButtonUssd(
                title: 'Трафик 5Gb (100р.)',
                onClick: () => _onClickSendUssd(context, Constants.buy5Gb),
                isDisable: vm.requestState == RequestState.ongoing),
          ],
        ),
        if (vm.requestList.isNotEmpty) SliverTitle(text: 'История запросов:'),
        if (vm.requestState == RequestState.ongoing)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (vm.requestState == RequestState.error)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent.withAlpha(40),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Во время запроса ${vm.errorBalanceInfo.code} произошла ошибка. Повторитть запрос?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonUssd(
                        color: Colors.deepPurpleAccent,
                        onClick: () => vm.retryErrorCall(),
                        title: 'Повторить',
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ButtonUssd(
                          color: Colors.deepPurpleAccent,
                          onClick: () => vm.removeErrorCall(),
                          title: 'Отменить')
                    ],
                  )
                ],
              ),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTileBalanceInfo(ba: vm.requestList.elementAt(index));
            },
            childCount: vm.requestList.length,
          ),
        )
      ],
    );
  }

  void _onClickSendUssd(BuildContext context, String code) {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return SheetConfirmDialog(
              text: 'Продолжить выполнение USSD запроса $code?',
              onConfirmClick: () => vm.sendUssdRequest(code));
        });
  }

  Widget _mapNetworkStateToWidget(HomeViewModel vm) {
    switch (vm.networkLoadingState) {
      case RequestState.ongoing:
        return SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey.shade300,
            child: const Text(
              'Выполняется запрос...',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        );
        break;
      case RequestState.success:
        return Text(
          vm.balanceNetwork
              .split('\nСправка')
              .first
              .replaceAll('по пакетам интернета', '')
              .replaceAll('Mb', ' Mb'),
          style: const TextStyle(fontSize: 20, color: Colors.white),
        );
        break;

      case RequestState.error:
        return ButtonUssd(
            title: 'Проверить баланс', onClick: () => vm.getNetworkBalance());
        break;
    }
    return const SizedBox();
  }
}
