import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../services/shop_service.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopService _shopService;

  ShopBloc(this._shopService) : super(ShopInitial()) {
    on<LoadShop>(_onLoadShop);
    on<BuyShopItem>(_onBuyShopItem);
  }

  Future<void> _onLoadShop(LoadShop event, Emitter<ShopState> emit) async {
    emit(ShopLoading());
    try {
      final points = await _shopService.getPoints();
      final powerups = <String, int>{
        'solved_state_5s': await _shopService.getItemCount('solved_state_5s'),
        'show_clues': await _shopService.getItemCount('show_clues'),
      };
      emit(ShopLoaded(points: points, itemCounts: powerups));
    } catch (e) {
      emit(ShopError(error: e.toString()));
    }
  }

  Future<void> _onBuyShopItem(BuyShopItem event, Emitter<ShopState> emit) async {
    try {
      final updatedPoints = await _shopService.buyItem(event.itemKey, event.cost);
      final powerups = <String, int>{
        'solved_state_5s': await _shopService.getItemCount('solved_state_5s'),
        'show_clues': await _shopService.getItemCount('show_clues'),
      };
      emit(ShopLoaded(points: updatedPoints, itemCounts: powerups));
    } catch (e) {
      final currentPoints = await _shopService.getPoints();
      final powerups = <String, int>{
        'solved_state_5s': await _shopService.getItemCount('solved_state_5s'),
        'show_clues': await _shopService.getItemCount('show_clues'),
      };

      emit(ShopLoaded(
        points: currentPoints,
        itemCounts: powerups,
        errorMessage: e.toString(),
      ));
    }
  }

}
