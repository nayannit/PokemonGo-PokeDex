import 'package:pokemon_go_pokedex/models/pokemon.dart';

abstract class PokemonRepository {
  Future<List<String>> getPokemonNames();

  Future<Pokemon> getPokemonDetails(String pokemonName);
}
