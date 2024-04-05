
import 'package:brick_breaker/bloc/inventory_bloc/inventory_bloc_events.dart';
import 'package:brick_breaker/bloc/inventory_bloc/inventory_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryBloc extends Bloc<InventoryEvents, InventoryState> {
  InventoryBloc() : super(const InventoryState.empty()) {
    on<AddBallEvent>((event, emit) {
      emit(state.copyWith(balls: state.balls + 1));
    });
    on<AddGerenadeEvent>((event, emit) {});
    on<AddBombEvent>((event, emit) {});
    on<AddGiftEvent>((event, emit) {});
    on<AddBrickEvent>((event, emit) {});
  }
}
