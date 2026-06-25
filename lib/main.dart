import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_go_pokedex/repositories/lily_dex_pokemon_repository.dart';
import 'package:pokemon_go_pokedex/screens/pokemon_screen.dart';
import 'package:pokemon_go_pokedex/services/pokemon_service.dart';
import 'package:pokemon_go_pokedex/utils/app_theme.dart';
import 'package:pokemon_go_pokedex/viewmodels/pokemon_viewmodel.dart';

void main() {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.none;
  runApp(const PokemonGoPokeDexApp());
}

class PokemonGoPokeDexApp extends StatelessWidget {
  const PokemonGoPokeDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<LilyDexPokemonRepository>(
          create: (_) => LilyDexPokemonRepository(),
        ),
        ProxyProvider<LilyDexPokemonRepository, PokemonService>(
          update: (_, LilyDexPokemonRepository repository, __) => PokemonService(repository),
        ),
        ChangeNotifierProxyProvider<PokemonService, PokemonViewModel>(
          create: (BuildContext context) => PokemonViewModel(context.read<PokemonService>()),
          update: (_, PokemonService service, PokemonViewModel? previous) =>
              previous ?? PokemonViewModel(service),
        ),
      ],
      child: MaterialApp(
        title: 'Pokemon GO PokeDex',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme().copyWith(
          textTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme().textTheme),
        ),
        darkTheme: AppTheme.darkTheme().copyWith(
          textTheme: GoogleFonts.interTextTheme(AppTheme.darkTheme().textTheme),
        ),
        themeMode: ThemeMode.system,
        home: const PokemonScreen(),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

