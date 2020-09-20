import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:star/home/game_timeprofile.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/util/global.dart';
import 'package:star/util/jsonconver.dart';
import 'package:star/util/pubRequest.dart';
import 'package:star/widgets/waveScrollBehavior.dart';
import 'package:chat_bubble/chat_bubble.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provide/provide.dart';
import 'package:sa_anicoto/sa_anicoto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/provider/game_message_provier.dart';
import 'package:star/provider/game_openpokers_provider.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/custome_divider.dart';
import 'package:star/widgets/some_widgets.dart';
import 'package:flutter_radio_slider/flutter_radio_slider.dart';

Widget popMenuItemCSS(
    String value, double w, double h, String img, String title,
    {Color color = Colors.white}) {
  return PopupMenuItem<String>(
      enabled: color != Colors.white ? false : true,
      value: value,
      child: Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 18.0, 0.0),
            child: Image.asset(imgpath + "game/$img.png",
                width: ssSetWidth(w), height: ssSetWidth(h))),
        setTextWidget(title, 16, false, color)
      ]));
}

Widget showCustomPopMenu(bool userSited, void Function(String) func) {
  return PopupMenuButton(
      color: Color(0xff111119),
      onSelected: (String value) {
        func(value);
      },
      child: Image.asset(
        imgpath + "game/down_arrow.png",
        width: ssSetWidth(37),
        height: ssSetWidth(37),
      ),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
            popMenuItemCSS('1', 20, 19.5, 'lt_0', '牌局设置'),
            CustomDivider(1.0),
            popMenuItemCSS('2', 19.5, 20, 'lt_1', '牌型'),
            CustomDivider(1.0),
            popMenuItemCSS('3', 17, 19, 'lt_2', '保险说明'),
            CustomDivider(1.0),
            popMenuItemCSS('4', 16.5, 22, userSited ? 'lt_3' : 'lt_3_c', '站起',
                color: userSited ? Colors.white : Color(0xff999999)),
            CustomDivider(1.0),
            popMenuItemCSS('5', 21, 15.5, 'lt_4', '离开'),
          ]);
}

//保險說明
Dialog baoxianDes(context) {
  return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Material(
          color: Colors.transparent,
          child: Container(
              padding: EdgeInsets.only(left: 15, right: 10),
              height: ssSetWidth(500),
              width: ssSetWidth(316),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: Color(0xff001733),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: ssSetWidth(316),
                      height: ssSetHeigth(45),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: ssSetWidth(316),
                            height: ssSetHeigth(45),
                            padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                            child: setTextWidget(
                                "保险说明", 16, false, Colors.white,
                                textAlign: TextAlign.center),
                          ),
                          Positioned(
                            right: 0,
                            top: ssSetWidth(4),
                            child: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ssSetWidth(15)),
                      child: setTextWidget("概述", 16, false, Color(0xffcccccc)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                      child: setTextWidget(
                          """1.当牌局中玩家全部All in之后，由当前牌型最大的玩家，获得购买的机会并弹出保险购买操作提示。
2.保险超过14张补牌不激活。
3.当保险涉及的底池中超过3个玩家的时候，保险不激活。（2人或3人时可以卖保险）
4.造成玩家平分的补牌不会计入购买保险的补牌数量，如果河牌存在平分补牌，那么玩家购买保险的总额不会超过他向底池内投入的总额。
5.存在多个底池时，可以选择1个或多个参与的底池购买保险。
6.牌桌内“实时战绩”和“上局回顾”中均有保险数据显示，且战绩中会增加保险数据显示。
7.翻牌三张不可购买保险，转牌保险投保额不得超过0.25*底池，河牌保险投保额不得超过0.5*底池。
8.如果购买了转牌保险，那么系统会强制玩家购买河牌的少量保险，背回转牌的保险投入。""", 12, false, Color(0xff999999),
                          maxLines: 999),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ssSetWidth(30)),
                      child: setTextWidget("概述", 16, false, Color(0xffcccccc)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                      child: setTextWidget("""1.保本：保险赔付额=玩家投入金额。
2.点击底池按钮可以展开滑动条，选择需要购买的保险金额。
3.确保好保险金额后，点击购买按钮，即成功购买保险。
4.存在多个底池时，每个底池均可以分别操作购买。
5.玩家也可以点击全部保本快速购买所有保险。
6.购买保险消耗的筹码从底池中扣除，如果买中，系统会根据赔率，直接赔付到玩家手中；如果没有中，则系统收走购买保险消耗的筹码。""", 12, false,
                          Color(0xff999999),
                          maxLines: 999),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ssSetWidth(30)),
                      child: setTextWidget("概述", 16, false, Color(0xffcccccc)),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ssSetWidth(14.5), bottom: ssSetWidth(14.5)),
                        child: Image.asset(imgpath + "game/peilv.png"))
                  ],
                ),
              ))));
}

//加注对话框
class CallOtherDialog extends StatefulWidget {
  final BuildContext homeContext;
  //点击确认后回调
  final void Function(String) onCallback;
  final double minCall;
  final double maxCall;
  const CallOtherDialog(
      {Key key, this.homeContext, this.onCallback, this.minCall, this.maxCall})
      : super(key: key);

  @override
  //加注对话框
  _CallOtherDialogState createState() => _CallOtherDialogState();
}

//加注对话框
class _CallOtherDialogState extends State<CallOtherDialog> {
  double callTotal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callTotal = widget.minCall;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              // print("sdf");
              Navigator.maybePop(context);
            },
            child: Container(
              width: ssSetWidth(120),
              height: ssSetWidth(400),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: ssSetWidth(75),
                      height: ssSetWidth(30),
                      decoration: BoxDecoration(
                          color: callTotal.toInt() == widget.maxCall.toInt()
                              ? Color(0xffFF9F36)
                              : Colors.black,
                          borderRadius: BorderRadius.circular(ssSetWidth(6)),
                          border: callTotal.toInt() == widget.maxCall.toInt()
                              ? null
                              : Border.all(color: Colors.white, width: 1)),
                      child: Center(
                        child: setTextWidget(
                            callTotal.toInt() == widget.maxCall.toInt()
                                ? "ALL IN"
                                : callTotal.toInt().toString(),
                            13,
                            false,
                            Colors.white),
                      )),
                  Container(
                      width: ssSetWidth(430),
                      height: ssSetWidth(230),
                      color: Colors.transparent,
                      child: Center(
                          child: Transform.rotate(
                              angle: -pi / 2,
                              child: Container(
                                // color: Colors.greenAccent,
                                height: ssSetWidth(80),
                                // width: ssSetWidth(30),
                                child: SliderTheme(
                                    data: SliderThemeData(
                                        trackHeight: 2,
                                        thumbColor: Color(0xffFF9F36),
                                        overlayColor:
                                            Colors.lightGreen.withAlpha(32),
                                        activeTickMarkColor: Colors.lightGreen,
                                        activeTrackColor: Color(0xffFF9F36),
                                        inactiveTrackColor: Color(0xffFF9F36),
                                        inactiveTickMarkColor:
                                            Color(0xffFF9F36)),
                                    child: Slider(
                                        max: widget.maxCall,
                                        min: widget.minCall,
                                        value: callTotal,
                                        onChanged: (value) {
                                          setState(() {
                                            callTotal = value;
                                          });
                                        })),
                              )))),
                  Container(
                      width: ssSetWidth(16),
                      height: ssSetWidth(16),
                      margin: EdgeInsets.only(top: 6),
                      child: Center(
                          child: Image.asset(imgpath + "game/call_up.png"))),
                  Container(
                    width: ssSetWidth(54),
                    height: ssSetWidth(54),
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(ssSetWidth(30)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xffFF9F36),
                              Color(0xffD1720B),
                            ])),
                    child: InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.maybePop(context);
                          widget
                              .onCallback(callTotal.toInt().toStringAsFixed(0));
                        },
                        child: Center(
                          child: setTextWidget("确定", 13, false, Colors.white),
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

//牌局设置
class GameSetting extends StatefulWidget {
  final BuildContext homeContext;
  final bool isOwner;
  GameSetting(this.homeContext, this.isOwner);
  @override
  _GameSettingState createState() => _GameSettingState();
}

class _GameSettingState extends State<GameSetting> {
  SharedPreferences _shp;
  void getSharep() async {
    _shp = await SharedPreferences.getInstance();
  }

  @override
  initState() {
    getSharep();
  }

  Dialog gameSet(homeContext, bool isOwner) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Material(
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(left: 15, right: 10),
                height: ssSetWidth(isOwner ? 311 : 265),
                width: ssSetWidth(316),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: Color(0xff001733),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: ssSetWidth(316),
                        height: ssSetWidth(35),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: ssSetWidth(316),
                              height: ssSetWidth(35),
                              padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                              child: setTextWidget(
                                  "牌局设置", 16, false, Colors.white,
                                  textAlign: TextAlign.center),
                            ),
                            Positioned(
                              right: 0,
                              top: ssSetWidth(4),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(homeContext);
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(14)),
                        child:
                            setTextWidget("桌面风格", 12, false, Color(0xff999999)),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(16)),
                          child: Row(
                            children: <Widget>[
                              themeSelete(0),
                              themeSelete(1),
                              themeSelete(2),
                              themeSelete(3),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(30)),
                        child:
                            setTextWidget("音量设置", 12, false, Color(0xff999999)),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(10)),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: ssSetWidth(8)),
                                  child: Container(
//                                    color: Colors.blueAccent,
                                      width: ssSetWidth(19),
                                      height: ssSetWidth(19),
                                      child: Image.asset(
                                          imgpath + "game/volume_l.png"))),
                              Expanded(
                                  child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 6,
                                ),
                                child: Slider(
                                    min: 0,
                                    max: 1,
                                    activeColor: Colors.blue,
                                    inactiveColor: Colors.blueGrey,
                                    value: soundVolume,
                                    onChanged: (value) {
                                      _shp.setDouble("gameSoundVolume", value);
                                      setState(() {
                                        soundVolume = value;
                                      });
                                    }),
                              )),
                              Padding(
                                  padding:
                                      EdgeInsets.only(right: ssSetWidth(8)),
                                  child: Container(
//                                    color: Colors.blueAccent,
                                      width: ssSetWidth(19),
                                      height: ssSetWidth(19),
                                      child: Image.asset(
                                          imgpath + "game/volume_a.png"))),
                            ],
                          )),
                      isOwner
                          ? Padding(
                              padding: EdgeInsets.only(top: ssSetWidth(0)),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                    child: Container(
                                        width: ssSetWidth(100),
                                        height: ssSetWidth(36),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                ssSetWidth(25)),
                                            border: Border.all(
                                              color: Color(0xffFF9F36),
                                              width: 1,
                                            )),
                                        child: Center(
                                          child: setTextWidget("牌局暂停", 14,
                                              false, Color(0xffFF9F36)),
                                        )),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: ssSetWidth(27)),
                                    child: GestureDetector(
                                      child: Container(
                                          width: ssSetWidth(100),
                                          height: ssSetWidth(36),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ssSetWidth(25)),
                                              border: Border.all(
                                                color: Color(0xffFF9F36),
                                                width: 1,
                                              )),
                                          child: Center(
                                            child: setTextWidget("解散牌局", 14,
                                                false, Color(0xffFF9F36)),
                                          )),
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ))
                          : SizedBox(),
                    ]))));
  }

  Widget themeSelete(int index) {
    List themes = [
      {"title": "经典蓝", "color": Color(0xff1479ED)},
      {"title": "磨砂黑", "color": Color(0xff1B1B1B)},
      {"title": "宝石蓝", "color": Color(0xff39518F)},
      {"title": "青葱绿", "color": Color(0xff19643D)}
    ];
    return Expanded(
      child: Container(
        height: ssSetWidth(71),
        margin: EdgeInsets.only(left: ssSetWidth(8), right: ssSetWidth(8)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ssSetWidth(4)),
            border: Border.all(
              color: Color(0xffFF9F36),
              width: 1,
            )),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ssSetWidth(4)),
              border: Border.all(
                color: Color(0xff001733),
                width: 2,
              ),
              color: themes[index]["color"],
            ),
            child: InkWell(
              child: Center(
                child: setTextWidget(
                    themes[index]["title"], 11, false, Colors.white),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return gameSet(widget.homeContext, widget.isOwner);
  }
}

