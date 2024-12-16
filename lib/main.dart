import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(GameWidget(game: PokerEstimationGame()));

}

class PokerEstimationGame extends FlameGame with TapDetector {
  late SpriteComponent table;
  late List<List<SpriteComponent>> playerCards; // Cards for each player
  late Vector2 cardSize;
  late List<Vector2> playerPositions; // Player positions
  int currentPlayer = 0; // Tracks which player's turn it is

  @override
  Future<void> onLoad() async {
    super.onLoad();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Load table background
    table = SpriteComponent()
      ..sprite = await loadSprite('table.jpeg')
      ..size = size
      ..anchor = Anchor.center
      ..position = size / 2;
    add(table);

    // Define card size and player positions
    cardSize = Vector2(50, 75);
    playerPositions = [
      Vector2(size.x / 2, size.y - 100), // Bottom (You)
      Vector2(size.x - 100, size.y / 2), // Right
      Vector2(size.x / 2, 100),          // Top
      Vector2(100, size.y / 2),          // Left
    ];

    // Distribute cards to players
    playerCards = List.generate(4, (_) => []); // 4 players

    for (int playerIndex = 0; playerIndex < 4; playerIndex++) {
      for (int cardIndex = 0; cardIndex < 13; cardIndex++) { // 8 cards per player
        final card = SpriteComponent()
          ..sprite = await loadSprite('card_${playerIndex==0?0:2}.png') // Load a card
          ..size = cardSize
          ..position = playerPositions[playerIndex] + Vector2(cardIndex * 10, 0); // Offset cards for player
        playerCards[playerIndex].add(card);
        add(card);
      }
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    // Get the current player's cards
    final currentCards = playerCards[currentPlayer];

    if (currentCards.isNotEmpty) {
      final card = currentCards.removeAt(0); // Remove the top card from the player's hand

      // Animate card to the center of the table
      card.add(
        MoveEffect.to(
          size / 2, // Center of the table
          EffectController(duration: 0.5),
        ),
      );

      // Pass turn to the next player
      currentPlayer = (currentPlayer + 1) % 4;
    }
  }
}
