import 'package:equatable/equatable.dart';
import 'package:sports_betting_simulator/core/models/odds_model.dart';

class Game extends Equatable {
  final int gameId;
  final String homeTeam;
  final String awayTeam;
  final Odds odds;
  final bool hasUpdates;
  final bool isExpanded;
  final String? updatedOddsType;

  const Game({
    required this.gameId,
    required this.homeTeam,
    required this.awayTeam,
    required this.odds,
    this.hasUpdates = false,
    this.isExpanded = false,
    this.updatedOddsType,
  });

  Game copyWith({
    int? gameId,
    String? homeTeam,
    String? awayTeam,
    Odds? odds,
    bool? hasUpdates,
    bool? isExpanded,
    String? updatedOddsType,
  }) {
    return Game(
      gameId: gameId ?? this.gameId,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      odds: odds ?? this.odds,
      hasUpdates: hasUpdates ?? this.hasUpdates,
      isExpanded: isExpanded ?? this.isExpanded,
      updatedOddsType: updatedOddsType ?? this.updatedOddsType,
    );
  }

  @override
  List<Object?> get props => [
    gameId,
    homeTeam,
    awayTeam,
    odds,
    hasUpdates,
    isExpanded,
    updatedOddsType,
  ];
}
