import 'package:phoenix_ussd/models/constants.dart';

class BalanceInfo {
  String response;
  String code;

  BalanceInfo(this.response, this.code);

  String getBalance() {
    if (code == Constants.checkBalance) {
      return response;
    } else {
      return 'Баланс неизвестен';
    }
  }
}
