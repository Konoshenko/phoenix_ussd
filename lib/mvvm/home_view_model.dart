import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/models/info.dart';
import 'package:sim_data/sim_data.dart';
import 'package:sim_data/sim_model.dart';
import 'package:ussd_service/ussd_service.dart';

class HomeViewModel extends ChangeNotifier {
  RequestState requestState;
  RequestState balanceLoadingState;
  RequestState networkLoadingState;

  //final Map<String, BalanceInfo> requestList = {};
  final List<BalanceInfo> _requestList = <BalanceInfo>[];
  String balance = '';
  String balanceNetwork = '';
  BalanceInfo errorBalanceInfo;

  List<BalanceInfo> get requestList => _requestList.reversed.toList();

  Future<void> sendUssdRequest(String req) async {
    requestState = RequestState.ongoing;
    notifyListeners();
    try {
      final String responseMessage = await _singleUssdRequest(req);

      _requestList.add(BalanceInfo(responseMessage, req));

      if (req == Constants.checkBalance) {
        balance = responseMessage.split('р.').first;
      }
      if (req == Constants.checkInternetBalance) {
        balanceNetwork = responseMessage;
      }
      requestState = RequestState.success;
      notifyListeners();
    } on Exception catch (e) {
      requestState = RequestState.error;
      errorBalanceInfo = BalanceInfo(e.toString(), req);
      notifyListeners();
    }
  }

  Future<void> getNetworkBalance() async {
    networkLoadingState = RequestState.ongoing;
    notifyListeners();
    try {
      final String responseMessage =
          await _singleUssdRequest(Constants.checkInternetBalance);
      balanceNetwork = responseMessage;
      networkLoadingState = RequestState.success;
      notifyListeners();
    } on Exception catch (_) {
      networkLoadingState = RequestState.error;
      notifyListeners();
    }
  }

  Future<void> getBalance() async {
    balanceLoadingState = RequestState.ongoing;
    notifyListeners();
    try {
      final String responseMessage =
          await _singleUssdRequest(Constants.checkBalance);
      balance = responseMessage.split('р.').first;
      balanceLoadingState = RequestState.success;
      notifyListeners();
    } on Exception catch (_) {
      balanceLoadingState = RequestState.error;
      notifyListeners();
    }
  }

  void removeErrorCall() {
    errorBalanceInfo = null;
    requestState = RequestState.success;
    notifyListeners();
  }

  void retryErrorCall() {
    if (errorBalanceInfo != null) {
      sendUssdRequest(errorBalanceInfo.code);
    } else {
      requestState = RequestState.success;
      notifyListeners();
    }
  }

  Future<String> _singleUssdRequest(String request) async {
    await Permission.phone.request();
    if (!await Permission.phone.isGranted) {
      throw Exception('permission missing');
    }
    final SimData simData = await SimDataPlugin.getSimData();
    if (simData == null) {
      throw Exception('sim data is null');
    }
    return UssdService.makeRequest(simData.cards.first.subscriptionId, request);
  }
}
