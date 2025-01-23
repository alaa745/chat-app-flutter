import 'package:flutter/material.dart';

class SendButtonProvider extends ChangeNotifier {
  late bool _isSendable;

  SendButtonProvider() {
    print('object');
    _isSendable = false;
    notifyListeners();
  }
  bool get isSendable => _isSendable;

  void changeIsSendable(value) {
    _isSendable = value;
    notifyListeners();
  }
}
