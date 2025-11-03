import 'package:flutter/material.dart';

class SwipeCounterWidget extends StatelessWidget {
  final int swipesLeft;
  final int superLikesLeft;
  final bool isPremium;

  const SwipeCounterWidget({
    super.key,
    required this.swipesLeft,
    required this.superLikesLeft,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 16, color: Colors.white),
            SizedBox(width: 4),
            Text(
              'Premium',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            '$swipesLeft',
            style: TextStyle(
              color: swipesLeft < 10 ? Colors.orange : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.star, size: 16, color: Colors.amber),
          SizedBox(width: 4),
          Text(
            '$superLikesLeft',
            style: TextStyle(
              color: superLikesLeft == 0 ? Colors.orange : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