//暂时没用
class BScore extends StatefulWidget {
  final BuildContext homeContext;
  BScore(this.homeContext);
  @override
  _BScoreState createState() => _BScoreState();
}

class _BScoreState extends State<BScore> {
  Dialog bscoreDialog(homeContext) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Material(
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(left: 15, right: 10),
                height: ssSetWidth(287),
                width: ssSetWidth(316),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: Color(0xff001733),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: ssSetWidth(316),
                        height: ssSetHeigth(45),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: ssSetWidth(316),
                              height: ssSetHeigth(45),
                              padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                              child: setTextWidget(
                                  "补充积分", 16, false, Colors.white,
                                  textAlign: TextAlign.center),
                            ),
                            Positioned(
                              right: 0,
                              top: ssSetWidth(4),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(homeContext);
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(10)),
                        child: Divider(height: 1.5, color: Color(0xff333333)),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: SizedBox()),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "小盲/小盲", 13, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "1/2", 18, true, Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: ssSetWidth(79)),
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "补充记分牌", 13, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "200", 18, true, Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: ssSetWidth(30.5), left: 15, right: 15),
                          child: Row(
                            children: <Widget>[
                              setTextWidget("最小", 13, false, Color(0xff999999)),
                              Expanded(child: SizedBox()),
                              setTextWidget("最大", 13, false, Color(0xff999999)),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(0)),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 6,
                            ),
                            child: Slider(
                                min: 0,
                                max: 1,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.blueGrey,
                                value: soundVolume,
                                onChanged: (value) {
                                  setState(() {
                                    soundVolume = value;
                                  });
                                }),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(20)),
                          child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(widget.homeContext).pop();
                                },
                                child: Container(
                                    width: ssSetWidth(150),
                                    height: ssSetWidth(39),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ssSetWidth(25)),
                                        color: Color(0xff1479ED)),
                                    child: Center(
                                      child: setTextWidget(
                                        "确定",
                                        14,
                                        false,
                                        Colors.white,
                                      ),
                                    ))),
                          )),
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    return bscoreDialog(widget.homeContext);
  }
}

class GetInScore extends StatefulWidget {
  final BuildContext homeContext;
  final double minV;
  final double maxV;
  final int type;
  final ValueChanged<double> call;
  GetInScore(this.homeContext, this.type, this.minV, this.maxV, this.call);
  @override
  _GetInScoreState createState() => _GetInScoreState();
}

class _GetInScoreState extends State<GetInScore> {
  double scoreValue = 0;
  Dialog bscoreDialog(homeContext) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Material(
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(left: 15, right: 10),
                height: ssSetWidth(287),
                width: ssSetWidth(316),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: Color(0xff001733),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: ssSetWidth(316),
                        height: ssSetWidth(35),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: ssSetWidth(316),
                              height: ssSetWidth(35),
                              padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                              child: setTextWidget(
                                  widget.type == 1 ? "积分带入" : "补充积分",
                                  16,
                                  false,
                                  Colors.white,
                                  textAlign: TextAlign.center),
                            ),
                            Positioned(
                              right: 0,
                              top: ssSetWidth(4),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    widget.call(null);
                                    Navigator.pop(homeContext);
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(10)),
                        child: Divider(height: 1.5, color: Color(0xff333333)),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: SizedBox()),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "小盲/小盲", 13, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "${(nowRoomInfo["matBlind"] / 2).toInt().toString()}/${nowRoomInfo["matBlind"].toString()}",
                                          18,
                                          true,
                                          Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: ssSetWidth(79)),
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "补充记分牌", 13, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "${scoreValue.toInt()}",
                                          18,
                                          true,
                                          Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: ssSetWidth(30.5), left: 15, right: 15),
                          child: Row(
                            children: <Widget>[
                              setTextWidget("最小", 13, false, Color(0xff999999)),
                              Expanded(child: SizedBox()),
                              setTextWidget("最大", 13, false, Color(0xff999999)),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(0)),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 6,
                              activeTickMarkColor: Colors.blue,
                              inactiveTickMarkColor: Colors.transparent,
                            ),
                            child: Slider(
                                min: widget.minV,
                                max: widget.maxV,
                                divisions: 9,
                                value: scoreValue,
                                onChanged: (value) {
                                  setState(() {
                                    scoreValue = value;
                                  });
                                }),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(20)),
                          child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  widget.call(scoreValue);
                                  Navigator.of(widget.homeContext).pop();
                                },
                                child: Container(
                                    width: ssSetWidth(150),
                                    height: ssSetWidth(39),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ssSetWidth(25)),
                                        color: Color(0xff1479ED)),
                                    child: Center(
                                      child: setTextWidget(
                                        "确定",
                                        14,
                                        false,
                                        Colors.white,
                                      ),
                                    ))),
                          )),
                    ]))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scoreValue = widget.minV;
  }

  @override
  Widget build(BuildContext context) {
    return bscoreDialog(widget.homeContext);
  }
}

//用户申请进入房间对话框
class UserInDialog extends StatelessWidget {
  final BuildContext homeContext;
  final ValueChanged<bool> callBack;
  final Map userInfo;
  UserInDialog(this.homeContext, this.callBack, this.userInfo);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 4,
        backgroundColor: Colors.transparent,
        child: Material(
            color: Colors.transparent,
            child: Container(
                //padding: EdgeInsets.only(left: 15, right: 10),
                height: ssSetWidth(125),
                width: ssSetWidth(280),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: Color(0xff001733),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: ssSetWidth(80.5),
                        width: ssSetWidth(280),
                        padding: EdgeInsets.only(
                            left: ssSetWidth(26), right: ssSetWidth(26)),
                        child: Center(
                          child: setTextWidget(
                              "“${userInfo["cnName"]}”申请带入记分牌${userInfo["score"]}",
                              14,
                              false,
                              Colors.white,
                              maxLines: 2),
                        )),
                    Divider(
                      height: 1.5,
                      color: Color(0xff333333),
                    ),
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                callBack(false);
                                Navigator.of(homeContext).pop();
                              },
                              child: Container(
                                width: ssSetWidth(139),
                                child: setTextWidget(
                                    "拒绝", 14, false, Color(0xff666666),
                                    textAlign: TextAlign.center),
                              )),
                        ),
                        Container(
                          width: 0.5,
                          child: greyLineUI(ssSetWidth(44),
                              color: Color(0xff333333)),
                        ),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                callBack(true);
                                Navigator.of(homeContext).pop();
                              },
                              child: Container(
                                width: ssSetWidth(139),
                                child: setTextWidget(
                                    "确定", 14, false, Color(0xffffffff),
                                    textAlign: TextAlign.center),
                              )),
                        ),
                      ],
                    ))
                  ],
                ))));
  }
}

