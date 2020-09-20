import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/widgets/some_widgets.dart';
import 'package:star/provider/index_page_data_provider.dart';

class MineMain extends StatefulWidget {
  @override
  _MineMainState createState() => _MineMainState();
}

class _MineMainState extends State<MineMain> {
  UserModel _model;
  @override
  void initState() {
    super.initState();
    eventBus.on("mineChanged", (arg) {
      print("用户已登录");
      setState(() {
        _model = arg;
      });
    });
    eventBus.on("onThemeChange", (arg) {
      setState(() {});
    });
  }

  IndexPageDataProvider model = IndexPageDataProvider();

  @override
  Widget build(BuildContext context) {
    return Provide<IndexPageDataProvider>(
      builder:(context,child,model){
        return Scaffold(
          backgroundColor: style.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                mineHeader(),
                shareBar(),
                dataShowBar(model),
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: bottomButtonCell(0, imgpath + "mine/score.png", "战绩"),
                ),
                greyLineUI(0.5,
                    color: style.textDivideLineColor,
                    padding: EdgeInsets.only(left: 15, right: 15)),
                bottomButtonCell(1, imgpath + "mine/cards.png", "牌谱"),
                greyLineUI(0.5,
                    color: style.textDivideLineColor,
                    padding: EdgeInsets.only(left: 15, right: 15)),
                bottomButtonCell(2, imgpath + "mine/data.png", "数据"),
                greyLineUI(0.5,
                    color: style.textDivideLineColor,
                    padding: EdgeInsets.only(left: 15, right: 15)),
                Container(
                  height: ssSetWidth(100),
                )
              ],
            ),
          ),
        );
      }
    );

  }

  toDataInfomationView() {
    Application.router.navigateTo(context, mineDataPath,
        transition: TransitionType.inFromRight);
  }

  toScoreInfomationView() {
    Application.router.navigateTo(context, mineScoreListPath,
        transition: TransitionType.inFromRight);
  }

  toCardsInfomationView() {
    Application.router.navigateTo(context, "$mineCardsListPath?boardKeyContain=''&isFromMine=true",
        transition: TransitionType.inFromRight);
  }

  Widget bottomButtonCell(int index, String image, String text) {
    return Container(
      height: ssSetWidth(54),
      child: labelCell(text, "",
          leftImage: image,
          hasArrow: true,
          func: index == 0
              ? toScoreInfomationView
              : index == 1 ? toCardsInfomationView : toDataInfomationView),
    );
  }

  Widget singleDataBar(String image, String title, String data) {
    return Container(
      height: ssSetWidth(90),
      width: ssSetWidth(375 / 2),
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: style.purityBlockColor,
        borderRadius: BorderRadius.circular(ssSetWidth(6)),
        boxShadow: style.themeType == 0
            ? [
                BoxShadow(
                    color: g99.withOpacity(0.16),
                    offset: Offset(0, 0),
                    blurRadius: 6.0,
                    spreadRadius: 1),
                BoxShadow(color: Color(0xffffffff))
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            image,
            width: ssSetWidth(45),
            height: ssSetWidth(45),
          ),
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                setTextWidget(title, 14, false, Color(0xff666666)),
                setTextWidget(data, 16, true, b33)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget dataShowBar(model) {
    return Container(
      width: ssSetWidth(375),
      height: ssSetWidth(230),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(right: 7.5),
                child: singleDataBar(imgpath + "mine/totalGame.png", "总场次",
                    "${model.mineDataMap["totalOfGameHouse"] ?? 0}"),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 7.5),
                child: singleDataBar(imgpath + "mine/totalHand.png", "总手数",
                    "${model.mineDataMap["totalOfGameBoard"] ?? 0}"),
              )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(right: 7.5),
                  child: singleDataBar(imgpath + "mine/singleGameHeigher.png",
                      "单场最高盈利", "${model.mineDataMap["maxProfitOfGameHouse"] ?? 0}"),
                )),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 7.5),
                        child: singleDataBar(
                            imgpath + "mine/singleHandHeigher.png",
                            "单手最高盈利",
                            "${model.mineDataMap["maxProfitOfGameBoard"] ?? 0}"))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget shareBar() {
    return Container(
      height: ssSetWidth(39),
      width: ssSetWidth(375),
      color: style.shareBarColor,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: <Widget>[
          setTextWidget("分享官网 www.puke.com", 16, false, lanse),
          Expanded(child: SizedBox()),
          Container(
            width: ssSetWidth(21.14),
            height: ssSetWidth(21.14),
            child: InkWell(
              onTap: () {
                print("分享");
                showShareView(context, "https://www.baidu.com");
              },
              child: Image.asset(imgpath + "mine/share.png"),
            ),
          )
        ],
      ),
    );
  }

  Widget mineHeader() {
    return Container(
//      height: ssSetWidth(185)+safeStatusBarHeight(),
      width: ssSetWidth(375),
      padding: EdgeInsets.only(top: safeStatusBarHeight()),
      color: lanse,
      child: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(imgpath + "mine/headerBG.png"),
          ),
          Positioned(
              top: ssSetWidth(9),
              left: ssSetWidth(15),
              child: setTextWidget("我的", 18, true, style.wodeTitle)),
          Container(
            width: ssSetWidth(375),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ssSetWidth(43)),
                  child: _model != null
                      ? circleMemberAvatar(-1,
                          avatarPath: _model.avatar, size: ssSetWidth(62))
                      : Image.asset(
                          imgpath + "defaultAvatar.png",
                          width: ssSetWidth(62),
                          height: ssSetWidth(62),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ssSetWidth(10)),
                  child: setTextWidget(_model != null ? _model.nickName : "",
                      18, false, style.wodeTitle),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: ssSetWidth(2), bottom: ssSetWidth(5)),
                  child: setTextWidget(_model != null ? "ID:${_model.id}" : "",
                      12, false, style.wodeId),
                )
              ],
            ),
          ),
          Container(
            color: style.minePictureMaskColor,
          ),
          Positioned(
              top: ssSetWidth(11),
              right: ssSetWidth(16),
              child: Container(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      Application.router.navigateTo(context, mineSettingPath,
                          transition: TransitionType.inFromRight);
                    },
                    child: Opacity(
                      opacity: style.themeType == 0 ? 1 : 0.7,
                      child: Image.asset(
                        imgpath + "mine/setting.png",
                        width: ssSetWidth(24.09),
                        height: ssSetWidth(23.26),
                      ),
                    )),
              )),
        ],
      ),
    );
  }
}
