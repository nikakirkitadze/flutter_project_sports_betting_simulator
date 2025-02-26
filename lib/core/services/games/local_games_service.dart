import 'package:sports_betting_simulator/core/models/game_model.dart';
import 'package:sports_betting_simulator/core/models/odds_model.dart';
import 'package:sports_betting_simulator/core/services/games/games_service.dart';

class LocalGamesService implements GamesService {
  @override
  Future<List<Game>> fetchGames() async {
    return [
      Game(
        gameId: 1,
        homeTeam: "Liverpool",
        awayTeam: "Barcelona",
        odds: const Odds(homeWin: 1.8, draw: 3.2, awayWin: 4.5),
        isExpanded: false,
        hasUpdates: false,
      ),
      Game(
        gameId: 2,
        homeTeam: "Real Madrid",
        awayTeam: "Manchester United",
        odds: const Odds(homeWin: 2.0, draw: 3.0, awayWin: 3.5),
        isExpanded: false,
        hasUpdates: false,
      ),
      Game(
        gameId: 3,
        homeTeam: "Bayern Munich",
        awayTeam: "Juventus",
        odds: const Odds(homeWin: 1.6, draw: 3.5, awayWin: 5.0),
        isExpanded: false,
        hasUpdates: false,
      ),
      Game(
        gameId: 4,
        homeTeam: "Paris Saint-Germain",
        awayTeam: "Chelsea",
        odds: const Odds(homeWin: 2.1, draw: 3.3, awayWin: 3.8),
        isExpanded: false,
        hasUpdates: false,
      ),
      Game(
        gameId: 5,
        homeTeam: "AC Milan",
        awayTeam: "Inter Milan",
        odds: const Odds(homeWin: 1.9, draw: 3.4, awayWin: 4.0),
        isExpanded: false,
        hasUpdates: false,
      ),
      Game(
        gameId: 6,
        homeTeam: "Arsenal",
        awayTeam: "Tottenham",
        odds: const Odds(homeWin: 2.3, draw: 3.6, awayWin: 3.2),
        isExpanded: false,
        hasUpdates: false,
      ),
      Game(
        gameId: 7,
        homeTeam: "Borussia Dortmund",
        awayTeam: "Schalke",
        odds: const Odds(homeWin: 1.7, draw: 3.1, awayWin: 4.2),
        isExpanded: false,
        hasUpdates: false,
      ),
      Game(
        gameId: 8,
        homeTeam: "Atletico Madrid",
        awayTeam: "Sevilla",
        odds: const Odds(homeWin: 1.95, draw: 3.0, awayWin: 3.9),
        isExpanded: false,
        hasUpdates: false,
      ),
    ];
  }
}
