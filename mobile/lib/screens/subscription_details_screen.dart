import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../models/subscription.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  const SubscriptionDetailsScreen({super.key});

  @override
  State<SubscriptionDetailsScreen> createState() => _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load subscription data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubscriptionProvider>(context, listen: false).loadCurrentSubscription();
    });
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    final darkPurple = _hexToColor('2D1B69');

    return Scaffold(
      backgroundColor: darkPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: lightTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Subscription Details',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, subscriptionProvider, child) {
          if (subscriptionProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: purpleAccent,
              ),
            );
          }

          if (subscriptionProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subscriptionProvider.error!,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      subscriptionProvider.clearError();
                      subscriptionProvider.loadCurrentSubscription();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleAccent,
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final subscription = subscriptionProvider.currentSubscription;

          if (subscription == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.subscriptions_outlined,
                    color: lightTextColor.withOpacity(0.5),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Active Subscription',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You don\'t have an active subscription.',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subscription card
                _buildSubscriptionCard(subscription, lightTextColor, purpleAccent),
                
                const SizedBox(height: 24),
                
                // Subscription details
                _buildSubscriptionDetails(subscription, lightTextColor),
                
                const SizedBox(height: 24),
                
                // Actions
                _buildActionButtons(subscriptionProvider, lightTextColor, purpleAccent),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubscriptionCard(Subscription subscription, Color lightTextColor, Color purpleAccent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.8),
            purpleAccent.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lightTextColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.planName,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscription.displayStatus,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (subscription.amount != null) ...[
            const SizedBox(height: 16),
            Text(
              subscription.formattedAmount,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subscription.billingCycle != null) ...[
              const SizedBox(height: 4),
              Text(
                'per ${subscription.billingCycle}',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetails(Subscription subscription, Color lightTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Details',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildDetailRow('Plan', subscription.planName, lightTextColor),
        _buildDetailRow('Status', subscription.displayStatus, lightTextColor),
        if (subscription.startDate != null)
          _buildDetailRow('Start Date', _formatDate(subscription.startDate!), lightTextColor),
        if (subscription.endDate != null)
          _buildDetailRow('End Date', _formatDate(subscription.endDate!), lightTextColor),
        if (subscription.nextBillingDate != null)
          _buildDetailRow('Next Billing', _formatDate(subscription.nextBillingDate!), lightTextColor),
        if (subscription.paymentMethod != null)
          _buildDetailRow('Payment Method', subscription.paymentMethod!, lightTextColor),
        _buildDetailRow('Auto Renew', subscription.isAutoRenew ? 'Yes' : 'No', lightTextColor),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Color lightTextColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(SubscriptionProvider subscriptionProvider, Color lightTextColor, Color purpleAccent) {
    return Column(
      children: [
        if (subscriptionProvider.currentSubscription?.isActive == true) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCancelSubscriptionDialog(subscriptionProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel Subscription',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showUpdatePaymentMethodDialog(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: purpleAccent),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Update Payment Method',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: purpleAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCancelSubscriptionDialog(SubscriptionProvider subscriptionProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _hexToColor('2D1B69'),
        title: Text(
          'Cancel Subscription',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: _hexToColor('F0E6D8'),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel your subscription? You will lose access to PRO features at the end of your current billing period.',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: _hexToColor('F0E6D8'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Keep Subscription',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: _hexToColor('F0E6D8').withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await subscriptionProvider.cancelSubscription();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subscription cancelled successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(subscriptionProvider.error ?? 'Failed to cancel subscription'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Cancel Subscription',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdatePaymentMethodDialog() {
    // In a real implementation, this would integrate with a payment processor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment method update coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
