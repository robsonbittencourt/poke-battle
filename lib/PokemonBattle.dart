import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Pokemon.dart';
import 'PokemonStats.dart';

class PokemonBattle {
  final Pokemon firstPokemon;
  final Pokemon secondPokemon;

  PokemonBattle(this.firstPokemon, this.secondPokemon);

  Future<Pokemon> startBattle() async {
    final firstPokemonStats = await getPokemonStats(firstPokemon.number);
    final secondPokemonStats = await getPokemonStats(secondPokemon.number);

    if (firstPokemonStats.statsSum() >= secondPokemonStats.statsSum()) {
      return firstPokemon;
    } else {
      return secondPokemon;
    }
  }

  Future<PokemonStats> getPokemonStats(int pokemonNumber) async {
    final uri = Uri.parse("https://pokeapi.co/api/v2/pokemon/$pokemonNumber");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return PokemonStats.fromJson(json);
    } else {
      throw Exception();
    }
  }

}