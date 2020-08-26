import 'dart:collection';

import 'package:flutter/foundation.dart';

enum DataType {
  RANGED_INT,
  BOOL
}

enum RuleTitle {
  PLAYER_NUMBER,
  WEREWOLF_NUMBER,
  SHERIFF,
  HUNTER,
  WITCH,
  THIEF,
  CUPID,
  LITTER_GIRL,
  FOOL,
  ELDER,
  SCAPEGOAT,
  GUARD,
  POET,
  NEW_MOON,
}

class Rules {
  static Map _constructRule(DataType dataType, String displayName, {int rangeLow, int rangeUp, dynamic defaultValue}) {
    if (dataType == DataType.RANGED_INT)
      return {
        'DataType': dataType,
        'Data': {
          'DisplayName': displayName,
          'RangeLow': rangeLow,
          'RangeUp': rangeUp,
          'Value': defaultValue,
        }
      };
    else if (dataType == DataType.BOOL)
      return {
        'DataType': dataType,
        'Data': {'DisplayName': displayName, 'Value': defaultValue}
      };
    else return {};
  }
  
  static int _getDefaultWerewolfNumber(int playerNumber) {
    if(playerNumber <= 11) return 2;
    else if(playerNumber <= 17) return 3;
    else return 4;
  } 

  Map rules;
  List<int> newMoonRules;
  
  Rules({int playerNumber=8, int werewolfNumber=2}){
    rules = {
      RuleTitle.PLAYER_NUMBER: _constructRule(DataType.RANGED_INT, '遊玩人數', rangeLow: 8, rangeUp: 18, defaultValue: playerNumber),
      RuleTitle.WEREWOLF_NUMBER: _constructRule(DataType.RANGED_INT, '狼人數量', rangeLow: 1, rangeUp: 9, defaultValue: werewolfNumber),
      RuleTitle.SHERIFF: _constructRule(DataType.BOOL, '警長', defaultValue: false),
      RuleTitle.HUNTER: _constructRule(DataType.BOOL, '獵人', defaultValue: false),
      RuleTitle.WITCH: _constructRule(DataType.BOOL, '女巫', defaultValue: false),
      RuleTitle.THIEF: _constructRule(DataType.BOOL, '盜賊', defaultValue: false),
      RuleTitle.CUPID: _constructRule(DataType.BOOL, '邱比特', defaultValue: false),
      RuleTitle.LITTER_GIRL: _constructRule(DataType.BOOL, '小女孩', defaultValue: false),
      RuleTitle.FOOL: _constructRule(DataType.BOOL, '愚者', defaultValue: false),
      RuleTitle.ELDER: _constructRule(DataType.BOOL, '長老', defaultValue: false),
      RuleTitle.SCAPEGOAT: _constructRule(DataType.BOOL, '替罪羊', defaultValue: false),
      RuleTitle.GUARD: _constructRule(DataType.BOOL, '守衛', defaultValue: false),
      RuleTitle.POET: _constructRule(DataType.BOOL, '吹笛人', defaultValue: false),
      RuleTitle.NEW_MOON: _constructRule(DataType.BOOL, '新月事件', defaultValue: false),
    };

    newMoonRules = List.filled(NewMoon.RuleList.length, 0);
  }

  void byDefault() {
    this[RuleTitle.WEREWOLF_NUMBER] = _getDefaultWerewolfNumber(rules[RuleTitle.PLAYER_NUMBER]['Data']['Value']);
    this[RuleTitle.SHERIFF] = false;
    this[RuleTitle.HUNTER] = false;
    this[RuleTitle.WITCH] = false;
    this[RuleTitle.THIEF] = false;
    this[RuleTitle.CUPID] = false;
    this[RuleTitle.LITTER_GIRL] = false;
    this[RuleTitle.FOOL] = false;
    this[RuleTitle.ELDER] = false;
    this[RuleTitle.SCAPEGOAT] = false;
    this[RuleTitle.GUARD] = false;
    this[RuleTitle.POET] = false;
    this[RuleTitle.NEW_MOON] = false;
    newMoonRules = List.filled(NewMoon.RuleList.length, 0);
  }

