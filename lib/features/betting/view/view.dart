import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/core/models/game_model.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_bloc.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_event.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_state.dart';
import 'package:sports_betting_simulator/features/betting/view/match_tile/match_tile.dart';

class BettingView extends StatefulWidget {
  const BettingView({super.key});

  @override
  State<BettingView> createState() => _BettingViewState();
}

class _BettingViewState extends State<BettingView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll to make expanded item fully visible
  void _scrollToExpandedItem(BuildContext context, Game game) {
    // Find the context of the expanded item
    final RenderObject? renderObject = context.findRenderObject();
    final RenderAbstractViewport? viewport = RenderAbstractViewport.maybeOf(
      renderObject,
    );

    if (renderObject != null && viewport != null) {
      // Calculate the offset needed to make the item fully visible
      final double offset = _scrollController.position.pixels;
      final targetPosition =
          viewport.getOffsetToReveal(renderObject, 1.0).offset;

      // Only scroll if needed
      if (targetPosition > offset) {
        _scrollController.animateTo(
          targetPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BettingBloc, BettingState>(
      builder: (context, state) {
        // Loading state
        if (state is BettingLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Loaded state
        if (state is BettingLoaded) {
          if (state.games.isEmpty) {
            return const Center(
              child: Text(
                'No upcoming games available',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.games.length,
            itemBuilder: (context, index) {
              final game = state.games[index];
              return MatchTile(
                key: ValueKey('game-${game.gameId}'),
                game: game,
                onExpand: (isExpanded, tileContext) {
                  if (isExpanded) {
                    _scrollToExpandedItem(tileContext, game);
                  }
                },
              );
            },
          );
        }

        // Error state
        if (state is BettingError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<BettingBloc>().add(LoadGames());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Default error state
        return const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(color: Colors.white70),
          ),
        );
      },
    );
  }
}
