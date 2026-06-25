import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokemon_go_pokedex/models/pokemon.dart';
import 'package:pokemon_go_pokedex/widgets/type_chip.dart';

class PokemonHeader extends StatelessWidget {
  const PokemonHeader({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          pokemon.names.english,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const Gap(6),
        Text(
          '#${pokemon.dexNr.toString().padLeft(3, '0')}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            TypeChip(type: pokemon.primaryType.names.english),
            if (pokemon.secondaryType != null) TypeChip(type: pokemon.secondaryType!.names.english),
          ],
        ),
      ],
    );
  }
}