  String validate() {
    if(rules[RuleTitle.WEREWOLF_NUMBER]['Data']['Value'] * 2 > rules[RuleTitle.PLAYER_NUMBER]['Data']['Value']) return '狼人數量過多';
    int characterNumber = rules[RuleTitle.WEREWOLF_NUMBER]['Data']['Value'] + 1;
    for(RuleTitle ruleTitle in RuleTitle.values) {
      if (ruleTitle != RuleTitle.PLAYER_NUMBER && ruleTitle != RuleTitle.WEREWOLF_NUMBER && ruleTitle != RuleTitle.SHERIFF && ruleTitle != RuleTitle.NEW_MOON)
        if(rules[ruleTitle]['Data']['Value']) characterNumber++;
    }
    if(characterNumber > rules[RuleTitle.PLAYER_NUMBER]['Data']['Value']) return '角色數量大於玩家人數';

    return 'OK';
  }

  List<Map> summary() {
    List<Map> result = List()
      ..add({'Title': '預言家', 'Summary': 1})
      ..add({'Title': '狼人', 'Summary': rules[RuleTitle.WEREWOLF_NUMBER]['Data']['Value']});

    int characterNumber = rules[RuleTitle.WEREWOLF_NUMBER]['Data']['Value'] + 1;

    for(RuleTitle ruleTitle in RuleTitle.values){
      if(ruleTitle == RuleTitle.SHERIFF || ruleTitle == RuleTitle.NEW_MOON || ruleTitle == RuleTitle.PLAYER_NUMBER || ruleTitle == RuleTitle.WEREWOLF_NUMBER) continue;
      if(rules[ruleTitle]['Data']['Value']) {
        result.add({'Title': rules[ruleTitle]['Data']['DisplayName'], 'Summary': 1});
        characterNumber++;
      }
    }

    result.add({'Title': '普通村民', 'Summary': rules[RuleTitle.PLAYER_NUMBER]['Data']['Value'] - characterNumber});
    result.add({'Title': '警長', 'Summary': rules[RuleTitle.SHERIFF]['Data']['Value']});
    result.add({'Title': '玩家人數', 'Summary': rules[RuleTitle.PLAYER_NUMBER]['Data']['Value']});

    return result;
  }

  int get length => rules.length;

  Map operator [] (RuleTitle ruleTitle) {
    return rules[ruleTitle];
  }

  void operator []= (RuleTitle ruleTitle, dynamic value) {
    rules[ruleTitle]['Data']['Value'] = value;
  }

  dynamic get(RuleTitle ruleTitle) => rules[ruleTitle]['Data']['Value'];

  List<int> newMoonSortedIndex() {
    List<int> result = List.generate(NewMoon.RuleList.length, (index) => index);
    result.sort((a, b) => newMoonRules[b] - newMoonRules[a]);
    return result;
  }
}

class NewMoon {
  static _constructNewMoonRule(String displayName, String description) => {'Title': displayName, 'Description': description, 'Image': null};

