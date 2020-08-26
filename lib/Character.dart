enum Character {
  VILLAGER,
  PROPHET,
  WEREWOLF,
  WITCH,
  HUNTER,
  THIEF,
  CUPID,
  LITTLE_GIRL,
  SHERIFF,

  FOOL,
  ELDER,
  SCAPEGOAT,
  GUARD,
  POET,
}

String getCharacterDisplayName(Character character) {
  switch (character) {
    case Character.VILLAGER:
      return '村民';
    case Character.PROPHET:
      return '預言家';
    case Character.WEREWOLF:
      return '狼人';
    case Character.WITCH:
      return '女巫';
    case Character.HUNTER:
      return '獵人';
    case Character.THIEF:
      return '竊賊';
    case Character.CUPID:
      return '邱比特';
    case Character.LITTLE_GIRL:
      return '小女孩';
    case Character.SHERIFF:
      return '警長';

    case Character.FOOL:
      return '愚者';
    case Character.ELDER:
      return '長老';
    case Character.SCAPEGOAT:
      return '替罪羊';
    case Character.GUARD:
      return '守衛';
    case Character.POET:
      return '吹笛人';
    default:
      return '';
  }
}

String getCharacterDetail(Character character) {
  switch (character) {
    case Character.VILLAGER:
      return '村民沒有任何能力，卻要考慮諸多事情。\n村民會接受到難辨真假的訊息，需要從中判斷真偽並於投票時做出選擇。';
    case Character.PROPHET:
      return '每天晚上預言家可以窺探一名玩家的真實身分。\n預言家是遊戲中的靈魂人物，需要在幫助村民的同時，向狼人隱藏自己的身分。';
    case Character.WEREWOLF:
      return '每天晚上狼人會殘忍地殺害一位村民。\n在白天狼人要假扮村民隱藏身分，在擺脫嫌疑的同時混淆及誤導其他村民。';
    case Character.WITCH:
      return '神秘的女巫可以調配兩種藥劑，一種可以令一位被狼人殺害的玩家復活，另一種可以毒死一位玩家，每種藥劑只能使用一次，且可對自己使用。';
    case Character.HUNTER:
      return '當獵人被狼人殺害或被村民處決時，可以射殺一位玩家加以報復。';
    case Character.THIEF:
      return '遊戲開始時額外加入兩張村民，在第一個晚上，盜賊可以查看剩下兩張牌的內容，並決定是否要交換其中一張。如果兩張牌皆為狼人，則盜賊必須交換其中一張。';
    case Character.CUPID:
      return '在第一個晚上指定兩名玩家成為情侶，可選擇自己。\n如果情侶中有一名玩家不幸遇難，另一位玩家將當場殉情。\n表決時，情侶不能投票給另一半。\n若情侶之中有一名狼人一名村民，則該兩位玩家的遊戲目標變為"除掉所有其他玩家"。';
    case Character.LITTLE_GIRL:
      return '由於旺盛的好奇心，小女孩可以在夜晚偷看狼人行兇，但若被狼人發現則代替原受害者被立即殺害。';
    case Character.SHERIFF:
      return '在第一天白晝，所有玩家可以投票選出警長。\n警長投票時計為兩票，當警長遇難時，可以指定另一位玩家作為新任警長。';

    case Character.FOOL:
      return '如果村民在表決後發現疑犯是個愚者，愚者將被立即釋放，並在之後的遊戲中失去投票資格。';
    case Character.ELDER:
      return '由於老道的經驗，長老在第一次被狼人襲擊時不會死亡，但若長老被村民誤殺，作為教訓，所有村民將失去能力(若愚者已被揭露則出局)。\n女巫只能救活長老的一條命。';
    case Character.SCAPEGOAT:
      return '表決發生平票時，寧可錯殺的村民作為代替將處決替罪羊。\n為了不再發生如此的錯誤，被處決的替罪羊可以決定第二天誰可以參與表決。';
    case Character.GUARD:
      return '每天晚上守衛會在狼人之前被喚醒，並可以守護一位玩家，當晚該玩家不會被狼人殺害。\n守衛不可連續兩晚守護同一位玩家。\n守衛可以守護自己。\n守護對小女孩無效。';
    case Character.POET:
      return '每天晚上吹笛人可以迷惑兩位玩家，所有被迷惑的玩家將知道彼此，若所有存活的玩家皆被迷惑，則吹笛人獲勝。';
    default:
      return '';
  }
}

List<Map> getCharacterList() {
  return Character.values.map((c) => {'Title': getCharacterDisplayName(c), 'Description': getCharacterDetail(c), 'Image': true}).toList();
}
