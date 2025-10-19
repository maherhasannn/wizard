import 'package:flutter/foundation.dart';
import '../models/power_category.dart';
import '../services/power_service.dart';
import '../services/api_client.dart';

class PowerProvider extends ChangeNotifier {
  final PowerService _service;

  List<PowerCategory> _categories = [];
  List<UserPowerSelection> _selections = [];
  bool _isLoading = false;
  String? _error;

  PowerProvider(this._service);

  List<PowerCategory> get categories => _categories;
  List<UserPowerSelection> get selections => _selections;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _service.getCategories();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load categories';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSelections() async {
    try {
      _selections = await _service.getSelections();
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<bool> saveSelections(List<int> categoryIds) async {
    try {
      await _service.saveSelections(categoryIds);
      await loadSelections();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  List<PowerCategory> get selectedCategories {
    return _selections
        .where((s) => s.powerCategory != null)
        .map((s) => s.powerCategory!)
        .toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

