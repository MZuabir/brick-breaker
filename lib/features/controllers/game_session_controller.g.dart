// ignore_for_file: invalid_use_of_internal_member

part of 'game_session_controller.dart'; // Corrected part directive

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameSessionsControllerHash() =>
    r'81e9d64f4506d0b644da2dbaef669a34baf799a6';

/// See also [GameSessionsController].
@ProviderFor(GameSessionsController)
final gameSessionsControllerProvider = AutoDisposeAsyncNotifierProvider<
    GameSessionsController, List<GameSession>>.internal(
  GameSessionsController.new,
  name: r'gameSessionsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameSessionsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameSessionsController = AutoDisposeAsyncNotifier<List<GameSession>>;