class jiazhuButtonView extends StatefulWidget {
  final bool hiddenJiazhu;
  final double minCall;
  final double maxCall;
  final String title;
  final bool gamePause;
  final ValueChanged<String> callback;
  jiazhuButtonView(this.hiddenJiazhu, this.gamePause, this.title, this.minCall,
      this.maxCall, this.callback);
  @override
  _jiazhuButtonViewState createState() => _jiazhuButtonViewState();
}

class _jiazhuButtonViewState extends State<jiazhuButtonView> {
  bool isClicked;
  double callTotal;
  double vPercent = 0;
  double temPercent = 0;
  double clickPosition = 0;

  @override
  initState() {
    super.initState();
    isClicked = widget.hiddenJiazhu;
    callTotal = widget.minCall;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
//        top:safeStatusBarHeight() + ssSetHeigth(60),
        top: isClicked ? 0 : null,
        left: isClicked ? 0 : ssSetWidth(375 / 2 - 50 / 2),
        right: isClicked ? 0 : null,
//        right:50,
        bottom: isClicked
            ? 0
            : (ssSetHeigth(667) -
                safeStatusBarHeight() -
                ssSetHeigth(60) -
                viewHeight +
                tileHeight +
                ssSetWidth(4)),
        child: GestureDetector(
          onVerticalDragDown: (d) {
            if (widget.title == "加注" && !widget.gamePause) {
              clickPosition = d.globalPosition.dy;
              temPercent = vPercent;
            }
          },
          onTapUp: (d) {
            if (widget.title == "加注" && !widget.gamePause) {
              setState(() {
                isClicked = !isClicked;
                if (isClicked) {
                  temPercent = vPercent = 0.0;
                  callTotal = widget.minCall;
                }
              });
            } else if (!widget.gamePause) {
              widget.callback(null);
            }
          },
          onVerticalDragUpdate: (d) {
            if (widget.title == "加注" && !widget.gamePause) {
              if (!isClicked) {
                setState(() {
                  isClicked = !isClicked;
                  temPercent = vPercent = 0.0;
                  callTotal = widget.minCall;
                });
              } else if (!widget.gamePause) {
                vPercent = temPercent +
                    (clickPosition - d.globalPosition.dy) / ssSetHeigth(250);
                if (vPercent >= 1)
                  vPercent = 1;
                else if (vPercent <= 0) vPercent = 0;
                callTotal = vPercent * (widget.maxCall - widget.minCall) +
                    widget.minCall;
              }
            }
          },
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                color: isClicked
                    ? Colors.black.withOpacity(0.4)
                    : Colors.transparent,
              )),
              isClicked == false
                  ? Center(
                      child: Container(
                        width: ssSetWidth(50),
                        height: ssSetWidth(50),
                        child: Center(
                          child: setTextWidget(
                              widget.title, 12, false, Colors.white,
                              maxLines: 2),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ssSetWidth(25)),
                            border: Border.fromBorderSide(BorderSide(
                                style: BorderStyle.solid,
                                color: Color(0xff1D4766).withOpacity(0.3),
                                width: 1.5)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffFF9F36),
                                  Color(0xffD1720B)
                                ])),
                      ),
                    )
                  : Center(
                      child: Container(
                        margin: EdgeInsets.only(top: ssSetHeigth(60)),
                        width: ssSetWidth(120),
                        // height: ssSetWidth(400),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: ssSetWidth(75),
                                height: ssSetWidth(30),
                                decoration: BoxDecoration(
                                    color: callTotal.toInt() ==
                                            widget.maxCall.toInt()
                                        ? Color(0xffFF9F36)
                                        : Colors.black,
                                    borderRadius:
                                        BorderRadius.circular(ssSetWidth(6)),
                                    border: callTotal.toInt() ==
                                            widget.maxCall.toInt()
                                        ? null
                                        : Border.all(
                                            color: Colors.white, width: 1)),
                                child: Center(
                                  child: setTextWidget(
                                      callTotal.toInt() ==
                                              widget.maxCall.toInt()
                                          ? "ALL IN"
                                          : callTotal.toInt().toString(),
                                      13,
                                      false,
                                      Colors.white),
                                )),
                            Container(
                              width: ssSetWidth(4),
                              height: ssSetHeigth(250) + ssSetWidth(20),
                              decoration: BoxDecoration(
                                  color: Color(0xffFF9F36),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(4),
                                      bottomRight: Radius.circular(4))),
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Positioned(
                                      top: (ssSetHeigth(250) -
                                          ssSetHeigth(250) * vPercent),
                                      left: -ssSetWidth(8),
                                      child: Container(
                                        width: ssSetWidth(20),
                                        height: ssSetWidth(20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ssSetWidth(10))),
                                            color: Color(0xffFF9F36)),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                                width: ssSetWidth(16),
                                height: ssSetWidth(16),
                                margin: EdgeInsets.only(top: 6),
                                child: Center(
                                    child: Image.asset(
                                        imgpath + "game/call_up.png"))),
                            Container(
                              width: ssSetWidth(54),
                              height: ssSetWidth(54),
                              margin: EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius:
                                      BorderRadius.circular(ssSetWidth(30)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xffFF9F36),
                                        Color(0xffD1720B),
                                      ])),
                              child: InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    // Navigator.maybePop(context);
                                    widget.callback(
                                        callTotal.toInt().toStringAsFixed(0));
                                  },
                                  child: Center(
                                    child: setTextWidget(
                                        "确定", 13, false, Colors.white),
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ));
  }
}

class maiBaoxianView extends StatefulWidget {
  final List data;
  final ValueChanged<List> callBack;

  maiBaoxianView(this.data, this.callBack);
  @override
  _maiBaoxianViewState createState() => _maiBaoxianViewState();
}

