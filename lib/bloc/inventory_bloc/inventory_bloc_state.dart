import 'package:equatable/equatable.dart';

class InventoryState extends Equatable {
  final int balls;
  final int gerenades;
  final int gifts;
  final int bricks;
  final int bomb;

  const InventoryState(
      {required this.balls,
      required this.gerenades,
      required this.gifts,
      required this.bricks,
      required this.bomb});
  const InventoryState.empty()
      : this(
          balls: 0,
          bomb: 0,
          bricks: 0,
          gerenades: 0,
          gifts: 0,
        );

  InventoryState copyWith({
    int? balls,
    int? gerenades,
    int? gifts,
    int? bricks,
    int? bomb,
  }) {
    return InventoryState(
      balls: balls ?? this.balls,
      gerenades: gerenades ?? this.gerenades,
      gifts: gifts ?? this.gifts,
      bricks: bricks ?? this.bricks,
      bomb: bomb ?? this.bomb,
    );
  }

  @override
  List<Object?> get props => [balls, gerenades, gifts, bricks, bomb];
}
