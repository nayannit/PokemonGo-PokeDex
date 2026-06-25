import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pokemon_go_pokedex/widgets/info_card.dart';

class PokemonImageCard extends StatelessWidget {
  const PokemonImageCard({
    super.key,
    required this.heroTag,
    required this.imageUrl,
    required this.name,
  });

  final String heroTag;
  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: InfoCard(
        child: SizedBox(
          height: 210,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fadeInDuration: 400.ms,
            fit: BoxFit.contain,
            placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
            errorWidget: (_, __, ___) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.catching_pokemon_rounded, size: 54),
                const SizedBox(height: 8),
                Text(name),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
