import '../models/subscription.dart';
import 'api_client.dart';

class SubscriptionService {
  final ApiClient _client;

  SubscriptionService(this._client);

  /// Get current user's subscription details
  /// SECURITY: This endpoint must verify user authentication and return only their data
  Future<Subscription?> getCurrentSubscription() async {
    try {
      final json = await _client.get('/subscription/current');
      final data = json['data'] as Map<String, dynamic>?;
      return data != null ? Subscription.fromJson(data) : null;
    } catch (e) {
      // If no subscription exists, return null instead of throwing
      if (e is ApiException && e.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  /// Get user's purchase history
  /// SECURITY: This endpoint must verify user authentication and return only their data
  Future<List<PurchaseHistory>> getPurchaseHistory() async {
    final json = await _client.get('/subscription/purchases');
    final data = json['data'] as List<dynamic>;
    return data.map((item) => PurchaseHistory.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Cancel current subscription
  /// SECURITY: This endpoint must verify user authentication and only allow cancellation of their own subscription
  Future<bool> cancelSubscription() async {
    try {
      await _client.post('/subscription/cancel');
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return false; // No active subscription to cancel
      }
      rethrow;
    }
  }

  /// Restore purchases (for mobile platforms)
  /// SECURITY: This endpoint must verify user authentication and platform-specific purchase validation
  Future<List<PurchaseHistory>> restorePurchases() async {
    final json = await _client.post('/subscription/restore');
    final data = json['data'] as List<dynamic>;
    return data.map((item) => PurchaseHistory.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Update payment method
  /// SECURITY: This endpoint must verify user authentication and use secure payment processing
  Future<bool> updatePaymentMethod(Map<String, dynamic> paymentData) async {
    try {
      await _client.put('/subscription/payment-method', body: paymentData);
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        return false; // Invalid payment data
      }
      rethrow;
    }
  }

  /// Get subscription plans available for upgrade/downgrade
  /// SECURITY: This endpoint returns public data but should still verify authentication
  Future<List<Map<String, dynamic>>> getAvailablePlans() async {
    final json = await _client.get('/subscription/plans');
    final data = json['data'] as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  /// Change subscription plan
  /// SECURITY: This endpoint must verify user authentication and handle payment processing securely
  Future<bool> changePlan(String planId) async {
    try {
      await _client.post('/subscription/change-plan', body: {'planId': planId});
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        return false; // Invalid plan or payment failed
      }
      rethrow;
    }
  }
}
