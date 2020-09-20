import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/widgets/some_widgets.dart';

class MineScoreInfo extends StatefulWidget {
  final String curKey;
  MineScoreInfo(this.curKey);
  @override
  _MineScoreInfoState createState() => _MineScoreInfoState();
}

class _MineScoreInfoState extends State<MineScoreInfo> {
  Map curDataMap;
  String boardKeyContain;

  @override
  void initState() {
    super.initState();
    curDataMap =
        jsonDecode(Global.globalShareInstance.getString(widget.curKey));
    boardKeyContain = widget.curKey.replaceFirst("gameHouseInfoStorage", "boardsMapStorage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,// style.textDivideBlockColor,
      // 战绩列表页 / 游戏结束跳转到这里，返回到相应页面
      appBar: whiteAppBarWidget(
          "${curDataMap["gameHouseOwnerName"]}的牌局", context,
          haveShadowLine: true,
          actions: [
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
      body: Column(
        children: <Widget>[
          Container(
            width: ssSetWidth(375),
            color: style.themeColor,
            padding: EdgeInsets.only(top: 14, left: 15, right: 15, bottom: 14),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    circleMemberAvatar(-1, size: 55),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          setTextWidget(
                              "总手数: ${curDataMap["gameBoardOfTotalNum"]}",
                              14,
                              false,
                              Color(0xffffffff)),
                          setTextWidget("平均底池：${curDataMap["averageAccount"]}",
                              14, false, Color(0xffffffff))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 67),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          setTextWidget(
                              "总带入：${curDataMap["totalTakeIntoScoreOfGameHouse"]}",
                              14,
                              false,
                              Color(0xffffffff)),
                          setTextWidget("最大底池：${curDataMap["maxMatScore"]}", 14,
                              false, Color(0xffffffff))
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            imgpath + "mine/whitecanlendar.png",
                            width: ssSetWidth(14),
                            height: ssSetWidth(14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: ssSetWidth(6)),
                            child: setTextWidget(
                                "${curDataMap["matStartTime"]}",
                                14,
                                false,
                                Color(0xffffffff)),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            imgpath + "mine/whitetype.png",
                            width: ssSetWidth(14),
                            height: ssSetWidth(14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: ssSetWidth(6)),
                            child: setTextWidget("${curDataMap["matBlind"]}",
                                14, false, Color(0xffffffff)),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            imgpath + "mine/whitetime.png",
                            width: ssSetWidth(14),
                            height: ssSetWidth(14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: ssSetWidth(6)),
                            child: setTextWidget("${curDataMap["matTime"]}分钟",
                                14, false, Color(0xffffffff)),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
         // 查看您的本局牌谱  和 是否开了保险   mine/board_rele.png    mine/ins_logo.png
         Container(
           decoration: BoxDecoration(
             color: Color(0xFFDCEDFF)
           ),
           padding: EdgeInsets.fromLTRB(ssSetWidth(15), ssSetWidth(5), ssSetWidth(10), ssSetWidth(5)),
           child: InkWell(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     Image.asset(
                       imgpath+"mine/board_rele.png",
                       width: ssSetWidth(35),
                       height: ssSetWidth(35),
                     ),
                     Padding(
                       padding: EdgeInsets.only(left: ssSetWidth(10)),
                       child: setTextWidget("查看您本局牌谱",
                           16, false, Color(0xFF1479ED)),
                     )
                   ],
                 ),
                 Icon(Icons.arrow_forward_ios,size: ssSetWidth(20),color: Color(0xFF1479ED),),
               ],
             ),
             onTap: (){
              print("查看本局牌谱 $boardKeyContain");
              // 到期后不能查看本局牌谱，参数为 ""
              Application.router.navigateTo(context, "$mineCardsListPath?boardKeyContain=$boardKeyContain&isFromMine=false",
                  transition: TransitionType.inFromRight);
             },
           ),
         ),
         curDataMap["isInsGameHouse"]==false?SizedBox():
         Container(
           padding:EdgeInsets.only(left:ssSetWidth(15),right:ssSetWidth(15),top:ssSetWidth(15)),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Image.asset(
                     imgpath+"mine/ins_log.png",
                     width: ssSetWidth(28.05),
                     height: ssSetWidth(31.03),
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: ssSetWidth(10)),
                     child: setTextWidget("保险池",
                         14, false, Color(0xFF333333)),
                   )
                 ],
               ),
               setTextWidget("${curDataMap["insScoreOfGameBoard"]}",
                   14, true, Color(0xFF333333))
             ],
           ),
         ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: ListView.builder(
                itemCount: curDataMap["gameHouseUserInfoList"].length,
                itemBuilder: (context, index) {
                  Map item = curDataMap["gameHouseUserInfoList"][index];
                  return Container(
                      color: style.backgroundColor,
                      padding: EdgeInsets.only(top: 6, left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              circleMemberAvatar(-1,
                                  avatarPath: item["profileUrl"]),
                              Padding(
                                padding: EdgeInsets.only(left: 9),
                                child: setTextWidget("${item["userName"]}", 14,
                                    false, style.textTitleColor),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 48),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: ssSetWidth(20),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: "带入 ",
                                              style: TextStyle(
                                                  color: style.textTitleColor,
                                                  fontSize: ssSp(12))),
                                          TextSpan(
                                            text:
                                                "${item["totalTakeIntoScore"]}",
                                            style: TextStyle(
                                                color: style.textContextColor,
                                                fontSize: ssSp(12)),
                                          ),
                                        ])),
                                      ),
                                      Container(
                                        height: ssSetWidth(20),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: "手数 ",
                                              style: TextStyle(
                                                  color: style.textTitleColor,
                                                  fontSize: ssSp(12))),
                                          TextSpan(
                                            text: "${item["totalGameNum"]}",
                                            style: TextStyle(
                                                color: style.textContextColor,
                                                fontSize: ssSp(12)),
                                          ),
                                        ])),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                child: setTextWidget("${item["settlement"]}",
                                    14, false, Color(0xff2e9aec),
                                    textAlign: TextAlign.right),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: greyLineUI(1),
                          )
                        ],
                      ));
                }),
          ))
        ],
      ),
    );
  }
}
