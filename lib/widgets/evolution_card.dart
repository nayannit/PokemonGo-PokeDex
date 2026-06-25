import 'package:flutter/material.dart';
import 'package:pokemon_go_pokedex/models/pokemon.dart';
import 'package:pokemon_go_pokedex/widgets/info_card.dart';

class EvolutionCard extends StatelessWidget {
  const EvolutionCard({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final List<String> chain = <String>[
      pokemon.names.english,
      ...pokemon.evolutions.map((PokemonEvolution item) => _formatId(item.id)),
    ];

    return InfoCard(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          for (int index = 0; index < chain.length; index++) ...<Widget>[
            _EvolutionChip(label: chain[index]),
            if (index != chain.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(Icons.arrow_downward_rounded),
              ),
          ],
        ],
      ),
    );
  }

  String _formatId(String value) {
    return value
        .toLowerCase()
        .split('_')
        .map((String part) => part.isEmpty ? '' : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

class _EvolutionChip extends StatelessWidget {
  const _EvolutionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
