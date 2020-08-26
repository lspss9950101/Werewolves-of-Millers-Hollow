import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:werewolf/Character.dart';
import 'package:werewolf/GameCore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui';
import 'Rules.dart';
import 'Utils.dart';

Rules ruleSettings;

void main() {
  ruleSettings = Rules();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Werewolf of Miller\'s Hollow',
      theme: Decorations.THEME,
      /*ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),*/
      home: HallPage(),
    );
  }
}

class HallPage extends StatefulWidget {
  HallPage({Key key}) : super(key: key);

  @override
  _HallPageState createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        body: StripeBackground(
            child: Builder(
                builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: InkWellRow(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '開始',
                                  style: Theme.of(buildContext).textTheme.subtitle1,
                                ),
                                Transform.rotate(
                                  angle: pi * 0.5,
                                  child: Icon(Icons.expand_less),
                                ),
                              ],
                              onTap: () async {
                                String validation = ruleSettings.validate();
                                if (validation != 'OK') {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(validation),
                                  ));
                                  return;
                                }
                                var result = await Utils.popDialogFromBottom(
                                    context,
                                    (_, __) => [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                                                child: FlatButton(
                                                  color: Colors.green,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                                    child: Text(
                                                      '開始',
                                                      style: Theme.of(buildContext).textTheme.subtitle1,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          for (Map summary in ruleSettings.summary())
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    summary['Title'] + ' :',
                                                    style: Theme.of(context).textTheme.bodyText1,
                                                  ),
                                                  (summary['Summary'] is int
                                                      ? Text(
                                                          summary['Summary'].toString() + '人',
                                                          style: Theme.of(context).textTheme.bodyText2,
                                                        )
                                                      : Text(
                                                          summary['Summary'] ? '開啟' : '關閉',
                                                          style: Theme.of(context).textTheme.bodyText2,
                                                        )),
                                                ],
                                              ),
                                            ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '新月事件 :',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                                Text(
                                                  ruleSettings[RuleTitle.NEW_MOON]['Data']['Value'] ? '開啟' : '關閉',
                                                  style: Theme.of(context).textTheme.bodyText2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (ruleSettings[RuleTitle.NEW_MOON]['Data']['Value'])
                                            for (int i in ruleSettings.newMoonSortedIndex())
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(12, 8, 16, 16),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            NewMoon.RuleList[i]['Title'],
                                                            style: Theme.of(context).textTheme.subtitle1,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                                            child: Column(
                                                              children: [
                                                                for (String str in NewMoon.RuleList[i]['Description'].split('\n'))
                                                                  TextWithBulletPoint(
                                                                    ' •  ',
                                                                    str,
                                                                    style: Theme.of(context).textTheme.bodyText2,
                                                                    bulletPointStyle: Theme.of(context).textTheme.bodyText2,
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                                      child: Text(
                                                        'x' + ruleSettings.newMoonRules[i].toString(),
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                        ]);
                                if (result == true) Navigator.push(context, ScaleRoute(page: GamePage()));
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: SettingPanel(),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: InkWellRow(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '規則說明',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Transform.rotate(
                                angle: pi * 0.5,
                                child: Icon(Icons.expand_less),
                              ),
                            ],
                            onTap: () {
                              setState(() {
                                Navigator.of(context).push(ScaleRoute(page: DescriptionPage()));
                              });
                            },
                          ),
                        )
                      ],
                    ))));
  }
}

