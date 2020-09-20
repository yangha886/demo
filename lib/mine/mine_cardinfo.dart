import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:star/util/global.dart';
import 'package:star/widgets/game_widgets.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class MineCardInfo extends StatefulWidget {
  final String curKey;
  final String winnerName;
  final String winnerType;
  final String winnerScore;
  MineCardInfo(this.curKey, this.winnerName, this.winnerType, this.winnerScore);
  @override
  _MineCardInfoState createState() => _MineCardInfoState();
}

class _MineCardInfoState extends State<MineCardInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: style.backgroundColor,
        appBar:
            whiteAppBarWidget("牌谱详情", context, haveShadowLine: true, actions: [
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Container(
                color: style.backgroundColor,
                child: InkWell(
                  onTap: () {
                    showShareView(context, "www.starpuke.com");
                  },
                  child: Image.asset(
                    imgpath + "mine/blackshare.png",
                    width: ssSetWidth(19),
                    height: ssSetWidth(19),
                  ),
                ),
              ))
        ]),
        body: loopInfoTemp.isEmpty ? Center(child: Text("暂无牌局详情"),) : Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.grey,
                  height: ssSetWidth(280),
                  width: ssSetWidth(375),
                  child: Center(
                    child: Text("假装这里是个视频"),
                  ),
                ),
                Container(
                    color: style.backgroundColor,
                    height: ssSetWidth(105),
                    width: ssSetWidth(375),
                    padding: EdgeInsets.only(top: 11, left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            setTextWidget("Won: ${topBaseInfo["winnerScore"]}",
                                14, true, style.textTitleColor),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: setTextWidget(
                                  "${topBaseInfo["winnerName"]}以${topBaseInfo["winnerType"]}获得胜利",
                                  14,
                                  true,
                                  style.textTitleColor),
                            )
                          ],
                        ),
                        Expanded(
                            child: Row(
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
                              child: setTextWidget("${topBaseInfo["blind"]}",
                                  12, false, style.textContextColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: setTextWidget("2020/6/18  11:51", 12,
                                  false, style.textContextColor),
                            ),
                            Expanded(
                                child: setTextWidget(
                                    "第${topBaseInfo["handNum"]}手",
                                    12,
                                    false,
                                    style.textContextColor,
                                    textAlign: TextAlign.right))
                          ],
                        )),
                        Expanded(
                            child: Row(
                          children: <Widget>[
                            circleMemberAvatar(-1,
                                size: 22,
                                avatarPath: topBaseInfo["curUserAvatar"]),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: setTextWidget(
                                  "${topBaseInfo["curUserNickName"]}",
                                  12,
                                  false,
                                  style.textContextColor),
                            ),
                            Expanded(child: SizedBox()),
                            Opacity(
                              opacity: style.themeType == 0 ? 1 : 0.4,
                              child: Icon(Icons.visibility,size: ssSetWidth(20),color: Colors.grey.withOpacity(0.6),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: setTextWidget(
                                  "5", 12, false, style.textContextColor),
                            ),
                            Opacity(
                              opacity: style.themeType == 0 ? 1 : 0.4,
                              child: Padding(
                                padding: EdgeInsets.only(left: 36),
                                child:Icon(Icons.thumb_up,size: ssSetWidth(18),color:Colors.grey.withOpacity(0.6),),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: setTextWidget(
                                  "0", 12, false, style.textContextColor),
                            ),
                          ],
                        )),
                      ],
                    )),
                Container(
                  color: Colors.grey.withOpacity(0.1),
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 7),
                  width: ssSetWidth(375),
                  child:
                      setTextWidget("精彩文字牌谱", 12, true, style.textTitleColor),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: loopInfoTemp.length,
                    itemBuilder: (context, index) {
                      return oneLoopCell(loopInfoTemp[index]);
                    }),
              ],
            ),
          ),
        ));
  }

  Map topBaseInfo = {};
  List loopInfoTemp = List();
  List<Widget> roundViews = List();
  List roundName = ["Preflop", "Flop", "Turn", "River", "Showdown"];
  List openPokerList;
  @override
  void initState() {
    super.initState();
    // 超时等会没有牌局详情,这里一定会进 if 判断，需要修改判断时间
    if(Global.globalShareInstance.getKeys().toList().contains(widget.curKey)){
      processData();
    }
  }

  // 处理数据格式
  void processData() {
    Map temp = jsonDecode(Global.globalShareInstance.getString(widget.curKey));
    openPokerList = temp["openPoker"] != "" ? jsonDecode(temp["openPoker"]) : [0,0,0,0,0];
    topBaseInfo = {
      "winnerName": widget.winnerName,
      "winnerType": widget.winnerType,
      "winnerScore": widget.winnerScore,
      "blind": temp["matBlind"],
      "handNum": temp["page"],
      "curUserAvatar": Global.currentUser.avatar,
      "curUserNickName": Global.currentUser.nickName,
    };
    Map tempMap;
    List tempUserList;
    for (var item in temp["recordRoundFavoriteList"]) {
      tempMap = {
        "recordRoundNum": item["recordRoundNum"] - 1,
        "pokes":item["recordRoundNum"] == 1 ? [] : openPokerList.getRange( 0, item["recordRoundNum"] + 1).toList(),   // 2（暂时取公牌） 3 4 5张公牌显示
        // "roundType": "SB",     // 当前用户是 SB  BB  才显示这个
        "num": item["totalNumbersOfPlays"].toString(),
        "money": item["poolScore"].toString(),
        "isNotFirst": item["recordRoundNum"] == 1 ? false : true,
      };
      tempUserList = List();
      for (var user in item["recordUserFavoriteList"]) {
        String actionType = getActionName(user["action"]);
        String total = "";
        if (tempMap["isNotFirst"] == false) {
          // 第一回合
          if (user["totalScore"] != null) total = user["totalScore"].toString();
        } else
          total = user["currentMatScore"].toString();
        tempUserList.add({
          "type": user["seatName"],
          "name": user["userName"],
          "sType": actionType == ""
              ? user["seatName"] == "BTN" ? "SB" : user["seatName"]
              : actionType,
          "money": user["totalBet"].toString(),
          "total": total,
          "isMe":
              user["userId"].toString() == Global.currentUser.id ? true : false,
        });
      }
      tempMap["users"] = tempUserList;
      loopInfoTemp.add(tempMap);
    }

    tempMap = {
      "recordRoundNum": 4,
      "pokes": loopInfoTemp.last["pokes"],
      "num": loopInfoTemp.last["num"],
      "money": loopInfoTemp.last["money"],
      "isNotFirst": true,
    };
    tempUserList = List();
    for (var item in temp["recordUserFavoriteSettlementList"]) {
      tempUserList.add({
        "type": item["seatName"],
        "settlementType": item["bluffType"],
        "userName": item["userName"],
        "bluff": item["bluff"] != "" ? jsonDecode(item["bluff"]) : [0,0],
        "settlementScore": item["settlementScore"].toString(),
        "maxPoker": item["maxPoker"] != "" ? jsonDecode(item["maxPoker"]) : [0,0,0,0,0],
        "isMe":
            item["userId"].toString() == Global.currentUser.id ? true : false,
      });
    }
    tempMap["users"] = tempUserList;
    // print(tempMap);
    loopInfoTemp.add(tempMap);
  }

  String getActionName(int actionNum) {
    if (actionNum == 1)
      return "B"; // 加注  下注   改为 R
    else if (actionNum == 2)
      return "C";
    else if (actionNum == 3)
      return "X";
    else if (actionNum == 4)
      return "A";
    else if (actionNum == 5)
      return "F";
    else
      return "";
  }

  // SB：小盲   BB：大盲   X：过牌   B：下注
  // C：跟注     F：弃牌   A：Allin  R：加注
  Widget pokeCell(List pokersList, List maxPokersList) {
    List<Widget> tempWidget = List();
    Widget pokes;
    for (var item in pokersList) {
      tempWidget.add(Container(
          width: ssSetWidth(18.0),
          height: ssSetWidth(25.0),
          margin: EdgeInsets.only(right: 2.5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ssSetWidth(4)),
              border: Border.all(color: Colors.black12, width: 1)),
          child: Stack(
            children: <Widget>[
              ImagesAnim(18.0, 25.0, 0, 0, false, item),
              Positioned(
                  child: Container(
                width: ssSetWidth(18.0),
                height: ssSetWidth(25.0),
                decoration: BoxDecoration(
                  color: (maxPokersList.isEmpty ||
                          (maxPokersList.indexOf(item) == -1))
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.3),
                ),
                // backgroundColor:Colors.grey,
              ))
            ],
          )));
    }
    pokes = Row(
      children: tempWidget,
    );
    return pokes;
  }

  // if item ==   做遮罩   加一个背景，定位到和图片一样位置，层级高些

  Widget roundInfoCell(List usersList, {bool isNotFirst = true}) {
    List<Widget> tempWidget = List();
    Widget pokes;
    for (Map item in usersList) {
      tempWidget.add(Container(
        margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            typeTagView(item["type"]),
            Padding(
              padding: EdgeInsets.only(left: ssSetWidth(15)),
              child: Container(
                width: ssSetWidth(110),
                child: setTextWidget(
                    item["name"],
                    14,
                    false,
                    item["sType"] == "F"
                        ? Color(0xff666666)
                        : item["isMe"] != null
                            ? Color(0xff7EABC8)
                            : Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: ssSetWidth(10)),
              child: typeTagView(item["sType"],
                  size: 20, isRight: true, isMe: item["isMe"]),
            ),
            Padding(
              padding: EdgeInsets.only(left: ssSetWidth(15)),
              child: Container(
                width: ssSetWidth(60),
                child: setTextWidget(
                    "${item["money"]}",
                    14,
                    false,
                    item["sType"] == "F"
                        ? Color(0xff666666)
                        : item["isMe"] != null
                            ? Color(0xff7EABC8)
                            : Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: ssSetWidth(10)),
              child: Container(
                width: ssSetWidth(70),
                child: item["total"] == ""
                    ? SizedBox()
                    : setTextWidget(
                        "${isNotFirst == true ? "P:" : ""}${item["total"]}",
                        14,
                        false,
                        item["sType"] == "F"
                            ? Color(0xff666666)
                            : item["isMe"] != null
                                ? Color(0xff7EABC8)
                                : Colors.white),
              ),
            )
          ],
        ),
      ));
    }
    pokes = Container(
      margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Column(
        children: tempWidget,
      ),
    );
    return pokes;
  }

  Widget typeTagView(String type, {double size, bool isRight, bool isMe}) {
    return type != ""
        ? Container(
            width: ssSetWidth(size ?? 30),
            height: ssSetWidth(20),
            decoration: BoxDecoration(
                color: type == "B"
                    ? Color(0xFF921E1E)
                    : type == "F"
                        ? Color(0xff666666)
                        : (isRight != null ? Color(0xff09CC8A) : lanse),
                borderRadius: BorderRadius.circular(4)),
            child: Center(
              child: setTextWidget(type, 12, false, Colors.white),
            ))
        : SizedBox();
  }

  Widget oneLoopCell(Map roundInfo) {
    return Container(
      color: Color(0xFF1C2029), // style.backgroundColor,
      padding: EdgeInsets.fromLTRB(15, 3, 15, 5),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 7),
                  child: setTextWidget(
                      "${roundName[roundInfo["recordRoundNum"]]}",
                      14,
                      false,
                      Colors.white),
                ),
                pokeCell(roundInfo["pokes"], []),
                // roundInfo["recordRoundNum"] == 0
                // ? Padding(
                // padding: EdgeInsets.only(left: 8),
                // child: typeTagView(roundInfo["roundType"]),
                // )
                // : Expanded(child: SizedBox()),
                Expanded(child: SizedBox()),
                roundInfo["recordRoundNum"] != 0
                    ? Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Image.asset(
                          imgpath + "tab_mine.png",
                          width: ssSetWidth(21),
                          height: ssSetWidth(22),
                        ),
                      )
                    : Expanded(child: SizedBox()),
                roundInfo["recordRoundNum"] != 0
                    ? Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: setTextWidget(roundInfo["num"], 14, false,
                            Colors.white.withOpacity(0.61)),
                      )
                    : Expanded(child: SizedBox()),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Image.asset(
                    imgpath + "mine/chouma.png",
                    width: ssSetWidth(20.29),
                    height: ssSetWidth(20.29),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: setTextWidget(
                      roundInfo["money"], 14, false, Colors.white),
                )
              ],
            ),
          ),
          greyLineUI(0.5),
          roundInfo["recordRoundNum"] == 4
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: settlementEveryoneCell(roundInfo["users"]),
                )
              : Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: roundInfoCell(roundInfo["users"],
                      isNotFirst: roundInfo["isNotFirst"]),
                ),
          greyLineUI(0.5),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: loopInfoTemp[index]["users"].length,
          //   itemBuilder: (context,index){
          //     return Container(color:Colors.blueAccent,height:ssSetWidth(35));
          //   })
        ],
      ),
    );
  }

  Widget settlementEveryoneCell(List sUserList) {
    List<Widget> cellsWidgetList = List();
    for (var item in sUserList) {
      cellsWidgetList.add(Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  typeTagView(item["type"]),
                  setTextWidget(item["settlementType"], 10, false, Colors.white)
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    setTextWidget(
                        item["userName"],
                        12,
                        false,
                        item["isMe"] == true
                            ? Color(0xFF7EABC8)
                            : Colors.white),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        pokeCell(item["bluff"], item["maxPoker"]),
                        SizedBox(
                          width: ssSetWidth(8),
                        ),
                        pokeCell(openPokerList, item["maxPoker"]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: setTextWidget(item["settlementScore"], 14, false,
                      item["isMe"] == true ? Color(0xFF7EABC8) : Colors.white),
                )),
          ],
        ),
      ));
    }
    return Container(child: Column(children: cellsWidgetList));
  }
}
