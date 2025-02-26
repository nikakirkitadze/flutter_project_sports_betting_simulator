import 'package:flutter/material.dart';
import 'package:sports_betting_simulator/core/models/game_model.dart';
import 'package:sports_betting_simulator/core/models/odds_model.dart';
import 'package:sports_betting_simulator/features/betting/view/match_tile/match_header.dart';

class MatchTile extends StatefulWidget {
  final Game game;
  final Function(bool, BuildContext)? onExpand;

  const MatchTile({super.key, required this.game, this.onExpand});

  @override
  State<MatchTile> createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Initialize from game's isExpanded
    _isExpanded = widget.game.isExpanded;
  }

  @override
  void didUpdateWidget(covariant MatchTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.game.isExpanded != oldWidget.game.isExpanded) {
      // Update internal state if game.isExpanded changes
      _isExpanded = widget.game.isExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Color(0xFF2B2B3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          // Match header
          MatchHeader(
            game: widget.game,
            onExpand: widget.onExpand, // Pass onExpand callback
            isExpanded: _isExpanded,
          ),

          // Expandable odds section
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: _makeOddsSection(widget.game.odds),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _makeOddsSection(Odds odds) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _makeOddsTile('1', odds.homeWin),
          _makeOddsTile('X', odds.draw),
          _makeOddsTile('2', odds.awayWin),
        ],
      ),
    );
  }

  Widget _makeOddsTile(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
