class PokemonStats {
  final int hp;
  final int atk;
  final int def;
  final int satk;
  final int sdef;
  final int spd;

  PokemonStats(this.hp, this.atk, this.def, this.satk, this.sdef, this.spd);

  int statsSum() {
    return hp + atk + def + satk + sdef + spd;
  }

  PokemonStats.fromJson(Map<String, dynamic> json):
      hp = json["stats"][0]["base_stat"],
      atk = json["stats"][1]["base_stat"],
      def = json["stats"][2]["base_stat"],
      satk = json["stats"][3]["base_stat"],
      sdef = json["stats"][4]["base_stat"],
      spd = json["stats"][5]["base_stat"];
}