import 'package:flutter/foundation.dart';
import '../models/subscription.dart';
import '../services/subscription_service.dart';
import '../services/api_client.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _service;

  Subscription? _currentSubscription;
  List<PurchaseHistory> _purchaseHistory = [];
  bool _isLoading = false;
  String? _error;

  SubscriptionProvider(this._service);

  Subscription? get currentSubscription => _currentSubscription;
  List<PurchaseHistory> get purchaseHistory => _purchaseHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveSubscription => _currentSubscription?.isActive ?? false;
  bool get isProUser => hasActiveSubscription;

  /// Load current subscription details
  /// SECURITY: This method handles sensitive subscription data
  Future<void> loadCurrentSubscription() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentSubscription = await _service.getCurrentSubscription();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load subscription details';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load purchase history
  /// SECURITY: This method handles sensitive purchase data
  Future<void> loadPurchaseHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _purchaseHistory = await _service.getPurchaseHistory();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load purchase history';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cancel current subscription
  /// SECURITY: This method performs a critical security action
  Future<bool> cancelSubscription() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _service.cancelSubscription();
      if (success) {
        // Reload subscription data after cancellation
        await loadCurrentSubscription();
      }
      return success;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Failed to cancel subscription';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore purchases
  /// SECURITY: This method handles sensitive purchase restoration
  Future<List<PurchaseHistory>> restorePurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final restoredPurchases = await _service.restorePurchases();
      _purchaseHistory = restoredPurchases;
      // Also reload current subscription as restoration might affect it
      await loadCurrentSubscription();
      return restoredPurchases;
    } on ApiException catch (e) {
      _error = e.message;
      return [];
    } catch (e) {
      _error = 'Failed to restore purchases';
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update payment method
  /// SECURITY: This method handles sensitive payment data
  Future<bool> updatePaymentMethod(Map<String, dynamic> paymentData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _service.updatePaymentMethod(paymentData);
      if (success) {
        // Reload subscription data after payment method update
        await loadCurrentSubscription();
      }
      return success;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Failed to update payment method';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Change subscription plan
  /// SECURITY: This method handles sensitive subscription changes
  Future<bool> changePlan(String planId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _service.changePlan(planId);
      if (success) {
        // Reload subscription data after plan change
        await loadCurrentSubscription();
      }
      return success;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Failed to change subscription plan';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// SECURITY: Clear sensitive data when user logs out
  void clearData() {
    _currentSubscription = null;
    _purchaseHistory = [];
    _error = null;
    notifyListeners();
  }
}
