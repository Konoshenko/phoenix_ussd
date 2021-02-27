class BalanceInfo {

  BalanceInfo(this.response, this.code) {
    updateTime = DateTime.now();
  }

  String response;
  String code;
  DateTime updateTime;
}
