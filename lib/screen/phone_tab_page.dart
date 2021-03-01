import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:phoenix_ussd/screen/components/components.dart';
import 'package:phoenix_ussd/screen/components/sliver_title.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PhoneTabPage extends StatefulWidget {

   const PhoneTabPage({Key key}) : super(key: key);

  @override
  _PhoneTabPageState createState() => _PhoneTabPageState();
}

class _PhoneTabPageState extends State<PhoneTabPage> {
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
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _mapBalanceStateToWidget(vm),
            ),
          ),
          // Make the initial height of the SliverAppBar larger than normal.
          expandedHeight: 200,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverGrid.count(
          crossAxisCount: 2,
          childAspectRatio: 3 / 1,
          children: [
            ButtonUssd(
                title: 'Проверить счет',
                onClick: () {
                  vm.sendUssdRequest(Constants.checkBalance);
                },
                isDisable: vm.requestState == RequestState.ongoing),
            ButtonUssd(
                title: 'Узнать свой номер',
                onClick: () {
                  vm.sendUssdRequest(Constants.getMyPhoneNumber);
                },
                isDisable: vm.requestState == RequestState.ongoing),
            ButtonUssd(
                title: 'Отложеный (50р.)',
                onClick: () => _onClickSendUssd(context, Constants.get50Money),
                isDisable: vm.requestState == RequestState.ongoing),
            ButtonUssd(
                title: 'Отложеный (100р.)',
                onClick: () => _onClickSendUssd(context, Constants.get100Money),
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
                          fontWeight: FontWeight.bold, color: Colors.black54),
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

  Widget _mapBalanceStateToWidget(HomeViewModel vm) {
    switch (vm.balanceLoadingState) {
      case RequestState.ongoing:
        return SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey.shade400,
            child: const Text(
              'Выполняется запрос...',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        );
        break;
      case RequestState.success:
        return Text(
          '${vm.balance.replaceFirst('Ваш б', 'Б')} руб.',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        );
        break;
      case RequestState.error:
        return ButtonUssd(
            title: 'Проверить баланс', onClick: () => vm.getBalance());
        break;
    }
    return const SizedBox();
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
}