class SettingPanel extends StatefulWidget {
  SettingPanel({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPanelState();
}

class _SettingPanelState extends State<SettingPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        InkWellRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          onTap: () async {
            await Utils.popDialogFromBottom(
                context,
                (callback, _) => [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 48),
                            child: Container(
                              width: 60,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white60,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //for (RuleTitle ruleTitle in RuleTitle.values) RuleSettingRow(ruleTitle, callback: callback),
                      RuleSettingRow(RuleTitle.PLAYER_NUMBER),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(24, 0, 16, 0),
                              child: OutlineButton(
                                highlightedBorderColor: Theme.of(context).accentColor,
                                onPressed: () {
                                  callback(() {
                                    ruleSettings.byDefault();
                                  });
                                },
                                child: Text(
                                  '推薦設定',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      RuleSettingRow(RuleTitle.WEREWOLF_NUMBER),
                      for (int i = 2; i < RuleTitle.values.length - 1; i += 3)
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: ToggleButtons(
                                isSelected: [for (int j = 0; j < 3; j++) ruleSettings[RuleTitle.values[i + j]]['Data']['Value']],
                                onPressed: (index) {
                                  setState(() {
                                    callback(() {
                                      ruleSettings[RuleTitle.values[i + index]] = !ruleSettings[RuleTitle.values[i + index]]['Data']['Value'];
                                    });
                                  });
                                },
                                children: [
                                  for (int j = 0; j < 3; j++)
                                    Container(
                                      width: 100,
                                      child: Text(
                                        ruleSettings[RuleTitle.values[i + j]]['Data']['DisplayName'],
                                        style: Theme.of(context).textTheme.bodyText2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ExpandedSection(
                        isExpanded: ruleSettings[RuleTitle.NEW_MOON]['Data']['Value'],
                        child: RuleSettingNewMoon(),
                      )
                    ]);
          },
          children: [
            Text(
              '設定',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Transform.rotate(
              angle: pi * 0.5,
              child: Icon(Icons.expand_less),
            ),
          ],
        ),
      ],
    );
  }
}

class RuleSettingRow extends StatefulWidget {
  final RuleTitle ruleTitle;
  final bool hasBorder;
  final Function(Function()) callback;
  RuleSettingRow(this.ruleTitle, {Key key, this.callback, this.hasBorder = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RuleSettingRowState();
}

class _RuleSettingRowState extends State<RuleSettingRow> {
  @override
  Widget build(BuildContext context) {
    Map data = ruleSettings[widget.ruleTitle];
    return Container(
        decoration: (widget.hasBorder ? Decorations.BORDER_UP_BOTTOM() : null),
        child: Padding(
            padding: EdgeInsets.fromLTRB(32, 4, 8, 8),
            child: (data['DataType'] == DataType.BOOL
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                        Text(
                          data['Data']['DisplayName'],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Switch(
                          value: data['Data']['Value'],
                          onChanged: (value) {
                            setState(() {
                              if (widget.callback != null)
                                widget.callback(() {
                                  ruleSettings[widget.ruleTitle] = value;
                                });
                              else
                                ruleSettings[widget.ruleTitle] = value;
                            });
                          },
                        )
                      ])
                : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      data['Data']['DisplayName'],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                        child: Slider(
                          value: data['Data']['Value'].toDouble(),
                          min: data['Data']['RangeLow'].toDouble(),
                          max: data['Data']['RangeUp'].toDouble(),
                          divisions: data['Data']['RangeUp'] - data['Data']['RangeLow'],
                          label: data['Data']['Value'].toString(),
                          onChanged: (value) {
                            setState(() {
                              ruleSettings[widget.ruleTitle] = value.floor();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: Container(
                          width: 30,
                          child: Text(
                            data['Data']['Value'].toString(),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ])
                  ]))));
  }
}

class RuleSettingNewMoon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RuleSettingNewMoonState();
}

class _RuleSettingNewMoonState extends State<RuleSettingNewMoon> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < ruleSettings.newMoonRules.length; i++)
          Container(
            decoration: Decorations.BORDER_UP_BOTTOM(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          NewMoon.RuleList[i]['Title'],
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Text(
                            NewMoon.RuleList[i]['Description'],
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.expand_less),
                          onPressed: () {
                            setState(() {
                              ruleSettings.newMoonRules[i]++;
                            });
                          }),
                      Text(ruleSettings.newMoonRules[i].toString()),
                      IconButton(
                          icon: Icon(Icons.expand_more),
                          onPressed: () {
                            if (ruleSettings.newMoonRules[i] == 0) return;
                            setState(() {
                              ruleSettings.newMoonRules[i]--;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class DescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: InkWellRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '角色',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Transform.rotate(
                      angle: pi * 0.5,
                      child: Icon(Icons.expand_less),
                    ),
                  ],
                  onTap: () {
                    Navigator.of(context).push(ScaleRoute(page: DescriptionCardPage(' •  ', getCharacterList())));
                  }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: InkWellRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '遊戲流程',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Transform.rotate(
                      angle: pi * 0.5,
                      child: Icon(Icons.expand_less),
                    ),
                  ],
                  onTap: () {
                    Navigator.of(context).push(ScaleRoute(page: DescriptionCardPage('', GameProcedure.ProcedureList)));
                  }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: InkWellRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '新月事件',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Transform.rotate(
                    angle: pi * 0.5,
                    child: Icon(Icons.expand_less),
                  ),
                ],
                onTap: () {
                  Navigator.of(context).push(ScaleRoute(page: DescriptionCardPage(' •  ', NewMoon.RuleList)));
                },
              ),
            )
          ],
        ));
  }
}

