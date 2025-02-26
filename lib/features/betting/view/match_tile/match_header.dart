import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/core/models/game_model.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_bloc.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_event.dart';
import 'package:sports_betting_simulator/features/betting/view/match_tile/club_logo.dart';

class MatchHeader extends StatelessWidget {
  final Game game;
  final bool isExpanded;
  final Function(bool, BuildContext)? onExpand;

  const MatchHeader({
    super.key,
    required this.game,
    this.onExpand,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('MatchHeader build method called');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Home team logo
                    Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: ClubLogo(
                        logoPath:
                            'assets/clubs/${_getLogoFileName(game.homeTeam)}.png',
                      ),
                    ),
                    // Away team logo
                    ClubLogo(
                      logoPath:
                          'assets/clubs/${_getLogoFileName(game.awayTeam)}.png',
                      hasStroke: true,
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(width: 14.0),
                // Match details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${game.homeTeam} vs ${game.awayTeam}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Expand/collapse button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.read<BettingBloc>().add(ToggleGameExpansion(game.gameId));
              if (onExpand != null) {
                onExpand!(!isExpanded, context);
              }
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                game.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getLogoFileName(String teamName) {
    // Convert team name to lowercase and remove spaces for file naming
    return teamName.toLowerCase().replaceAll(' ', '');
  }
}
