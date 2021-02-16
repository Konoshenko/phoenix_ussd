class BalanceInfo {
  String response;
  String code;
  DateTime updateTime;

  BalanceInfo(this.response, this.code) {
    this.updateTime = DateTime.now();
  }
}
