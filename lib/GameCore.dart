import 'dart:math';

import 'package:werewolf/Character.dart';
import 'package:werewolf/Rules.dart';

enum GameStage {
  DRAW,
  MAIN,
}

class GameCore {
  List<Character> _cardPool;
  List<Character> drawnCharacter;
  List<Map> _newMoonPool;
  List<Map> drawnNewMoon;

  void init(Rules rules) {
    _cardPool = List();
    _newMoonPool = List();
    drawnNewMoon = List();
    drawnCharacter = List();

    _cardPool.add(Character.PROPHET);
    _cardPool.addAll(List.filled(rules.get(RuleTitle.WEREWOLF_NUMBER), Character.WEREWOLF));
    int characterNumber = rules.get(RuleTitle.WEREWOLF_NUMBER) + 1;

    if (rules.get(RuleTitle.CUPID)) {
      _cardPool.add(Character.CUPID);
      characterNumber++;
    }
    if (rules.get(RuleTitle.WITCH)) {
      _cardPool.add(Character.WITCH);
      characterNumber++;
    }
    if (rules.get(RuleTitle.HUNTER)) {
      _cardPool.add(Character.HUNTER);
      characterNumber++;
    }
    if (rules.get(RuleTitle.POET)) {
      _cardPool.add(Character.POET);
      characterNumber++;
    }
    if (rules.get(RuleTitle.GUARD)) {
      _cardPool.add(Character.GUARD);
      characterNumber++;
    }
    if (rules.get(RuleTitle.SCAPEGOAT)) {
      _cardPool.add(Character.SCAPEGOAT);
      characterNumber++;
    }
    if (rules.get(RuleTitle.ELDER)) {
      _cardPool.add(Character.ELDER);
      characterNumber++;
    }
    if (rules.get(RuleTitle.FOOL)) {
      _cardPool.add(Character.FOOL);
      characterNumber++;
    }
    if (rules.get(RuleTitle.LITTER_GIRL)) {
      _cardPool.add(Character.LITTLE_GIRL);
      characterNumber++;
    }

    if (rules.get(RuleTitle.THIEF)) {
      _cardPool.add(Character.THIEF);
      _cardPool.addAll(List.filled(2, Character.VILLAGER));
      characterNumber++;
    }

    _cardPool.addAll(List.filled(rules.get(RuleTitle.PLAYER_NUMBER) - characterNumber, Character.VILLAGER));

    print(_cardPool);

    for(int i = 0; i < NewMoon.RuleList.length; i++)
      _newMoonPool.addAll(List.filled(rules.newMoonRules[i], NewMoon.RuleList[i]));
  }

  Character draw() {
    int index = Random().nextInt(_cardPool.length);
    Character character = _cardPool[index];
    _cardPool.removeAt(index);
    drawnCharacter.add(character);
    print(character);
    return character;
  }

  List<Character> remain() {
    return _cardPool;
  }

  Map drawNewMoon() {
    Map result;

    if(_newMoonPool.length > 0) {
      int index = Random().nextInt(_newMoonPool.length);
      result = _newMoonPool[index];
      _newMoonPool.removeAt(index);
      drawnNewMoon.insert(0, result);
    }else result = {
      'Title': '無新月事件',
      'Description': '新月事件已抽完'
    };
      print(result);
      return result;
  }
}
