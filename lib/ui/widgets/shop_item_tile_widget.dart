import 'package:flutter/material.dart';

class ShopItemTile extends StatelessWidget {
  final String title;
  final int cost;
  final int count;
  final VoidCallback onBuy;
  final IconData icon;
  final Color color;

  const ShopItemTile({
    super.key,
    required this.title,
    required this.cost,
    required this.count,
    required this.onBuy,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 3,
        color: color.withAlpha(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: 500, // Set a narrower fixed width
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              // Icon Circle
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withAlpha(51),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),

              // Title and cost
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cost: $cost points',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // Count
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              // Buy Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
                onPressed: onBuy,
                child: const Text('Buy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
