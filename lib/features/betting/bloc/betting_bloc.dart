import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/core/domain/repositories/games/games_repository.dart';
import 'package:sports_betting_simulator/core/models/odds_model.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_event.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_state.dart';

class BettingBloc extends Bloc<BettingEvent, BettingState> {
  final GamesRepository _gamesRepository;

  Timer? _updateTimer;
  final _random = Random();
  static const _updateGameId = 1;

  BettingBloc(this._gamesRepository) : super(BettingInitial()) {
    on<LoadGames>(_onLoadGames);
    on<ToggleGameExpansion>(_onToggleGameExpansion);
    on<UpdateGameOdds>(_onUpdateGameOdds);
  }

  void _onLoadGames(LoadGames event, Emitter<BettingState> emit) async {
    emit(BettingLoading());
    try {
      final games = await _gamesRepository.getGames();
      emit(BettingLoaded(games: games));
      _startOddsUpdates();
    } catch (e) {
      emit(BettingError(errorMessage: e.toString()));
    }
  }

  void _onToggleGameExpansion(
    ToggleGameExpansion event,
    Emitter<BettingState> emit,
  ) {
    if (state is BettingLoaded) {
      final currentState = state as BettingLoaded;
      final updatedGames =
          currentState.games.map((game) {
            if (game.gameId == event.gameId) {
              // Toggle the expansion for the selected game
              return game.copyWith(isExpanded: !game.isExpanded);
            } else {
              // Collapse other games (optional: remove this if multiple expansions are allowed)
              return game.copyWith(isExpanded: false);
            }
          }).toList();
      emit(BettingLoaded(games: updatedGames));
    }
  }

  void _onUpdateGameOdds(UpdateGameOdds event, Emitter<BettingState> emit) {
    if (state is BettingLoaded) {
      final currentState = state as BettingLoaded;
      final updatedGames =
          currentState.games.map((game) {
            if (game.gameId == event.gameId) {
              String? updatedOddsType;
              if (game.odds.homeWin != event.newOdds.homeWin) {
                updatedOddsType = 'homeWin';
              } else if (game.odds.draw != event.newOdds.draw) {
                updatedOddsType = 'draw';
              } else if (game.odds.awayWin != event.newOdds.awayWin) {
                updatedOddsType = 'awayWin';
              }

              return game.copyWith(
                odds: event.newOdds,
                hasUpdates: updatedOddsType != null,
                updatedOddsType: updatedOddsType,
              );
            }
            return game;
          }).toList();
      emit(BettingLoaded(games: updatedGames));
    }
  }

  void _startOddsUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (state is BettingLoaded) {
        final currentState = state as BettingLoaded;
        final currentGame = currentState.games.firstWhere(
          (g) => g.gameId == _updateGameId,
        );

        final newOdds = Odds(
          homeWin: _updateValue(currentGame.odds.homeWin),
          draw: _updateValue(currentGame.odds.draw),
          awayWin: _updateValue(currentGame.odds.awayWin),
        );

        add(UpdateGameOdds(_updateGameId, newOdds));
      }
    });
  }

  double _updateValue(double current) {
    final variation = _random.nextDouble() * 0.2 - 0.1; // -0.1 to +0.1
    return (current + variation).clamp(1.1, 5.0); // Keep odds reasonable
  }

  @override
  Future<void> close() {
    _updateTimer?.cancel();
    return super.close();
  }
}
