import 'package:sports_betting_simulator/core/domain/repositories/games/games_repository.dart';
import 'package:sports_betting_simulator/core/models/game_model.dart';
import 'package:sports_betting_simulator/core/services/games/games_service.dart';

class GamesRepositoryImpl implements GamesRepository {
  final GamesService _gamesService;

  GamesRepositoryImpl(this._gamesService);

  @override
  Future<List<Game>> getGames() async {
    return await Future.delayed(
      Duration(seconds: 3),
      () => _gamesService.fetchGames(),
    );
  }
}
