import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_go_pokedex/models/pokemon.dart';
import 'package:pokemon_go_pokedex/viewmodels/pokemon_viewmodel.dart';
import 'package:pokemon_go_pokedex/widgets/evolution_card.dart';
import 'package:pokemon_go_pokedex/widgets/info_card.dart';
import 'package:pokemon_go_pokedex/widgets/move_card.dart';
import 'package:pokemon_go_pokedex/widgets/pokemon_header.dart';
import 'package:pokemon_go_pokedex/widgets/pokemon_image_card.dart';
import 'package:pokemon_go_pokedex/widgets/search_suggestions.dart';
import 'package:pokemon_go_pokedex/widgets/section_title.dart';
import 'package:pokemon_go_pokedex/widgets/stat_bar.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonViewModel>().loadPokemonNames();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pokemon GO PokeDex'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              theme.colorScheme.primary.withValues(alpha: 0.16),
              theme.colorScheme.surface,
              theme.scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<PokemonViewModel>(
          builder: (BuildContext context, PokemonViewModel viewModel, _) {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: viewModel.retry,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  children: <Widget>[
                    _SearchCard(viewModel: viewModel),
                    const Gap(12),
                    if (viewModel.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (viewModel.hasError)
                      InfoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              viewModel.errorMessage ?? 'Something went wrong.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                            const Gap(12),
                            FilledButton.tonal(
                              onPressed: viewModel.retry,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    if (viewModel.selectedPokemon != null)
                      _PokemonDetails(pokemon: viewModel.selectedPokemon!),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.viewModel});

  final PokemonViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Discover Pokemon GO details',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Gap(8),
          Text(
            'Search any released Pokemon and explore moves, stats, evolutions, and more.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(12),
          TextField(
            controller: viewModel.searchController,
            onChanged: viewModel.onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search Pokemon',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          if (viewModel.suggestions.isNotEmpty) ...<Widget>[
            const Gap(12),
            SearchSuggestions(
              suggestions: viewModel.suggestions,
              onSuggestionTap: viewModel.selectSuggestion,
            ),
          ],
          const Gap(10),
          _GradientButton(
            enabled: viewModel.canSearch && !viewModel.isLoading,
            label: 'Analyze',
            onPressed: viewModel.fetchPokemonDetails,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -.05, end: 0);
  }
}

class _PokemonDetails extends StatelessWidget {
  const _PokemonDetails({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final List<PokemonMove> fastMoves = <PokemonMove>[
      ...pokemon.quickMoves.values,
      ...pokemon.eliteQuickMoves.values,
    ];
    final List<PokemonMove> chargedMoves = <PokemonMove>[
      ...pokemon.cinematicMoves.values,
      ...pokemon.eliteCinematicMoves.values,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PokemonImageCard(
          heroTag: 'pokemon-${pokemon.dexNr}',
          imageUrl: pokemon.assets.image,
          name: pokemon.names.english,
        ),
        const Gap(10),
        PokemonHeader(pokemon: pokemon),
        const Gap(10),
        const SectionTitle(title: 'Base Stats'),
        const Gap(6),
        InfoCard(
          child: Column(
            children: <Widget>[
              StatBar(label: 'Attack', value: pokemon.stats.attack, max: 300),
              const Gap(10),
              StatBar(label: 'Defense', value: pokemon.stats.defense, max: 300),
              const Gap(10),
              StatBar(label: 'Stamina', value: pokemon.stats.stamina, max: 300),
            ],
          ),
        ).animate().fadeIn(delay: 80.ms),
        const Gap(10),
        const SectionTitle(title: 'Fast Moves'),
        const Gap(6),
        ...fastMoves.map(
          (PokemonMove move) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: MoveCard(
              title: move.names.english,
              type: move.type?.names.english ?? 'Unknown',
              power: move.power,
              energy: move.energy,
              combatPower: move.combat?.power ?? 0,
              turns: move.combat?.turns ?? 0,
              isElite: pokemon.eliteQuickMoves.containsKey(move.id),
              icon: Icons.bolt_rounded,
            ),
          ),
        ),
        const Gap(6),
        const SectionTitle(title: 'Charged Moves'),
        const Gap(6),
        ...chargedMoves.map(
          (PokemonMove move) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: MoveCard(
              title: move.names.english,
              type: move.type?.names.english ?? 'Unknown',
              power: move.power,
              energy: move.energy,
              combatPower: move.combat?.power ?? 0,
              turns: move.combat?.turns ?? 0,
              isElite: pokemon.eliteCinematicMoves.containsKey(move.id),
              icon: Icons.whatshot_rounded,
            ),
          ),
        ),
        const Gap(6),
        const SectionTitle(title: 'Evolutions'),
        const Gap(6),
        EvolutionCard(pokemon: pokemon),
        const Gap(10),
        const SectionTitle(title: 'Additional Information'),
        const Gap(6),
        InfoCard(
          child: Wrap(
            runSpacing: 14,
            spacing: 14,
            children: <Widget>[
              _InfoItem(label: 'Generation', value: pokemon.generation.toString()),
              _InfoItem(label: 'Buddy Distance', value: '${pokemon.buddyDistance} km'),
              _InfoItem(
                label: 'Third Move Cost',
                value: pokemon.thirdMoveCost?.toString() ?? 'N/A',
              ),
              _InfoItem(label: 'Released', value: pokemon.released ? 'Yes' : 'No'),
              _InfoItem(
                label: 'Mega Evolution Available',
                value: pokemon.hasMegaEvolution ? 'Yes' : 'No',
              ),
              _InfoItem(
                label: 'Gigantamax Available',
                value: pokemon.hasGigantamaxEvolution ? 'Yes' : 'No',
              ),
              if (pokemon.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pokemon.tags
                      .map((String tag) => Chip(label: Text(tag.replaceAll('_', ' '))))
                      .toList(),
                ),
            ],
          ),
        ).animate().fadeIn(delay: 120.ms),
      ],
    ).animate().fadeIn(duration: 350.ms);
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 148,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(4),
          Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.enabled,
    required this.label,
    required this.onPressed,
  });

  final bool enabled;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF6C63FF), Color(0xFF8A7CFF)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: FilledButton(
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

