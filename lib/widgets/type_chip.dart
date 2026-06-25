import 'package:flutter/material.dart';

class TypeChip extends StatelessWidget {
  const TypeChip({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    final _TypeStyle style = _TypeStyle.fromType(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: style.color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(style.icon),
          const SizedBox(width: 6),
          Text(
            type,
            style: TextStyle(
              color: style.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeStyle {
  const _TypeStyle({required this.color, required this.icon});

  final Color color;
  final String icon;

  static _TypeStyle fromType(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return const _TypeStyle(color: Colors.green, icon: '🌿');
      case 'fire':
        return const _TypeStyle(color: Colors.orange, icon: '🔥');
      case 'water':
        return const _TypeStyle(color: Colors.blue, icon: '💧');
      case 'electric':
        return const _TypeStyle(color: Colors.amber, icon: '⚡');
      case 'fairy':
        return const _TypeStyle(color: Colors.pink, icon: '✨');
      case 'dragon':
        return const _TypeStyle(color: Colors.deepPurple, icon: '🐉');
      case 'steel':
        return const _TypeStyle(color: Colors.blueGrey, icon: '⚙');
      case 'ghost':
        return const _TypeStyle(color: Colors.deepPurple, icon: '👻');
      case 'dark':
        return const _TypeStyle(color: Colors.brown, icon: '🌑');
      case 'ice':
        return const _TypeStyle(color: Colors.lightBlue, icon: '❄');
      case 'poison':
        return const _TypeStyle(color: Colors.purple, icon: '☠');
      case 'fighting':
        return const _TypeStyle(color: Colors.deepOrange, icon: '🥊');
      case 'psychic':
        return const _TypeStyle(color: Colors.pinkAccent, icon: '🔮');
      case 'ground':
        return const _TypeStyle(color: Colors.brown, icon: '⛰');
      case 'rock':
        return const _TypeStyle(color: Colors.brown, icon: '🪨');
      case 'bug':
        return const _TypeStyle(color: Colors.lightGreen, icon: '🐛');
      case 'flying':
        return const _TypeStyle(color: Colors.indigo, icon: '🪽');
      case 'normal':
        return const _TypeStyle(color: Colors.grey, icon: '⭕');
      default:
        return const _TypeStyle(color: Colors.teal, icon: '✦');
    }
  }
}
