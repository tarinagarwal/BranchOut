import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.star,
                    size: 80,
                    color: AppTheme.superLikeColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Unlock Premium Features',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get the most out of BranchOut',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Features
            _buildFeature(
              Icons.favorite,
              'Unlimited Swipes',
              'Swipe as much as you want, no daily limits',
            ),
            _buildFeature(
              Icons.star,
              'Unlimited Super Likes',
              'Stand out with unlimited super likes',
            ),
            _buildFeature(
              Icons.visibility,
              'See Who Liked You',
              'Know who\'s interested before you swipe',
            ),
            _buildFeature(
              Icons.undo,
              'Rewind',
              'Undo your last swipe if you change your mind',
            ),
            _buildFeature(
              Icons.rocket_launch,
              'Profile Boost',
              'Get 10x more profile views for 30 minutes',
            ),
            _buildFeature(
              Icons.work,
              'Project Marketplace',
              'Post and browse project collaboration opportunities',
            ),
            _buildFeature(
              Icons.filter_alt,
              'Advanced Filters',
              'Filter by specific technologies, timezone, and more',
            ),
            _buildFeature(
              Icons.analytics,
              'Profile Analytics',
              'See who viewed your profile and engagement stats',
            ),
            const SizedBox(height: 32),

            // Pricing
            _buildPricingCard(
              'Monthly',
              '\$9.99',
              'per month',
              () => _subscribe(context, 'monthly'),
            ),
            const SizedBox(height: 16),
            _buildPricingCard(
              'Yearly',
              '\$79.99',
              'per year (Save 33%)',
              () => _subscribe(context, 'yearly'),
              isPopular: true,
            ),
            const SizedBox(height: 24),

            // Terms
            const Text(
              'Cancel anytime. Subscription automatically renews unless cancelled.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.matchColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.matchColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    String title,
    String price,
    String subtitle,
    VoidCallback onTap, {
    bool isPopular = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isPopular ? AppTheme.superLikeColor : Colors.grey,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.superLikeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'MOST POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isPopular) const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _subscribe(BuildContext context, String plan) {
    // TODO: Implement Polar.sh payment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscribing to $plan plan...'),
      ),
    );
  }
}
