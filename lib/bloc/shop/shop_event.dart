part of 'shop_bloc.dart';

@immutable
sealed class ShopEvent {}

class LoadShop extends ShopEvent {}

class BuyShopItem extends ShopEvent {
  final String itemKey;
  final int cost;

  BuyShopItem({required this.itemKey, required this.cost});
}
