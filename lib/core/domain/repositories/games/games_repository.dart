import 'package:sports_betting_simulator/core/models/game_model.dart';

abstract class GamesRepository {
  Future<List<Game>> getGames();
}
