import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class MineCardsList extends StatefulWidget {
  final String boardKeyContain;
  final String isFromMine;
  MineCardsList(this.boardKeyContain,this.isFromMine);
  @override
  _MineCardsListState createState() => _MineCardsListState();
}

class _MineCardsListState extends State<MineCardsList> {
  List cardsList = [];
  @override
  void initState() {
    super.initState();
    dynamic sharedKeysList = Global.globalShareInstance.getKeys().toList();
    if(widget.isFromMine == 'true'){
      processData(sharedKeysList,"boardsMapStorage:");
    }else if(widget.boardKeyContain != ""){
      processData(sharedKeysList,widget.boardKeyContain);
    }
  }

  /// 获取缓存数据并处理
  void processData(sharedKeysList,subKeyString) {
    // print(sharedKeysList);
    for (var i = 0; i < sharedKeysList.length; i++) {
      if (sharedKeysList[i].contains(subKeyString)) {
        Map temp = jsonDecode(Global.globalShareInstance.getString(sharedKeysList[i]));
        if((widget.isFromMine=='false') || ((widget.isFromMine == 'true') && (temp["isCollect"] == true))){  // 收藏的才显示
          Map tempMap = {
            "curkey": sharedKeysList[i],
            "myHandPoker": [0, 0],
            "handNum": temp["page"],
            "winOrLostScore": "",
            "blind": temp["matBlind"],
            "winnerName": "",
            "winnerType": "",
            "winnerScore": -1,
          };
          // 找当前用户 和 赢家信息
          bool currentUserFlag = false; // 当前用户是否找到
          for (var j = 0;
          j < temp["recordUserFavoriteSettlementList"].length;
          j++) {
            if (tempMap["winnerScore"] <
                temp["recordUserFavoriteSettlementList"][j]["settlementScore"]) {
              tempMap["winnerName"] =
              temp["recordUserFavoriteSettlementList"][j]["userName"]; // 赢家
              tempMap["winnerType"] =
              temp["recordUserFavoriteSettlementList"][j]["bluffType"];
              tempMap["winnerScore"] =
              temp["recordUserFavoriteSettlementList"][j]["settlementScore"];
            }
            if (!currentUserFlag &&
                (temp["recordUserFavoriteSettlementList"][j]["userId"]
                    .toString() ==
                    Global.currentUser.id)) {
              currentUserFlag = true;
              tempMap["myHandPoker"] =
              temp["recordUserFavoriteSettlementList"][j]["bluff"] != "" ? jsonDecode(
                  temp["recordUserFavoriteSettlementList"][j]["bluff"]) : [0,0];
              tempMap["winOrLostScore"] =
              temp["recordUserFavoriteSettlementList"][j]["settlementScore"];
            }
          }
          // 最后信息中没有当前用户,找弃牌时用户的信息
          if (!currentUserFlag) {
            for (var j = 0; j < temp["recordUserInfoList"].length; j++) {
              if (temp["recordUserInfoList"][j]["userId"] ==
                  Global.currentUser.id) {
                currentUserFlag = true;
                tempMap["winOrLostScore"] =
                temp["recordUserInfoList"][j]["totalBet"];
                break;
              }
            }
            // 如果仍然没有当前用户，则只是看客
            if (!currentUserFlag) {}
          }
          // print(tempMap);
          cardsList.add(tempMap);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.backgroundColor,
      // 战绩 / 我的 页面跳转到这里，返回相应的页面
      appBar: whiteAppBarWidget("牌谱", context, haveShadowLine: true),
      body: cardsList.length == 0
          ? Center(child: Text('暂无牌谱信息'))
          : ListView.builder(
              itemCount: cardsList.length,
              itemBuilder: (context, index) {
                return cardInfoCell(cardsList[index]);
              }),
    );
  }

  Widget cardInfoCell(Map item) {
    return Container(
        height: ssSetWidth(60),
        width: ssSetWidth(375),
        color: style.backgroundColor,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: InkWell(
          onTap: () {
            Application.router.navigateTo(context,
                "$mineCardInfoPath?curKey=${item["curkey"]}&winnerName=${Uri.encodeComponent(item["winnerName"])}&winnerType=${Uri.encodeComponent(item["winnerType"])}&winnerScore=${item["winnerScore"]}",
                transition: TransitionType.inFromRight);
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ssSetWidth(50),
                      // decoration: BoxDecoration(
                      // border: Border.all(color: Colors.red, width: 1),
                      // ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: ssSetWidth(28.41),
                            height: ssSetWidth(40),
                            // decoration: BoxDecoration(
                            // border: Border.all(color: Colors.red,width: 1),
                            // ),
                            child: Image.asset(imgpath +
                                "pokes/poke_${item["myHandPoker"][0]}.png"),
                          ),
                          Positioned(
                            left: ssSetWidth(17),
                            child: Container(
                              width: ssSetWidth(28.41),
                              height: ssSetWidth(40),
                              // decoration: BoxDecoration(
                              // border: Border.all(color: Colors.red,width: 1),
                              // ),
                              child: Image.asset(imgpath +
                                  "pokes/poke_${item["myHandPoker"][1]}.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "${item["winnerName"]}以",
                                    style: TextStyle(
                                        color: style.textTitleColor,
                                        fontSize: ssSp(14))),
                                TextSpan(
                                  text: "${item["winnerType"]}",
                                  style: TextStyle(
                                      color: style.themeColor,
                                      fontSize: ssSp(14)),
                                ),
                                TextSpan(
                                    text: "获得胜利",
                                    style: TextStyle(
                                        color: style.textTitleColor,
                                        fontSize: ssSp(14))),
                              ])),
                              Expanded(child: SizedBox()),
                              Container(
                                child: setTextWidget("第${item["handNum"]}手", 12,
                                    false, style.textContextColor),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Opacity(
                                opacity: style.themeType == 0 ? 1 : 0.4,
                                child: Image.asset(
                                  imgpath + "room_type.png",
                                  width: ssSetWidth(14),
                                  height: ssSetWidth(14),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: setTextWidget("${item["blind"]}", 12,
                                    false, style.textContextColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: setTextWidget(
                                    "赢得: ${item["winnerScore"]}",
                                    12,
                                    false,
                                    style.textContextColor),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                child: setTextWidget(
                                    "${item["winOrLostScore"]}",
                                    14,
                                    false,
                                    style.textContextColor),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              greyLineUI(
                1,
              )
            ],
          ),
        ));
  }
}
