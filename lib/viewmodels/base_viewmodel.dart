import 'package:fireshare/handlers/navigation_handler.dart';
import 'package:fireshare/utils/locator.dart';
import 'package:flutter/foundation.dart';

class BaseViewModel extends ChangeNotifier {
  late NavigationHandler navigationHandler;
  BaseViewModel({
    NavigationHandler? navigationHandler,
  }) {
    this.navigationHandler = navigationHandler ?? locator();
  }
  bool _isUploading = false;
  bool get isUploading => _isUploading;

  void toggleisUpLoading(bool val) {
    _isUploading = val;
    notifyListeners();
  }
}
