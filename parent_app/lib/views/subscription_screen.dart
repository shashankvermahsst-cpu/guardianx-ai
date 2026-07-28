import 'package:flutter/material.dart';
import '../core/theme.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.workspace_premium, size: 70, color: Colors.amber),
                const SizedBox(height: 10),
                const Text('GuardianX Premium', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('Protect up to 5 devices with AI surveillance', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                const SizedBox(height: 24),

                _buildPlanCard(title: 'Monthly Plan', price: '\$9.99 / mo', desc: '1 Child Device • Basic AI Insights', isPopular: false),
                const SizedBox(height: 16),
                _buildPlanCard(title: 'Yearly Plan (Save 40%)', price: '\$59.99 / yr', desc: '3 Child Devices • Full AI Insights & Audio', isPopular: true),
                const SizedBox(height: 16),
                _buildPlanCard(title: 'Family Ultimate Plan', price: '\$89.99 / yr', desc: 'Unlimited Child Devices • Live Screen Mirroring', isPopular: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({required String title, required String price, required String desc, required bool isPopular}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPopular ? AppTheme.accentBlue : AppTheme.primaryPurple, width: isPopular ? 2.5 : 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(color: AppTheme.accentBlue, borderRadius: BorderRadius.circular(8)),
                    child: const Text('MOST POPULAR', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPurple, foregroundColor: Colors.white),
            onPressed: () {},
            child: Text(price),
          ),
        ],
      ),
    );
  }
}