  static List<Map> RuleList = List.of([
    _constructNewMoonRule('強烈的懷疑', '每個村民得到兩票，可以用來指定2個最好的朋友。\n當主持人給出信號後，所有人立即用兩隻手指定玩家進行表決。\n沒有被指定的玩家將被當場處決。'),
    _constructNewMoonRule('奇蹟', '實際上，最近一個被狼人殺害的玩家並沒有真的死去，只是受到狼人驚嚇後昏厥，他恢復了知覺並立即返回遊戲，不過喪失了特殊能力。'),
    _constructNewMoonRule('森林採集', '所有的女性玩家進入森林採集女巫需要的草藥，她們將在日落時返回。她們既不會參與討論，也不能投票表決。\n女巫將在傍晚前獲得一瓶額外的藥劑。'),
    _constructNewMoonRule('虔誠的菲利浦', '為了紀念偉大的菲利浦，村民決定選舉出一位真正有魅力的領袖。\n若村莊內已經有一位警長，則他將因為自己的無能被解雇。'),
    _constructNewMoonRule('鬼怪', '主持人讓下一個被狼人指定的玩家睜眼，他立即被轉化為狼人，並指定一位原本的狼人殺害。'),
    _constructNewMoonRule('雙面間諜', '在夜晚時，第一個被殺害的玩家指定一位非狼人玩家成為狼人的祕密盟友，主持人讓其睜眼，並指出所有狼人的位置。\n狼人的秘密盟友依然是個村民，但他可以分享狼人的獲勝。'),
    _constructNewMoonRule('不滿', '由於對失敗的表決結果感到失望，村民們無法克制追求正義的慾望。\n如果下一個被處決的玩家不是狼人，村民將開啟第二輪投票。\n由於焦慮的情緒，第二輪投票不經過討論。'),
    _constructNewMoonRule('禮貌', '所有的村民將變得有禮，禁止打斷他人發言。\n主持人將安排發言的順序，任何違反規則的人將失去該回合的投票權。'),
    _constructNewMoonRule('愚人節', '下列角色將交換能力:\n女巫和預言家\n獵人和小女孩\n守衛和長老\n情侶將分手，並於每次投票時指定對方。'),
    _constructNewMoonRule('儲備', '狼人將吃剩的遇害者遺體埋葬。\n自此之後，被狼人殺害的遇害者將不會公布身分。'),
    _constructNewMoonRule('逆火', '下一個夜晚，若狼人指定了一位普通的村民，該村民將被轉化為狼人。\n否則受害者將不會遇害，取而代之他將反擊左邊的第一個狼人，並將其殺害。'),
    _constructNewMoonRule('洪水', '一場洪水將玩家分隔兩地，女性玩家聚集在教堂中，而男性玩家聚集在酒吧。\n當天不進行表決。\n下一個夜晚，狼人必須在他們藏身的地方行兇。'),
    _constructNewMoonRule('劊子手', '為了不弄髒雙手，村民們選擇一位劊子手負責處決。\n接下來，只有劊子手會知道被處決者的身分。\n若劊子手死亡，新的劊子手將被選出。'),
    _constructNewMoonRule('夢遊', '預言家成為了一位夢遊者。\n接下來，主持人將大聲宣布被揭示的身分。'),
    _constructNewMoonRule('狂熱', '由於對卓越的表決結果感到滿意，村民們無法克制追求正義的慾望。\n如果下一個被處決的玩家是狼人，村民將開啟第二輪投票。\n由於欣喜若狂，第二輪投票不經過討論。'),
    _constructNewMoonRule('打獵', '所有的男性玩家進入森林打獵，在黎明前不會回來。他們既不會參與討論，也不能投票表決。\n他們不會被指定投票，無法作為狼人行兇，也不會被狼人殺害。'),
    _constructNewMoonRule('夢魘', '一位妄想成為狼人的殺人狂出現在村民的夢中。\n下一次表決時，不經過討論，並且從最近被害者的左邊開始輪流指定一個玩家，被指定最多次的玩家將被處決。'),
    _constructNewMoonRule('靈媒', '第一位被狼人殺害的玩家被招魂回來，最近被害者的左邊一位玩家成為靈媒。\n靈媒可以問靈魂一個是非題，靈魂將如實回答。'),
    _constructNewMoonRule('滿月升起', '接下來的夜晚，狼人變成預言家，他們將依次醒來揭示一位玩家的身分。獵人，女巫和預言家將同時醒來並殺害一位玩家。'),
  ]);
}

enum Procedure {
 NIGHT,
 THIEF,
 CUPID,
 LOVER,
 GUARD,
 PROPHET,
 WEREWOLF,
 WITCH,
 POET,
 LURED,
 DAY,
 NEW_MOON,
 ELECTION,
}

