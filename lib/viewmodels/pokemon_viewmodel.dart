import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_go_pokedex/models/pokemon.dart';
import 'package:pokemon_go_pokedex/services/pokemon_service.dart';

class PokemonViewModel extends ChangeNotifier {
  PokemonViewModel(this._service);

  final PokemonService _service;

  final TextEditingController searchController = TextEditingController();

  List<String> _pokemonNames = <String>[];
  List<String> _suggestions = <String>[];
  Pokemon? _selectedPokemon;
  bool _isLoadingNames = false;
  bool _isLoadingDetails = false;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedName;
  Timer? _debounce;

  List<String> get suggestions => _suggestions;
  Pokemon? get selectedPokemon => _selectedPokemon;
  bool get isLoading => _isLoadingNames || _isLoadingDetails;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  bool get canSearch {
    if (_selectedName != null) {
      return true;
    }

    return _pokemonNames.any(
      (String name) => name.toLowerCase() == _searchQuery.trim().toLowerCase(),
    );
  }

  Future<void> loadPokemonNames() async {
    _isLoadingNames = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemonNames = await _service.getPokemonNames();
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingNames = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String value) {
    _searchQuery = value;
    _selectedName = _normalizePokemonName(value);
    _debounce?.cancel();

    if (value.trim().length < 2) {
      _suggestions = <String>[];
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      final String query = value.trim().toLowerCase();
      _suggestions = _pokemonNames
          .where((String name) => name.toLowerCase().contains(query))
          .take(10)
          .toList();
      notifyListeners();
    });
  }

  void selectSuggestion(String pokemonName) {
    _selectedName = pokemonName;
    _searchQuery = pokemonName;
    searchController.value = TextEditingValue(
      text: pokemonName,
      selection: TextSelection.collapsed(offset: pokemonName.length),
    );
    _suggestions = <String>[];
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchPokemonDetails() async {
    if (!canSearch || isLoading) {
      return;
    }

    final String pokemonName = _selectedName ?? _normalizePokemonName(_searchQuery)!;

    _selectedPokemon = null;
    _errorMessage = null;
    _isLoadingDetails = true;
    notifyListeners();

    try {
      _selectedPokemon = await _service.getPokemonDetails(pokemonName);
      _suggestions = <String>[];
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    if (_pokemonNames.isEmpty) {
      await loadPokemonNames();
      return;
    }

    await fetchPokemonDetails();
  }

  String? _normalizePokemonName(String value) {
    for (final String name in _pokemonNames) {
      if (name.toLowerCase() == value.trim().toLowerCase()) {
        return name;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
