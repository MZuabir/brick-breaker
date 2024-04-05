

import 'package:equatable/equatable.dart';

abstract class InventoryEvents extends Equatable {
  const InventoryEvents();
}

class AddBallEvent extends InventoryEvents{
  @override
  List<Object?> get props =>[];
}
class AddBrickEvent extends InventoryEvents{
  @override
  List<Object?> get props =>[];
}
class AddGerenadeEvent extends InventoryEvents{
  @override
  List<Object?> get props =>[];
}
class AddBombEvent extends InventoryEvents{
  @override
  List<Object?> get props =>[];
}
class AddGiftEvent extends InventoryEvents{
  @override
  List<Object?> get props =>[];
}