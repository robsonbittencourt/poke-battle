
import 'dart:async';

import 'package:flutter/material.dart';

import 'Pokemon.dart';
import 'PokemonBattle.dart';
import 'PokemonList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poké Battle',
      theme: ThemeData(
          primaryColor: Colors.red
      ),
      home: PokeBattle(),
    );
  }
}

class PokeBattle extends StatefulWidget {
  @override
  _PokeBattleState createState() => _PokeBattleState();
}

class _PokeBattleState extends State<PokeBattle> {
  final _pokemonList = <Pokemon>[];
  var _selectedPokemon = <Pokemon>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poké Battle'),
      ),
      body: _listPokemon(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                      title: Text('Battle Result')
                  ),
                  body: Center(
                    child: FutureBuilder<Pokemon>(
                      future: PokemonBattle(_selectedPokemon[0], _selectedPokemon[1]).startBattle(),
                      builder: (context, snapshot){
                        if (snapshot.hasData) {
                          final result = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/${result.number}.png"),
                              SizedBox(height: 20),
                              Text("The winner Pokémon is ${result.name}", style: _biggerFont),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("An error occur");
                        }

                        return CircularProgressIndicator();
                      },
                    ),
                  )
              );
            }
        )
    ).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    _selectedPokemon = <Pokemon>[];
    setState(() {});
  }

  Widget _listPokemon() {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: _biggerFont,
      primary: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 100),
    );

    return Column(
      children: [
        Center(
          child: Container(
              color: Color.fromRGBO(224, 224, 224, 1),
              padding: EdgeInsets.all(10),
              child: Text(
                "Choose two Pokémon to Battle.\n The Pokémon with the highest stat sum will be the winner.",
                style: TextStyle(fontSize: 16), textAlign: TextAlign.center,
              )
          ),
        ),
        Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: 302,
                itemBuilder: (context, i) {
                  if (i.isOdd) return Divider();

                  final index = i ~/ 2;
                  if (index >= _pokemonList.length) {
                    _pokemonList.addAll(PokemonList().take(index + 1,index + 20));
                  }

                  return _buildRow(_pokemonList[index]);
                }
            )
        ),
        ElevatedButton(
            onPressed: _selectedPokemon.length == 2 ? _pushSaved : null,
            child: Text("Battle!"),
            style: buttonStyle
        )
      ],
    );
  }

  Widget _buildRow(Pokemon pokemon) {
    final alreadySaved = _selectedPokemon.contains(pokemon);

    return ListTile(
      leading: new Tab(icon: new Image.asset("assets/${pokemon.number}.png")),
      title: Text(
          pokemon.name,
          style: _biggerFont
      ),
      trailing: Icon(
          alreadySaved ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
          color: alreadySaved ? Colors.red : null
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _selectedPokemon.remove(pokemon);
          } else if (_selectedPokemon.length < 2) {
            _selectedPokemon.add(pokemon);
          }
        });
      },
    );
  }
}
