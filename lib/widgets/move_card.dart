import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokemon_go_pokedex/widgets/info_card.dart';
import 'package:pokemon_go_pokedex/widgets/type_chip.dart';

class MoveCard extends StatelessWidget {
  const MoveCard({
    super.key,
    required this.title,
    required this.type,
    required this.power,
    required this.energy,
    required this.combatPower,
    required this.turns,
    required this.isElite,
    required this.icon,
  });

  final String title;
  final String type;
  final int power;
  final int energy;
  final int combatPower;
  final int turns;
  final bool isElite;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InfoCard(
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (isElite)
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Icons.star_rounded, size: 16, color: Color(0xFFC49000)),
                      ),
                  ],
                ),
                const Gap(6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      TypeChip(type: type),
                      const Gap(8),
                      _Metric(label: 'PWR', value: power.toString()),
                      const Gap(6),
                      _Metric(label: 'ENG', value: energy.toString()),
                      const Gap(6),
                      _Metric(label: 'CP', value: combatPower.toString()),
                      const Gap(6),
                      _Metric(label: 'TRN', value: turns.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.labelMedium,
          children: <InlineSpan>[
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
