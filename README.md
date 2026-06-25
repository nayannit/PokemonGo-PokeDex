# Pokemon GO PokeDex

A cross-platform Flutter application that lets users search and explore detailed Pokémon GO data — including base stats, move sets, evolution chains, and metadata — powered by the [LilyDex API](https://mknepprath.github.io/lily-dex-api).

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Data Model](#data-model)
- [Screens & Widgets](#screens--widgets)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [API Reference](#api-reference)
- [State Management](#state-management)
- [Theming](#theming)
- [Testing](#testing)
- [Platform Support](#platform-support)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

**Pokemon GO PokeDex** is a Flutter application built around a single-screen experience: search for any released Pokémon by name and instantly view its complete GO profile — stats, type matchups, fast and charged moves, evolution chain, buddy distance, and more.

The app follows the **MVVM (Model-View-ViewModel)** pattern with a **Repository** abstraction layer for data access, keeping business logic cleanly separated from the UI.

---

## Features

| Feature | Description |
|---|---|
| **Pokémon Search** | Debounced live search with auto-complete suggestions across all released Pokémon |
| **Base Stats** | Animated stat bars for Attack, Defense, and Stamina (max 300 scale) |
| **Move Sets** | Full Fast Move and Charged Move listings with Power, Energy, Combat Power, and Turns |
| **Elite Moves** | Elite moves are flagged with a star indicator |
| **Type Chips** | Color-coded type badges with icons for all 18 Pokémon types |
| **Evolution Chain** | Sequential evolution chain display for the selected Pokémon |
| **Additional Info** | Generation, Buddy Distance, Third Move Cost, Mega/Gigantamax availability, Tags |
| **Error Handling** | User-friendly error messages with inline retry |
| **Pull-to-Refresh** | Swipe down to reload current data |
| **Dark / Light Theme** | Automatic theme switching based on system preference (Material 3) |
| **In-memory Cache** | Pokédex data is fetched once and cached for the session |

---

## Architecture

The application follows a layered **MVVM + Repository** architecture:

```
┌─────────────────────────────────────────────┐
│                    UI Layer                 │
│   Screens  ◄──►  Widgets  ◄──►  ViewModel  │
└─────────────────────┬───────────────────────┘
                      │ observes / calls
┌─────────────────────▼───────────────────────┐
│               Service Layer                 │
│             PokemonService                  │
│   (error mapping, DioException handling)    │
└─────────────────────┬───────────────────────┘
                      │ delegates to
┌─────────────────────▼───────────────────────┐
│             Repository Layer                │
│  PokemonRepository (abstract interface)     │
│  LilyDexPokemonRepository (implementation) │
│  (HTTP via Dio, in-memory cache)            │
└─────────────────────┬───────────────────────┘
                      │ fetches from
┌─────────────────────▼───────────────────────┐
│              LilyDex REST API               │
│  https://mknepprath.github.io/lily-dex-api  │
└─────────────────────────────────────────────┘
```

**Dependency injection** is handled via `MultiProvider` in [`main.dart`](lib/main.dart), wiring the repository → service → viewmodel chain at app startup.

---

## Project Structure

```
lib/
├── main.dart                          # App entry point, DI setup, theme config
│
├── models/
│   └── pokemon.dart                   # All data model classes (Pokemon, PokemonStats, PokemonMove, …)
│
├── repositories/
│   ├── pokemon_repository.dart        # Abstract interface defining the data contract
│   └── lily_dex_pokemon_repository.dart # Concrete LilyDex HTTP implementation with caching
│
├── services/
│   └── pokemon_service.dart           # Business logic, DioException → human-readable error mapping
│
├── viewmodels/
│   └── pokemon_viewmodel.dart         # ChangeNotifier VM: search state, debouncing, loading flags
│
├── screens/
│   └── pokemon_screen.dart            # Main (and only) screen, wires all widgets together
│
├── widgets/
│   ├── evolution_card.dart            # Evolution chain chip list
│   ├── info_card.dart                 # Generic surface card container
│   ├── move_card.dart                 # Fast / charged move row with metrics
│   ├── pokemon_header.dart            # Pokémon name, dex number, type chips
│   ├── pokemon_image_card.dart        # Hero-animated Pokémon artwork card
│   ├── search_suggestions.dart        # Scrollable suggestion dropdown list
│   ├── section_title.dart             # Reusable section heading
│   ├── stat_bar.dart                  # Animated linear progress stat bar
│   └── type_chip.dart                 # Colored type badge with emoji icon
│
└── utils/
    └── app_theme.dart                 # Material 3 light & dark ThemeData definitions
```

---

## Data Model

All models live in [`lib/models/pokemon.dart`](lib/models/pokemon.dart) and are deserialized from the LilyDex API JSON response.

| Class | Purpose |
|---|---|
| `Pokemon` | Root model — holds all fields for a single Pokémon entry |
| `PokemonNameSet` | Localized name container (English name field) |
| `PokemonTypeInfo` | Type identifier + localized name |
| `PokemonStats` | GO battle stats: `stamina`, `attack`, `defense` |
| `PokemonMove` | Move definition with type, power, energy, and combat data |
| `PokemonCombatMove` | PvP-specific stats for a move: `energy`, `power`, `turns` |
| `PokemonEvolution` | Evolution target with ID and Dex number |
| `PokemonAssets` | Asset URLs — currently the Pokémon artwork `image` URL |

---

## Screens & Widgets

### `PokemonScreen`

The single screen of the application. On mount it triggers `PokemonViewModel.loadPokemonNames()` to prefetch all released Pokémon names. It renders:

1. **Search Card** — search field, debounced suggestions, and the **Analyze** button.
2. **Loading Indicator** — centered `CircularProgressIndicator` during any async operation.
3. **Error Card** — displays a human-readable error message and a **Retry** button.
4. **Pokémon Details** — rendered only when a Pokémon is successfully loaded.

### Key Widgets

| Widget | File | Role |
|---|---|---|
| `PokemonImageCard` | `widgets/pokemon_image_card.dart` | Displays Pokémon artwork via `CachedNetworkImage` with Hero animation |
| `PokemonHeader` | `widgets/pokemon_header.dart` | Name, formatted Dex number (`#001`), and type chips |
| `StatBar` | `widgets/stat_bar.dart` | Animated stat bar with `TweenAnimationBuilder` (600 ms) |
| `MoveCard` | `widgets/move_card.dart` | Move row showing type chip, PWR, ENG, CP, TRN metrics; elite star badge |
| `EvolutionCard` | `widgets/evolution_card.dart` | Horizontal evolution chip chain with arrow separators |
| `TypeChip` | `widgets/type_chip.dart` | Colored pill badge for all 18 Pokémon types |
| `SearchSuggestions` | `widgets/search_suggestions.dart` | Scrollable list (max 240 px) of up to 10 name suggestions |

---

## Tech Stack

| Dependency | Version | Purpose |
|---|---|---|
| Flutter | ≥ 3.x | Cross-platform UI framework |
| Dart | `>=3.3.0 <4.0.0` | Language runtime |
| [`provider`](https://pub.dev/packages/provider) | `^6.1.5+1` | Dependency injection and state management |
| [`dio`](https://pub.dev/packages/dio) | `^5.9.0` | HTTP client with timeout and error handling |
| [`cached_network_image`](https://pub.dev/packages/cached_network_image) | `^3.4.1` | Efficient image loading and disk caching |
| [`google_fonts`](https://pub.dev/packages/google_fonts) | `^6.3.0` | Inter font family for all text |
| [`flutter_animate`](https://pub.dev/packages/flutter_animate) | `^4.5.2` | Declarative fade/slide entrance animations |
| [`gap`](https://pub.dev/packages/gap) | `^3.0.1` | Concise spacing widget |
| [`nested`](https://pub.dev/packages/nested) | `^1.0.0` | Multi-provider nesting support |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | `^1.0.8` | iOS-style icon set |

**Dev dependencies:** `flutter_test`, `flutter_lints ^4.0.0`

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **3.x** or later (stable channel)
- Dart SDK **≥ 3.3.0**
- A connected device or emulator (Android, iOS, Web, or Desktop)

Verify your environment:

```bash
flutter doctor
```

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/nayannit/PokemonGo-pokeDex.git
cd PokemonGo-pokeDex

# 2. Install dependencies
flutter pub get
```

### Running the App

```bash
# Run on a connected device / emulator
flutter run

# Run on a specific platform
flutter run -d chrome          # Web
flutter run -d android         # Android emulator or device
flutter run -d ios             # iOS simulator or device (macOS only)

# Build a release APK
flutter build apk --release

# Build for web
flutter build web --release
```

---

## API Reference

The app consumes the **LilyDex API** — a static JSON dataset hosted on GitHub Pages.

| Endpoint | Method | Description |
|---|---|---|
| `/pokedex.json` | `GET` | Full Pokédex — array of all Pokémon objects |

**Base URL:** `https://mknepprath.github.io/lily-dex-api`

**Timeouts:** 15 s connect / 15 s receive (configured in [`LilyDexPokemonRepository`](lib/repositories/lily_dex_pokemon_repository.dart))

**Caching:** The full Pokédex payload is fetched once per app session and stored in memory (`_pokemonCache`). Subsequent lookups are served from cache without additional network requests.

**Error mapping** in [`PokemonService`](lib/services/pokemon_service.dart):

| `DioExceptionType` | User Message |
|---|---|
| `connectionTimeout / sendTimeout / receiveTimeout` | "The request timed out. Please try again." |
| `connectionError` | "No internet connection. Please check your network and try again." |
| `badResponse` 404 | "Pokemon not found." |
| `badResponse` 500 | "The server encountered an error. Please try again later." |

---

## State Management

State is managed with the **Provider** package using a `ChangeNotifier` ViewModel pattern.

**`PokemonViewModel`** ([`lib/viewmodels/pokemon_viewmodel.dart`](lib/viewmodels/pokemon_viewmodel.dart)) exposes:

| Property / Method | Type | Description |
|---|---|---|
| `suggestions` | `List<String>` | Live filtered name suggestions (max 10) |
| `selectedPokemon` | `Pokemon?` | Currently loaded Pokémon data |
| `isLoading` | `bool` | True while any async operation is in flight |
| `hasError` | `bool` | True when `errorMessage` is non-null |
| `errorMessage` | `String?` | User-facing error description |
| `canSearch` | `bool` | True when search input matches a valid Pokémon name |
| `loadPokemonNames()` | `Future<void>` | Fetches and caches all released Pokémon names |
| `onSearchChanged(value)` | `void` | Updates query, applies 300 ms debounce for suggestions |
| `selectSuggestion(name)` | `void` | Fills search field from suggestion tap |
| `fetchPokemonDetails()` | `Future<void>` | Loads full data for the selected Pokémon |
| `retry()` | `Future<void>` | Re-runs the last failed operation |

---

## Theming

Theming is centralized in [`lib/utils/app_theme.dart`](lib/utils/app_theme.dart).

- **Design system:** Material 3 (`useMaterial3: true`)
- **Font:** Inter via `google_fonts`
- **Seed color — Light:** `#6C63FF` (indigo-purple)
- **Seed color — Dark:** `#8B80FF` (lighter indigo)
- **Theme mode:** `ThemeMode.system` — follows the OS preference automatically

Both themes define custom `AppBarTheme`, `CardTheme`, and `InputDecorationTheme` for a consistent, rounded UI language.

---

## Testing

Widget tests are located in [`test/widget_test.dart`](test/widget_test.dart).

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

The baseline test verifies the home screen renders the app title, search field, and Analyze button correctly.

---

## Platform Support

| Platform | Status |
|---|---|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Web | ✅ Supported |
| Linux | ✅ Supported |
| macOS | ✅ Supported |
| Windows | ✅ Supported |

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes following conventional commit style
4. Push to your fork and open a Pull Request against `main`

Please ensure `flutter analyze` and `flutter test` pass before submitting.

---

## License

This project is open source. See the repository at [github.com/nayannit/PokemonGo-pokeDex](https://github.com/nayannit/PokemonGo-pokeDex) for details.
