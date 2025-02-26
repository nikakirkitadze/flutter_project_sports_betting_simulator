import 'package:equatable/equatable.dart';
import 'package:sports_betting_simulator/core/models/odds_model.dart';

abstract class BettingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadGames extends BettingEvent {}

class ToggleGameExpansion extends BettingEvent {
  final int gameId;

  ToggleGameExpansion(this.gameId);

  @override
  List<Object?> get props => [gameId];
}

class UpdateGameOdds extends BettingEvent {
  final int gameId;
  final Odds newOdds;

  UpdateGameOdds(this.gameId, this.newOdds);

  @override
  List<Object?> get props => [gameId, newOdds];
}
