import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_go_pokedex/main.dart';

void main() {
  testWidgets('renders Pokemon GO PokeDex home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PokemonGoPokeDexApp());
    await tester.pump();

    expect(find.text('Pokemon GO PokeDex'), findsOneWidget);
    expect(find.text('Search Pokemon'), findsOneWidget);
    expect(find.text('Analyze'), findsOneWidget);
  });
}