class DescriptionCardPage extends StatelessWidget {
  final List<Map> details;
  final String bulletPoint;

  DescriptionCardPage(this.bulletPoint, this.details, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: ListView(
        children: details
            .map(
              (detail) => Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4, 8, 4, 16),
                    child: ListTile(
                      leading: detail['Image'] != null
                          ? Container(
                              height: double.infinity,
                              child: FlutterLogo(
                                size: 100,
                              ))
                          : null,
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                        child: Text(
                          detail['Title'],
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Column(
                            children: <Widget>[
                              for (String str in detail['Description'].split('\n'))
                                TextWithBulletPoint(
                                  bulletPoint,
                                  str,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  bulletPointStyle: Theme.of(context).textTheme.bodyText2,
                                )
                            ],
                          ) /*Text(
                          detail['Description'],
                          style: Theme.of(context).textTheme.bodyText2,
                        ),*/
                          ),
                      isThreeLine: true,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameCore _gameCore;
  Character _character;
  int drawnCardNumber;
  bool drawComplete = false;
  int ruleIdx = 0;
  List<Character> drawnCharacter = List();
  bool isFirstNight;

  @override
  void initState() {
    super.initState();
    drawnCharacter = List();
    isFirstNight = true;
    _gameCore = GameCore()..init(ruleSettings);
    _character = _gameCore.draw();
    drawnCardNumber = 1;
    drawnCharacter.add(_character);

    ruleIdx = 0;

    drawComplete = false;
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: !drawComplete
          ? CharacterDrawPanel(
              _character,
              isLast: drawnCardNumber >= ruleSettings.get(RuleTitle.PLAYER_NUMBER),
              callback: () {
                setState(() {
                  drawnCardNumber++;
                  if (drawnCardNumber <= ruleSettings.get(RuleTitle.PLAYER_NUMBER)) {
                    _character = _gameCore.draw();
                    drawnCharacter.add(_character);
                  } else
                    drawComplete = true;
                });
              },
            )
          : GameProcedurePanel(
              GameProcedure.getProcedureList(ruleSettings, isFirstNight)[ruleIdx],
              drawnCharacter,
              _gameCore.remain(),
              callback: (type) {
                switch (type) {
                  case 0:
                    setState(() {
                      ruleIdx++;
                      if (ruleIdx >= GameProcedure.getProcedureList(ruleSettings, isFirstNight).length) {
                        isFirstNight = false;
                        ruleIdx = 0;
                      }
                    });
                    break;
                  case 1:
                    Navigator.of(buildContext).push(ScaleRoute(page: NewMoonDisplayPage(_gameCore.drawNewMoon())));
                    break;
                  case 2:
                    Navigator.of(buildContext).push(ScaleRoute(page: DescriptionCardPage(' •  ', _gameCore.drawnNewMoon)));
                    break;
                }
              },
            ),
    );
  }
}

class CharacterDrawPanel extends StatefulWidget {
  final Function() callback;
  final Character _character;
  final bool isLast;
  CharacterDrawPanel(this._character, {this.isLast = false, this.callback});

  @override
  _CharacterDrawPanelState createState() => _CharacterDrawPanelState();
}

class _CharacterDrawPanelState extends State<CharacterDrawPanel> with TickerProviderStateMixin {
  bool isRevealed;
  bool canChange;

  AnimationController _flipAnimationController;
  AnimationController _scaleTranslateAnimationController;
  AnimationController _endingOpacityAnimationController;

  _CharacterDrawPanelState() {
    _flipAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1300), reverseDuration: Duration(milliseconds: 300));
    _scaleTranslateAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _endingOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 750));
  }

  @override
  void initState() {
    super.initState();
    isRevealed = false;
    canChange = false;
  }

  @override
  void didUpdateWidget(CharacterDrawPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    isRevealed = false;
    canChange = false;
  }

  @override
  void dispose() {
    super.dispose();
    _flipAnimationController.dispose();
    _scaleTranslateAnimationController.dispose();
    _endingOpacityAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size cardSize = Size(350, 350);
    Container cardBack = Container(
      width: cardSize.width,
      height: cardSize.height,
      decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.all(Radius.circular(15))),
    );
    Container cardFront = Container(
      width: cardSize.width,
      height: cardSize.height,
      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(15))),
    );

    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, cardSize.height * 1.05, 0, 0),
          child: OpacityAnimation(
            _scaleTranslateAnimationController,
            callback: (status) {
              if (status == AnimationStatus.dismissed && canChange) {
                if (widget.isLast) {
                  _endingOpacityAnimationController.forward();
                  canChange = false;
                } else
                  widget.callback();
              }
              if (status == AnimationStatus.completed)
                setState(() {
                  canChange = true;
                });
            },
            beginOpacity: 0,
            endOpacity: 1,
            builder: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  getCharacterDisplayName(widget._character),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (String str in getCharacterDetail(widget._character).split('\n'))
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                          child: TextWithBulletPoint(
                            ' •  ',
                            str,
                            style: Theme.of(context).textTheme.bodyText2,
                            bulletPointStyle: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ScaleTranslateAnimation(
          _scaleTranslateAnimationController,
          beginPosition: Offset(MediaQuery.of(context).size.width / 2 - cardSize.width / 2, MediaQuery.of(context).size.height / 2 - cardSize.height / 2),
          endPosition: Offset(MediaQuery.of(context).size.width / 2 - cardSize.width / 2, MediaQuery.of(context).size.height / 2 - cardSize.height / 2 - 200),
          beginScale: 1,
          endScale: 0.7,
          child: OpacityAnimation(
            _endingOpacityAnimationController,
            beginOpacity: 1,
            endOpacity: 0,
            callback: (status) {
              if (status == AnimationStatus.completed) widget.callback();
            },
            builder: (_) => FlipAnimation(
              _flipAnimationController,
              enabledFlip: (!isRevealed || canChange),
              front: cardBack,
              back: cardFront,
              callback: (status) {
                if (status == AnimationStatus.completed) {
                  setState(() {
                    if (!isRevealed) {
                      isRevealed = true;
                      _scaleTranslateAnimationController.forward();
                    }
                  });
                }
                if (canChange) {
                  _scaleTranslateAnimationController.reverse();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class GameProcedurePanel extends StatefulWidget {
  final Map procedure;
  final List<Character> characters;
  final List<Character> remainCards;
  final Function(int) callback;
  GameProcedurePanel(this.procedure, this.characters, this.remainCards, {this.callback, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameProcedurePanelState();
}

class _GameProcedurePanelState extends State<GameProcedurePanel> with TickerProviderStateMixin {
  bool isTitleDisappeared = false;
  AnimationController _titleOpacityAnimationController;
  AnimationController _contextOpacityAnimationController;
  bool isBottomSheetExpanded;
  PanelController panelController = PanelController();

  _GameProcedurePanelState() {
    _titleOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    _contextOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    isBottomSheetExpanded = false;
    isTitleDisappeared = false;
    _titleOpacityAnimationController.forward();
  }

  @override
  void didUpdateWidget(GameProcedurePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    isTitleDisappeared = false;
    isBottomSheetExpanded = false;
    _titleOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    _contextOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _titleOpacityAnimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _titleOpacityAnimationController.dispose();
    _contextOpacityAnimationController.dispose();
    _titleOpacityAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget descriptionCard = Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
      width: 360,
      height: 480,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                widget.procedure['Title'],
                style: TextStyle(
                  inherit: false,
                  fontSize: 60,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                for (String str in widget.procedure['Description'].split('\n'))
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Text(
                      str,
                      style: TextStyle(
                        inherit: false,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget bottomSheet(scrollController) => Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
              color: Color.lerp(Colors.blueGrey.withAlpha(230), Colors.white70, 0.4),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 24, 0, 48),
                        child: Container(
                          width: 60,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 4, 4),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '角色分配',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      for (int i = 1; i <= widget.characters.length; i++)
                                        TapLink(
                                          route: ScaleRoute(page: TextDisplayPage(getCharacterDisplayName(widget.characters[i - 1]))),
                                          child: Text(
                                            (i >= 10 ? '$i. ' : '$i.   ') + getCharacterDisplayName(widget.characters[i - 1]),
                                            style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 4, 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '牌堆剩牌',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (widget.remainCards.length == 0)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '空',
                                              style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        )
                                      else
                                        for (Character character in widget.remainCards)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              TapLink(
                                                route: ScaleRoute(page: TextDisplayPage(getCharacterDisplayName(character))),
                                                child: Text(
                                                  getCharacterDisplayName(character),
                                                  style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ruleSettings.get(RuleTitle.NEW_MOON)
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '新月事件',
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(4),
                                                child: OutlineButton(
                                                  borderSide: BorderSide(color: Colors.black54),
                                                  highlightedBorderColor: Colors.black87,
                                                  onPressed: () {
                                                    widget.callback(1);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '抽取事件',
                                                        style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w700),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(4),
                                                child: OutlineButton(
                                                  borderSide: BorderSide(color: Colors.black54),
                                                  highlightedBorderColor: Colors.black87,
                                                  onPressed: () {
                                                    widget.callback(2);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '當前事件',
                                                        style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w700),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )))
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

    return Stack(
      children: <Widget>[
        !isTitleDisappeared
            ? OpacityAnimation(
                _titleOpacityAnimationController,
                beginOpacity: 0,
                endOpacity: 1,
                callback: (status) {
                  if (status == AnimationStatus.completed)
                    Future.delayed(Duration(milliseconds: 1000), () {
                      _titleOpacityAnimationController.reverse();
                    });
                  else if (status == AnimationStatus.dismissed)
                    setState(() {
                      isTitleDisappeared = true;
                      _contextOpacityAnimationController.forward();
                    });
                },
                builder: (_) => Center(
                  child: Text(
                    widget.procedure['Title'],
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              )
            : Center(
                child: OpacityAnimation(
                  _contextOpacityAnimationController,
                  beginOpacity: 0,
                  endOpacity: 1,
                  builder: (_) => Draggable(
                    axis: Axis.horizontal,
                    maxSimultaneousDrags: (panelController.isAttached ? panelController.isPanelOpen : true) ? 0 : 1,
                    childWhenDragging: Container(),
                    feedback: descriptionCard,
                    child: descriptionCard,
                    onDragEnd: (detail) {
                      if (detail.offset.dx.abs() > MediaQuery.of(context).size.width * 0.6) widget.callback?.call(0);
                    },
                  ),
                  callback: (status) => {},
                ),
              ),
        OpacityAnimation(
          _contextOpacityAnimationController,
          beginOpacity: 0,
          endOpacity: 1,
          builder: (_) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: isBottomSheetExpanded ? 5 : 0, sigmaY: isBottomSheetExpanded ? 5 : 0),
            child: SlidingUpPanel(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              minHeight: MediaQuery.of(context).size.height * 0.06,
              controller: panelController,
              renderPanelSheet: false,
              body: Container(),
              panelBuilder: bottomSheet,
              backdropTapClosesPanel: true,
              backdropEnabled: true,
              backdropOpacity: 0,
              onPanelSlide: (position) {
                setState(() {
                  isBottomSheetExpanded = true;
                });
              },
              onPanelClosed: () {
                setState(() {
                  isBottomSheetExpanded = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class NewMoonDisplayPage extends StatelessWidget {
  final Map detail;
  NewMoonDisplayPage(this.detail, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget descriptionCard = Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
      width: 360,
      height: 480,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                detail['Title'],
                style: TextStyle(
                  inherit: false,
                  fontSize: 60,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                for (String str in detail['Description'].split('\n'))
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: TextWithBulletPoint(
                      ' •  ',
                      str,
                      style: TextStyle(
                        inherit: false,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      body: Center(child: descriptionCard),
    );
  }
}