class _maiBaoxianViewState extends State<maiBaoxianView> {
  bool isFirst = true;
  Widget buttons(String number, String title, Color color, void Function() func,
      {Color textColor}) {
    return Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: ssSetHeigth(15), bottom: ssSetHeigth(8)),
            child: InkWell(
              onTap: func,
              child: Container(
                  width: ssSetWidth(45),
                  height: ssSetWidth(45),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        ssSetWidth(22.5),
                      ),
                      color: color),
                  child: Center(
                      child: setTextWidget(number, 12, true, Colors.white))),
            ),
          ),
          setTextWidget(title, 12, false, textColor ?? Color(0xffCCCCCC))
        ],
      ),
    );
  }

  Widget firstTopView() {
    return Center(
      child: Container(
        width: ssSetWidth(
            95 * (widget.data.length > 4 ? 4 : widget.data.length) +
                14.0 * (widget.data.length > 4 ? 4 : widget.data.length)),
        child: ScrollConfiguration(
            behavior: WaveScrollBehavior(),
            child: ListView.builder(
//          shrinkWrap: true,
                addSemanticIndexes: false,
                scrollDirection: Axis.horizontal,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: ssSetWidth(7), right: ssSetWidth(7)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        setTextWidget(
                            goumaiJson[index]["insScore"] > 0 ? "已选择" : "点击选择",
                            14,
                            false,
                            Color(0xff1479ED)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isFirst = false;
                              poolType = index;
                              singleGoumai = goumaiJson[index]["insScore"];
                              moveOffset = (singleGoumai /
                                          widget.data[poolType]["maxIns"] -
                                      widget.data[poolType]["minIns"]) *
                                  ssSetHeigth(172 - 31.0);
                              idleOffset = moveOffset;
//                            singleGoumai = (moveOffset / ssSetHeigth(172-31.0)) * widget.data[poolType]["maxIns"] + widget.data[poolType]["minIns"];
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: ssSetHeigth(13)),
                            width: ssSetWidth(95.5),
                            height: ssSetWidth(68),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    width: ssSetWidth(95.5),
                                    height: ssSetWidth(19),
                                    padding: EdgeInsets.only(
                                        left: ssSetWidth(8),
                                        right: ssSetWidth(7.5)),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(ssSetWidth(3)),
                                            topRight: Radius.circular(
                                                ssSetWidth(3)))),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          left: ssSetWidth(-8 - 6.5),
                                          top: ssSetWidth(-5),
                                          child: Image.asset(
                                            imgpath + "game/call_yellow.png",
                                            width: ssSetWidth(25.5),
                                            height: ssSetWidth(25.5),
                                          ),
                                        ),
                                        Positioned(
                                            left: ssSetWidth(-8 - 6.5),
                                            top: ssSetWidth(-5),
                                            child: Container(
                                              width: ssSetWidth(25.5),
                                              height: ssSetWidth(25.5),
                                              child: Center(
                                                child: setTextWidget(
                                                    widget.data[index]
                                                                ["poolId"] ==
                                                            0
                                                        ? "主"
                                                        : "边",
                                                    13,
                                                    true,
                                                    Colors.white),
                                              ),
                                            )),
                                        Positioned(
                                            right: 0,
                                            child: setTextWidget(
                                                widget.data[index]["score"]
                                                    .toString(),
                                                14,
                                                false,
                                                Colors.white))
                                      ],
                                    )),
                                Container(
                                    width: ssSetWidth(95.5),
                                    height: ssSetWidth(49),
                                    padding: EdgeInsets.only(
                                        left: ssSetWidth(8),
                                        right: ssSetWidth(8)),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            bottomRight: Radius.circular(4))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            setTextWidget(
                                                "赔率", 12, false, Colors.white),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: ssSetWidth(15)),
                                              child: setTextWidget(
                                                  widget.data[index]["odds"]
                                                      .toString(),
                                                  16,
                                                  true,
                                                  Color(0xffFF9F36)),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            setTextWidget(
                                                "补牌", 12, false, Colors.white),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: ssSetWidth(15)),
                                                child: setTextWidget(
                                                  widget.data[index]["outs"]
                                                      .length
                                                      .toString(),
                                                  12,
                                                  false,
                                                  Colors.white,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })),
      ),
    );
  }

  int poolType = -1; // 0池子下标
  double goumaiValue = 0;
  double allocValue = 0;
  double singleGoumai = 0.0;
  Widget secondTopView() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 0),
              height: ssSetHeigth(21),
              decoration: BoxDecoration(
//                color: Colors.red,
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(ssSetWidth(11)),
              ),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    imgpath + "game/call_yellow.png",
                    width: ssSetWidth(15),
                    height: ssSetWidth(15),
                  ),
                  setTextWidget(" " + widget.data[poolType]["score"].toString(),
                      14, false, Colors.white)
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isFirst = true;
                    moveOffset = 0;
                    idleOffset = 0;
                  });
                })
          ],
        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            InkWell(
//              onTap: (){
//                if(poolType == 0) return;
//                setState(() {
//                  poolType = 0;
//                });
//              },
//              child: Container(
//                width: ssSetWidth(120),
//                height: ssSetHeigth(28),
//                decoration: BoxDecoration(
//                    color: poolType == 0 ? Color(0xff0C4E99) : Color(0xff010F21),
//                    borderRadius: BorderRadius.only(topLeft: Radius.circular(ssSetWidth(3)),bottomLeft: Radius.circular(ssSetWidth(3)),topRight: widget.pools.length ==1 ?  Radius.circular(ssSetWidth(3)) : null,bottomRight: widget.pools.length ==1 ?  Radius.circular(ssSetWidth(3)) : null)
//                ),
//                child: Center(child:setTextWidget("主池", 12, false, poolType == 1 ? Color(0xff999999) :Colors.white),)
//              ),
//            ),
//            widget.pools.length ==1 ? SizedBox() :
//            InkWell(
//              onTap: (){
//                if(poolType == 1) return;
//                setState(() {
//                  poolType = 1;
//                });
//              },
//              child: Container(
//                width: ssSetWidth(120),
//                height: ssSetHeigth(28),
//                decoration: BoxDecoration(
//                    color: poolType == 1 ? Color(0xff0C4E99) : Color(0xff010F21),
//                    borderRadius: BorderRadius.only(topRight: Radius.circular(ssSetWidth(3)),bottomRight: Radius.circular(ssSetWidth(3)))
//                ),
//                child: Center(child:setTextWidget("边池", 12, false, poolType == 0 ? Color(0xff999999) :Colors.white),)
//              ),
//            )
//          ],
//        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            middleNumberWidget("投保额", singleGoumai.toStringAsFixed(1)),
            middleNumberWidget(
                "赔付额",
                (singleGoumai * widget.data[poolType]["odds"])
                    .toStringAsFixed(1)),
            middleNumberWidget("赔率", widget.data[poolType]["odds"].toString()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ssSetWidth(100),
              height: ssSetHeigth(190),
//              color: Colors.red,
              margin: EdgeInsets.only(right: ssSetWidth(30)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: ssSetHeigth(10.5)),
                    child: Row(
                      children: <Widget>[
                        setTextWidget("outs", 14, false, Color(0xffCCCCCC)),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: setTextWidget(
                              widget.data[poolType]["outs"].length.toString(),
                              16,
                              true,
                              Color(0xffFF9F36)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                        shrinkWrap: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.data[poolType]["outs"].length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                        itemBuilder: (context, index) {
                          return ImagesAnim(20.5, 30, 0, 0, false,
                              widget.data[poolType]["outs"][index]);
                        }),
                  ),
                ],
              ),
            ),
            sliderHor(),
            Container(
              width: ssSetWidth(100),
              height: ssSetHeigth(190),
//              color: Colors.red,
              margin: EdgeInsets.only(left: ssSetWidth(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: ssSetHeigth(10.5)),
                    child: setTextWidget("公共牌", 14, false, Color(0xffCCCCCC)),
                  ),
                  Expanded(child: Provide<GameOpenPokersProvider>(
                      builder: (context, child, snapshot) {
                    return snapshot.pokes == null || snapshot.pokes.length == 0
                        ? SizedBox()
                        : GridView.builder(
                            shrinkWrap: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.pokes.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                            ),
                            itemBuilder: (context, index) {
                              return ImagesAnim(
                                  20.5, 30, 0, 0, false, snapshot.pokes[index]);
                            });
                  })),
                ],
              ),
            ),
          ],
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }

  List goumaiJson = List();
  double qbbaobenValue = 0.0;
  double qbmanchiValue = 0.0;
  @override
  initState() {
    super.initState();
    for (Map item in widget.data) {
      goumaiValue += item["minIns"];
      goumaiJson.add({"poolId": item["poolId"], "insScore": item["minIns"]});
      qbbaobenValue += item["principal"];
      qbmanchiValue += item["maxIns"];
    }
    allocValue = goumaiValue;
  }

  Widget sliderHor() {
    return Container(
        width: ssSetWidth(55),
        height: ssSetHeigth(172),
        margin: EdgeInsets.only(top: ssSetHeigth(0.5)),
//      color: Colors.orangeAccent,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: ssSetWidth(55),
                    height: ssSetHeigth(30),
                    decoration: DottedDecoration(
                        shape: Shape.box,
                        color: Color(0xffE05B03),
                        borderRadius: BorderRadius.circular(ssSetHeigth(6))),
                    child: Center(
                      child: setTextWidget("最大值", 12, false, Color(0xffE05B03)),
                    )),
                RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      width: ssSetHeigth(120.5),
                      height: ssSetWidth(0.5),
                      decoration: DottedDecoration(
                        shape: Shape.line,
                        color: Color(0xffE05B03),
                      ),
                    )),
                Container(
                  width: ssSetWidth(12),
                  height: ssSetWidth(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ssSetWidth(6)),
                    color: Color(0xffE05B03),
                  ),
                )
              ],
            ),
            Positioned(
                left: ssSetWidth(55 / 2),
                bottom: ssSetHeigth((172 - 31.0) *
                    ((widget.data[poolType]["principal"] /
                                (widget.data[poolType]["maxIns"] -
                                    widget.data[poolType]["minIns"])) >
                            0.9
                        ? 0.9
                        : (widget.data[poolType]["principal"] /
                            (widget.data[poolType]["maxIns"] -
                                widget.data[poolType]["minIns"])))),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 1,
                      width: 5,
                      color: Color(0xffE05B03),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: setTextWidget("保本", 12, false, Color(0xffE05B03)),
                    )
                  ],
                )),
            Positioned(
              left: ssSetWidth(55 / 2 - 2.5),
              bottom: ssSetHeigth(30 / 2),
              child: Container(
                height: ssSetWidth(moveOffset),
                width: ssSetWidth(5),
                decoration: BoxDecoration(
                  color: Color(0xffE05B03),
                ),
              ),
            ),
            Positioned(
              left: -1,
              bottom: moveOffset,
              child: GestureDetector(
                onVerticalDragDown: (detail) {
                  lastStartOffset = detail.globalPosition.dy;
                },
                onVerticalDragUpdate: (detail) {
                  setState(() {
                    moveOffset = (lastStartOffset - detail.globalPosition.dy) +
                        idleOffset;
                    if (moveOffset < 0)
                      moveOffset = 0;
                    else if (moveOffset > ssSetHeigth(172 - 31.0))
                      moveOffset = ssSetHeigth(172 - 31.0);

                    singleGoumai = (moveOffset / ssSetHeigth(172 - 31.0)) *
                            widget.data[poolType]["maxIns"] +
                        widget.data[poolType]["minIns"];
                  });
                },
                onVerticalDragEnd: (detail) {
                  idleOffset = moveOffset * 1;
                  goumaiJson[poolType]["insScore"] =
                      double.parse(singleGoumai.toStringAsFixed(1));
                  goumaiValue = 0;
                  for (Map item in goumaiJson) {
                    goumaiValue += item["insScore"];
                  }
                  setState(() {});
                },
                child: Container(
                  height: ssSetHeigth(32),
                  width: ssSetWidth(57),
                  decoration: BoxDecoration(
                      color: Color(0xffE05B03),
                      borderRadius: BorderRadius.circular(ssSetWidth(6))),
                  child: Center(
                      child: moveOffset == ssSetHeigth(172 - 31.0)
                          ? setTextWidget("最大值", 12, false, Colors.white)
                          : Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white,
                              size: ssSetWidth(20),
                            )),
                ),
              ),
            ),
          ],
        ));
  }

  //静止状态下的offset
  double idleOffset = 0;
  //本次移动的offset
  double moveOffset = 0;
  //最后一次down事件的offset
  double lastStartOffset = 0;
  Widget middleNumberWidget(String title, String numbr) {
    return Container(
      width: ssSetWidth(80),
//      height: ssSetWidth(51.5),
      padding: EdgeInsets.only(top: ssSetHeigth(4), bottom: ssSetHeigth(5)),
      child: Column(
        children: <Widget>[
          setTextWidget(numbr, 16, true, Color(0xffFF9F36)),
          setTextWidget(title, 12, false, Color(0xffCCCCCC)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        height: ssSetHeigth(isFirst ? 156 + 148.5 : 303.5 + 165),
        width: ssSetWidth(375),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              height: ssSetHeigth(isFirst ? 156 : 303),
              width: ssSetWidth(375),
              color: Colors.black.withOpacity(0.9),
              padding: EdgeInsets.only(
                  top: ssSetHeigth(0),
                  right: ssSetWidth(14),
                  left: ssSetWidth(14)),
              child: isFirst ? firstTopView() : secondTopView(),
            )),
            Container(
              height: ssSetHeigth(165),
              // padding: EdgeInsets.only(right:ssSetWidth(29.5)),
              color: Colors.black.withOpacity(0.8),
              child: Row(
                children: <Widget>[
                  allocValue == 0.0
                      ? buttons("x", "放弃", Colors.red, () {
                          widget.callBack(goumaiJson);
                        }, textColor: Color(0xffEE6161))
                      : SizedBox(),
                  buttons(
                      goumaiValue.toStringAsFixed(1),
                      goumaiValue == 0.0 ? "请选择分池" : "购买保险",
                      goumaiValue != 0.0
                          ? Color(0xff1479ED)
                          : Color(0xff999999), () {
                    if (goumaiValue == 0.0) return;
                    widget.callBack(goumaiJson);
                  }),
                  Expanded(flex: 1, child: SizedBox()),
                  buttons(qbbaobenValue.toStringAsFixed(1), "全部保本",
                      Colors.orangeAccent, () {
                    for (int i = 0; i < goumaiJson.length; i++) {
                      goumaiJson[i]["insScore"] = widget.data[i]["principal"];
                    }
                    widget.callBack(goumaiJson);
                  }),
                  buttons(qbmanchiValue.toStringAsFixed(1), "全部满池",
                      Colors.orangeAccent, () {
                    for (int i = 0; i < goumaiJson.length; i++) {
                      goumaiJson[i]["insScore"] = widget.data[i]["maxIns"];
                    }
                    widget.callBack(goumaiJson);
                  }),
                ],
              ),
            )
          ],
        ));
  }
}

