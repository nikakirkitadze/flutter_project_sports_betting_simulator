import 'package:sports_betting_simulator/core/models/game_model.dart';
import 'package:sports_betting_simulator/core/services/games/games_service.dart';

// Remote service - data to be fetched from real backend
class DefaultGamesService extends GamesService {
  @override
  Future<List<Game>> fetchGames() {
    // TODO: implement fetchGames
    throw UnimplementedError();
  }
}
