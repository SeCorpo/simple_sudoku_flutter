import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../widgets/snackbar_widget.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ShopBloc>().add(LoadShop());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<ShopBloc, ShopState>(
          listener: (context, state) {
            if (state is ShopLoaded && state.errorMessage != null) {
              SnackBarWidget.show(context, state.errorMessage!, isError: true);
            }
            if (state is ShopLoaded && state.infoMessage != null) {
              SnackBarWidget.show(context, state.infoMessage!);
            }
          },
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if (state is ShopLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ShopLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Points: ${state.points}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ShopItemTile(
                      title: '5 Seconds Solved State',
                      cost: 20,
                      count: state.itemCounts['solved_state_5s'] ?? 0,
                      onBuy: () {
                        context.read<ShopBloc>().add(
                          BuyShopItem(itemKey: 'solved_state_5s', cost: 20),
                        );
                      },
                    ),
                    ShopItemTile(
                      title: 'Show Clues Solution',
                      cost: 15,
                      count: state.itemCounts['show_clues'] ?? 0,
                      onBuy: () {
                        context.read<ShopBloc>().add(
                          BuyShopItem(itemKey: 'show_clues', cost: 15),
                        );
                      },
                    ),
                  ],
                );
              }

              return const SizedBox(); // fallback for unexpected states
            },
          ),
        )
      ),
    );
  }
}

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