//分享对话框
class ShareRoomDialog extends StatelessWidget {
  final BuildContext homeContext;
  GlobalKey _globalKey = GlobalKey();
  ShareRoomDialog(this.homeContext);
  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes; //这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(nowRoomInfo);
    Map userInfo;
    for (var item in nowRoomInfo["gameHouseUserList"]) {
      if (item["user"]["id"] == nowRoomInfo["houseOwnerId"]) {
        userInfo = item["user"];
        break;
      }
    }
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: RepaintBoundary(
            key: _globalKey,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: ssSetWidth(445),
                    width: ssSetWidth(253),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset(imgpath + "game/s_bg.png"),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(top: ssSetWidth(53)),
                                child: Container(
                                  width: ssSetWidth(253),
                                  child: setTextWidget(
                                      nowRoomInfo["houseType"] == "1"
                                          ? "德州局"
                                          : "其他局",
                                      24,
                                      true,
                                      Color(0xff1479ED),
                                      textAlign: TextAlign.center),
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: ssSetWidth(14)),
                                child: Container(
                                  width: ssSetWidth(253),
                                  child: circleMemberAvatar(-1,
                                      avatarPath: userInfo == null
                                          ? ""
                                          : userInfo["profilePicture"],
                                      size: 46),
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: ssSetWidth(8)),
                                child: Container(
                                  width: ssSetWidth(253),
                                  child: setTextWidget(
                                      userInfo == null
                                          ? ""
                                          : userInfo["userNameOrigin"],
                                      11,
                                      false,
                                      Color(0xff1479ED),
                                      textAlign: TextAlign.center),
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                                child: Container(
                                  width: ssSetWidth(253),
                                  child: setTextWidget(
                                      "房间名：${nowRoomInfo["houseName"]}",
                                      12,
                                      false,
                                      Color(0xff1479ED),
                                      textAlign: TextAlign.center),
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: ssSetWidth(41)),
                              child: Container(
                                  width: ssSetWidth(202),
                                  height: ssSetWidth(90.5),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Image.asset(
                                            imgpath + "game/s_deco.png"),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: ssSetWidth(15),
                                                      top: ssSetWidth(20)),
                                                  child: Image.asset(
                                                    imgpath + "game/s_pwd.png",
                                                    width: ssSetWidth(14),
                                                    height: ssSetWidth(15),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: ssSetWidth(20)),
                                                  child: setTextWidget(
                                                      nowRoomInfo["housePwd"]
                                                          .toString(),
                                                      19,
                                                      true,
                                                      Color(0xffFF9F36))),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: ssSetWidth(4),
                                                      top: ssSetWidth(14)),
                                                  child: Image.asset(
                                                    imgpath + "game/s_mn.png",
                                                    width: ssSetWidth(13.5),
                                                    height: ssSetWidth(13.5),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: ssSetWidth(14),
                                                      top: ssSetWidth(14)),
                                                  child: setTextWidget(
                                                      "${(nowRoomInfo["matBlind"] / 2).toInt().toString()}/${nowRoomInfo["matBlind"].toString()}",
                                                      11,
                                                      false,
                                                      Color(0xff1479ED))),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: ssSetWidth(4),
                                                      top: ssSetWidth(14)),
                                                  child: Image.asset(
                                                    imgpath + "game/s_num.png",
                                                    width: ssSetWidth(13.5),
                                                    height: ssSetWidth(13.5),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: ssSetWidth(14),
                                                      top: ssSetWidth(14)),
                                                  child: setTextWidget(
                                                      nowRoomInfo[
                                                              "maxUserNumbers"]
                                                          .toString(),
                                                      11,
                                                      false,
                                                      Color(0xff1479ED))),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: ssSetWidth(4),
                                                      top: ssSetWidth(14)),
                                                  child: Image.asset(
                                                    imgpath + "game/s_time.png",
                                                    width: ssSetWidth(13.5),
                                                    height: ssSetWidth(13.5),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: ssSetWidth(14)),
                                                  child: setTextWidget(
                                                      "${nowRoomInfo['matTime'].toString()}m",
                                                      11,
                                                      false,
                                                      Color(0xff1479ED))),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: ssSetWidth(31)),
                                width: ssSetWidth(57),
                                height: ssSetWidth(57),
                                color: Colors.redAccent,
                                child: Center(
                                  child: setTextWidget(
                                      "二维码", 16, false, Colors.black),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ssSetWidth(35.5)),
                    height: ssSetWidth(39),
                    width: ssSetWidth(150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ssSetWidth(20)),
                      color: Color(0xff1479ED),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        Uint8List imgs = await _capturePng();
                        showShareView(homeContext, "");
                      },
                      child: Center(
                        child: setTextWidget("立即分享", 16, false, Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

//用户信息对话框
class UserInfoDialog extends StatelessWidget {
  final BuildContext homeContext;
  final Map userInfo;
  UserInfoDialog(this.homeContext, this.userInfo);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Material(
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(left: 15, right: 10),
                height: ssSetWidth(345),
                width: ssSetWidth(260),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: Color(0xff001733),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: ssSetWidth(316),
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: ssSetWidth(316),
                                padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                                child: Column(
                                  children: <Widget>[
                                    circleMemberAvatar(-1,
                                        size: ssSetWidth(69),
                                        avatarPath: userInfo["user"]
                                            ["profilePicture"]),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(8)),
                                      child: setTextWidget(
                                          userInfo["user"]["userNameOrigin"],
                                          12,
                                          false,
                                          Colors.white,
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(5)),
                                      child: setTextWidget(
                                          "ID:${userInfo["user"]["id"].toString()}",
                                          11,
                                          false,
                                          Color(0xff999999),
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                )),
                            Positioned(
                              right: 0,
                              top: ssSetWidth(4),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(homeContext);
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(10)),
                        child: Divider(height: 1.5, color: Color(0xff333333)),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "总手数", 14, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "45", 14, false, Color(0xffFEFEFE)),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                child: greyLineUI(ssSetWidth(44),
                                    color: Color(0xff333333)),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "入池率", 14, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "51%", 14, false, Color(0xffFEFEFE)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(10)),
                        child: Divider(height: 1.5, color: Color(0xff333333)),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(14.5)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "加注率", 14, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "20%", 14, false, Color(0xffFEFEFE)),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                child: greyLineUI(ssSetWidth(44),
                                    color: Color(0xff333333)),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    setTextWidget(
                                        "胜率", 14, false, Color(0xff999999)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: ssSetWidth(10)),
                                      child: setTextWidget(
                                          "49%", 14, false, Color(0xffFEFEFE)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(10)),
                        child: Divider(height: 1.5, color: Color(0xff333333)),
                      ),
                    ]))));
  }
}

/// 房间信息，积分情况，进入房间人数等统计信息
/// 考虑使用 Provider ，这里应该是实时变化才对，先完成
class RoomStatisticsView extends StatefulWidget {
  final List audiencesList;
  RoomStatisticsView(this.audiencesList);
  @override
  _RoomStatisticsViewState createState() => _RoomStatisticsViewState();
}

class _RoomStatisticsViewState extends State<RoomStatisticsView> {
  Widget exLabelView(int flex, String text, Color color, {double fontSize}) {
    return Expanded(
      flex: flex,
      child: setTextWidget(text, fontSize ?? 13, false, color,
          textAlign: flex == 3 ? TextAlign.left : TextAlign.center),
    );
  }

