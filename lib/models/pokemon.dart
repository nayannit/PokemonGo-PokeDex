class PokemonNameSet {
  const PokemonNameSet({
    required this.english,
  });

  final String english;

  factory PokemonNameSet.fromJson(Map<String, dynamic> json) {
    return PokemonNameSet(
      english: json['English'] as String? ?? '',
    );
  }
}

class PokemonTypeInfo {
  const PokemonTypeInfo({
    required this.type,
    required this.names,
  });

  final String type;
  final PokemonNameSet names;

  factory PokemonTypeInfo.fromJson(Map<String, dynamic> json) {
    return PokemonTypeInfo(
      type: json['type'] as String? ?? '',
      names: PokemonNameSet.fromJson(
        (json['names'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
    );
  }
}

class PokemonStats {
  const PokemonStats({
    required this.stamina,
    required this.attack,
    required this.defense,
  });

  final int stamina;
  final int attack;
  final int defense;

  factory PokemonStats.fromJson(Map<String, dynamic> json) {
    return PokemonStats(
      stamina: json['stamina'] as int? ?? 0,
      attack: json['attack'] as int? ?? 0,
      defense: json['defense'] as int? ?? 0,
    );
  }
}

class PokemonCombatMove {
  const PokemonCombatMove({
    required this.energy,
    required this.power,
    required this.turns,
  });

  final int energy;
  final int power;
  final int turns;

  factory PokemonCombatMove.fromJson(Map<String, dynamic> json) {
    return PokemonCombatMove(
      energy: json['energy'] as int? ?? 0,
      power: json['power'] as int? ?? 0,
      turns: json['turns'] as int? ?? 0,
    );
  }
}

class PokemonMove {
  const PokemonMove({
    required this.id,
    required this.power,
    required this.energy,
    required this.type,
    required this.names,
    required this.combat,
  });

  final String id;
  final int power;
  final int energy;
  final PokemonTypeInfo? type;
  final PokemonNameSet names;
  final PokemonCombatMove? combat;

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    final dynamic type = json['type'];
    final dynamic combat = json['combat'];

    return PokemonMove(
      id: json['id'] as String? ?? '',
      power: json['power'] as int? ?? 0,
      energy: json['energy'] as int? ?? 0,
      type: type is Map ? PokemonTypeInfo.fromJson(type.cast<String, dynamic>()) : null,
      names: PokemonNameSet.fromJson(
        (json['names'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
      combat: combat is Map ? PokemonCombatMove.fromJson(combat.cast<String, dynamic>()) : null,
    );
  }
}

class PokemonEvolution {
  const PokemonEvolution({
    required this.id,
    required this.dexNr,
  });

  final String id;
  final int? dexNr;

  factory PokemonEvolution.fromJson(Map<String, dynamic> json) {
    return PokemonEvolution(
      id: json['id'] as String? ?? '',
      dexNr: json['dexNr'] as int?,
    );
  }
}

class PokemonAssets {
  const PokemonAssets({
    required this.image,
  });

  final String image;

  factory PokemonAssets.fromJson(Map<String, dynamic> json) {
    return PokemonAssets(
      image: json['image'] as String? ?? '',
    );
  }
}

class Pokemon {
  const Pokemon({
    required this.id,
    required this.dexNr,
    required this.generation,
    required this.names,
    required this.stats,
    required this.primaryType,
    required this.secondaryType,
    required this.quickMoves,
    required this.cinematicMoves,
    required this.eliteQuickMoves,
    required this.eliteCinematicMoves,
    required this.evolutions,
    required this.buddyDistance,
    required this.thirdMoveCost,
    required this.released,
    required this.hasMegaEvolution,
    required this.hasGigantamaxEvolution,
    required this.tags,
    required this.assets,
  });

  final String id;
  final int dexNr;
  final int generation;
  final PokemonNameSet names;
  final PokemonStats stats;
  final PokemonTypeInfo primaryType;
  final PokemonTypeInfo? secondaryType;
  final Map<String, PokemonMove> quickMoves;
  final Map<String, PokemonMove> cinematicMoves;
  final Map<String, PokemonMove> eliteQuickMoves;
  final Map<String, PokemonMove> eliteCinematicMoves;
  final List<PokemonEvolution> evolutions;
  final int buddyDistance;
  final int? thirdMoveCost;
  final bool released;
  final bool hasMegaEvolution;
  final bool hasGigantamaxEvolution;
  final List<String> tags;
  final PokemonAssets assets;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final dynamic primaryType = json['primaryType'];
    final dynamic secondaryType = json['secondaryType'];

    return Pokemon(
      id: json['id'] as String? ?? '',
      dexNr: json['dexNr'] as int? ?? 0,
      generation: json['generation'] as int? ?? 0,
      names: PokemonNameSet.fromJson(
        (json['names'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
      stats: PokemonStats.fromJson(
        (json['stats'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
      primaryType: primaryType is Map
          ? PokemonTypeInfo.fromJson(primaryType.cast<String, dynamic>())
          : const PokemonTypeInfo(type: '', names: PokemonNameSet(english: 'Unknown')),
      secondaryType: secondaryType is Map
          ? PokemonTypeInfo.fromJson(secondaryType.cast<String, dynamic>())
          : null,
      quickMoves: _moveMap(json['quickMoves']),
      cinematicMoves: _moveMap(json['cinematicMoves']),
      eliteQuickMoves: _moveMap(json['eliteQuickMoves']),
      eliteCinematicMoves: _moveMap(json['eliteCinematicMoves']),
      evolutions: (json['evolutions'] as List?)
              ?.whereType<Map>()
              .map((Map item) => PokemonEvolution.fromJson(item.cast<String, dynamic>()))
              .where((PokemonEvolution item) => item.id.isNotEmpty)
              .toList() ??
          const <PokemonEvolution>[],
      buddyDistance: json['buddyDistance'] as int? ?? 0,
      thirdMoveCost: json['thirdMoveCost'] as int?,
      released: json['released'] as bool? ?? false,
      hasMegaEvolution: json['hasMegaEvolution'] as bool? ?? false,
      hasGigantamaxEvolution: json['hasGigantamaxEvolution'] as bool? ?? false,
      tags: (json['tags'] as List?)?.whereType<String>().toList() ?? const <String>[],
      assets: PokemonAssets.fromJson(
        (json['assets'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
    );
  }

  static Map<String, PokemonMove> _moveMap(dynamic value) {
    if (value is! Map) {
      return <String, PokemonMove>{};
    }

    return value.map(
      (dynamic key, dynamic move) => MapEntry<String, PokemonMove>(
        key.toString(),
        PokemonMove.fromJson((move as Map).cast<String, dynamic>()),
      ),
    );
  }
}
