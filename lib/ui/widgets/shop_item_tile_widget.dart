import 'package:flutter/material.dart';

class ShopItemTile extends StatelessWidget {
  final String title;
  final int cost;
  final int count;
  final VoidCallback onBuy;

  const ShopItemTile({
    required this.title,
    required this.cost,
    required this.count,
    required this.onBuy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text('Cost: $cost points • Owned: $count'),
        trailing: ElevatedButton(
          onPressed: onBuy,
          child: const Text('Buy'),
        ),
      ),
    );
  }
}