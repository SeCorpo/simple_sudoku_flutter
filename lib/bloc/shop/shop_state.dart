part of 'shop_bloc.dart';

@immutable
sealed class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final int points;
  final Map<String, int> itemCounts;
  final String? errorMessage;
  final String? infoMessage;

  ShopLoaded({
    required this.points,
    required this.itemCounts,
    this.errorMessage,
    this.infoMessage,
  });
}

class ShopError extends ShopState {
  final String error;

  ShopError({required this.error});
}