  Widget scoreList(List playersList) {
    List<Widget> sList = List();
    for (int i = 0; i < playersList.length; i++) {
      sList.add(
        Container(
          padding: EdgeInsets.only(left: ssSetWidth(15), right: ssSetWidth(15)),
          height: ssSetWidth(30),
          child: Row(
            children: <Widget>[
              exLabelView(
                  3, "${playersList[i]["userName"]}", Color(0xffffffff)),
              exLabelView(
                  2, "${playersList[i]["totalGameNum"]}", Color(0xffffffff)),
              exLabelView(2, "${playersList[i]["totalTakeIntoScore"]}",
                  Color(0xffffffff)),
              exLabelView(
                  2,
                  "${playersList[i]["settlement"]}",
                  playersList[i]["settlement"] >= 0
                      ? Color(0xffFF9F36)
                      : Color(0xff1479ED)),
            ],
          ),
        ),
      );
    }
    return Column(
      children: sList.toList(),
    );
  }

  Widget visitorList() {
    List<Widget> uList = List();
    for (int i = 0; i < widget.audiencesList.length; i++) {
      uList.add(
        Container(
          margin: EdgeInsets.only(top: 5, left: 4.25, right: 4.25),
          child: circleMemberAvatar(-1,
              size: ssSetWidth(20),
              noBorder: true,
              avatarPath: widget.audiencesList[i]),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: GridView.count(
          // childAspectRatio: 1.04,
          shrinkWrap: true,
          crossAxisCount: 5,
          physics: NeverScrollableScrollPhysics(),
          children: uList),
    );
  }

  Map curDataMap = {};
  @override
  void initState() {
    super.initState();
    String storeKey =
        "gameHouseInfoStorage:${Global.currentUser.id}:${nowRoomInfo["id"]}";
    if (Global.globalShareInstance.containsKey(storeKey)) {
      String store = Global.globalShareInstance.getString(storeKey); // 有字段一定有数据
      curDataMap = jsonDecode(store);
    } else {
      print('暂无数据,未开局');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001733),
      body: Stack(
        children: <Widget>[
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: ssSetHeigth(100),
                color: Color(0xff282F43),
                padding: EdgeInsets.only(
                    left: ssSetWidth(15),
                    right: ssSetWidth(15),
                    top: ssSetHeigth(15.5)),
                child: curDataMap.isEmpty
                    ? SizedBox()
                    : Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                setTextWidget(
                                  "本局手数: ${curDataMap["gameBoardOfTotalNum"]}",
                                  14,
                                  false,
                                  Color(0xffffffff).withOpacity(0.8),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: ssSetHeigth(16.5)),
                                  child: setTextWidget(
                                    "平均底池: ${curDataMap["averageAccount"]}",
                                    14,
                                    false,
                                    Color(0xffffffff).withOpacity(0.8),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                setTextWidget(
                                  "总带入: ${curDataMap["totalTakeIntoScoreOfGameHouse"]}",
                                  14,
                                  false,
                                  Color(0xffffffff).withOpacity(0.8),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: ssSetHeigth(16.5)),
                                  child: setTextWidget(
                                    "本局时长: ${curDataMap["matTime"]}分钟",
                                    14,
                                    false,
                                    Color(0xffffffff).withOpacity(0.8),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: ssSetHeigth(100),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: safeStatusBarHeight(),
                        left: ssSetWidth(15),
                        right: ssSetWidth(15)),
                    child: Container(
                      height: ssSetWidth(37),
                      child: Row(
                        children: <Widget>[
                          setTextWidget(nowRoomInfo["houseName"], 12, false,
                              Color(0xff1479ED)),
                          Expanded(child: SizedBox()),
                          setTextWidget(
                              "0${nowRoomInfo["matTime"] == 30 ? "0" : (nowRoomInfo["matTime"] / 60).toInt().toString()}:${nowRoomInfo["matTime"] == 30 ? "30" : "00"}:00",
                              12,
                              false,
                              Color(0xff1479ED)),
                        ],
                      ),
                    ),
                  ), //setTextWidget("title1", 18, true, Colors.blueAccent),
                  Container(
                    padding: EdgeInsets.only(
                        left: ssSetWidth(15), right: ssSetWidth(15)),
                    color: Colors.black.withOpacity(0.2),
                    height: ssSetWidth(30),
                    child: Row(
                      children: <Widget>[
                        exLabelView(
                            3, "昵称", Color(0xffffffff).withOpacity(0.4)),
                        exLabelView(
                            2, "手数", Color(0xffffffff).withOpacity(0.4)),
                        exLabelView(
                            2, "带入", Color(0xffffffff).withOpacity(0.4)),
                        exLabelView(
                            2, "积分", Color(0xffffffff).withOpacity(0.4)),
                      ],
                    ),
                  ),
                  // 保险池，没开保险不显示，判断
                  (curDataMap.isEmpty ||
                          curDataMap["isInsGameHouse"] == false)
                      ? SizedBox()
                      : Container(
                          padding: EdgeInsets.only(
                              left: ssSetWidth(15), right: ssSetWidth(15)),
                          height: ssSetWidth(30),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                imgpath + "game/baoxianchi.png",
                                width: ssSetWidth(13.5),
                                height: ssSetWidth(15),
                              ),
                              setTextWidget(
                                "  保险池",
                                13,
                                false,
                                Color(0xff04AA2B).withOpacity(0.8),
                              ),
                              Expanded(child: SizedBox()),
                              setTextWidget(
                                "${curDataMap["insScoreOfGameBoard"]}",
                                13,
                                false,
                                Color(0xff04AA2B),
                              )
                            ],
                          ),
                        ),
                  curDataMap.isEmpty
                      ? Center(
                          child: setTextWidget(
                              '暂无数据，请玩一局后再试', 14, false, Color(0xffffffff)))
                      : scoreList(curDataMap["gameHouseUserInfoList"]),
                  Container(
                    padding: EdgeInsets.only(
                        left: ssSetWidth(15), right: ssSetWidth(15)),
                    color: Colors.black.withOpacity(0.2),
                    height: ssSetWidth(30),
                    child: Row(
                      children: <Widget>[
                        exLabelView(3, "看客", Color(0xffffffff)),
                        exLabelView(2, "", Color(0xffffffff).withOpacity(0.4)),
                        exLabelView(2, "", Color(0xffffffff).withOpacity(0.4)),
                        exLabelView(2, "  ${widget.audiencesList.length}人",
                            Color(0xffffffff)),
                      ],
                    ),
                  ),
                  MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: widget.audiencesList.length == 0
                          ? SizedBox()
                          : visitorList())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//聊天消息页面
class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  ScrollController _controller = ScrollController();
  TextEditingController _editingController = TextEditingController();
  //气泡左右显示的组件
  Widget bubbleView(bool isLeft, String text, String userAvatar) {
    if (isLeft) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: circleMemberAvatar(-1, size: ssSetWidth(40)),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 8, right: 20),
            child: ChatBubble(
              nipTop: 12,
              direction: ChatBubbleNipDirection.LEFT,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                color: Color(0xff1479ED),
                child:
                    setTextWidget(text, 13, false, Colors.white, maxLines: 99),
              ),
            ),
          ))
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 20, right: 8),
            child: ChatBubble(
              nipTop: 12,
              direction: ChatBubbleNipDirection.RIGHT,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                color: Color(0xff1479ED),
                child:
                    setTextWidget(text, 13, false, Colors.white, maxLines: 99),
              ),
            ),
          )),
          Padding(
            padding: EdgeInsets.only(right: 9),
            child: circleMemberAvatar(-1, size: ssSetWidth(40)),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provide<GameMessageProvier>(
      builder: (context, child, msg) {
        if (msg.messageList.length > 4)
          Timer(
              Duration(milliseconds: 50),
              () => _controller.animateTo(_controller.position.maxScrollExtent,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut));
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              cancelTextEdit(context);
            },
            child: Container(
              color: Color(0xff001733),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: msg.messageList.length == 0
                          ? Container(
                              height: 44,
                              padding: EdgeInsets.only(
                                  top: safeStatusBarHeight() + 20),
                              child: setTextWidget(
                                  "暂无聊天记录", 14, false, Color(0xff999999)),
                            )
                          : ListView.builder(
                              controller: _controller,
                              itemCount: msg.messageList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 10),
                                      child: Center(
                                        child: setTextWidget(
                                            "10:59", 13, false, Colors.white,
                                            maxLines: 1),
                                      ),
                                    ),
                                    index % 2 == 0
                                        ? bubbleView(
                                            true,
                                            "${msg.messageList[index]}",
                                            "userAvatar")
                                        : bubbleView(
                                            false,
                                            "${msg.messageList[index]}",
                                            "userAvatar")
                                  ],
                                );
                              })),
                  Container(
                    height: ssSetHeigth(54),
                    width: ssSetWidth(300),
                    padding: EdgeInsets.only(
                        left: ssSetWidth(10.5), right: ssSetWidth(10.5)),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            right: ssSetWidth(8.5),
                          ),
                          child: CupertinoTextField(
                            style: TextStyle(color: b33),
                            autofocus: false,
                            controller: _editingController,
                            cursorColor: b33,
                            keyboardType: TextInputType.text,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(ssSetWidth(6))),
                            onEditingComplete: () {
                              if (_editingController.text.length > 0) {
                                Provide.value<GameMessageProvier>(context)
                                    .newMessageArrive(_editingController.text);
                              }
                              _editingController.text = "";
                              cancelTextEdit(context);
                            },
                          ),
                        )),
                        Container(
                            height: ssSetWidth(30),
                            decoration: BoxDecoration(
                                color: Color(0xff1479ED),
                                borderRadius:
                                    BorderRadius.circular(ssSetWidth(6))),
                            child: InkWell(
                              onTap: () {
                                if (_editingController.text.length > 0) {
                                  Provide.value<GameMessageProvier>(context)
                                      .newMessageArrive(
                                          _editingController.text);
                                }
                                cancelTextEdit(context);
                                _editingController.text = "";
                              },
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ssSetWidth(15),
                                      right: ssSetWidth(15)),
                                  child: Center(
                                    child: setTextWidget(
                                        "发送", 14, false, Colors.white),
                                  )),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//回合信息
