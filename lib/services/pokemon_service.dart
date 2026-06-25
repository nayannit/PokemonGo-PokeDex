import 'package:dio/dio.dart';
import 'package:pokemon_go_pokedex/models/pokemon.dart';
import 'package:pokemon_go_pokedex/repositories/pokemon_repository.dart';

class PokemonService {
  const PokemonService(this._repository);

  final PokemonRepository _repository;

  Future<List<String>> getPokemonNames() async {
    try {
      return await _repository.getPokemonNames();
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    } catch (_) {
      throw Exception('Unexpected error while loading Pokemon names.');
    }
  }

  Future<Pokemon> getPokemonDetails(String pokemonName) async {
    try {
      return await _repository.getPokemonDetails(pokemonName);
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    } catch (_) {
      throw Exception('Unexpected error while loading Pokemon details.');
    }
  }

  String _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network and try again.';
      case DioExceptionType.badResponse:
        final int? statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return 'Pokemon not found.';
        }
        if (statusCode == 500) {
          return 'The server encountered an error. Please try again later.';
        }
        return 'Request failed with status code $statusCode.';
      default:
        return 'Unexpected error while communicating with LilyDex API.';
    }
  }
}
