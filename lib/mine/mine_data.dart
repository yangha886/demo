import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class MineData extends StatefulWidget {
  @override
  _MineDataState createState() => _MineDataState();
}

class _MineDataState extends State<MineData> {
  Map mineDataMap = {};
  List maxPoker = [0, 0, 0, 0, 0];
  @override
  void initState() {
    super.initState();
    if (Global.globalShareInstance
        .getKeys()
        .toList()
        .contains("minePageRecordStorage")) {
      mineDataMap = jsonDecode(
          Global.globalShareInstance.getString("minePageRecordStorage"));
      maxPoker = mineDataMap["maxHoldPoker"] == ""
          ? [0, 0, 0, 0, 0]
          : jsonDecode(mineDataMap["maxHoldPoker"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.purityBlockColor,
      appBar: whiteAppBarWidget("数据", context, haveShadowLine: true),
      body: Column(
        children: <Widget>[
          dataShowBar(),
          bigCard(),
        ],
      ),
    );
  }

  Widget bigCard() {
    return Container(
      height: ssSetWidth(131),
      color: style.backgroundColor,
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 1,
                width: ssSetWidth(40),
                margin: EdgeInsets.only(right: 10),
                color: Color(0xffe5e5e5),
              ),
              setTextWidget("最大牌型", 14, false, b33),
              Container(
                height: 1,
                width: ssSetWidth(40),
                margin: EdgeInsets.only(left: 10),
                color: Color(0xffe5e5e5),
              )
            ],
          ),
          Expanded(
            child: maxPokes(),
          ),
          setTextWidget("${mineDataMap["maxHoldType"]}", 12, false, g99),
        ],
      ),
    );
  }

  Widget maxPokes(){
    List<Widget> maxPokes = [];
    for(var item in maxPoker){
      maxPokes.add(
        Container(
          height: ssSetWidth(54.35),
          width: ssSetWidth(37.01),
          margin: EdgeInsets.only(left:4,right: 4),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(ssSetWidth(15)),
              border: Border.all(color: Color(0xff1479ED), width: 0.5)
          ),
          child: Image.asset(imgpath + "pokes/poke_$item.png"),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: maxPokes,
    );
  }

  Widget dataShowBar() {
    return Container(
      width: ssSetWidth(375),
      margin: EdgeInsets.fromLTRB(
          ssSetWidth(20), ssSetWidth(20), ssSetWidth(20), 27),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              circleProgress("入局率", mineDataMap["rateOfWin"] ?? 0.0),
              Padding(
                padding: EdgeInsets.only(left: 34),
                child: circleProgress("胜率", mineDataMap["rateOfWin"] ?? 0.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 34),
                child: circleProgress(
                    "摊牌率", mineDataMap["rateOfSettlement"] ?? 0.0),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                circleProgress(
                    "翻前加注率", mineDataMap["rateOfRaiseBeforeFlop"] ?? 0.0),
                Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: circleProgress(
                      "持续下注", mineDataMap["rateOfContinue"] ?? 0.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget circleProgress(String text, double rate) {
    return Column(
      children: <Widget>[
        Container(
          width: ssSetWidth(76),
          height: ssSetWidth(76),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: ssSetWidth(76),
                width: ssSetWidth(76),
                child: new CircularProgressIndicator(
                    strokeWidth: ssSetWidth(13),
                    value: rate,
                    backgroundColor: style.textTipColor,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xffFFC98E))),
              ),
              Center(
                child: setTextWidget("${(rate * 100).round()}%", 16, true, b33),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 14),
          child: setTextWidget(text, 14, false, g99),
        )
      ],
    );
  }
}