class CardsDrawView extends StatefulWidget {
  final int boardPageIndex;
  final Map nowBoardInfo;
  CardsDrawView(this.nowBoardInfo, this.boardPageIndex);
  @override
  _CardsDrawViewState createState() => _CardsDrawViewState();
}

class _CardsDrawViewState extends State<CardsDrawView> {
  //顶部的公牌信息
  Widget headCards(List openPokes) {
    List<Widget> cardsList = List();
    for (int i = 0; i < openPokes.length; i++) {
      cardsList.add(ImagesAnim(13, 22, 2.5, 0, false, openPokes[i]));
    }
    return Row(
      children: cardsList,
    );
  }

  //用户操作信息列表
  Widget scoreList(List recordUserInfoList, openPokes) {
    List<Widget> sList = List();
    for (int i = 0; i < recordUserInfoList.length; i++) {
      var item = recordUserInfoList[i];
      sList.add(Stack(
        //stack层叠布局
        children: <Widget>[
          // 外部嵌套container统一管理缩进,不再每一个控件处理
          Container(
            padding: EdgeInsets.only(
                left: ssSetWidth(15),
                right: ssSetWidth(15),
                top: ssSetWidth(10),
                bottom: ssSetWidth(5)),
            //height: ssSetWidth(30),
            child: Row(
              children: <Widget>[
                //用户头像,-1传参是固定值
                circleMemberAvatar(-1, avatarPath: item["profileUrl"]),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: ssSetWidth(7)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          //用户昵称
                          setTextWidget(
                              item["userName"], 12, false, Colors.white),
                          Expanded(flex: 7, child: SizedBox()),
                          item["insScore"] > 0
                              ? setTextWidget("保险${item['insScore']}", 10,
                                  false, Colors.red)
                              : item["insScore"] < 0
                                  ? setTextWidget("保险${item['insScore']}", 10,
                                      false, Colors.green)
                                  : SizedBox(),
                          Expanded(flex: 1, child: SizedBox()),
                          //右边那个加号, 我也不知道是什么,具体需要问UI
                          setTextWidget('${item["settlementScore"]}', 12, false,
                              Color(0xffFEFEFE)),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    //卡牌,填充数据时singleCard(cardNum: xx),直接传入卡牌的id就可以
                                    ImagesAnim(13, 22, 2.5, 0, false,
                                        item["playerBluff"][0]),
                                    //卡牌,填充数据时singleCard(cardNum: xx),直接传入卡牌的id就可以
                                    ImagesAnim(13, 22, 2.5, 0, false,
                                        item["playerBluff"][1])
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child:
                                        //操作记录
                                        setTextWidget(
                                            "${item["firstAction"]} ${item["firstBet"] == 0 ? "" : item["firstBet"]}",
                                            10,
                                            false,
                                            Color(0xff999999))),
                              ],
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Column(
                                      children: <Widget>[
                                        //这个Row其实感觉没什么必要, 虽然是照着设计图做的,可复用 headCards
                                        Row(
                                          children: <Widget>[
                                            ImagesAnim(
                                                13, 22, 2.5, 0, false, openPokes.length>2?openPokes[0]:0),
                                            ImagesAnim(
                                                13, 22, 2.5, 0, false, openPokes.length>2?openPokes[1]:0),
                                            ImagesAnim(
                                                13, 22, 2.5, 0, false, openPokes.length>2?openPokes[2]:0),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: setTextWidget(
                                                "${item["flopAction"]} ${item["flopBet"] == 0 ? "" : item["flopBet"]}",
                                                10,
                                                false,
                                                Color(0xff999999))),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            ImagesAnim(
                                                13, 22, 2.5, 0, false, openPokes.length>3?openPokes[3]:0),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child:
                                            //第三次行为
                                            setTextWidget(
                                                "${item["turnAction"]} ${item["turnBet"] == 0 ? "" : item["turnBet"]}",
                                                10,
                                                false,
                                                Color(0xff999999))),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            ImagesAnim(
                                                13, 22, 2.5, 0, false, openPokes.length>4?openPokes[4]:0),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: setTextWidget(
                                                "${item["riverAction"]} ${item["riverBet"] == 0 ? "" : item["riverBet"]}",
                                                10,
                                                false,
                                                Color(0xff999999))),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          // 用户头像左上角的tag
          // item["seatName"]==""?SizedBox():
          Positioned(
              top: 11,
              left: 8,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ssSetWidth(7.5)),
                      color: item["seatName"] == "BTN"
                          ? Colors.white
                          : Color(0xff1379ED)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: setTextWidget(
                        item["seatName"],
                        10,
                        false,
                        item["seatName"] == "BTN"
                            ? Colors.black
                            : Color(0xfffefefe)),
                  ))),
        ],
      ));
    }
    return Column(
      children: sList.toList(),
    );
  }

  /// 获取牌局信息  缓存存在 =>  取缓存，否则 => 请求接口   并改变 nowBoardMap
  /// 参数格式  "${_userModel.id}:${nowRoomInfo['id']}:$nowCurrentIndex"   最后一个暂时是页码
  Future getBoardStorage(keyString) async {
    Map temp;
    if (Global.globalShareInstance.containsKey("boardsMapStorage:$keyString")) {
      temp = jsonDecode(
          Global.globalShareInstance.getString("boardsMapStorage:$keyString"));
    } else {
      // 请求接口
      print("接口");
      temp = await getGameBoardInfo(nowRoomInfo["id"],
          boardId: nowCurrentIndex - 1);
    }
    processData(temp);
  }

  //获取用户信息，主要是id
  UserModel _userModel = UserInfo().getModel();
  //页码
  int nowCurrentIndex = 0;
  // 当前一局的信息
  Map nowBoardMap = {};
  // 收藏改变
  bool nowInitCollectFlag;
  // 已经收藏的个数
  int storeNum = 0;

  /// 获取数据类型
  getType(obj) {
    if (obj is String)
      print('String');
    else if (obj is Map)
      print('Map');
    else if (obj is List)
      print('List');
    else if (obj is int)
      print('int');
    else if (obj is bool)
      print(bool);
    else
      print('Other type');
  }

  ///判断用户动作
  String getActionName(actionNum) {
    if (actionNum == 1)
      return '加注';
    else if (actionNum == 2)
      return '跟注';
    else if (actionNum == 3)
      return '看牌';
    else if (actionNum == 4)
      return 'Allin';
    else if(actionNum == 5)
      return '弃牌';
    else
      return '';
  }

  /// 加工数据
  /// widget.nowBoardInfo 或 从缓存 或 从请求中获取的数据
  /// 为需要展示的格式 nowBoardMap
  void processData(workingData) {
    if(workingData==""){
      setState(() {
        nowBoardMap = {};
        nowCurrentIndex = 0;
      });
      return;
    }
    nowBoardMap = {
      'openPoker': workingData["openPoker"] != "" ? jsonDecode(
          workingData["openPoker"]) : [0,0,0,0,0],
      'totalNumbersOfPlayers': workingData["totalNumbersOfPlayers"].toString()??"0",
      'poolScore': workingData["poolScore"].toString() ?? "0",
      'page': workingData['page'],
      'isCollect': workingData['isCollect']
    };
    nowInitCollectFlag = workingData['isCollect'];
    List<Map> tempList = [];
    for (int i = 0; i < workingData['recordUserInfoList'].length; i++) {
      Map item = workingData['recordUserInfoList'][i];
      Map tempItem = {
        "userName": item["userName"],
        "profileUrl": item["profileUrl"],
        "playerBluff": item["playerBluff"] !="" ? jsonDecode(item["playerBluff"]) : [0,0],
        "insScore": item["insScore"] ?? "0",
        "settlementScore": item["settlementScore"].toString() ?? "0",
        "seatName": item["seatName"],
        "firstAction": getActionName(item["firstAction"]),
        "flopAction": getActionName(item["flopAction"]),
        "turnAction": getActionName(item["turnAction"]),
        "riverAction": getActionName(item["riverAction"]),
        "firstBet": item["firstBet"],
        "flopBet": item["flopBet"],
        "turnBet": item["turnBet"],
        "riverBet": item["riverBet"],
      };
      // print(tempItem);
      tempList.add(tempItem);
    }
    // 变量.clear()
    // 设置 setState 为了牌局翻页 re build
    // 若只是 initState 不需要 setState
    setState(() {
      nowBoardMap['recordUserInfoList'] = tempList;
      nowCurrentIndex = nowBoardMap['page'];
    });
  }

  void initState() {
    super.initState();
    if(Global.globalShareInstance.getKeys().toList().contains("boardsStorageNum:${_userModel.id}")){
      setState(() {
        storeNum = Global.globalShareInstance.getInt("boardsStorageNum:${_userModel.id}");
      });
    }

    // 处理数据为空时，显示暂无数据
    if (widget.nowBoardInfo.isNotEmpty) {
      processData(widget.nowBoardInfo);
    }
  }

  /// 判断是否修改要缓存   关于 收藏
  Future isChangeStorage(pageNum,{isDispose = false}) async {
    // 相同 不修改缓存 和 收藏总数量 和 缓存的收藏信息部分
    // 不同 要修改
    if (nowBoardMap["isCollect"] != nowInitCollectFlag) {
      SharedPreferences store = await SharedPreferences.getInstance();
      // 改变牌局缓存
      String key =
          "boardsMapStorage:${_userModel.id}:${nowRoomInfo['id']}:$pageNum";
      Map temp = jsonDecode(store.getString(key));
      temp["isCollect"] = !temp["isCollect"];
      await store.setString(key, jsonEncode(temp));
      await store.setInt("boardsStorageNum:${_userModel.id}", storeNum);
    }
  }

  // 退出时 和翻页时  判断收藏是否改变改变则修改缓存
  @override
  void dispose() {
    super.dispose();
    print("dispose");
    if (nowBoardMap.isNotEmpty) {
      isChangeStorage(nowCurrentIndex,isDispose: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 记录上一查看牌局的信息，判断是否有收藏，一次性修改缓存，避免玩家在一局中多次点击  收藏/取消收藏
    return Scaffold(
        backgroundColor: Color(0xff001733),
        body: Stack(
          children: <Widget>[
            // 底部的视图
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: ssSetWidth(40),
                  padding: EdgeInsets.only(
                      left: ssSetWidth(15),
                      right: ssSetWidth(15),
                      top: ssSetHeigth(3)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: ssSetWidth(25),
                        child: IconButton(
                            // 向左翻页
                            splashColor: Colors.transparent,
                            icon: Icon(
                              Icons.chevron_left,
                              //小于等于1 则灰色 并且不允许点击
                              color: nowCurrentIndex <= 1
                                  ? Color(0xff999999)
                                  : Color(0xffFF9F36),
                              size: ssSetWidth(25),
                            ),
                            onPressed: () async {
                              if (nowCurrentIndex > 1) {
                                // 直接获取数据会设置 nowCurrentIndex 的值
                                await isChangeStorage(nowCurrentIndex);
                                await getBoardStorage(
                                    "${_userModel.id}:${nowRoomInfo['id']}:${nowCurrentIndex - 1}");
                              }
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 0, top: 3),
                        child: setTextWidget(
                            "$nowCurrentIndex/${widget.boardPageIndex}",
                            13,
                            false,
                            Color(0xffFF9F36)),
                      ),
                      Container(
                        width: ssSetWidth(25),
                        child: IconButton(
                            //向右翻页
                            splashColor: Colors.transparent,
                            icon: Icon(
                              Icons.chevron_right,
                              color: //最后一页则灰色,不允许点击
                                  nowCurrentIndex == widget.boardPageIndex
                                      ? Color(0xff999999)
                                      : Color(0xffFF9F36),
                              size: ssSetWidth(25),
                            ),
                            onPressed: () async {
                              if (nowCurrentIndex < widget.boardPageIndex) {
                                await isChangeStorage(nowCurrentIndex);
                                await getBoardStorage(
                                    "${_userModel.id}:${nowRoomInfo['id']}:${nowCurrentIndex + 1}");
                              }
                            }),
                      ),
                      Expanded(child: SizedBox()),
                      IconButton(
                        icon: Icon(
                          (nowBoardMap.isEmpty ||
                                  (nowBoardMap["isCollect"] == false))
                              ? Icons.star_border
                              : Icons.star,
                          color: Color(0xffFF9F36),
                          size: ssSetWidth(25),
                        ),
                        onPressed: () {
                          print("点击收藏 / 取消收藏");
                          if (nowBoardMap.isNotEmpty && (storeNum < 15)) {
                            setState(() {
                              // 全局【收藏数量】和【收藏按钮】发生变化  并 先对应 再 修改缓存
                              nowBoardMap["isCollect"] =
                                  !nowBoardMap["isCollect"];
                              storeNum = nowBoardMap["isCollect"] == true ? (storeNum + 1) : (storeNum - 1);
                            });
                          }else if(storeNum >= 15){
                            showAlertView(context, "提示", "哎呀，您的收藏个数达到上限了", null, "知道了", (){
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                      setTextWidget("${storeNum.toString()}/15", 13, false, Color(0xffFF9F36)),
                      Padding(
                        padding: EdgeInsets.only(left: ssSetWidth(19.5)),
                        child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Color(0xffFF9F36),
                            ),
                            onPressed: () {
                              showShareView(context, "www.starpuke.com");
                            }),
                      )
                    ],
                  ),
                )),
            // 主数据显示视图
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: ssSetWidth(40),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: safeStatusBarHeight(),
                          left: ssSetWidth(15),
                          right: ssSetWidth(15)),
                      child: Container(
                        height: ssSetWidth(27),
                        child: Row(
                          children: <Widget>[
                            //房间名字
                            setTextWidget(nowRoomInfo["houseName"].toString(),
                                12, false, Color(0xff1479ED)),
                          ],
                        ),
                      ),
                    ),
                    nowBoardMap.isEmpty
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.only(
                                left: ssSetWidth(15), right: ssSetWidth(15)),
                            color: Colors.black.withOpacity(0.2),
                            height: ssSetWidth(35),
                            child: Row(
                              children: <Widget>[
                                setTextWidget("牌谱", 13, false,
                                    Color(0xffffffff).withOpacity(0.4)),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: ssSetWidth(25)),
                                  child: headCards(nowBoardMap["openPoker"]),
                                ),
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: EdgeInsets.only(left: ssSetWidth(0)),
                                  child: Image.asset(
                                    imgpath + "game/s_num.png",
                                    width: ssSetWidth(14),
                                    height: ssSetWidth(14),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: ssSetWidth(7.5)),
                                  child: setTextWidget(
                                      "${nowBoardMap["totalNumbersOfPlayers"]}",
                                      13,
                                      false,
                                      Color(0xff999999)),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: ssSetWidth(18)),
                                  child: Image.asset(
                                    imgpath + "game/s_mn.png",
                                    width: ssSetWidth(14),
                                    height: ssSetWidth(14),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: ssSetWidth(7.5)),
                                  child: setTextWidget(
                                      "${nowBoardMap["poolScore"]}",
                                      13,
                                      false,
                                      Color(0xff999999)),
                                ),
                              ],
                            ),
                          ),
                    //展示List<Widget>
                    nowBoardMap.isEmpty
                        ? Center(child:setTextWidget("暂无数据",13,false,Color(0xffffffff)))
                        : nowBoardMap["recordUserInfoList"].length == 0
                            ? SizedBox()
                            : scoreList(nowBoardMap["recordUserInfoList"],
                                nowBoardMap["openPoker"]),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class ImagesAnim extends StatefulWidget {
//  final Map<int, Image> imageCaches;
  final double width;
  final double height;
  final double right;
  final int timeLength;
  final bool needAni;
  final int cardNum;

  ImagesAnim(this.width, this.height, this.right, this.timeLength, this.needAni,
      this.cardNum,
      {Key key})
      : assert(cardNum != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ImagesAnimState();
  }
}

