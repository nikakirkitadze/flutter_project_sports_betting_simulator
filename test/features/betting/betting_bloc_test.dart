import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_betting_simulator/core/models/game_model.dart';
import 'package:sports_betting_simulator/core/models/odds_model.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_bloc.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_event.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_state.dart';

import '../../mocks/repositories/mock_games_repository.dart';

void main() {
  late BettingBloc bettingBloc;
  late MockGamesRepository mockGamesRepository;

  setUp(() {
    mockGamesRepository = MockGamesRepository();
    bettingBloc = BettingBloc(mockGamesRepository);
  });

  tearDown(() {
    bettingBloc.close();
  });

  group('BettingBloc', () {
    test('initial state is BettingInitial', () {
      expect(bettingBloc.state, BettingInitial());
    });

    group('LoadGames', () {
      final testGames = [
        const Game(
          gameId: 1,
          homeTeam: 'Liverpool',
          awayTeam: 'Man United',
          odds: Odds(homeWin: 1.5, draw: 3.0, awayWin: 2.5),
          isExpanded: false,
          hasUpdates: false,
        ),
        const Game(
          gameId: 2,
          homeTeam: 'Real Madrid',
          awayTeam: 'Barcelona',
          odds: Odds(homeWin: 2.0, draw: 3.5, awayWin: 2.0),
          isExpanded: false,
          hasUpdates: false,
        ),
      ];

      blocTest<BettingBloc, BettingState>(
        'emits [BettingLoading, BettingLoaded] when LoadGames is added and games are loaded successfully',
        build: () {
          when(
            () => mockGamesRepository.getGames(),
          ).thenAnswer((_) async => testGames);
          return bettingBloc;
        },
        act: (bloc) => bloc.add(LoadGames()),
        expect: () => [BettingLoading(), BettingLoaded(games: testGames)],
        verify: (_) {
          verify(() => mockGamesRepository.getGames()).called(1);
        },
      );

      blocTest<BettingBloc, BettingState>(
        'emits [BettingLoading, BettingError] when LoadGames is added and games fail to load',
        build: () {
          when(
            () => mockGamesRepository.getGames(),
          ).thenThrow(Exception('Failed to load games'));
          return bettingBloc;
        },
        act: (bloc) => bloc.add(LoadGames()),
        expect:
            () => [
              BettingLoading(),
              BettingError(errorMessage: 'Exception: Failed to load games'),
            ],
        verify: (_) {
          verify(() => mockGamesRepository.getGames()).called(1);
        },
      );
    });

    group('ToggleGameExpansion', () {
      final initialGames = [
        const Game(
          gameId: 1,
          homeTeam: 'Liverpool',
          awayTeam: 'Man United',
          odds: Odds(homeWin: 1.5, draw: 3.0, awayWin: 2.5),
          isExpanded: false,
          hasUpdates: false,
        ),
        const Game(
          gameId: 2,
          homeTeam: 'Real Madrid',
          awayTeam: 'Barcelona',
          odds: Odds(homeWin: 2.0, draw: 3.5, awayWin: 2.0),
          isExpanded: false,
          hasUpdates: false,
        ),
      ];

      blocTest<BettingBloc, BettingState>(
        'emits BettingLoaded with toggled expansion for the given gameId and collapses others',
        build: () => bettingBloc,
        seed: () => BettingLoaded(games: initialGames),
        act: (bloc) => bloc.add(ToggleGameExpansion(1)),
        expect: () {
          final updatedGames = [
            initialGames[0].copyWith(isExpanded: true, hasUpdates: false),
            initialGames[1].copyWith(isExpanded: false), // Collapsed
          ];
          return [BettingLoaded(games: updatedGames)];
        },
      );
    });

    group('UpdateGameOdds', () {
      final initialGames = [
        const Game(
          gameId: 1,
          homeTeam: 'Liverpool',
          awayTeam: 'Man United',
          odds: Odds(homeWin: 1.5, draw: 3.0, awayWin: 2.5),
          isExpanded: true,
          hasUpdates: false,
        ),
        const Game(
          gameId: 2,
          homeTeam: 'Real Madrid',
          awayTeam: 'Barcelona',
          odds: Odds(homeWin: 2.0, draw: 3.5, awayWin: 2.0),
          isExpanded: false,
          hasUpdates: false,
        ),
      ];
      final newOdds = Odds(homeWin: 1.6, draw: 3.2, awayWin: 2.7);

      blocTest<BettingBloc, BettingState>(
        'emits BettingLoaded with updated odds and hasUpdates=false if expanded',
        seed: () => BettingLoaded(games: initialGames),
        build: () => bettingBloc,
        act: (bloc) => bloc.add(UpdateGameOdds(1, newOdds)),
        expect: () {
          final updatedGames = [
            initialGames[0].copyWith(
              odds: newOdds,
              hasUpdates: false,
            ), // No update if expanded
            initialGames[1],
          ];
          return [BettingLoaded(games: updatedGames)];
        },
      );

      blocTest<BettingBloc, BettingState>(
        'emits BettingLoaded with updated odds and hasUpdates=true if not expanded',
        seed:
            () => BettingLoaded(
              games:
                  initialGames
                      .map((g) => g.copyWith(isExpanded: false))
                      .toList(),
            ), // All collapsed
        build: () => bettingBloc,
        act: (bloc) => bettingBloc.add(UpdateGameOdds(1, newOdds)),
        expect: () {
          final updatedGames = [
            initialGames[0].copyWith(
              odds: newOdds,
              isExpanded: false,
              hasUpdates: true,
            ), // hasUpdates true if collapsed
            initialGames[1].copyWith(isExpanded: false),
          ];
          return [BettingLoaded(games: updatedGames)];
        },
      );
    });
  });
}
