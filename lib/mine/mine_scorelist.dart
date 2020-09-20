import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:star/club/club_infomation.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class MineScoreList extends StatefulWidget {
  @override
  _MineScoreListState createState() => _MineScoreListState();
}

class _MineScoreListState extends State<MineScoreList> {
  Widget headerEnView(String title, String number) {
    return Container(
      // height: ssSetWidth(144),
      // width: ssSetWidth(144),
      child: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(number.contains('-')
                ? imgpath + "mine/yellowen.png"
                : imgpath + "mine/blueen.png"),
          ),
          Positioned(
              bottom: ssSetWidth(53),
              child: Container(
                width: ssSetWidth(144),
                child: setTextWidget(title, 12, false, style.backgroundColor,
                    textAlign: TextAlign.center),
              )),
          Positioned(
              top: ssSetWidth(43),
              child: Container(
                width: ssSetWidth(144),
                child: setTextWidget(number, 18, true, b33,
                    textAlign: TextAlign.center),
              ))
        ],
      ),
    );
  }

  Widget gameCell(Map item) {
    return Container(
        height: ssSetWidth(80),
        width: ssSetWidth(375),
        color: style.backgroundColor,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: InkWell(
          onTap: () {
            Application.router.navigateTo(context,
                "$mineScoreInfoPath?curKey=${item["curKey"]}",
                transition: TransitionType.inFromRight);
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    circleMemberAvatar(-1,
                        avatarPath: item["gameHouseOwnerProfile"]),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 11, top: 6, bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              //padding: EdgeInsets.only(top: 13, bottom: 4),
                              child: Row(
                                children: <Widget>[
                                  setTextWidget("${item["gameHouseName"]}", 14,
                                      true, b33),
                                  Container(
                                    margin: EdgeInsets.only(left: 9),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xff1479ed)
                                            .withOpacity(0.21)),
                                    child: setTextWidget(
                                        "  ${item["gameHouseType"]}  ",
                                        12,
                                        false,
                                        lanse),
                                  ),
                                  item["isInsGameHouse"] == false?SizedBox():
                                  Container(
                                    margin: EdgeInsets.only(left: 9),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFFF10F0F)
                                            .withOpacity(0.21)),
                                    child: setTextWidget(
                                        "  保险  ",
                                        12,
                                        false,
                                        Color(0xFFF10F0F)),
                                  ),
                                  Expanded(child: SizedBox()),
                                  setTextWidget(
                                      "${item["matStartTime"]}", 12, false, g99)
                                ],
                              )),
                          setTextWidget(
                              "创建者:${item["gameHouseOwnerName"]}",
                              12,
                              false,
                              b33),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Image.asset(
                                    imgpath + "room_type.png",
                                    width: ssSetWidth(14),
                                    height: ssSetWidth(14),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: ssSetWidth(4)),
                                    child: setTextWidget(
                                        "${item["matBlind"]}", 12, false, b33),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: ssSetWidth(15)),
                                    child: Image.asset(
                                      imgpath + "room_time.png",
                                      width: ssSetWidth(14),
                                      height: ssSetWidth(14),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: ssSetWidth(4)),
                                      child: setTextWidget("${item["matTime"]}",
                                          12, false, b33)),
                                ],
                              ),
                              setTextWidget("who的输赢分数", 12, false, b33)
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              greyLineUI(1)
            ],
          ),
        ));
  }

  List recordDataList = [];
  Map mineDataMap = {};
  @override
  void initState() {
    super.initState();
    dynamic sharedKeysList = Global.globalShareInstance.getKeys().toList();
    if(sharedKeysList.contains("minePageRecordStorage")){
      mineDataMap = jsonDecode(Global.globalShareInstance.getString("minePageRecordStorage"));
    }
    mineDataMap = jsonDecode(Global.globalShareInstance.getString("minePageRecordStorage"));
    for (int i = 0; i < sharedKeysList.length; i++) {
      if (sharedKeysList[i].contains("gameHouseInfoStorage:")) {
        Map temp = jsonDecode(
            Global.globalShareInstance.getString(sharedKeysList[i]));
        temp["curKey"] = sharedKeysList[i];
        // print(temp);
        recordDataList.add(temp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: style.purityBlockColor,
        appBar: whiteAppBarWidget("战绩", context, haveShadowLine: true),
        body: Column(
          children: <Widget>[
            Center(
                child: Container(
              height: ssSetWidth(175),
              width: ssSetWidth(144),
              margin: EdgeInsets.only(top: 15),
              child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return index == 0 ? headerEnView("今日盈利","${mineDataMap["profitOfToday"]}") : index == 1 ? headerEnView("近七日盈利","${mineDataMap["profitOfLastWeek"]}") : headerEnView("近30日盈利","${mineDataMap["profitOfLastMonth"]}");
                  },
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  loop: true,
                  autoplay: false,
                  pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      //margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
                      builder: DotSwiperPaginationBuilder(
                          size: 5,
                          activeSize: 8,
                          color: Color(0xffcccccc),
                          activeColor: lanse)),
//                autoplayDelay: 3000,
                  autoplayDisableOnInteraction: true),
            )),
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 12),
              child: Container(
                width: ssSetWidth(375),
                child: setTextWidget("历史牌局", 16, false, b33),
              ),
            ),
            // if recordDataList != []
            Expanded(
                child: ListView.builder(
                    itemCount: recordDataList.length,
                    itemBuilder: (context, index) {
                      return gameCell(recordDataList[index]);
                    }))
          ],
        ));
  }
}
