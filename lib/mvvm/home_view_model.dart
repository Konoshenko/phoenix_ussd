import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/models/info.dart';
import 'package:sim_data/sim_data.dart';
import 'package:sim_data/sim_model.dart';
import 'package:ussd_service/ussd_service.dart';

class HomeViewModel extends ChangeNotifier {
  RequestState requestState;
  String requestCode = "";

  //final Map<String, BalanceInfo> requestList = {};
  final List _requestList = <BalanceInfo>[];
  String balance = '';
  String balanceNetwork = '';

  List get requestList => _requestList.reversed.toList();

  Future<void> sendUssdRequest(String req) async {
    requestState = RequestState.Ongoing;
    notifyListeners();
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      if (simData == null) {
        throw Exception("sim data is null");
      }
      responseMessage = await UssdService.makeRequest(
          simData.cards.first.subscriptionId, req);

      _requestList.add(BalanceInfo(req, responseMessage));

      if (req == Constants.checkBalance) {
        balance = responseMessage.split('р.').first;
      }
      if (req == Constants.checkInternetBalance) {
        balanceNetwork = responseMessage;
      }

      requestState = RequestState.Success;
      notifyListeners();
    } catch (e) {
      requestState = RequestState.Error;
      _requestList
          .add(BalanceInfo(e is PlatformException ? e.code : "", e.message));

      notifyListeners();
    }
  }

  Future<void> getNetworkBalance() async {
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      if (simData == null) {
        throw Exception("sim data is null");
      }
      responseMessage = await UssdService.makeRequest(
          simData.cards.first.subscriptionId, Constants.checkInternetBalance);

      balanceNetwork = responseMessage.split('.').first;
    } catch (e) {}
  }

  Future<void> getBalance() async {
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      if (simData == null) {
        throw Exception("sim data is null");
      }
      responseMessage = await UssdService.makeRequest(
          simData.cards.first.subscriptionId, Constants.checkBalance);

      balance = responseMessage.split('р.').first;
      notifyListeners();
    } catch (e) {}
  }
}
