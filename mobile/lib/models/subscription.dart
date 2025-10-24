class Subscription {
  final String id;
  final String planName;
  final String status; // active, expired, cancelled, trial
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;
  final double? amount;
  final String? currency;
  final String? billingCycle; // monthly, yearly
  final bool isAutoRenew;
  final String? paymentMethod; // masked card info
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Subscription({
    required this.id,
    required this.planName,
    required this.status,
    this.startDate,
    this.endDate,
    this.nextBillingDate,
    this.amount,
    this.currency,
    this.billingCycle,
    this.isAutoRenew = false,
    this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      planName: json['planName'] as String,
      status: json['status'] as String,
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String)
          : null,
      nextBillingDate: json['nextBillingDate'] != null 
          ? DateTime.parse(json['nextBillingDate'] as String)
          : null,
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      currency: json['currency'] as String?,
      billingCycle: json['billingCycle'] as String?,
      isAutoRenew: json['isAutoRenew'] as bool? ?? false,
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planName': planName,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'amount': amount,
      'currency': currency,
      'billingCycle': billingCycle,
      'isAutoRenew': isAutoRenew,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isActive => status == 'active';
  bool get isExpired => status == 'expired';
  bool get isCancelled => status == 'cancelled';
  bool get isTrial => status == 'trial';

  String get displayStatus {
    switch (status) {
      case 'active':
        return 'Active';
      case 'expired':
        return 'Expired';
      case 'cancelled':
        return 'Cancelled';
      case 'trial':
        return 'Trial';
      default:
        return 'Unknown';
    }
  }

  String get formattedAmount {
    if (amount == null || currency == null) return 'N/A';
    return '$currency ${amount!.toStringAsFixed(2)}';
  }
}

class PurchaseHistory {
  final String id;
  final String productId;
  final String productName;
  final double amount;
  final String currency;
  final DateTime purchaseDate;
  final String status; // completed, pending, failed, refunded
  final String? transactionId;
  final String? receipt;

  const PurchaseHistory({
    required this.id,
    required this.productId,
    required this.productName,
    required this.amount,
    required this.currency,
    required this.purchaseDate,
    required this.status,
    this.transactionId,
    this.receipt,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      receipt: json['receipt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'amount': amount,
      'currency': currency,
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': status,
      'transactionId': transactionId,
      'receipt': receipt,
    };
  }

  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';
  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';
  bool get isRefunded => status == 'refunded';
}