class GameProcedure {
  static _constructGameProcedure(String displayName, String description, bool onlyOnce, Procedure procedureId) => {'Title': displayName, 'Description': description, 'Image': null, 'OnlyOnce': onlyOnce, 'Id': procedureId};
  static List<Map> ProcedureList = List.of([
    _constructGameProcedure('夜晚降臨', '"黑夜降臨，所有人闔上雙眼"\n所有玩家闔上眼睛。', false, Procedure.NIGHT),
    _constructGameProcedure('盜賊', '"盜賊睜眼"\n盜賊查看剩餘角色卡，決定是否竊取身分。\n"盜賊闔眼"', true, Procedure.THIEF),
    _constructGameProcedure('邱比特', '"邱比特睜眼"\n邱比特選擇兩位玩家成為情侶，可選自己。\n主持人告知情侶。\n"邱比特闔眼"', true, Procedure.CUPID),
    _constructGameProcedure('情侶', '"情侶睜眼"\n"情侶闔眼"', true, Procedure.LOVER),
    _constructGameProcedure('守衛', '"守衛睜眼"\n守衛指定一位玩家，該玩家當晚不會被狼人殺害。\n不可連續兩晚指定同一人，可指定自己。\n小女孩不受保護。\n"守衛闔眼"', false, Procedure.GUARD),
    _constructGameProcedure('預言家', '"預言家睜眼"\n預言家指定一位玩家，主持人告知其身分。\n"預言家闔眼"', false, Procedure.PROPHET),
    _constructGameProcedure('狼人/小女孩', '"狼人睜眼"\n狼人指定一位玩家殺害。(可不殺)\n"狼人闔眼"', false, Procedure.WEREWOLF),
    _constructGameProcedure('女巫', '"女巫睜眼"\n主持人告知受害者位置，女巫決定是否使用魔藥。\n姆指向上表示救人\n拇指向下表示殺人，並指向一位玩家\n"女巫闔眼"', false, Procedure.WITCH),
    _constructGameProcedure('吹笛人', '"吹笛人睜眼"\n吹笛人迷惑兩位玩家。\n主持人示意兩位玩家已被迷惑。\n"吹笛人闔眼"', false, Procedure.POET),
    _constructGameProcedure('被迷惑之人', '"被迷惑的人睜眼"\n若所有活著的玩家皆被迷惑，吹笛人獲勝。\n"被迷惑的人闔眼"', false, Procedure.LURED),
    _constructGameProcedure('白晝到來', '"白晝到來，所有人睜開雙眼"\n主持人指出遇害者。\n若是第一天或警長遇害，選出新任警長。\n遇害者公布身分。\n若獵人遇害，射殺一位玩家報復。除被女巫毒殺。\n若情侶之一遇害，另一人殉情。', false, Procedure.DAY),
    _constructGameProcedure('新月事件', '主持人抽出新月事件。', false, Procedure.NEW_MOON),
    _constructGameProcedure('討論與表決', '討論與表決', false, Procedure.ELECTION),
  ]);

  static List<Map> getProcedureList(Rules rules, bool isFirstNight) {
    List result = ProcedureList;
    if(!rules.get(RuleTitle.WITCH)) result = result.where((value) => value['Title'] != '女巫').toList();
    if(!rules.get(RuleTitle.THIEF)) result = result.where((value) => value['Title'] != '盜賊').toList();
    if(!rules.get(RuleTitle.CUPID)) result = result.where((value) => value['Title'] != '邱比特' && value['Title'] != '情侶').toList();
    if(!rules.get(RuleTitle.POET)) result = result.where((value) => value['Title'] != '吹笛人' && value['Title'] != '被迷惑之人').toList();
    if(!rules.get(RuleTitle.GUARD)) result = result.where((value) => value['Title'] != '守衛').toList();
    if(!rules.get(RuleTitle.NEW_MOON)) result = result.where((value) => value['Title'] != '新月事件').toList();

    if(isFirstNight) return result;
    return result.where((value) => !value['OnlyOnce']).toList();
  }
}