class ImagesAnimState extends State<ImagesAnim>
    with AnimationMixin, GameTimeProfile {
  Animation<double> _animation;
  AnimationController _controller;
  Duration _duration;
  int interval = 0; //442
  int cardNum;
  bool needAni;
  void killController() {
    _controller?.dispose();
  }

  @override
  void initState() {
    super.initState();
//    if (widget.timeLength != null) {
//      interval = widget.timeLength;
//    }
    interval = danzhangfanpaitime;
    cardNum = widget.cardNum;
    needAni = widget.needAni;
    if (widget.cardNum != -1) {
      // 启动动画controller
      _controller = createController();
      _controller.play(duration: Duration(milliseconds: interval));
      final CurvedAnimation curve1 =
          CurvedAnimation(parent: _controller, curve: Curves.easeIn);
      _animation = new Tween<double>(begin: 0, end: 8).animate(curve1)
        ..addListener(() {
          setState(() {
            // the state that has changed here is the animation object’s value
          });
        });
      if (widget.needAni) _controller.play();
    }
  }

  void setCardNum(int card) {
    cardNum = card;
    needAni = true;
    setState(() {});
    _controller.play();
  }

//  void startAnimation() => _controller.play();
  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  void reSetController() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    int ix = _animation.value.floor() % 9;

    return Container(
      margin: EdgeInsets.only(right: widget.right),
      width: ssSetWidth(widget.width),
      height: ssSetWidth(widget.height),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
      child: widget.cardNum == -1
          ? SizedBox()
          : ClipRRect(
              child: Image.asset(
//              returnPokeImg(widget.cardNum.toString()),
                needAni
                    ? ix == 0
                        ? returnPokeImg("0")
                        : ix < 8
                            ? returnPokeImg("0${ix - 1}")
                            : returnPokeImg(cardNum.toString())
                    : returnPokeImg(cardNum.toString()),
                fit: BoxFit.fitWidth,
              ),
            ),
    );
  }
}
