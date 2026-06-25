import 'package:dio/dio.dart';
import 'package:pokemon_go_pokedex/models/pokemon.dart';
import 'package:pokemon_go_pokedex/repositories/pokemon_repository.dart';

class LilyDexPokemonRepository implements PokemonRepository {
  LilyDexPokemonRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://mknepprath.github.io/lily-dex-api',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  List<Pokemon>? _pokemonCache;

  @override
  Future<List<String>> getPokemonNames() async {
    final List<Pokemon> pokemon = await _getPokedex();
    final List<String> names = pokemon
        .where((Pokemon item) => item.released)
        .map((Pokemon item) => item.names.english)
        .where((String item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return names;
  }

  @override
  Future<Pokemon> getPokemonDetails(String pokemonName) async {
    final List<Pokemon> pokemon = await _getPokedex();

    return pokemon.firstWhere(
      (Pokemon item) => item.names.english.toLowerCase() == pokemonName.toLowerCase(),
      orElse: () => throw DioException(
        requestOptions: RequestOptions(path: '/pokedex.json'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/pokedex.json'),
          statusCode: 404,
        ),
        type: DioExceptionType.badResponse,
      ),
    );
  }

  Future<List<Pokemon>> _getPokedex() async {
    if (_pokemonCache != null) {
      return _pokemonCache!;
    }

    final Response<dynamic> response = await _dio.get<dynamic>('/pokedex.json');
    final List<dynamic> data = response.data as List<dynamic>;
    _pokemonCache = data
        .whereType<Map>()
        .map((Map item) => Pokemon.fromJson(item.cast<String, dynamic>()))
        .toList();

    return _pokemonCache!;
  }
}
