import 'package:equatable/equatable.dart';
import 'package:sports_betting_simulator/core/models/game_model.dart';

abstract class BettingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BettingInitial extends BettingState {}

class BettingLoading extends BettingState {}

class BettingLoaded extends BettingState {
  final List<Game> games;

  BettingLoaded({required this.games});

  @override
  List<Object?> get props => [games];

  BettingLoaded copyWith({List<Game>? games}) {
    return BettingLoaded(games: games ?? this.games);
  }
}

class BettingError extends BettingState {
  final String errorMessage;
  BettingError({required this.errorMessage});
}
