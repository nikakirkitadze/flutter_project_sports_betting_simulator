import 'package:equatable/equatable.dart';

class Odds extends Equatable {
  final double homeWin; // "1"
  final double draw; // "X"
  final double awayWin; // "2"

  const Odds({
    required this.homeWin,
    required this.draw,
    required this.awayWin,
  });

  Odds copyWith({double? homeWin, double? draw, double? awayWin}) {
    return Odds(
      homeWin: homeWin ?? this.homeWin,
      draw: draw ?? this.draw,
      awayWin: awayWin ?? this.awayWin,
    );
  }

  @override
  List<Object?> get props => [homeWin, draw, awayWin];
}
