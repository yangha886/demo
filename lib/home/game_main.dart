import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provide/provide.dart';
import 'package:sa_anicoto/sa_anicoto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/home/game_timeprofile.dart';
import 'package:star/home/game_var.dart';
import 'package:star/home/person_round_painter.dart';
import 'package:star/httprequest/socketUtil.dart';
import 'package:star/provider/game_dashboard_theme_provider.dart';
import 'package:star/provider/game_message_provier.dart';
import 'package:star/provider/game_openpokers_provider.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/game_widgets.dart';
import 'package:star/widgets/some_widgets.dart';
import 'package:supercharged/supercharged.dart';
import 'package:star/util/pubRequest.dart';
import 'game_sound.dart';

class GameMain extends StatefulWidget {
  @override
  _GameMainState createState() => _GameMainState();
}

class _GameMainState extends State<GameMain> with AnimationMixin, GameVar ,GameTimeProfile{
  //scaffold的key,用于唤醒左右两侧划出视图
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<ImagesAnimState> _leftCardKey = GlobalKey<ImagesAnimState>();
  final GlobalKey<ImagesAnimState> _rightCardKey = GlobalKey<ImagesAnimState>();
  //中间键,用于筹码收集以及发牌动画的起始位置计算
  final GlobalKey _centerPointKey = GlobalKey();
  AnimationController seatController;
  //重设动画控制器
  void allocController() {
    if(controller  == null){
      controller = AnimationController(
          duration: Duration(milliseconds: zuoweiyidong), vsync: this);
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (!gameIsStarted) {
            startSitePosition.clear();
            for (int i = 0; i < numTotal; i++) {
              startSitePosition.add(endSitePosition[i]);
            }
            resetAnimationList();
            setState(() {});
          }
        }
      });
    }else{
      controller.reset();
    }
    if(seatController  == null){
      seatController = AnimationController(
          duration: Duration(milliseconds: zuoweiyidong), vsync: this);
      seatController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          startSitePosition.clear();
          for (int i = 0; i < numTotal; i++) {
            startSitePosition.add(endSitePosition[i]);
          }
          resetAnimationList();
          setState(() {});
        }
      });
    }else{
      seatController.reset();
    }

  }

  //判断是否需要移动座位
  Future<void> calNeedTransSeat(Map userInfo) async {
    if (userInfo["user"]["id"] == int.parse(userModel.id)) {
      //当用户点击某个空座位时,先socket发送命令, 反馈成功后判断当前座位与当时点击的座位号是否相同,不同则进行换位动画,-1判断用于右上角补充记分时(因为没有临时座位号)不需要进行换位
      if (nowCurrentIndex != seatNumTemp && seatNumTemp != -1) {
        seatTrans();
      }
      //判断当前用户是否已经坐下
      if (userInfo["seat"] == 0) {
        isSeated = false;
      } else {
        isSeated = true;
      }

      return null;
    }
  }

  //收集筹码时飞出的筹码组件
  Widget returnCollCallWidget(userInfo, seatNum, i, paddingMode) {
    //当前座位有人 且 已下注 且 正在进行飞出筹码动画 满足条件则显示筹码组件
//    RelativeRect endRect = RelativeRect.fromLTRB(
//        paddingMode == 0
//            ? ssSetWidth(-12-8.0)
//            : ssSetWidth(50 + 7.0),
//        ssSetHeigth(3.5),
//        paddingMode == 0
//            ? ssSetWidth(50+8.0)
//            : ssSetWidth(-19.0),
//        ssSetHeigth(tileHeight) - ssSetHeigth(15.5));
//  if(i == 0 && seatList[seatNum] != null && (seatList[seatNum]["totalBet"] == null || seatList[seatNum]["totalBet"] <= 0)){
//    return SizedBox();
//  }
    return userCallList["${seatNum}_$i"] == null ||
            (seatList[seatNum] == null ||
                seatList[seatNum]["showCall_$i"] == null ||
                seatList[seatNum]["showCall_$i"] == false)
        ? SizedBox()
//        : PositionedTransition(
//      rect: RelativeRectTween(
//        begin: endRect,
//        end:endRect
//      ).animatedBy(controller),
//      child: Container(
//          width: ssSetWidth(13),
//          height: ssSetWidth(13),
////          color: Colors.deepPurpleAccent,
//
//          child: Opacity(
//            opacity: 1,
//            child: Image.asset(
//              userInfo["totalBet"] <= 10
//                  ? imgpath + "game/call_blue.png"
//                  : userInfo["totalBet"] <= 100
//                  ? imgpath + "game/call_yellow.png"
//                  : imgpath + "game/call_red.png",
//              width: ssSetWidth(13),
//              height: ssSetWidth(13),
////                    fit: BoxFit.fitWidth
//            ),
//          )),
//    );
        : PositionedTransition(
            rect: userCallList["${seatNum}_$i"],
            child: Container(
                width: ssSetWidth(13),
                height: ssSetWidth(13),
//                 color: Colors.deepPurpleAccent,
                child: Opacity(
                  opacity: 1,
                  child: Image.asset(
                    i == 1
                        ? imgpath + "game/call_blue.png"
                        : i == 2
                            ? imgpath + "game/call_yellow.png"
                            : i == 3
                                ? imgpath + "game/call_red.png"
                                : userInfo["totalBet"] <= 10
                                    ? imgpath + "game/call_blue.png"
                                    : userInfo["totalBet"] <= 100
                                        ? imgpath + "game/call_yellow.png"
                                        : imgpath + "game/call_red.png",
                    width: ssSetWidth(13),
                    height: ssSetWidth(13),
//                    fit: BoxFit.fitWidth
                  ),
                )),
          );
  }

  //没用
  void userNumberChangeAni() {}
  //筹码从在座玩家视图中飞出动画设置
  void collFirstAni() async {
    int index = 0;
    //收集用户筹码动画效果数据赋值
//    try {
    for (var i = 0; i < seatList.length; i++) {
      //有人且参与游戏且已下注
      final CurvedAnimation curve1 =
          CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
      if (seatList[i] != null &&
          seatList[i]["status"] == 2 &&
          seatList[i]["totalBet"] != null &&
          seatList[i]["totalBet"] != 0.0) {
        gameNumberList["${i}_1"] =
            Tween<double>(begin: seatList[i]["totalBet"], end: 0.0)
                .animate(curve1);
        seatList[i]["totalBet"] = 0.0;

        try {
          //获取筹码飞出动画控制器
          AnimationController cont = collCallFirstController["0"]["$i"]["data"];
          final CurvedAnimation curve =
              CurvedAnimation(parent: cont, curve: defaultCurve);
          userCallList["${i}_0"] = RelativeRectTween(
            begin: choumaPosition["${i}_1"],
            end: choumaPosition["${i}_2"],
          ).animate(curve);
          cont.play();

//            Future.delayed(2600.milliseconds,(){
//              cont.reset();
//              seatList[i]["showCall_0"] = false;
//              setState(() {
//
//              });
//            });
        } catch (e) {
          print("在这里   $e");
        }
        index++;
      }
    }
//    }catch(e){
//      showToast(e);
//    }
    //重设数值动画控制器
    gameNumberController.reset();
    //播放数值动画控制器
    gameNumberController.play();
    // generate5Widget();
  }

  void collInScore(int seatNum) {
    Map data = collCallFirstController["0"]["$seatNum"];
    //用于判断是否需要显示飞出的筹码
    seatList[seatNum]["showCall_0"] = true;
    //获取筹码飞出动画控制器
    AnimationController cont = data["data"];
    final CurvedAnimation curve =
        CurvedAnimation(parent: cont, curve: defaultCurve);
    userCallList["${seatNum}_0"] = RelativeRectTween(
      begin: choumaPosition["${seatNum}_0"],
      end: choumaPosition["${seatNum}_1"],
    ).animate(curve);
    //通过await进行阻塞,延迟20毫秒播放一次飞出动画,形成错乱的动画效果
    cont.play();
  }

  void collWinnerAni() async {
    for (int x = 1; x < 4; x++) {
      for (String item in winnerInfo.keys) {
        int winnerSeat = int.parse(item) - 1;
        //用于判断是否需要显示飞出的筹码
        seatList[winnerSeat]["showCall_$x"] = true;
        try {
          //获取筹码飞出动画控制器
          AnimationController cont =
              collCallFirstController["0"]["$winnerSeat"]["data"];
          //通过await进行阻塞,延迟20毫秒播放一次飞出动画,形成错乱的动画效果
          await Future.delayed((choumajiange).milliseconds, () {
            cont.play();
          });
        } catch (e) {}

        //延迟170后通过赋值隐藏掉飞出的筹码
        Future.delayed((yingjiachoumayanchi).milliseconds, () {
          seatList[winnerSeat]["showCall_$x"] = false;
        });
      }
    }
  }

  //初始化收集筹码动画效果
  void allocShoujichoumaAnimation() {
//    for(var str1 in collCallFirstController.keys){
//      for(var str2 in collCallFirstController[str1].keys){
//        collCallFirstController[str1][str2]["data"].dispose();
//        collCallFirstController[str1][str2]["data"]=null;
//      }
//    }
    //清理当前筹码控制器
//    collCallFirstController.clear();
    //清理筹码动画数据
    userCallList.clear();
    choumaPosition.clear();
    //循环在座用户数据
    for (var i = 0; i < seatList.length; i++) {
      //有人且已参与游戏
      if (seatList[i] != null && seatList[i]["status"] == 2) {

        //每一个座位对应的坐标
        RelativeRect startRect = startSitePosition[i];

        //这里的0不用管, 因为取消了一次飞出多个筹码,现在只飞出一个 所以用了0
        if (collCallFirstController["0"] == null) {
          collCallFirstController["0"] = Map();
        }
        AnimationController cont;
        if(collCallFirstController["0"]["$i"] == null){
          //初始化一个控制器
          cont = createController();
        }else{
          cont = collCallFirstController["0"]["$i"]["data"];
          cont.reset();
        }
        //给动画控制器的Map对象赋值座位以及控制器的信息
        //动画效果持续200毫秒
        cont.play(duration: huiheshoujichouma.milliseconds);
        collCallFirstController["0"]["$i"] = {"index": i, "data": cont};
        //终点X轴
        double x1 = centerOffset.dx + ssSetHeigth(40);
        //起点X轴
        double x2 = startRect.left;
        //终点Y轴
        double y1 = centerOffset.dy - ssSetHeigth(40);
        //起点Y轴
        double y2 = startRect.top;
        //座位视图宽度
        double w = ssSetWidth(50);
//        double h = ssSetWidth(70);
        //筹码组件的宽高
        double w2 = ssSetWidth(7 / 2);
        double h2 = ssSetWidth(7 / 2);

        //计算公式
        //起点:
        // L: 根据座位在左还是右,分别赋值对应的Left位置
        // Top: 0
        // Right:判断座位方向分别赋值
        // Bottom: 块高度-头像高度50 1.5作为偏差量
        //终点:
        // L: 终点X-起点X-组件宽度-3.5偏差量
        // T:终点Y-起点Y
        // R:终点X+视图宽度-起点X-组件宽度+5.5偏差量
        // B:起点Y+视图高度-终点Y-组件高度
        RelativeRect beginRect = RelativeRect.fromLTRB(
            w / 2 - ssSetWidth(6),
            tileHeight / 2 - ssSetWidth(6),
            w / 2 - ssSetWidth(6),
            tileHeight / 2 - ssSetWidth(6));
        RelativeRect midRect = RelativeRect.fromLTRB(
            seatList[i]["mode"] == 0
                ? ssSetWidth(-12 - 8.0)
                : ssSetWidth(50 + 7.0),
            ssSetWidth(2.5),
            seatList[i]["mode"] == 0 ? ssSetWidth(50 + 8.0) : ssSetWidth(-19.0),
            tileHeight - ssSetWidth(14.5));
        RelativeRect endRect = RelativeRect.fromLTRB(
            x1 - x2 - w2 - ssSetWidth(3.5),
            y1 - y2 - ssSetWidth(60),
            x2 + w - x1 - w2 - ssSetWidth(5.5),
            y2 + w - y1 - h2 + ssSetWidth(90));
        //筹码飞出的初始位置(头像中间)
        choumaPosition["${i}_0"] = beginRect;
        //筹码在中间位置
        choumaPosition["${i}_1"] = midRect;
        //筹码飞到下注池的位置
        choumaPosition["${i}_2"] = endRect;
        if (seatList[i]["totalBet"] != null && seatList[i]["totalBet"] > 0) {
          seatList[i]["showCall_0"] = true;

          setState(() {});
        }
        final CurvedAnimation curve =
            CurvedAnimation(parent: cont, curve: defaultCurve);
        userCallList["${i}_0"] = RelativeRectTween(
          begin: choumaPosition["${i}_1"],
          end: choumaPosition["${i}_1"],
        ).animate(curve);
        cont.addStatusListener((status) {
          if (status == AnimationStatus.completed) {

            userCallList["${i}_0"] = RelativeRectTween(
              begin: userCallList["${i}_0"].value,
              end: userCallList["${i}_0"].value,
            ).animate(curve);
            cont.reset();
            if (userCallList["${i}_0"].value == choumaPosition["${i}_2"]) {
              seatList[i]["showCall_0"] = false;
              setState(() {});
            }
          }
        });
        //赢家收集筹码飞出动画预置
        for (int x = 1; x < 4; x++) {
          //初始化一个控制器
          if (collCallFirstController["$x"] == null) {
            collCallFirstController["$x"] = Map();
          }
          AnimationController cont1;
          if(collCallFirstController["$x"]["$i"] == null){
            //初始化一个控制器
            cont1 = createController();
          }else{
            cont1 = collCallFirstController["$x"]["$i"]["data"];
            cont1.reset();
          }
          final CurvedAnimation curve1 =
              CurvedAnimation(parent: cont1, curve: defaultCurve);
          //动画效果持续200毫秒
          cont1.play(duration: huiheshoujichouma.milliseconds);


          //给动画控制器的Map对象赋值座位以及控制器的信息
          collCallFirstController["$x"]["$i"] = {"index": i, "data": cont1};
          userCallList["${i}_$x"] = RelativeRectTween(
            begin: endRect,
            end: beginRect,
          ).animate(curve1);
          cont1.repeat();
        }
      }
    }
  }

  //发牌动画数值
  Future<void> fapaiAnimate() async {
//    return;
    //正在发牌  设置成false
    fapaiEnded = false;
//    for (var str in fapaiControllers.keys){
//      fapaiControllers[str].dispose();
//      fapaiControllers[str]=null;
//    }
    //清理发牌控制器
//    fapaiControllers.clear();
//    //清理发牌动画数值
    fapaiList.clear();
//    try {
    //先竖着的牌子分发
//    await Future.delayed(400.milliseconds);
    for (var i = 0; i < seatList.length; i++) {
      if (seatList[i] != null) {
        if ((seatList[i]["status"] == 2)) {
          GameSound.getInstance().playAudio1("fapai2");


          //计算发牌起始点坐标
          RelativeRect startRect = startSitePosition[i];

          AnimationController cont;
          if(fapaiControllers["${i}_f"] == null ){
            cont = createController();
          }else {
            cont = fapaiControllers["${i}_f"];
            cont.reset();
          }
          cont.play(duration: iszhongtu ? 0.milliseconds: fapaiTime.milliseconds);
          final CurvedAnimation curve = CurvedAnimation(parent: cont, curve: defaultCurve);
          fapaiControllers["${i}_f"] = cont;
          //这里的计算差不多同筹码飞出动画的计算,略有部分数值不同而已
          double x1 = centerOffset.dx + ssSetWidth(40);
          double x2 = startRect.left;
          double y1 = centerOffset.dy - ssSetWidth(40);
          double y2 = startRect.top;
          double w = ssSetWidth(50);
          double w2 = ssSetWidth(21.5 / 2);
          double h2 = ssSetWidth(16 / 2);

          RelativeRect fapaiBegin = RelativeRect.fromLTRB(
              x1 - x2 - 21.5,
              y1 - y2 - ssSetWidth(8),
              -(x1 - x2 + 21.5 - w),
              -(y1 - y2 - w + ssSetWidth(16)));
          fapaiCenterPoint["${i}_l"] = fapaiBegin;
          //当前座位为当前玩家所在位置, 所以需要另外一种计算方式
          if (i == nowCurrentIndex && isSeated) {
            print("$i 桌 是自己1");
            w2 = ssSetWidth(48 / 2);
            h2 = ssSetWidth(60 / 2);
            fapaiList["${i}_first"] = RelativeRectTween(
                    begin: RelativeRect.fromLTRB(ssSetWidth(375 / 2 - 10),
                        y1 - h2 - w, ssSetWidth(375 / 2 - 10), y1 + h2),
                    end: leftHandPokerRect)
                .animate(curve);
            Future.delayed(iszhongtu ? 0.milliseconds:(wodepaiewai + fapaiTime).milliseconds, () {

              _leftCardKey.currentState.setCardNum(myHandPoker[0]["id"]);
            });
          } else {
            fapaiList["${i}_first"] = RelativeRectTween(
              begin: fapaiBegin,
              end: RelativeRect.fromLTRB(
                  seatList[i]["mode"] == 0 ? ssSetWidth(-2) : ssSetWidth(29),
                  seatList[i]["mode"] == 0
                      ? ssSetWidth(25.5)
                      : ssSetWidth(25.5),
                  seatList[i]["mode"] == 0 ? ssSetWidth(33.5) : ssSetWidth(2.5),
                  seatList[i]["mode"] == 0 ? ssSetWidth(0) : ssSetWidth(0)),
            ).animate(curve);
          }

          await Future.delayed(iszhongtu ? 0.milliseconds:fapaijiange.milliseconds, () {
            cont.play();
          });
        }
      }
    }
//      // 再分发一圈第二张牌子
    for (var i = 0; i < seatList.length; i++) {
      if (seatList[i] != null && (seatList[i]["status"] == 2)) {
        GameSound.getInstance().playAudio1("fapai2");

        RelativeRect startRect = startSitePosition[i];
        AnimationController cont;
        if(fapaiControllers["${i}_s"] == null){
          cont = createController();
        }else{
          cont = fapaiControllers["${i}_s"];
          cont.reset();
        }
        final CurvedAnimation curve =
        CurvedAnimation(parent: cont, curve: defaultCurve);
        cont.play(duration: iszhongtu ? 0.milliseconds:fapaiTime.milliseconds);
        fapaiControllers["${i}_s"] = cont;

        double x1 = centerOffset.dx + ssSetWidth(40);
        double x2 = startRect.left;
        double y1 = centerOffset.dy - ssSetWidth(40);
        double y2 = startRect.top;
        double w = ssSetWidth(50);
        double w2 = ssSetWidth(23.5 / 2);
        double h2 = ssSetWidth(19 / 2);
        RelativeRect fapaiBegin = RelativeRect.fromLTRB(
            x1 - x2 - 21.5 + ssSetWidth(4),
            y1 - y2 - ssSetWidth(8) + ssSetWidth(2),
            -(x1 - x2 + 21.5 - w + ssSetWidth(4)),
            -(y1 - y2 - w + ssSetWidth(16) + ssSetWidth(2)));
        fapaiCenterPoint["${i}_r"] = fapaiBegin;
        if (i == nowCurrentIndex && isSeated) {
          print("$i 桌 是自己2");
          w2 = ssSetWidth(48 / 2);
          h2 = ssSetWidth(60 / 2);
          fapaiList["${i}_second"] = RelativeRectTween(
                  begin: RelativeRect.fromLTRB(ssSetWidth(375 / 2 - 10),
                      y1 - h2 - w, ssSetWidth(375 / 2 - 10), y1 + h2),
                  end: rightHandPokerRect)
              .animate(curve);
          Future.delayed(iszhongtu ? 0.milliseconds:(wodepaiewai + fapaiTime).milliseconds, () {
            _rightCardKey.currentState.setCardNum(myHandPoker[1]["id"]);
          });
        } else {
          fapaiList["${i}_second"] = RelativeRectTween(
            begin: fapaiBegin,
            end: RelativeRect.fromLTRB(
                seatList[i]["mode"] == 0 ? ssSetWidth(2.5) : ssSetWidth(33.5),
                seatList[i]["mode"] == 0 ? ssSetWidth(27) : ssSetWidth(27),
                seatList[i]["mode"] == 0 ? ssSetWidth(29) : ssSetWidth(-2),
                seatList[i]["mode"] == 0 ? ssSetWidth(-1.5) : ssSetWidth(-1.5)),
          ).animate(curve);
        }
        await Future.delayed(iszhongtu ? 0.milliseconds:fapaijiange.milliseconds, () {
          cont.play();
        });
      }
    }

    Future.delayed(iszhongtu ? 0.milliseconds:fapaiTime.milliseconds, () {

      fapaiEnded = true;
      if (callData != null) playerRoundAni(null, true);
      setState(() {});
    });

    return null;
  }

  Future<void> isnewdeal() {
    _leftCardKey.currentState?.reSetController();
    _rightCardKey.currentState?.reSetController();
    tempOpPoker.clear();
    pokesWidgets = [
      SizedBox(
        width: ssSetWidth(midPokW + midPokR),
        height: ssSetWidth(midPokH),
      ),
      SizedBox(
        width: ssSetWidth(midPokW + midPokR),
        height: ssSetWidth(midPokH),
      ),
      SizedBox(
        width: ssSetWidth(midPokW + midPokR),
        height: ssSetWidth(midPokH),
      ),
      SizedBox(
        width: ssSetWidth(midPokW + midPokR),
        height: ssSetWidth(midPokH),
      ),
      SizedBox(
        width: ssSetWidth(midPokW + midPokR),
        height: ssSetWidth(midPokH),
      ),
    ];
    fenchiList = null;
    baoxianData = null;
    final CurvedAnimation curve =
        CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
    gameNumberList["game_total"] = gameCallTotal.tweenTo(0.0).animate(curve);
    gameNumberList["round_total"] = roundCallTotal.tweenTo(0.0).animate(curve);
    gameNumberList["game_total"].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        gameNumberList["game_total"] = Tween<double>(
                begin: gameNumberList["game_total"].value,
                end: gameNumberList["game_total"].value)
            .animate(curve);
      }
    });
    gameCallTotal = 0.0;
    roundCallTotal = 0.0;

    for (Map item in seatList) {
      if (item != null) {
        item["status"] = 1;
        item["isAllin"] = null;
      }
    }
    return null;
  }

  Future<void> forUsrLis(temp, isNewRound, i) {
    Map temp1 = temp["recordUserList"] != null ? temp["recordUserList"][i] :temp["recordUserOfflineList"][i] ;
    if (isNewRound) {
      seatList[temp1["seat"] - 1]["bluff"] = null;
    }
    seatList[temp1["seat"] - 1]["status"] = 2;
    seatList[temp1["seat"] - 1]["totalBet"] = temp1["totalBet"] == null ? 0.0 :temp1["totalBet"].toDouble();
    if(!iszhongtu)
    seatList[temp1["seat"] - 1]["totalScore"] = temp1["totalScore"] == null ? 0.0 :temp1["totalScore"].toDouble();
    seatList[temp1["seat"] - 1]["action"] = temp1["action"];

    seatList[temp1["seat"] - 1]["userType"] = temp1["userType"];
    if (temp1["userType"] != null && temp1["userType"] == 3) {
      RelativeRect rect = startSitePosition[temp1["seat"] - 1];
      int paddingMode = seatList[temp1["seat"] - 1]["mode"];
      RelativeRect _rec = RelativeRect.fromLTRB(
          rect.left -
              (paddingMode == 2
                  ? ssSetWidth(14.0 + 5)
                  : paddingMode == 3
                      ? -ssSetWidth(50.0 + 4.5)
                      : paddingMode == 0
                          ? ssSetWidth(0)
                          : -ssSetWidth(50 - 13.0)),
          rect.top +
              (paddingMode == 2
                  ? 0
                  : paddingMode == 1
                      ? ssSetWidth(77 + 2.5)
                      : paddingMode == 3
                          ? ssSetWidth(77 - 12.5)
                          : ssSetWidth(77 + 2.5)),
          rect.right -
              (paddingMode == 2
                  ? -ssSetWidth(50 + 6.0)
                  : paddingMode == 1
                      ? 0
                      : paddingMode == 3
                          ? ssSetWidth(14.0 + 2.5)
                          : -ssSetWidth(50 - 14.0)),
          rect.bottom +
              (tileHeight) -
              (paddingMode == 2
                  ? ssSetWidth(13)
                  : paddingMode == 1
                      ? ssSetWidth(77.0 + 14 + 1.0)
                      : paddingMode == 3
                          ? ssSetWidth(77)
                          : ssSetWidth(77 + 14.0 + 1.0)));
      if (lastZhuangjiaTagAnimation == null) {
        lastZhuangjiaTagAnimation = gameZhuangjiaTagAnimation = _rec;
      } else {
        gameZhuangjiaTagAnimation = _rec;
      }
      gameZhuangjiaTagController.play();
    }
//      seatList[temp1["seat"] - 1]["bluff"] = temp1["bluff"];
    //重新赋值数值
    final CurvedAnimation curve =
        CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
    if(!iszhongtu)
    gameNumberList["${temp1["seat"] - 1}_0"] = Tween<double>(
            begin:temp1["totalScore"] == null ? 0.0: temp1["totalScore"].toDouble(),
            end: temp1["totalScore"] == null ? 0.0:temp1["totalScore"].toDouble())
        .animate(curve);

    gameNumberList["${temp1["seat"] - 1}_1"] = Tween<double>(
            begin:temp1["totalBet"] == null ? 0.0: temp1["totalBet"].toDouble(),
            end: temp1["totalBet"] == null ? 0.0:temp1["totalBet"].toDouble())
        .animate(curve);

    if (isNewRound) {
      roundCallTotal += temp1["bet"].toDouble();
    }
    return null;
  }
  int nowGameBoardId;
  Future<void> newRound(arg, bool isNewRound) async {

    //回合
    autoAction = 0;
    print("一回合开始");
    iszhongtu = false;
    Map temp = arg["data"]["data"];
    final CurvedAnimation curve =
    CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
    if (isNewRound) {

      nowGameBoardId = temp["recordUserList"].first["gameBoardId"];
      print("当前牌局id=$nowGameBoardId");
      await isnewdeal();
      //循环用户列表
      for (var i = 0; i < temp["recordUserList"].length; i++) {
        await forUsrLis(temp, isNewRound, i);
      }
      gameNumberList["round_total"] =
          0.0.tweenTo(roundCallTotal).animate(curve);
    }else{
      for (int i = 0; i < seatList.length; i++) {
        if (seatList[i] != null) {
          if (seatList[i]["action"] != null && seatList[i]["action"] != 5) {
            seatList[i]["action"] = 0;
          }
        }
      }
    }

    //总底池+=当前回合底池
    gameNumberList["game_total"] =
        gameCallTotal.tweenTo(temp["matScoreCard"].toDouble()).animate(curve);
    //赋值新的总底池
    gameCallTotal = temp["matScoreCard"].toDouble();
    //matScoreCardCurrent
    //清零

    gameNumberController.reset();
    gameNumberController.play();
    //刷新公牌信息
    openPokers = arg["data"]["data"]["openPokerGroup"] == ""
        ? null
        : jsonDecode(arg["data"]["data"]["openPokerGroup"]);
    Provide.value<GameOpenPokersProvider>(context).setOpenpokes(openPokers);
    if (openPokers != null) {
      isFanpai = true;
      if (tempOpPoker.length != openPokers.length) {
        getPubPokeWid();
      }
      await Future.delayed(huihejiangongpaijiange.milliseconds, () {
        isFanpai = false;
      });
      await checkNextS();
    }
    //游戏已开局
    gameIsStarted = true;

    setState(() {});
    return null;
  }
  //用户回合
  void playerRoundAni(arg, bool isMe) {
    //我的回合
    if (isMe) {
      if (arg != null) callData = arg["data"]["data"];
      if (callData["follow"] != null && callData["follow"]["followBet"] <= 0) {
        callData["follow"] = null;
      }
      if (callData["multiplying"] is Map) {
        Map multiList = callData["multiplying"];
        List tes = [];
        if (multiList != null)
          for (var item in multiList.keys) {
            if (item == "minCall") {
              minCall = multiList[item];
              continue;
            } else if (item == "maxCall") {
              maxCall = multiList[item];
              continue;
            }
            tes.add({"name": item, "value": multiList[item]});
          }
        if (tes.length > 0) {
          tes.sort((a, b) => (a["value"]).compareTo(b["value"]));
        }
        if (minCall == maxCall) callData["call"] = null;
        callData["multiplying"] = tes;
      }
      if(callData["isRoundFirst"] != null && callData["isRoundFirst"]["isRoundFirst"].toString() == "1"){
        autoAction = 0;
      }
      //自动弃牌或让牌
      if (autoAction == 1) {
        autoPass();
        autoAction = 0;
        setState(() {});
      }
      //自动让牌
      else if (autoAction == 2 && callData["pass"] != null) {
        sendSocketMsg({
          "messageType": SocketMessageType().GAME_ACTION_REQUEST,
          "gameActionType": GameActions().PASS,
          "bet": "0.0",
          "gameHouseId": nowRoomInfo["id"]
        });
        setState(() {});
        return;
      }
      autoAction = 0;
      //我的回合
      isMyRound = true;
      hiddenJiazhuButton = false;
      setState(() {});
      GameSound.getInstance().playAudio2("kuaijiejiazhuchuxian");
      gameButtonPositionController.reset();
      gameButtonPositionController.play();
      alphaController.reset();
      alphaController.play();
    } else {
      //先循环把所有的在玩玩家的 isHandle设为false
      for (Map item in seatList) {
        if (item != null && item["isHandle"] == true) {
          item["isHandle"] = false;
        }
      }
      //把当前出手玩家的isHandle设为true
      seatList[arg["data"]["data"] - 1]["isHandle"] = true;
      //导火索动画
      allocUserRoundStrokeAnimate();
      setState(() {});
    }
  }

  bool isAccess = false;
  Future<void> checkNextS() async {
    if (argData["wdhh"] != null && argData["wdhh"]["data"]["data"]["gameBoardId"]["gameBoardId"] == nowGameBoardId) {
      //用户出手
      print("我的回合");
      if (!gameEnd && fapaiEnded)
        playerRoundAni(argData["wdhh"], true);
      else {
        if (!fapaiEnded) {
          callData = argData["wdhh"]["data"]["data"];
        } else {
          setState(() {});
          playerRoundAni(argData["wdhh"], true);
        }
      }
      argData["wdhh"] = null;
    }
    if (argData["mwjhh"] != null) {
      print("${argData["mwjhh"]["data"]["data"] - 1}玩家回合");
      //同我的回合的判断
      playerRoundAni(argData["mwjhh"], false);
      argData["mwjhh"] = null;
    }
    if (argData["4"] != null) {
      Map _ = argData["4"];
      argData["4"] = null;
      await newRound(_, false);
//      await Future.delayed(0.5.seconds);
    }
    if (argData["5"] != null) {
      Map _ = argData["5"];
      argData["5"] = null;
      await newRound(_, false);
      await Future.delayed(2.seconds);
    }
    if (argData["xiupai"] != null) {
      showpai(argData["xiupai"]);
      argData["xiupai"] = null;
    }
    if (argData["bidaxiao"] != null) {
      bidaxiao(argData["bidaxiao"]);
      argData["bidaxiao"] = null;
      await Future.delayed(1.seconds);
    }
    if (argData["bufen"] != null) {
      bufen(argData["bufen"]);
      argData["bufen"] = null;
    }
    return null;
  }

  void bidaxiao(arg) {
    if(overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
    callData = null;
    gameEnd = true;

    for (Map item in seatList) {
      if (item != null) {
        item["showCall_0"] = null;
        item["totalBet"] = 0.0;
      }
    }
    print("赢家信息:===>$arg");
    //赢家信息
    Map tempWinnerInfo = jsonDecode(arg["data"]["data"]["winnerMsg"]);
    if(winnerInfo == null){
      winnerInfo = Map();
    }
    winnerInfo.clear();

    for (String item in tempWinnerInfo.keys) {
      for (int i =0;i<seatList.length;i++) {
        Map user = seatList[i];
        if(user != null && item == user["user"]["id"].toString()){
          winnerInfo["${i+1}"] = tempWinnerInfo[item];
          break;
        }
      }
    }
    collWinnerAni();
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: defaultCurve);
    final CurvedAnimation curve1 =
        CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
    //赢家结算分
    for (String item in winnerInfo.keys) {
      //"我赢啦!"的动画效果
      if (isSeated && item == (nowCurrentIndex + 1).toString()) {
        GameSound.getInstance().playAudio("sng_winner");
        winnerAnimation = RelativeRectTween(
                begin: RelativeRect.fromLTRB(
                    0, -ssSetHeigth(70), 0, ssSetHeigth(70 + 70.0 + 30)),
                end: RelativeRect.fromLTRB(-ssSetWidth(40), -ssSetHeigth(100),
                    -ssSetWidth(40), ssSetHeigth(70 + 60.0)))
            .animate(curve);
      } else {
        GameSound.getInstance().playAudio("choumafageiyingjia");
      }
      winnerScoreAnimation = RelativeRectTween(
              begin: RelativeRect.fromLTRB(0, 0, 0, 0),
              end: RelativeRect.fromLTRB(
                  0, -ssSetHeigth(50), 0, ssSetHeigth(70 + 30.0)))
          .animate(curve);
      controller.reset();
      controller.play();
      //结算分数变动 + 计算分
      gameNumberList["${int.parse(item) - 1}_0"] = Tween<double>(
              begin: seatList[int.parse(item) - 1]["totalScore"].toDouble(),
              end: double.parse(winnerInfo[item]) +
                  seatList[int.parse(item) - 1]["totalScore"].toDouble())
          .animate(curve1);
//
//            double tempha= double.parse(winnerInfo[item]);
//            winnerInfo[item] = "${double.parse(winnerInfo[item]) - seatList[int.parse(item) - 1]["totalScore"].toDouble()}";
      seatList[int.parse(item) - 1]["totalScore"] =
          double.parse(winnerInfo[item]) +
              seatList[int.parse(item) - 1]["totalScore"].toDouble();
    }
    if (arg["data"]["data"]["scoreBack"] != null) {
      Map tempscoreBakc = jsonDecode(arg["data"]["data"]["scoreBack"]);
      Map scoreBakc = Map();
      if (tempscoreBakc != null) {
        for (String item in tempscoreBakc.keys) {
          for (int i =0;i<seatList.length;i++) {
            Map user = seatList[i];
            if(item == user["user"]["id"].toString()){
              scoreBakc["${i+1}"] = tempscoreBakc[item];
              break;
            }
          }
        }
      }

      if (scoreBakc.keys.length >0) {
        //退分
        for (String item in scoreBakc.keys) {
          gameNumberList["${int.parse(item) - 1}_0"] = Tween<double>(
                  begin: seatList[int.parse(item) - 1]["totalScore"].toDouble(),
                  end: double.parse(scoreBakc[item]))
              .animate(curve1);
          seatList[int.parse(item) - 1]["totalScore"] =
              double.parse(scoreBakc[item]);
        }
      }
    }

    setState(() {});
    print("游戏结束,比大小");
    //重设
    gameNumberController.reset();
    //播放
    gameNumberController.play();

    Future.delayed(jinruxiayiju.seconds, () async{
//            gameIsStarted= false;
      callData = null;
      gameEnd = false;
      winnerInfo = null;
      myHandPoker.clear();
      myHandPokerType = null;
      checkSession();
    });
  }

  void showpai(arg) {
    callData = null;
    for (var item in arg["data"]["data"]) {
      seatList[item["seat"] - 1]["bluff"] = item["bluff"];
    }
    setState(() {});
  }

  void bufen(arg) {
    List temp = arg["data"]["data"];
    for (int i = 0; i < temp.length; i++) {
      seatList[temp[i] - 1]["action"] = 1;
      if (temp[i] - 1 == nowCurrentIndex && isSeated && !showInScoreDialog) {
        showInScoreDialog = true;
        showDialog(
            barrierDismissible: false,
            context: context,
            child: GetInScore(
                context,
                1,
                nowRoomInfo["matMinScorecard"].toDouble(),
                nowRoomInfo["matMaxScorecard"].toDouble(), (score) {
              showInScoreDialog = false;
              if (score == null) return;
              sendSocketMsg({
                "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                "gameHouseMessage":
                    HouseMessageType().SCORE_USR_TO_HOUSE_OWNER_REQUEST,
                "score": score.toStringAsFixed(0),
                "gameHouseId": nowRoomInfo["id"]
              });
            }));
      }
    }
  }

  void checkSession() async {
    if (argData["kaiju"] != null) {
      print("已经ka8iju");
      await kaixinju(argData["kaiju"]);
    }
    if (argData["fapai"] != null) {
      await Future.delayed(0.2.seconds,() async{
        //单纯更新手牌类型
        if (argData["fapai"]["data"]["data"]["bluff"] == null ||
            jsonDecode(argData["fapai"]["data"]["data"]["bluff"]).length == 0) {
          myHandPokerType = argData["fapai"]["data"]["data"]["type"];
          setState(() {});
        } else {
          myHandPoker = jsonDecode(argData["fapai"]["data"]["data"]["bluff"]);
          myHandPokerType = argData["fapai"]["data"]["data"]["type"];
          GameSound.getInstance().playAudio1("fapai2");
          await fapaiAnimate();
        }
      });
    }
    if (argData["fapai1"] != null) {
      //手牌
      print("发放其他人手牌");
      await fapaiAnimate();
    }
    if (argData["wdhh"] != null) {
      //用户出手
      print("我的回合");
      if (!gameEnd && fapaiEnded)
        playerRoundAni(argData["wdhh"], true);
      else {
        if (!fapaiEnded) {
          callData = argData["wdhh"]["data"]["data"];
        } else {
          setState(() {});
          playerRoundAni(argData["wdhh"], true);
        }
      }
    }
    if (argData["mwjhh"] != null) {
      print("${argData["mwjhh"]["data"]["data"] - 1}玩家回合");
      //同我的回合的判断
      playerRoundAni(argData["mwjhh"], false);
    }
    argData.clear();
  }

  Future<void> kaixinju(arg) async {
    //设置新的回合数据
    newRound(arg, true).then((value) => allocShoujichoumaAnimation());
    //初始化收集筹码动画
  }

  void fpskjdfl(arg) async {
    gameEnd = false;
    winnerInfo = null;
    if (arg != null) {
      myHandPoker = jsonDecode(arg["data"]["data"]["bluff"]);
      myHandPokerType = arg["data"]["data"]["type"];
    }

    await fapaiAnimate();
  }
  void zhongtujinru(arg)async{
    Map data = arg["data"];
    gameIsStarted =true;
    iszhongtu = true;
    autoAction = 0;
    print("一回合开始");
    final CurvedAnimation curve =
    CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
//    nowGameBoardId = data["recordUserList"].first["gameBoardId"];
    nowGameBoardId =1;
    print("当前牌局id=$nowGameBoardId");

    await isnewdeal();

    for (var i = 0; i < data["recordUserOfflineList"].length; i++) {
//      print("$i ===========");
      await forUsrLis(data, true, i);
    }
    roundCallTotal = data["matScoreCardCurrent"].toDouble();
    gameNumberList["round_total"] =
        0.0.tweenTo(roundCallTotal).animate(curve);

    //总底池+=当前回合底池
    gameNumberList["game_total"] =
        gameCallTotal.tweenTo(data["matScoreCard"].toDouble()).animate(curve);
    //赋值新的总底池
    gameCallTotal = data["matScoreCard"].toDouble();
    //清零

    gameNumberController.reset();
    gameNumberController.play();
    openPokers = data["openPokerGroup"] == ""
        ? null
        : jsonDecode(data["openPokerGroup"]);
    Provide.value<GameOpenPokersProvider>(context).setOpenpokes(openPokers);
    if (openPokers != null) {
      isFanpai = true;
      if (tempOpPoker.length != openPokers.length) {
        getPubPokeWid();
      }
      await Future.delayed(iszhongtu ? 1.milliseconds:huihejiangongpaijiange.milliseconds, () {
        isFanpai = false;
      });
    }
    allocShoujichoumaAnimation();
    await fapaiAnimate();
  }

  // 当前房间维护一个看客列表
  List audiencesList = [];
  //所有的socket响应都在这里处理
  void allocEventBus() {
    eventBus.on("zhongtu", (arg) async {
      print("jieshou1");
      print("6000中途进入");
      print(arg);

      await Future.delayed(0.5.seconds,(){zhongtujinru(arg["data"]);});
    });
    eventBus.on("gameSession", (arg) async {
      print("jieshou132");
      try {
        //房间相关命令
        if (arg["messageType"] == SocketMessageType().GAME_HOUSE_RESPONSE) {
          if (int.parse(arg["data"]["msg"]) ==
              HouseMessageType().SEAT_MESSAGE) {
            print("有人站起/坐下");
            //座位信息
            Map userInfo = arg["data"]["data"];
            bool haveThisUser = false;
            //刷新用户的积分数值并动画
            for (int i = 0; i < usersList.length; i++) {
              Map temp = usersList[i];
              if (temp["user"]["id"] == userInfo["user"]["id"]) {
                print("用户数组含有该玩家,实行覆盖");
                if (usersList[i]["status"] == 2) {
                  Map tem = userInfo;
                  userInfo = usersList[i];
                  userInfo["totalScore"] = arg["data"]["data"]["totalScore"];
                  userInfo["seat"] = tem["seat"];
                }
                usersList[i] = userInfo;
                haveThisUser = true;
                break;
              }
            }
            //当前用户列表没有该玩家则新增
            if (!haveThisUser) {
              usersList.add(userInfo);
              print("用户数组里没有这个用户,正在添加");
            }
            print(
                "当前用户ID=${userInfo["user"]["id"]} , 起始分数=${userInfo == null ? 0.0 : userInfo["totalScore"].toDouble()},结束分数=${userInfo["totalScore"].toDouble()}");
            final CurvedAnimation curve = CurvedAnimation(
                parent: gameNumberController, curve: defaultCurve);
            gameNumberList["${userInfo["seat"] - 1}_0"] = Tween<double>(
                    begin: userInfo["totalScore"].toDouble(),
                    end: userInfo["totalScore"].toDouble())
                .animate(curve);
            gameNumberList["${userInfo["seat"] - 1}_0"]
                .addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                gameNumberList["${userInfo["seat"] - 1}_0"] = Tween<double>(
                        begin:
                            gameNumberList["${userInfo["seat"] - 1}_0"].value,
                        end: gameNumberList["${userInfo["seat"] - 1}_0"].value)
                    .animate(curve);
              }
            });

            //刷新座位数据
            refreshSeatInfo();
            //判断是否需要旋转座位
            calNeedTransSeat(userInfo);
            if(gameIsStarted){
              lastZhuangjiaTagAnimation = gameZhuangjiaTagAnimation = null;
              Future.delayed((zuoweiyidong+100).milliseconds,(){
                allocShoujichoumaAnimation();
                for(var temp1 in seatList){
                  if (temp1 != null && temp1["userType"] != null && temp1["userType"] == 3) {
                    RelativeRect rect = startSitePosition[temp1["seat"] - 1];
                    int paddingMode = seatList[temp1["seat"] - 1]["mode"];
                    RelativeRect _rec = RelativeRect.fromLTRB(
                        rect.left -
                            (paddingMode == 2
                                ? ssSetWidth(14.0 + 5)
                                : paddingMode == 3
                                ? -ssSetWidth(50.0 + 4.5)
                                : paddingMode == 0
                                ? ssSetWidth(0)
                                : -ssSetWidth(50 - 13.0)),
                        rect.top +
                            (paddingMode == 2
                                ? 0
                                : paddingMode == 1
                                ? ssSetWidth(77 + 2.5)
                                : paddingMode == 3
                                ? ssSetWidth(77 - 12.5)
                                : ssSetWidth(77 + 2.5)),
                        rect.right -
                            (paddingMode == 2
                                ? -ssSetWidth(50 + 6.0)
                                : paddingMode == 1
                                ? 0
                                : paddingMode == 3
                                ? ssSetWidth(14.0 + 2.5)
                                : -ssSetWidth(50 - 14.0)),
                        rect.bottom +
                            (tileHeight) -
                            (paddingMode == 2
                                ? ssSetWidth(13)
                                : paddingMode == 1
                                ? ssSetWidth(77.0 + 14 + 1.0)
                                : paddingMode == 3
                                ? ssSetWidth(77)
                                : ssSetWidth(77 + 14.0 + 1.0)));
                    if (lastZhuangjiaTagAnimation == null) {
                      lastZhuangjiaTagAnimation = gameZhuangjiaTagAnimation = _rec;
                    } else {
                      lastZhuangjiaTagAnimation = gameZhuangjiaTagAnimation = _rec;
                    }
                    gameZhuangjiaTagController.play();
                  }
                }
              });


            }
            //数值动画播放
            gameNumberController.reset();
            gameNumberController.play();
            //当前用户为自己
            if (userInfo["user"]["id"].toString() == userModel.id) {
              if (userInfo["seat"] != 0) {
                isSeated = true;
              } else {
                isSeated = false;
              }
              if (userInfo["seat"] != 0 && !isAccess) {
                if (!isSeated) {
                  GameSound.getInstance().playAudio2("zuoxia");
                }
                //判断总积分是否小于10, 提示带入积分
                if (userInfo["totalScore"] < 10.0 && !showInScoreDialog) {
                  showInScoreDialog = true;
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      child: GetInScore(
                          context,
                          1,
                          nowRoomInfo["matMinScorecard"].toDouble(),
                          nowRoomInfo["matMaxScorecard"].toDouble(), (score) {
                        showInScoreDialog = false;
                        if (score == null) return;
                        print('带入积分===>${score.toStringAsFixed(0)}');
                        sendSocketMsg({
                          "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                          "gameHouseMessage": HouseMessageType()
                              .SCORE_USR_TO_HOUSE_OWNER_REQUEST,
                          "score": score.toStringAsFixed(0),
                          "gameHouseId": nowRoomInfo["id"]
                        });
                      }));
                }
              }
            }
          } else if (int.parse(arg["data"]["msg"]) == 3002) {
            showToast(arg["data"]["data"]);
          } else if (int.parse(arg["data"]["msg"]) ==
              HouseMessageType().LEAVE_HOUSE_RESPONSE) {
            print("离开房间");
            //离开房间
            Map userInfo = arg["data"]["data"];
            for (int i = 0; i < usersList.length; i++) {
              Map temp = usersList[i];
              if (temp["user"]["id"] == userInfo["user"]["id"]) {
                usersList.removeAt(i);
                break;
              }
            }
            refreshSeatInfo();
          } else if (int.parse(arg["data"]["msg"]) ==
              HouseMessageType().START_GAME) {
            print("房主开始游戏");
            //开始游戏
            gameIsStarted = true;
            setState(() {});
          } else if (HouseMessageType().SCORE_HOUSE_OWNER_TO_SERVER_RESULT ==
              int.parse(arg["data"]["msg"])) {
            print("落座申请请求结果");
            if (arg["data"]["data"]["isAccess"] == false) {
              showToast("补分申请被拒绝");
              isAccess = false;
            } else {
              showAlertView(context, "补分申请", "补分申请通过,等待下一局更新积分", null, "我知道了",
                  () {
                Navigator.pop(context);
              });
              isAccess = true;
            }
          } else if (HouseMessageType().GAME_OVER ==
              int.parse(arg["data"]["msg"])) {
            print("游戏结束");
            showAlertView(context, "游戏结束", arg["data"]["data"], null, "离开房间",
                () {
              //第一次pop的是alertView
              Navigator.pop(context);
              //第二次pop的是游戏页面
              Navigator.pop(context);
            });
          }
        }
        //游戏相关命令
        else if (arg["messageType"] ==
            SocketMessageType().GAME_ACTION_RESPONSE) {
          if (int.parse(arg["data"]["msg"]) ==
              GameActions().UPDATE_GAME_BOARD) {
            if (!gameEnd && !isFanpai) {
              print("初始牌局首轮回合");
              kaixinju(arg);
            } else {
              print("记录下初始牌局首轮回合");
              argData["kaiju"] = arg;
            }
          }else if (int.parse(arg["data"]["msg"]) == 6000){

          } else if (int.parse(arg["data"]["msg"]) == 501) {
            print("分池变化");
            setState(() {
              fenchiList = null;
              fenchiList = List();
              try{
                for(var item in arg["data"]["data"]){
                  bool ismine = false;
                  for(int item1 in item["seats"]){
                    if(isSeated && item1 == nowCurrentIndex+1){
                      ismine = true;
                      break;
                    }
                  }
                  fenchiList.add(
                      tempDichi(item["score"]
                          .toInt()
                          .toString(),ismine: ismine,isbianch: true,txt:item["poolId"] == 0?"主":"边")
                  );
                }
              }catch(e){
                showToast("粪池数据处理出错: ${arg["data"]["data"]}");
              }
            });
          }  else if (int.parse(arg["data"]["msg"]) == 215) {
            if (!gameEnd && !isFanpai) {
              //手牌
              print("发放其他玩家手牌");
              fpskjdfl(null);
            } else {
              print("记录下发牌信息");
              argData["fapai1"] = {"1": "1"};
            }
          } else if (int.parse(arg["data"]["msg"]) == 235) {
            print("某玩家购买保险");
            if (goumaiBaoxianTimer != null) {
              goumaiBaoxianTimer = null;
              proTimerD = 30;
            }
            goumaiBaoxianTimer = Timer.periodic(1.seconds, (timer) {
              if (proTimerD < 0) {
//              proTimerD = 30;
                if (goumaiBaoxianTimer != null) goumaiBaoxianTimer.cancel();
                goumaiBaoxianTimer = null;
              } else {
                proTimerD -= 1;
//              setState(() {
//
//              });
              }
            });
            //先循环把所有的在玩玩家的 isHandle设为false
            for (Map item in seatList) {
              if (item != null && item["isHandle"] == true) {
                item["isHandle"] = false;
              }
              if (item != null && item["buyBaoxian"] == true) {
                item["buyBaoxian"] = null;
              }
            }
            //把当前出手玩家的isHandle设为true
            for (int uid in arg["data"]["data"]) {
              seatList[uid - 1]["isHandle"] = true;
              seatList[uid - 1]["buyBaoxian"] = true;
              if (seatList[uid - 1]["user"]["id"].toString() != userModel.id) {
                userRoundStokeLengthController?.stop();
                // insert
                overlayEntry = OverlayEntry(builder: (context) {
                  return Stack(children: <Widget>[
                    Positioned(
                        top: ssSetHeigth(667 / 2) - ssSetWidth(195 / 2),
                        left: ssSetWidth(375 / 2 - (195 / 2)),
                        child: Container(
//                        padding: EdgeInsets.only(top:ssSetWidth(39)),
                            width: ssSetWidth(195),
                            height: ssSetWidth(44),
                            decoration: BoxDecoration(
                                color: Color(0xff000000).withOpacity(0.8),
                                borderRadius:
                                    BorderRadius.circular(ssSetWidth(6))),
                            child: Center(
                                child: setTextWidget(
                                    "购买保险中...", 14, false, Color(0xffCCCCCC)))))
                  ]);
                });
                Overlay.of(context).insert(overlayEntry);
                gameIsPause = true;
              }
            }

            //导火索动画
            allocUserRoundStrokeAnimate();
            setState(() {});
          } else if (int.parse(arg["data"]["msg"]) ==
              GameActions().CANCEL_INSURANCE) {
            showToast(arg["data"]["data"]["msg"]);
          } else if (int.parse(arg["data"]["msg"]) == 400) {
            print("需要我购买保险");
            baoxianData = arg["data"]["data"];
            for (int i = 0; i < baoxianData.length; i++) {
              Map item = baoxianData[i];
              item["principal"] = double.parse(item["principal"]);
              item["score"] = double.parse(item["score"]);
              item["maxIns"] = double.parse(item["maxIns"]);
              item["minIns"] = double.parse(item["minIns"]);
              item["odds"] = double.parse(item["odds"]);
              item["poolId"] = int.parse(item["poolId"]);
              item["outs"] = jsonDecode(item["outs"]);
              baoxianData[i] = item;
            }
            showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return maiBaoxianView(baoxianData, (List value) {
                    Navigator.maybePop(context);
                    sendSocketMsg({
                      "messageType": SocketMessageType().GAME_ACTION_REQUEST,
                      "gameActionType": 410,
                      "pools": value,
                      "gameHouseId": nowRoomInfo["id"]
                    });
                  });
                });
          } else if (int.parse(arg["data"]["msg"]) == 410) {
            print("玩家购买保险结果");
          } else if (GameActions().HAND_POKER ==
              int.parse(arg["data"]["msg"])) {
            if (!gameEnd && !isFanpai) {
              //手牌
              print("发放手牌");
              //单纯更新手牌类型
              if (arg["data"]["data"]["bluff"] == null ||
                  jsonDecode(arg["data"]["data"]["bluff"]).length == 0) {
                myHandPokerType = arg["data"]["data"]["type"];
                setState(() {});
              } else {
                fpskjdfl(arg);
              }
            } else {
              print("记录下发牌信息");
              argData["fapai"] = arg;
            }
          } else if (GameActions().WEAKUP == int.parse(arg["data"]["msg"])) {
            if (!gameEnd && !isFanpai) {
              //用户出手
              print("我的回合");
              //upCallAnimationShow 代表的是正在收集筹码, gameEnd代表的上一轮游戏结束
              //判断后不满足则直接显示玩家菜单按钮
              if (!gameEnd && fapaiEnded)
                playerRoundAni(arg, true);
              else {
                if (!fapaiEnded) {
                  callData = arg["data"]["data"];
                  return;
                }

                setState(() {});
                playerRoundAni(arg, true);
              }
            } else {
              print("记录下我的回合");
              argData["wdhh"] = arg;
            }
          } else if (GameActions().CURRENT_HANDLER ==
              int.parse(arg["data"]["msg"])) {
            if (!gameEnd && !isFanpai) {
              print("某玩家回合");
              //同我的回合的判断
              playerRoundAni(arg, false);
            } else {
              print("记录下摸玩家回合信息");
              argData["mwjhh"] = arg;
            }
          } else if (GameActions().NEXT_ROUND ==
              int.parse(arg["data"]["msg"])) {
            // print(arg);
            print("下一回合");

            for (Map item in seatList) {
              if (item != null && item["buyBaoxian"] == true) {
                item["buyBaoxian"] = null;
              }
            }
            if (goumaiBaoxianTimer != null) goumaiBaoxianTimer.cancel();
            goumaiBaoxianTimer = null;
            overlayEntry?.remove();
            overlayEntry = null;
            gameIsPause = false;
            //先收集筹码动画播放一下
            collFirstAni();
            //2秒后开始下一回合
            setState(() {});
            if (isFanpai) {
              argData["${arg["data"]["data"]["round"] + 1}"] = arg;
            } else
              newRound(arg, false);
          } else if (GameActions().SHOW_BLUFF ==
              int.parse(arg["data"]["msg"])) {
            // print(arg);

            if (isFanpai) {
              print("记录下秀牌");
              argData["xiupai"] = arg;
            } else {
              print("秀牌");
              showpai(arg);
            }
          } else if (GameActions().WINNER_RESULT ==
              int.parse(arg["data"]["msg"])) {
            //游戏已结束
            if (isFanpai) {
              argData["bidaxiao"] = arg;
            } else {
              bidaxiao(arg);
            }
          } else if (GameActions().OUT_PLAYER ==
              int.parse(arg["data"]["msg"])) {
            print("玩家不够分,需补分");
            if (isFanpai) {
              argData["bufen"] = arg;
            } else {
              bufen(arg);
            }
          } else if (GameActions().USR_ACTION ==
              int.parse(arg["data"]["msg"])) {
            print("某玩家结束动作");
            //回合信息
//          if(roomRound[roomRound.keys.last]["userRecordData"] == null)
//            roomRound[roomRound.keys.last]["userRecordData"] = List();
//          roomRound[roomRound.keys.last]["userRecordData"].add(arg["data"]["data"]);
//          Provide.value<GameCardsProvider>(context).newBoardArrive(roomRound);
            //0代表用户的当前总积分 播放动画从上一次的总积分变化到当前总积分
            seatList[arg["data"]["data"]["seat"] - 1]["isHandle"] = false;
            final CurvedAnimation curve = CurvedAnimation(
                parent: gameNumberController, curve: defaultCurve);
            gameNumberList["${arg["data"]["data"]["seat"] - 1}_0"] =
                Tween<double>(
                        begin: seatList[arg["data"]["data"]["seat"] - 1]
                                ["totalScore"]
                            .toDouble(),
                        end: arg["data"]["data"]["totalScore"].toDouble())
                    .animate(curve);
            //1代表用户的当前下注分 播放动画从上一次的下注分变化到当前下注分
            if (seatList[arg["data"]["data"]["seat"] - 1]["totalBet"] == null)
              seatList[arg["data"]["data"]["seat"] - 1]["totalBet"] = 0;
            gameNumberList["${arg["data"]["data"]["seat"] - 1}_1"] =
                Tween<double>(
                        begin: seatList[arg["data"]["data"]["seat"] - 1]
                                ["totalBet"]
                            .toDouble(),
                        end: arg["data"]["data"]["totalBet"].toDouble())
                    .animate(curve);
            //覆盖当前用户的积分信息以及动作
            seatList[arg["data"]["data"]["seat"] - 1]["totalBet"] =
                arg["data"]["data"]["totalBet"].toDouble();
            seatList[arg["data"]["data"]["seat"] - 1]["totalScore"] =
                arg["data"]["data"]["totalScore"].toDouble();
            seatList[arg["data"]["data"]["seat"] - 1]["action"] =
                arg["data"]["data"]["action"];
            if (arg["data"]["data"]["action"] == 4) {
              seatList[arg["data"]["data"]["seat"] - 1]["isAllin"] = true;
            }
            if (arg["data"]["data"]["user"]["id"].toString() == userModel.id) {
              if (arg["data"]["data"]["action"] == 5 ||
                  arg["data"]["data"]["action"] == 4) {
                callData = null;
              }
            } else if (arg["data"]["data"]["action"] == 5) {
              AnimationController _cont1 =
                  fapaiControllers["${arg["data"]["data"]["seat"] - 1}_f"];
              AnimationController _cont2 =
                  fapaiControllers["${arg["data"]["data"]["seat"] - 1}_s"];
              final CurvedAnimation curve1 =
                  CurvedAnimation(parent: _cont1, curve: defaultCurve);
              final CurvedAnimation curve2 =
                  CurvedAnimation(parent: _cont2, curve: defaultCurve);
              fapaiList["${arg["data"]["data"]["seat"] - 1}_first"] =
                  RelativeRectTween(
                begin:
                    fapaiList["${arg["data"]["data"]["seat"] - 1}_first"].value,
                end: fapaiCenterPoint["${arg["data"]["data"]["seat"] - 1}_l"],
              ).animate(curve1);
              fapaiList["${arg["data"]["data"]["seat"] - 1}_second"] =
                  RelativeRectTween(
                begin: fapaiList["${arg["data"]["data"]["seat"] - 1}_second"]
                    .value,
                end: fapaiCenterPoint["${arg["data"]["data"]["seat"] - 1}_r"],
              ).animate(curve2);
              _cont1.reset();
              _cont2.reset();

              _cont1.play();
              _cont2.play();
            }
            // if(seatList[arg["data"]["data"][""]])
            //当用户动作不为0时, 播放对应的音效
            if (arg["data"]["data"]["action"] != 0) {
              GameSound.getInstance().playAudio(
                  arg["data"]["data"]["action"] == 1
                      ? "jiazhu_girl"
                      : arg["data"]["data"]["action"] == 2
                          ? "genzhu_girl"
                          : arg["data"]["data"]["action"] == 3
                              ? "guopai"
                              : arg["data"]["data"]["action"] == 4
                                  ? "allin_girl"
                                  : "qipai_girl");
            }
            gameNumberList["round_total"] = roundCallTotal
                .tweenTo(roundCallTotal + arg["data"]["data"]["bet"].toDouble())
                .animate(curve);
            roundCallTotal += arg["data"]["data"]["bet"].toDouble();
            //重设
            gameNumberController.reset();
            //播放
            gameNumberController.play();
            //
            if (arg["data"]["data"]["bet"] != 0) {
              if (arg["data"]["data"]["action"] <= 2 &&
                  arg["data"]["data"]["action"] >= 1)
                GameSound.getInstance()
                    .playAudio1("xiazhu,jiazhu,genzhu,choumashengyin");
              collInScore(arg["data"]["data"]["seat"] - 1);
            }
            //监听动画播放状态, 播放完成后将初始值与结束值设为同一个数值
            gameNumberList["${arg["data"]["data"]["seat"] - 1}_0"]
                .addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                gameNumberList["${arg["data"]["data"]["seat"] - 1}_0"] =
                    Tween<double>(
                            begin: gameNumberList[
                                    "${arg["data"]["data"]["seat"] - 1}_0"]
                                .value,
                            end: gameNumberList[
                                    "${arg["data"]["data"]["seat"] - 1}_0"]
                                .value)
                        .animate(curve);

                gameNumberList["${arg["data"]["data"]["seat"] - 1}_1"] =
                    Tween<double>(
                            begin: gameNumberList[
                                    "${arg["data"]["data"]["seat"] - 1}_1"]
                                .value,
                            end: gameNumberList[
                                    "${arg["data"]["data"]["seat"] - 1}_1"]
                                .value)
                        .animate(curve);
              }
            });
            gameNumberList["round_total"].addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                gameNumberList["round_total"] = Tween<double>(
                        begin: gameNumberList["round_total"].value,
                        end: gameNumberList["round_total"].value)
                    .animate(curve);
              }
            });
            gameNumberList["game_total"].addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                gameNumberList["game_total"] = Tween<double>(
                        begin: gameNumberList["game_total"].value,
                        end: gameNumberList["game_total"].value)
                    .animate(curve);
              }
            });
          }else if(int.parse(arg["data"]["msg"]) == 600){
            print("牌局统计信息");
            Map temp = arg["data"]["data"];
            temp["isCollect"] = false;
            // if(temp["openPoker"]==null){
              // temp["openPoker"] = [0,0,0,0,0];
            // }
            // 这里统一判空  给默认值
            await Global.globalShareInstance.setString("boardsMapStorage:${userModel.id}:${nowRoomInfo["id"]}:${temp["page"]}",jsonEncode(temp));
            nowBoardInfo = temp;
            boardPageIndex += 1;
          }else if(int.parse(arg["data"]["msg"]) == 601){
            print("房间数据 - 房间左下角按钮");
            // 这里统一判空  给默认值
            await Global.globalShareInstance.setString("gameHouseInfoStorage:${userModel.id}:${nowRoomInfo["id"]}",jsonEncode(arg["data"]["data"]));
          }
        }
      } catch (e) {
        print("命令接受错误, 错误信息来自$arg");
      }
    });
  }

  //初始化位置座位信息
  void allocPosition() {
    //根据房间最多人数 添加座位数据 因还没有玩家信息所以设置为null
    for (int i = 0; i < numTotal; i++) {
      //i号桌开始座位的position数据
      startSitePosition.add(
        sitePosition(numTotal, i),
      );
      //i号桌结束座位的position
      endSitePosition.add(
        sitePosition(numTotal, i),
      );
      seatList.add(null);
      //座位动画数据添加对应的桌位位置信息
      animationsList.add(
        RelativeRectTween(
          begin: startSitePosition[i],
          end: endSitePosition[i],
        ).animate(seatController),
      );
    }
    //清理用户数据
    usersList.clear();
    //重新赋值为当前房间内用户数据
    usersList = nowRoomInfo["gameHouseUserList"];
    //刷新座位信息
    refreshSeatInfo();

    for (int i = 0; i < usersList.length; i++) {
      Map userInfo = usersList[i];
      //断线重连进来后,先循环用户数组,如果存在当前用户并且已经落座
      if (userInfo["user"]["id"] == int.parse(userModel.id) &&
          userInfo["seat"] != 0) {
        //则seatNumTemp = 座位号
        seatNumTemp = userInfo["seat"] - 1;
        calNeedTransSeat(userInfo);
        break;
      }
    }

    //通过该方法实现中间键的位置信息获取
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      centerOffset =
          (_centerPointKey.currentContext.findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero);
//      print(centerOffset);
    });
  }

  @override
  void initState() {
    super.initState();
    //该变量用于socket的命令反馈判断
    isInGame = true;
    numTotal = nowRoomInfo["maxUserNumbers"];

    otherAnimationController();
    //gameIsStarted = nowRoomInfo["isGame"] == 1 ? true : false;
    allocController();
    allocEventBus();
    allocPosition();
    //配置加载
    SharedPreferences.getInstance().then((value) {
      if (value.getBool("gameSoundOn") == null) {
        soundOn = true;
        value.setBool("gameSoundOn", true);
        soundVolume = 0.5;
        value.setDouble("gameSoundVolume", 0.5);
      } else {
        soundOn = value.getBool("gameSoundOn");
        soundVolume = value.getDouble("gameSoundVolume");
      }
    });
    _loadImage(imgpath + "game/light.png").then((value) {
      imgLight = value;
    });
    for (Map item in nowRoomInfo["gameHouseUserList"]) {
      if (item["user"]["id"].toString() == userModel.id) {
        nowUserInfo = item;
        break;
      }
    }
    final CurvedAnimation curve1 =
        CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
    gameNumberList["game_total"] = 0.0.tweenTo(0.0).animate(curve1);
    gameNumberList["round_total"] = 0.0.tweenTo(0.0).animate(curve1);
    getDashboardTheme(context);

    if(nowRoomInfo["isGame"] == 1){
      sendSocketMsg({
        "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
        "gameHouseMessage": 6001,
        "gameHouseId": nowRoomInfo["id"]
      });
    }
  }

  //暂停游戏
  void gamePause(context) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      userRoundStokeLengthController?.play();
      gameIsPause = false;
    } else {
      userRoundStokeLengthController?.stop();
      // insert
      overlayEntry = OverlayEntry(builder: (context) {
        return Stack(children: <Widget>[
          Positioned(
              top: ssSetHeigth(667 / 2) - ssSetWidth(195 / 2),
              left: ssSetWidth(375 / 2 - (195 / 2)),
              child: Container(
                  padding: EdgeInsets.only(top: ssSetWidth(39)),
                  width: ssSetWidth(195),
                  height: ssSetWidth(195),
                  decoration: BoxDecoration(
                      color: Color(0xff000000).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(ssSetWidth(6))),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        imgpath + "game/pause.png",
                        width: ssSetWidth(57),
                        height: ssSetWidth(57),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ssSetWidth(12)),
                        child: setTextWidget("牌局暂停中", 16, false, Colors.white),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ssSetWidth(27.5)),
                          child: setTextWidget(
                              "请等待10:00...", 14, false, Colors.white))
                    ],
                  )))
        ]);
      });
      Overlay.of(context).insert(overlayEntry);
      gameIsPause = true;
    }
  }

  //其他动画控制器初始化
  void otherAnimationController() {
    alphaController = createController();
    gameZhuangjiaTagController = createController();
    gameZhuangjiaTagController.play(duration: zhuangjiatag.milliseconds);
    gameZhuangjiaTagController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        gameZhuangjiaTagController.reset();
        lastZhuangjiaTagAnimation = gameZhuangjiaTagAnimation;
      }
    });
    alphaController.play(duration: toumingshichang.milliseconds);
    gameButtonPositionController = AnimationController(
        duration: Duration(milliseconds: toumingshichang), vsync: this);
    alphaController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });
    final CurvedAnimation curve1 =
        CurvedAnimation(parent: alphaController, curve: defaultCurve);
    alphaAnimation = 0.0.tweenTo(1.0).animate(curve1);

    gameNumberController = createController();
    gameNumberController.play(duration: allnumshichang.milliseconds);
  }

  //座位数组信息刷新
  void refreshSeatInfo() {
    seatList.clear();
    seatPersonNum = 0;
    for (int i = 0; i < numTotal; i++) {
      seatList.add(null);
    }
    for (var item in usersList) {
      if (item["seat"] != 0) {
        seatList[item["seat"] - 1] = item;
        seatList[item["seat"] - 1]["isHandle"] = false;
        seatPersonNum++;
      }
    }
    setState(() {});
  }

  Future<ui.Image> _loadImage(String path) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: 10, targetWidth: 10);
    var info = await codec.getNextFrame();
    return info.image;
  }

  @override
  void dispose() {
    super.dispose();
//    userRoundStokeLengthController = null;
    eventBus.off("gameSession");
    eventBus.off("zhongtu");

    if (goumaiBaoxianTimer != null) goumaiBaoxianTimer.cancel();
//    controller = null;
//    if (gameButtonPositionController != null) {
//      gameButtonPositionController = null;
//      alphaController = null;
//    }
    overlayEntry?.remove();
    overlayEntry = null;
  }

  //各种按钮的样式
  Widget buttontest(double w, double h, String img, {void Function() func}) {
    return Container(
      width: ssSetWidth(w),
      height: ssSetWidth(h),
      child: InkWell(
        onTap: func ?? () {},
        child: Image.asset(imgpath + "game/" + img),
      ),
    );
  }

  //重新设置座位position
  void resetAnimationList() {
    for (int i = 0; i < numTotal; i++) {
      animationsList[i] = RelativeRectTween(
        begin: startSitePosition[i],
        end: endSitePosition[i],
      ).animate(seatController);
    }
  }

  //桌布图
  Widget dashBoardView() {
    return Provide<GameDashboardThemeProvider>(
        builder: (context, child, value) {
      return Container(
        child: Image.asset(
          imgpath + "game/dashboard_${value.themeType ?? 0}.png",
          width: ssSetWidth(375),
          height: ssSetHeigth(675),
          fit: BoxFit.fill,
        ),
      );
    });
  }

  //底部装饰图
  Widget bottomDecoration() {
    return Container(
      child: Image.asset(
        imgpath + "game/decoration.png",
        width: ssSetWidth(375),
        height: ssSetHeigth(675),
        fit: BoxFit.fill,
      ),
    );
  }

  //底部按钮视图
  Widget bottomButtons() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: ssSetWidth(75.5),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: ssSetWidth(8.5)),
                child: buttontest(28, 25.5, "calan.png", func: () {
                  if (gameIsPause) return;
                  if (leftDrawType == 1) {
                    setState(() {
                      leftDrawType = 0;
                    });
                  }
                  //保险视图
                  _scaffoldKey.currentState.openDrawer();
                }),
              ),
              Padding(
                padding: EdgeInsets.only(left: ssSetWidth(45)),
                child: buttontest(28, 23.5, "message.png", func: () {
                  if (gameIsPause) return;
                  if (leftDrawType == 0) {
                    setState(() {
                      leftDrawType = 1;
                    });
                  }
                  //聊天消息视图
                  _scaffoldKey.currentState.openDrawer();
                }),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding:
                    EdgeInsets.only(left: ssSetWidth(46), right: ssSetWidth(9)),
                child: buttontest(27, 27, "emoji.png", func: () {
                  sendSocketMsg({
                    "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                    "gameHouseMessage": 6001,
                    "gameHouseId": nowRoomInfo["id"]
                  });
//                  gamePause(context);
//                  changeDashboardTheme(Random().nextInt(3),context);
                  return;
                  //表情按钮点击事件, 目前用于测试环境测试部分功能

//                  showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
//                    return maiBaoxianView(100.0,0.0,200.0,(value){
//                      print("选择了购买$value保险");
//                      Navigator.maybePop(context);
//                    });
//                  });
//                  print(roomRound);
//                  collFirstAni();

                  eventBus.emit("gameSession", {
                    "messageType": 6,
                    "data": {
                      "code": 200,
                      "msg": "300",
                      "data": {
                        "winnerSeats": "[${(nowCurrentIndex + 1)},2,3]",
                        "winnerScore": "800"
                      }
                    }
                  });
//                  eventBus.emit("gameSession", {
//                    "messageType": 6,
//                    "data": {
//                      "code": 200,
//                      "msg": "200",
//                      "data": {
//                        "call": {"minCall": 1.0, "maxCall": 100.0},
//                        "multiplying": {"3倍": 6.0, "2倍": 4.0, "1倍": 2.0},
//                        "follow": {"bet": 1.0},
//                        "allin": {"bet": 100.0},
//                        // "pass": "0.0"
//                      }
//                    }
//                  });
                  if (1 == 1) {
//                     showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
//                       return maiBaoxianView();
//                     });
                    // GameSound.getInstance().playAudio("shoujichouma");
                    // GameSound.getInstance().playAudio("allin_girl");
                    // collFirstAni();

                    // winnerInfo = {
                    //   "winnerSeat": nowCurrentIndex+2,
                    //   "totalScore": "800"
                    // };
                    // setState(() {});
                    // winnerAnimation = RelativeRectTween(
                    //         begin: RelativeRect.fromLTRB(30, 30, 30, 30),
                    //         end: RelativeRect.fromLTRB(
                    //             -ssSetWidth(40),
                    //             -ssSetHeigth(70),
                    //             -ssSetWidth(40),
                    //             ssSetHeigth(70 + 30.0)))
                    //     .animatedBy(controller);
                    // controller.reset();
                    // controller.play();
                    // eventBus.emit("gameSession", {
                    //   "messageType": 6,
                    //   "data": {
                    //     "code": 200,
                    //     "msg": "230",
                    //     "data": nowCurrentIndex + 1
                    //   }
                    // });
                    //           seatList[arg["data"]["data"]["seat"] - 1]["totalBet"] =
                    //     arg["data"]["data"]["totalBet"];
                    // seatList[arg["data"]["data"]["seat"] - 1]["totalScore"] =
                    //     arg["data"]["data"]["totalScore"];
                    // seatList[arg["data"]["data"]["seat"] - 1]["action"] =
                    //     arg["data"]["data"]["action"];
                    // eventBus.emit("gameSession", {
                    //   "messageType": 6,
                    //   "data": {
                    //     "code": 200,
                    //     "msg": "260",
                    //     "data": {
                    //       "seat": nowCurrentIndex + 1,
                    //       "totalScore": Random().nextDouble(),
                    //       "totalBet": Random().nextDouble()
                    //     }
                    //   }
                    // });
                    // return;
//                    eventBus.emit("gameSession", {
//                      "messageType": 6,
//                      "data": {
//                        "code": 200,
//                        "msg": "300",
//                        "data": {
//                          "winnerSeat" :(nowCurrentIndex+1).toString(),
//                          "totalScore" : "800"
//                        }
//                      }
//                    });
//                     eventBus.emit("gameSession", {
//                       "messageType": 6,
//                       "data": {
//                         "code": 200,
//                         "msg": "200",
//                         "data": {
//                           "call": {"minCall": 1.0, "maxCall": 100.0},
//                           "multiplying": {"3倍": 6.0, "2倍": 4.0, "1倍": 2.0},
//                           "follow": {"bet": 1.0},
//                           "allin": {"bet": 100.0},
//                           // "pass": "0.0"
//                         }
//                       }
//                     });
                  }
                }),
              ),
            ],
          ),
        ));
  }

  // 请求的当前最新完整牌局信息
  Map nowBoardInfo={};
  int boardPageIndex = 0;
  //头部按钮视图
  Widget headerButtons() {
    return Positioned(
        top: safeStatusBarHeight(),
        left: 0,
        right: 0,
        child: Container(
          height: ssSetWidth(25.5) + safeStatusBarHeight(),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: ssSetWidth(8.5)),
                //左上角菜单按钮
                child: showCustomPopMenu(isSeated, (value) {
                  if (value == '1') {
                    if (gameIsPause) return;
                    //游戏设置
                    showDialog(
                        context: context,
                        builder: (context) {
                          return GameSetting(
                              context,
                              nowRoomInfo["houseOwnerId"] ==
                                  int.parse(userModel.id));
                        });
                  } else if (value == '2') {
                    //牌谱说明
                    if (gameIsPause) return;
                  } else if (value == '3') {
                    //保险说明
                    if (gameIsPause) return;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return baoxianDes(context);
                        });
                  } else if (value == '4') {
                    //站起,判断是否已坐下
                    if (isSeated) {
                      sendSocketMsg({
                        "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                        "gameHouseMessage": HouseMessageType().STAND_UP,
                        "gameHouseId": nowRoomInfo["id"]
                      });
                    }
                  } else {
                    //离开房间
                    print("离开房间");
                    sendSocketMsg({
                      "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                      "gameHouseMessage": HouseMessageType().LEAVE_HOUSE,
                      "gameHouseId": nowRoomInfo["id"]
                    });
                    Navigator.of(context).pop();
                    //清理聊天消息数据
                    Provide.value<GameMessageProvier>(context)
                        .newMessageArrive(null);
                    //清理牌谱数据
                    // Provide.value<GameCardsProvider>(context)
                    //     .newBoardArrive(null);
                    // Provide.value<GameCardsProvider>(context)
                    //     .changeNoNick(null);
                    isInGame = false;
                  }
                }),
                // child: buttontest(37, 37, "down_arrow.png"),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(left: ssSetWidth(0)),
                child: buttontest(30, 23, "invite.png", func: () {
                  if (gameIsPause) return;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ShareRoomDialog(context);
                      });
                }),
              ),
              Padding(
                padding: EdgeInsets.only(left: ssSetWidth(29.5)),
                child: buttontest(26.5, 24.5, "bscore.png", func: () {
                  if (gameIsPause) return;
                  if (showInScoreDialog) return;
                  showInScoreDialog = true;
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      child: GetInScore(
                          context,
                          1,
                          nowRoomInfo["matMinScorecard"].toDouble(),
                          nowRoomInfo["matMaxScorecard"].toDouble(), (score) {
                        showInScoreDialog = false;
                        if (score == null) return;

                        sendSocketMsg({
                          "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                          "gameHouseMessage": HouseMessageType()
                              .SCORE_USR_TO_HOUSE_OWNER_REQUEST,
                          "score": score.toStringAsFixed(0),
                          "gameHouseId": nowRoomInfo["id"]
                        });
                      }));
                }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ssSetWidth(29.5), right: ssSetWidth(8)),
                child: buttontest(23.5, 27, "cards.png", func: () async{
                  if (gameIsPause) return;
                  // 请求接口数据 并缓存到本地
                  if(gameIsStarted&&(boardPageIndex==0)){
                    print("接口获取数据===");
                    nowBoardInfo = await getGameBoardInfo(nowRoomInfo["id"]);
                    if(nowBoardInfo.isNotEmpty){
                      boardPageIndex = 1;
                    }else{
                      nowBoardInfo = {};
                    }
                  }
                  _scaffoldKey.currentState.openEndDrawer();
                }),
              ),
            ],
          ),
        ));
  }

  List tempOpPoker = List();
  static double midPokW = 46;
  static double midPokR = 2.5;
  static double midPokH = 63.5;
  List<Widget> pokesWidgets = [
    SizedBox(
      width: ssSetWidth(midPokW + midPokR),
      height: ssSetWidth(midPokH),
    ),
    SizedBox(
      width: ssSetWidth(midPokW + midPokR),
      height: ssSetWidth(midPokH),
    ),
    SizedBox(
      width: ssSetWidth(midPokW + midPokR),
      height: ssSetWidth(midPokH),
    ),
    SizedBox(
      width: ssSetWidth(midPokW + midPokR),
      height: ssSetWidth(midPokH),
    ),
    SizedBox(
      width: ssSetWidth(midPokW + midPokR),
      height: ssSetWidth(midPokH),
    ),
  ];
  bool iszhongtu = false;
  Future<void> getPubPokeWid() async {
    for (int i = 0; i < openPokers.length; i++) {
      int card = openPokers[i];
      if (!tempOpPoker.contains(card)) {
//          ImagesAnim ani = ;
        if (iszhongtu)
        pokesWidgets[i] = ImagesAnim(
            midPokW, midPokH, ssSetWidth(midPokR), 200, false, card);
        else
        await Future.delayed(openPokers.length == 4? (gongpai3to4.milliseconds):(gongpaiOther.milliseconds), () {
          pokesWidgets[i] = ImagesAnim(
              midPokW, midPokH, ssSetWidth(midPokR), 200, true, card);
        });
      }
    }
    if (openPokers.length <= 3) {
      GameSound.getInstance().playAudio1("sanzhanggongpai");
    } else  {
      GameSound.getInstance().playAudio1("disizhanggongpai");
    }
    tempOpPoker = openPokers;

    return null;
  }

  Widget middlePubPokers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pokesWidgets,
    );
  }

  Widget tempDichi(String val,{bool ismine=false,bool isbianch=false,String txt}) {
    return UnconstrainedBox(
      child: Container(
        // width: ssSetWidth(80),
        height: ssSetWidth(isbianch ? 16 : 21),
        decoration: BoxDecoration(
          border: ismine ? Border.all(
            color: Color(0xffE05B03),
            width: 1
          ) : null,
            borderRadius: BorderRadius.circular(ssSetWidth(10)),
            color: Colors.black.withOpacity(0.4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isbianch ? Container(
              width: ssSetWidth(16),
              height: ssSetWidth(16),
              child: Stack(
                children: <Widget>[
                  Image.asset(imgpath + "game/call_yellow.png",
                    width: ssSetWidth(16),
                    height: ssSetWidth(16),

                  ),
                  setTextWidget(txt, 10, false, Colors.white)
                ],
              ),
            ):
            Padding(
              padding: EdgeInsets.only(left: 4.5),
              child: Image.asset(
                int.parse(val) <= 10
                    ? imgpath + "game/call_blue.png"
                    : int.parse(val) <= 100
                        ? imgpath + "game/call_yellow.png"
                        : imgpath + "game/call_red.png",
                width: ssSetWidth(16),
                height: ssSetWidth(16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: setTextWidget(val, isbianch? 12: 14, false, Colors.white),
            )
          ],
        ),
      ),
    );
  }

  //中间数据视图
  Widget middleView() {
//    print("ssss "+baoxianData[0]["score"]);
    return Container(
      // width: ssSetWidth(375),
      height: ssSetHeigth(567),
      padding: EdgeInsets.only(top: ssSetWidth(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          setTextWidget(
              "底池:${gameNumberList["game_total"].value.toStringAsFixed(0)}",
              18,
              true,
              Color(0xff000000).withOpacity(0.8)),
          fenchiList == null
              ? tempDichi(
              gameNumberList["round_total"].value.toStringAsFixed(0))
              : Container(
              width: ssSetWidth(260),
              height: ssSetWidth(21),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top:0,
                      left:0,
                      right:0,
                      bottom:-ssSetHeigth(500),
                      child: Container(
                    height: ssSetHeigth(500),
                    width:ssSetWidth(260),
//                    color: Colors.redAccent,
                    child: Wrap(
                        spacing: ssSetWidth(16), // 主轴(水平)方向间距
                        runSpacing: ssSetWidth(4), // 纵轴（垂直）方向间距
                        alignment: WrapAlignment.center, //沿主轴方向居中
                        children:fenchiList
                    ),
                  ))

                ],
              )
          ),
          Padding(
              padding: EdgeInsets.only(top: ssSetHeigth(7)),
              child: Image.asset(
                imgpath + "game/logo.png",
                key: _centerPointKey,
                width: ssSetWidth(80),
                height: ssSetWidth(80),
              )),
          (seatPersonNum >= 2 &&
                  nowRoomInfo["houseOwnerId"] == int.parse(userModel.id) &&
                  !gameIsStarted) //&& !gameIsStarted
              ? Container(
                  margin: EdgeInsets.only(top: ssSetHeigth(10)),
                  width: ssSetWidth(161),
                  height: ssSetWidth(44),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ssSetWidth(24)),
                      color: Color(0xffffffff).withOpacity(0.1),
                      border: Border.all(
                          color: Color(0xffffffff).withOpacity(0.3), width: 1)),
                  child: InkWell(
                    onTap: () {
                      if (gameIsPause) return;

                      print("开局");
                      sendSocketMsg({
                        "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                        "gameHouseMessage": HouseMessageType().START_GAME,
                        "gameHouseId": nowRoomInfo["id"]
                      });
                    },
                    child: Center(
                        child: setTextWidget("开始", 16, false, Colors.white)),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: ssSetHeigth(7)),
//                  width: ssSetWidth(40*5.5),
//                  height: ssSetWidth(68),
                  child: middlePubPokers()),
          Padding(
            padding: EdgeInsets.only(top: ssSetHeigth(7.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  imgpath + "game/score.png",
                  width: ssSetWidth(13.5),
                  height: ssSetWidth(13.5),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ssSetWidth(3.5)),
                  child: setTextWidget(
                      "${(nowRoomInfo["matBlind"] / 2).toInt().toString()}/${nowRoomInfo["matBlind"].toString()}",
                      12,
                      false,
                      Color(0xff000000).withOpacity(0.8)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ssSetWidth(15)),
                  child: Image.asset(
                    imgpath + "game/lock.png",
                    width: ssSetWidth(13.5),
                    height: ssSetWidth(13.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ssSetWidth(3.5)),
                  child: setTextWidget(nowRoomInfo["housePwd"], 12, false,
                      Color(0xff000000).withOpacity(0.8)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ssSetWidth(15)),
                  child: Image.asset(
                    imgpath + "game/time.png",
                    width: ssSetWidth(13.5),
                    height: ssSetWidth(13.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ssSetWidth(3.5)),
                  child: setTextWidget(
                      "0${nowRoomInfo["matTime"] == 30 ? "0" : (nowRoomInfo["matTime"] / 60).toInt().toString()}:${nowRoomInfo["matTime"] == 30 ? "30" : "00"}:00",
                      12,
                      false,
                      Color(0xff000000).withOpacity(0.8)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ssSetHeigth(3.5)),
            child: setTextWidget("<${nowRoomInfo["houseName"]}>", 12, false,
                Color(0xff000000).withOpacity(0.8)),
          ),
          Padding(
            padding: EdgeInsets.only(top: ssSetHeigth(3.5)),
            child: setTextWidget(
                "底池限注", 12, false, Color(0xff000000).withOpacity(0.8)),
          ),
          nowRoomInfo["matGpsAndIp"]
              ? Padding(
                  padding: EdgeInsets.only(top: ssSetHeigth(3.5)),
                  child: setTextWidget("已开启GPS和IP限制", 12, false,
                      Color(0xff000000).withOpacity(0.8)),
                )
              : SizedBox()
        ],
      ),
    );
  }

  //房主新消息视图
  Widget newMessageView() {
    return 1 == 1
        ? SizedBox()
        : Positioned(
            top: safeStatusBarHeight() + ssSetHeigth(70),
            right: 0,
            child: Container(
                height: ssSetWidth(20),
                padding: EdgeInsets.only(left: 5, right: 2),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(ssSetWidth(20)),
                    )),
                child: InkWell(
                    onTap: () {
                      Application.router.navigateTo(
                          context, "$messageListPath?msgType=1",
                          transition: TransitionType.inFromRight);
                    },
                    child: Center(
                      child: setTextWidget("10 条新消息", 11, false, b33),
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        drawer: Drawer(
          elevation: 4,
          child: leftDrawType == 0 ? RoomStatisticsView(audiencesList) : MessageView(),
        ),
        endDrawer: Drawer(
          elevation: 4,
          child: CardsDrawView(nowBoardInfo,boardPageIndex),
        ),
        body: WillPopScope(
            child: Stack(
              children: <Widget>[
                //桌布画图
                dashBoardView(),
                //底部装饰图
//                bottomDecoration(),
                //底部按钮视图
                bottomButtons(),
                //顶部按钮视图
                headerButtons(),
                //中间部分视图
                middleView(),
                //新消息视图
                newMessageView(),
                //座位视图
                setUserSites(),
                //用户自己的手牌视图
                myHandPoker.length > 0 ? handCards(0) : SizedBox(),
                //用户自己的手牌视图
                myHandPoker.length > 0 ? handCards(1) : SizedBox(),
                //用户自己的手牌视图
                myHandPoker.length > 0 ? handCards(2) : SizedBox(),
                //自己出手回合的出牌按钮���图
                callData != null && !gameEnd && isSeated && fapaiEnded
                    ? myRound()
                    : SizedBox(),
                callData != null && !gameEnd && isSeated && fapaiEnded
                    ?jiazhuAnniuWidget():SizedBox()
              ],
            ),
            onWillPop: () async {
              return false;
            }));
  }

  void allocUserRoundStrokeAnimate() {
    if (userRoundStokeLengthController != null) {
      userRoundStokeLengthController = null;
    }
    userRoundStokeLengthController = createController();
    userRoundStokeLengthController.play(duration: thinkTime);

    userRoundStokeLengthAnimation =
        0.0.tweenTo(1.0).animatedBy(userRoundStokeLengthController);
    userRoundStokeLengthController.play();
    // userRoundStokeLengthController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     // autoPass();
    //   }
    // });
  }

  //回合操作按钮
  Widget myRoundButtons(rect, List<Color> colors, title, void Function() func) {
    return PositionedTransition(
        rect: rect,
        child: Opacity(
          opacity: alphaAnimation.value,
          child: Container(
            child: Center(
                child: Container(
                    width: ssSetWidth(50),
                    height: ssSetWidth(50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ssSetWidth(25)),
                        border: Border.fromBorderSide(BorderSide(
                            style: BorderStyle.solid,
                            color: Color(0xff1D4766).withOpacity(0.3),
                            width: 1.5)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: colors)),
                    child: InkWell(
                      onTap: gameIsPause ? () {} : func,
                      child: Center(
                        child: setTextWidget(title, 12, false, Colors.white,
                            maxLines: 2),
                      ),
                    ))),
          ),
        ));
//    return PositionedTransition(
//        rect: rect,
//        child: Opacity(
//          opacity: alphaAnimation.value,
//          child: jiazhuButtonView(),
//        ));
  }

  ui.Image imgLight;
  //静态左右回合操作按钮
  Widget staticRoundButtons(
      rect, List<Color> colors, title, void Function() func) {
    return Positioned(
        left: rect.left,
        top: rect.top,
        right: rect.right,
        bottom: rect.bottom,
        child: Opacity(
          opacity: 1,
          child: Container(
            child: Center(
                child: Container(
                    // color: Colors.redAccent.withOpacity(colorAnimation.value),
                    width: ssSetWidth(50),
                    height: ssSetWidth(50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ssSetWidth(25)),
                        border: Border.fromBorderSide(BorderSide(
                            style: BorderStyle.solid,
                            color: Color(0xff1D4766).withOpacity(0.3),
                            width: 1.5)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: colors)),
                    child: InkWell(
                      onTap: gameIsPause ? () {} : func,
                      child: Center(
                        child: setTextWidget(title, 12, false, Colors.white,
                            textAlign: TextAlign.center, maxLines: 2),
                      ),
                    ))),
          ),
        ));
  }

  void otherButtonAnimationHidden() {
    gameButtonPositionController.playReverse().orCancel;
    alphaController.playReverse().orCancel;
  }

  //我的出手回合视图
  Widget myRound() {
    RelativeRect startRect = sitePosition(numTotal, 0);
    List<Animation<RelativeRect>> positionAnimate = List();
    List<Widget> gameControllers = List();
    List<Widget> quickButtons = List();
    try {
      if (callData != null && callData["multiplying"].length > 0) {
        for (Map item in callData["multiplying"]) {
          quickButtons.add(Expanded(
              child: Opacity(
                  opacity: alphaAnimation.value,
                  child: Opacity(
                    opacity:item["value"] < minCall ? 0.3 : 1,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: ssSetWidth(42),
                            height: ssSetWidth(42),
                            child: Image.asset(
                              imgpath + "game/half_circle.png",
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              if (gameIsPause) return;
                              if (!isMyRound) return;
                              if(item["value"] < minCall ) return ;
                              if (item["value"] > maxCall) {
                                    //快捷下注
                              sendSocketMsg({
                                "messageType":
                                    SocketMessageType().GAME_ACTION_REQUEST,
                                "gameActionType": GameActions().ALL_IN,
                                "bet": "0",
                                "gameHouseId": nowRoomInfo["id"]
                              });
                                    return;
                                  }else{
//快捷下注
                              sendSocketMsg({
                                "messageType":
                                    SocketMessageType().GAME_ACTION_REQUEST,
                                "gameActionType": GameActions().CALL,
                                "bet": item["value"],
                                "gameHouseId": nowRoomInfo["id"]
                              });
                                  }

                              isMyRound = false;
                              otherButtonAnimationHidden();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: ssSetWidth(9)),
                                  child: setTextWidget(
                                      "底池", 10, false, Colors.white),
                                ),
                                setTextWidget(
                                    item["name"], 14, false, Colors.white),
                                setTextWidget(item["value"].toString(), 10,
                                    false, Colors.white),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))));
        }
      }
    } catch (e) {}

    positionAnimate = [
      //加注
      RelativeRectTween(
        begin: startRect,
        end: RelativeRect.fromLTRB(
          startRect.left,
          startRect.top - ssSetWidth(50 + 4.0),
          startRect.right,
          startRect.bottom + tileHeight+ ssSetWidth(4),
        ),
      ).animate(gameButtonPositionController),
      //快捷下注按钮组合
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          ssSetWidth(90),
          startRect.top - ssSetWidth(50 + 4.0 + 42) - ssSetWidth(17 + 20.0),
          ssSetWidth(90),
          startRect.bottom +
              tileHeight +
              ssSetWidth(4 + 50.0 + 20),
        ),
        end: RelativeRect.fromLTRB(
          ssSetWidth(90),
          startRect.top - ssSetWidth(50 + 4.0 + 42) - ssSetWidth(17),
          ssSetWidth(90),
          startRect.bottom + tileHeight + ssSetWidth(4 + 50.0),
        ),
      ).animate(gameButtonPositionController),
    ];

    gameControllers = [
      staticRoundButtons(
          RelativeRect.fromLTRB(
            startRect.left - ssSetWidth(50 + 27.5),
            startRect.top,
            startRect.right + ssSetWidth(50 + 27.5),
            startRect.bottom + tileHeight - ssSetWidth(77),
          ),
          autoAction == 1 && !isMyRound
              ? [Color(0xff48b5f3), Color(0xff3d8fee)]
              : [Color(0xff1A6DAC), Color(0xff074A97)],
          isMyRound == true ? "弃牌" : "让或弃", () {
        if (isMyRound != true) {
          if (autoAction == 1) {
            autoAction = 0;
          } else
            autoAction = 1;
          setState(() {});
        } else {
          isMyRound = false;
          sendSocketMsg({
            "messageType": SocketMessageType().GAME_ACTION_REQUEST,
            "gameActionType": GameActions().CANCEL,
            "bet": "0",
            "gameHouseId": nowRoomInfo["id"]
          });
          otherButtonAnimationHidden();
          callData = null;
          setState(() {});
        }
      }),
      staticRoundButtons(
          RelativeRect.fromLTRB(
            startRect.left + ssSetWidth(50 + 27.5),
            startRect.top,
            startRect.right - ssSetWidth(50 + 27.5),
            startRect.bottom + tileHeight - ssSetWidth(77),
          ),
          !isMyRound
              ? autoAction == 2
                  ? [Color(0xff48b5f3), Color(0xff3d8fee)]
                  : [Color(0xff1A6DAC), Color(0xff074A97)]
              : callData["follow"] != null
                  ? [Color(0xff1A6DAC), Color(0xff074A97)]
                  : callData["pass"] != null
                      ? [Color(0xff1A6DAC), Color(0xff074A97)]
                      : [Color(0xffFF9F36), Color(0xffD1720B)],
          !isMyRound
              ? "自动\n让牌"
              : callData["follow"] != null
                  ? "${callData["follow"]["followBet"]}\n跟注"
                  : callData["pass"] != null ? "看牌" : "ALL IN", () {
        if (isMyRound != true) {
          if (autoAction == 2) {
            autoAction = 0;
          } else
            autoAction = 2;
          setState(() {});
        } else {
          isMyRound = false;
          //可跟注  显示跟注
          if (callData["follow"] != null) {
            print("跟注");
            sendSocketMsg({
              "messageType": SocketMessageType().GAME_ACTION_REQUEST,
              "gameActionType": GameActions().FOLLOW,
              "bet": callData["follow"]["followBet"],
              "gameHouseId": nowRoomInfo["id"]
            });
          }
          //可看牌 显示allin
          else if (callData["pass"] != null) {
            print("让牌");
            sendSocketMsg({
              "messageType": SocketMessageType().GAME_ACTION_REQUEST,
              "gameActionType": GameActions().PASS,
              "bet": "0",
              "gameHouseId": nowRoomInfo["id"]
            });
          }
          //其他情况下(无法跟注无法看牌)显示ALLIN
          else {
            print("ALLIN");
            sendSocketMsg({
              "messageType": SocketMessageType().GAME_ACTION_REQUEST,
              "gameActionType": GameActions().ALL_IN,
              "bet": "0",
              "gameHouseId": nowRoomInfo["id"]
            });
          }
          otherButtonAnimationHidden();
        }
      }),
//       ((callData["call"] != null ||
//                   (callData["follow"] != null && callData["allin"] != null)) &&
//               isMyRound &&
//               !hiddenJiazhuButton) //callData["follow"] == null && callData["pass"] == null &&
//           ? myRoundButtons(
//               positionAnimate[0],
//               [Color(0xffFF9F36), Color(0xffD1720B)],
//               callData["call"] != null ? "加注" : "ALL IN", () {
//               if (gameIsPause) return;
//               if (!isMyRound) return;
//               setState(() {
//                 hiddenJiazhuButton = true;
//               });
//               if (callData["call"] != null) {
//                 showDialog(
//                     context: context,
//                     child: CallOtherDialog(
//                       homeContext: context,
//                       onCallback: (str) {
//                         if (double.parse(str) == callData["call"]["maxCall"]) {
//                           sendSocketMsg({
//                             "messageType":
//                                 SocketMessageType().GAME_ACTION_REQUEST,
//                             "gameActionType": GameActions().ALL_IN,
//                             "bet": "0",
//                             "gameHouseId": nowRoomInfo["id"]
//                           });
//                         } else {
//                           sendSocketMsg({
//                             "messageType":
//                                 SocketMessageType().GAME_ACTION_REQUEST,
//                             "gameActionType": GameActions().CALL,
//                             "bet": str,
//                             "gameHouseId": nowRoomInfo["id"]
//                           });
//                         }

// //                    Navigator.pop(context);
//                         isMyRound = false;
//                         otherButtonAnimationHidden();
//                       },
//                       minCall: callData["call"]["minCall"].toDouble(),
//                       maxCall: callData["call"]["maxCall"].toDouble(),
//                     )).then((value) {
//                   setState(() {
//                     hiddenJiazhuButton = false;
//                   });
//                 });
//               } else {
//                 sendSocketMsg({
//                   "messageType": SocketMessageType().GAME_ACTION_REQUEST,
//                   "gameActionType": GameActions().ALL_IN,
//                   "bet": "0",
//                   "gameHouseId": nowRoomInfo["id"]
//                 });
//               }
//             })
//           : SizedBox(),
      PositionedTransition(
        rect: positionAnimate[1],
        child: Row(
          children: quickButtons,
        ),
      )
    ];
    // controller.play();
    return Positioned(
        top: safeStatusBarHeight() + ssSetHeigth(60),
        child: Container(
            width: ssSetWidth(375),
            height: viewHeight,
            child: Stack(children: gameControllers.toList())));
  }

  //单个座位视图整体
  Widget userSite(int seatNum, RelativeRect rect, void Function() ontap) {
    int paddingMode = 0;
    if (rect.left < rect.right && rect.top != 0) {
      //左边桌位
      paddingMode = 1;
    } else if (rect.bottom == 0) {
      //底部座位
      paddingMode = 2;
    } else if (rect.top == 0) {
      //顶部座位
      paddingMode = 3;
    }
    Map userInfo = seatList[seatNum];
    String userty;
    if (userInfo != null) {
      userInfo["mode"] = paddingMode;

      seatList[seatNum] = userInfo;
      final CurvedAnimation curve1 =
          CurvedAnimation(parent: gameNumberController, curve: defaultCurve);
      if (gameNumberList["${seatNum}_0"] == null) {
        gameNumberList["${seatNum}_0"] = Tween<double>(
                begin: seatList[seatNum]["totalScore"]?.toDouble(),
                end: seatList[seatNum]["totalScore"]?.toDouble())
            .animate(curve1);
      }
      if (gameNumberList["${seatNum}_1"] == null) {
        gameNumberList["${seatNum}_1"] = Tween<double>(
                begin: seatList[seatNum]["totalBet"]?.toDouble(),
                end: seatList[seatNum]["totalBet"]?.toDouble())
            .animate(curve1);
      }
    }
    Map winner;
    if (winnerInfo != null)
      for (String item in winnerInfo.keys) {
        if (item == (seatNum + 1).toString()) {
          winner = {
            "winnerSeat": int.parse(item),
            "winnerScore": winnerInfo[item]
          };
          break;
        }
      }

    return Container(
//         color: Colors.redAccent,
        child: Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        //这仅仅只是桌位基本信息, 其他叠加层可以通过position添加覆盖上去
        Opacity(
          opacity: userInfo != null && userInfo["status"] != 2 ? 0.2 : 1,
          child: Container(
              width: ssSetWidth(50),
              height: ssSetWidth(77.8),
              decoration: BoxDecoration(
                color: gameIsStarted && userInfo != null
                    ? Colors.black.withOpacity(0.4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(ssSetWidth(4)),
              ),
              child: InkWell(
                onTap: () {
                  if (gameIsPause || isSeated) return;
                  if (userInfo == null) {
//                    if (gameIsStarted) {
//                      // showToast("已�����局,无法落座");
//                      return;
//                    }
                    //构建一个临时座位号储存
                    seatNumTemp = seatNum;
                    //只有在动画没有开始前才可以换
                    if (!controller.isAnimating) {
                      sendSocketMsg({
                        "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                        "gameHouseMessage": HouseMessageType().SIT_DOWN,
                        "seat": seatNum + 1,
                        "gameHouseId": nowRoomInfo["id"]
                      });
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return UserInfoDialog(context, userInfo);
                        });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //名字
                    Container(
//                    margin: EdgeInsets.only(top: 4),

                      decoration: BoxDecoration(
                          color: gameIsStarted && userInfo != null
                              ? Colors.black.withOpacity(0.6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(ssSetWidth(4)),
                              topRight: Radius.circular(ssSetWidth(4)))),
                      width: ssSetWidth(50),
                      child: setTextWidget(
                          userInfo == null
                              ? ""
                              : gameIsStarted &&
                                      userInfo != null &&
                                      userInfo["status"] == 2 &&
                                      userInfo["action"] != null &&
                                      userInfo["action"] != 0 &&
                                      winner == null
                                  ? (userInfo["action"] == 1
                                      ? "加注"
                                      : userInfo["action"] == 2
                                          ? "跟牌"
                                          : userInfo["action"] == 3
                                              ? "看牌"
                                              : userInfo["action"] == 4
                                                  ? "ALL IN"
                                                  : "弃牌")
                                  : "${userInfo["user"]["userNameOrigin"]}", //"${userInfo["user"]["userNameOrigin"]}+${seatNum+1}+${userInfo["userType"]}",
                          10,
                          false,
                          Colors.white,
                          textAlign: TextAlign.center,
                          maxLines: 1),
                    ),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                            // padding: EdgeInsets.all(ssSetWidth(2)),
                            width: ssSetWidth(49),
                            height: ssSetWidth(49),
                            child: userInfo != null
                                ?
//                          Image.asset(
//                            imgpath + "game/site.png",
//                            width: ssSetWidth(50),
//                            height: ssSetWidth(50),
//                          )
                                returnImageWithUrl(
                                    userInfo["user"]["profilePicture"],
                                    hasP: true,
                                    imgwidth: ssSetWidth(50),
                                    imgheight: ssSetWidth(50),
                                    boxF: BoxFit.fitHeight)
                                : isSeated
                                    ? SizedBox()
                                    : Image.asset(
                                        imgpath + "game/site.png",
                                        width: ssSetWidth(50),
                                        height: ssSetWidth(50),
                                      )),

                        //玩家弃牌
                        //叠加黑色透明视图
                        gameIsStarted &&
                                userInfo != null &&
                                userInfo["status"] == 2 &&
                                ((userInfo["action"] != null &&
                                        userInfo["action"] == 5) ||
                                    gameEnd ||
                                    userInfo["bluff"] != null)
                            ? Container(
                                decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(5),
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                width: ssSetWidth(49),
                                height: ssSetWidth(49),
                                child: userInfo["bluff"] != null &&
                                        userInfo["bluff"].length != 0 &&
                                        (userInfo["action"] != null &&
                                            userInfo["action"] != 5) //
                                    ? (isSeated && seatNum == nowCurrentIndex)
                                        ? SizedBox()
                                        : Stack(
                                            children: <Widget>[
                                              userInfo["bluff"][0] == null
                                                  ? SizedBox()
                                                  : Positioned(
                                                      left: 0,
                                                      top: ssSetWidth(3.5),
                                                      child: ImagesAnim(
                                                          29.5,
                                                          42.5,
                                                          0,
                                                          200,
                                                          true,
                                                          (seatNum == nowCurrentIndex &&
                                                                  isSeated)
                                                              ? myHandPoker[0]
                                                                  ["id"]
                                                              : userInfo[
                                                                      "bluff"]
                                                                  [0]["id"])),
                                              userInfo["bluff"][1] == null
                                                  ? SizedBox()
                                                  : Positioned(
                                                      right: ssSetWidth(0),
                                                      top: ssSetWidth(3.5),
                                                      child: ImagesAnim(
                                                          29.5,
                                                          42.5,
                                                          0,
                                                          200,
                                                          true,
                                                          (seatNum == nowCurrentIndex &&
                                                                  isSeated)
                                                              ? myHandPoker[1]
                                                                  ["id"]
                                                              : userInfo[
                                                                      "bluff"]
                                                                  [1]["id"])),
                                            ],
                                          )
                                    : SizedBox(),
                              )
                            : SizedBox(),

//                        //头像旁边的扑克牌
                        ((seatNum == nowCurrentIndex && isSeated) ||
                                gameEnd ||
                                (userInfo != null && userInfo["bluff"] != null))
                            ? SizedBox()
                            : PositionedTransition(
                                rect: fapaiList["${seatNum}_first"] ??
                                    RelativeRectTween(
                                            begin: RelativeRect.fromLTRB(
                                                0, 0, 0, 0),
                                            end: RelativeRect.fromLTRB(
                                                0, 0, 0, 0))
                                        .animatedBy(controller),
                                child: AnimatedOpacity(
                                  opacity: (gameIsStarted &&
                                          userInfo != null &&
                                          userInfo["status"] == 2 &&fapaiList["${seatNum}_second"] !=
                                      null &&
                                          fapaiList["${seatNum}_first"].status !=
                                              AnimationStatus.dismissed &&
                                          userInfo["action"] != null &&
                                          userInfo["action"] != 5)
                                      ? 1
                                      : 0,
                                  duration: (userInfo != null &&
                                          userInfo["action"] != null &&
                                          userInfo["action"] == 5)
                                      ? 400.milliseconds
                                      : fapaiTime.milliseconds,
                                  child: Container(
                                      child: Image.asset(
                                    imgpath + "pokes/poke_0.png",
                                    fit: BoxFit.fitHeight,
                                  )),
                                )),

                        ((seatNum == nowCurrentIndex && isSeated) ||
                                gameEnd ||
                                (userInfo != null && userInfo["bluff"] != null))
                            ? SizedBox()
                            : PositionedTransition(
                                rect: fapaiList["${seatNum}_second"] ??
                                    RelativeRectTween(begin: RelativeRect.fromLTRB(0, 0, 0, 0), end: RelativeRect.fromLTRB(0, 0, 0, 0))
                                        .animatedBy(controller),
                                child: AnimatedOpacity(
                                    opacity: (gameIsStarted && !gameEnd &&
                                            userInfo != null &&
                                            userInfo["status"] == 2 &&
                                            fapaiList["${seatNum}_second"] !=
                                                null && fapaiList["${seatNum}_second"].status !=
                                        AnimationStatus.dismissed &&
                                            userInfo["action"] != null &&
                                            userInfo["action"] != 5)
                                        ? 1
                                        : 0,
                                    duration: (userInfo != null &&
                                            userInfo["action"] != null &&
                                            userInfo["action"] == 5)
                                        ? 400.milliseconds
                                        : fapaiTime.milliseconds,
                                    child: Container(
                                        child:
                                            Image.asset(imgpath + "pokes/poke_0.png", fit: BoxFit.fitHeight))))
                      ],
                    ),
                    //剩余积分
                    setTextWidget(
                        userInfo == null
                            ? ""
                            : gameNumberList["${seatNum}_0"]
                                .value
                                .toStringAsFixed(0),
                        10,
                        false,
                        Colors.white),
                  ],
                ),
              )),
        ),
        //赢家的红色边框
        userInfo != null &&
                isSeated &&
                seatNum == nowCurrentIndex &&
                userInfo["standBy"] != 0 &&
                userInfo["standBy"] != null
            ? Positioned(
                left: -30,
                right: -30,
                top: -30,
                child: Container(
                    child: Center(
                        child: setTextWidget(
                            userInfo["standBy"] == 1
                                ? "等待过庄,下回合"
                                : userInfo["standBy"] == 2
                                    ? "等待过庄,1回合"
                                    : "等待过庄,2回合",
                            12,
                            true,
                            Colors.deepOrange))))
            : SizedBox(),
        winner != null && gameEnd
            ? Container(
                width: ssSetWidth(50),
                height: ssSetWidth(77),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Color(0xffFF3A0D), width: 1.5)),
              )
            : SizedBox(),

        //玩家出手回合的导火索
        gameIsStarted &&
                userInfo != null &&
                userInfo["status"] == 2 &&
                userInfo["isHandle"] &&
                !gameEnd &&
                !isFanpai
            ? Container(
//                              margin: EdgeInsets.only(top: ssSetWidth(7)),
                color: Colors.black12,
                child: CustomPaint(
                  painter: PersonRoundPatinter(
                      userRoundStokeLengthAnimation.value, imgLight),
                  size: Size(ssSetWidth(50), ssSetWidth(77)),
                ))
            : SizedBox(),
        // 出手类型
//        gameIsStarted &&
//                userInfo != null && userInfo["status"] == 2 &&
//                userInfo["action"] != null &&
//                userInfo["action"] != 0 &&winner == null
//            ? Positioned(
//                left: paddingMode == 0
//                    ? userInfo["action"] == 4
//                        ? -ssSetWidth(50 / 2 + 20)
//                        : -ssSetWidth(50 / 2 + 10)
//                    : paddingMode == 1
//                        ? ssSetWidth(50.0 + 10)
//                        : userInfo["action"] == 4
//                            ? ssSetWidth(6)
//                            : ssSetWidth(12),
//                top: paddingMode == 2 ? -ssSetWidth(20) : 2,
//                child: Container(
//                    padding: EdgeInsets.only(left: 6, right: 6),
//                    height: ssSetWidth(20),
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(ssSetWidth(10)),
//                        color: Color(0xffE05B03)),
//                    child: Center(
//                      child: setTextWidget(
//                          userInfo["action"] == 1
//                              ? "加注"
//                              : userInfo["action"] == 2
//                                  ? "跟牌"
//                                  : userInfo["action"] == 3
//                                      ? "看牌"
//                                      : userInfo["action"] == 4
//                                          ? "ALL IN"
//                                          : "弃牌",
//                          12,
//                          false,
//                          Colors.white),
//                    )))
//            : SizedBox(),
        //赢家赢了多少积分
        winner != null &&
                winner["winnerSeat"].toString() == (seatNum + 1).toString() &&
                gameEnd
            ? PositionedTransition(
                rect: winnerScoreAnimation,
                // margin: EdgeInsets.only(top: ssSetWidth(2)),
//                            width: ssSetWidth(60),
//                            height: ssSetWidth(77),
                child: Center(
                  child: AutoSizeText(
                    (double.parse(winner["winnerScore"]) >= 0 ? '+' : '') +
                        double.parse(winner["winnerScore"]).toStringAsFixed(0),
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: "pf",
                        fontSize: ssSp(14),
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFF9F36),
                        shadows: [
                          Shadow(color: Colors.red[900], offset: Offset(-1, 1))
                        ]),
                  ),
                ))
            : SizedBox(),
        //用户正在购买保险
        gameIsStarted &&
                userInfo != null &&
                userInfo["status"] == 2 &&
                userInfo["buyBaoxian"] != null &&
                userInfo["buyBaoxian"] == true &&
                proTimerD >= 0
            ? paddingMode == 0
                ? Positioned(
                    right: ssSetWidth(50.0 + 4.5),
                    top: ssSetWidth(0),
                    child: Container(
                        width: ssSetWidth(59),
                        height: ssSetWidth(70),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: ssSetWidth(59),
                              height: ssSetWidth(22),
                              decoration: BoxDecoration(
//                          color:Colors.blue,
                                  border: Border.all(
                                    color: Color(0xffE05B03),
                                    width: 0.5,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(ssSetWidth(11))),
                              child: Center(
                                child: setTextWidget("购买中${proTimerD}s", 10,
                                    false, Colors.white),
                              ),
                              padding: EdgeInsets.only(left: 3, right: 3),
                            )
                          ],
                        )),
                  )
                : Positioned(
                    left: ssSetWidth(50.0 + 4.5),
                    top: ssSetWidth(0),
                    child: Container(
                        width: ssSetWidth(59),
                        height: ssSetWidth(70),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: ssSetWidth(59),
                              height: ssSetWidth(22),
                              decoration: BoxDecoration(
//                      color:Colors.blue,
                                  border: Border.all(
                                    color: Color(0xffE05B03),
                                    width: 0.5,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(ssSetWidth(11))),
                              child: Center(
                                child: setTextWidget("购买中${proTimerD}s", 10,
                                    false, Colors.white),
                              ),
                              padding: EdgeInsets.only(left: 3, right: 3),
                            )
                          ],
                        )),
                  )
            : gameIsStarted &&
                    userInfo != null &&
                    userInfo["status"] == 2 &&
                    userInfo["totalBet"] != null &&
                    userInfo["totalBet"] != 0.0 &&
                    winner == null &&
                    (userInfo["buyBaoxian"] == null ||
                        userInfo["buyBaoxian"] == false) &&
                    proTimerD < 0
                ? paddingMode == 0
                    ? Positioned(
                        right: ssSetWidth(50.0 + 4.5),
                        top: ssSetWidth(0),
                        child: Container(
                          // width: ssSetWidth(80),
                          height: ssSetWidth(18),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(ssSetWidth(10)),
                              color: Colors.black.withOpacity(0.4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    right: ssSetWidth(17), left: ssSetWidth(6)),
                                child: setTextWidget(
                                    gameNumberList["${seatNum}_1"]
                                        .value
                                        .toStringAsFixed(0),
                                    10,
                                    false,
                                    Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    : Positioned(
                        left: ssSetWidth(50.0 + 4.5),
                        top: ssSetWidth(0),
                        child: Container(
                          // width: ssSetWidth(80),
                          height: ssSetWidth(18),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(ssSetWidth(10)),
                              color: Colors.black.withOpacity(0.4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ssSetWidth(17), right: ssSetWidth(6)),
                                child: setTextWidget(
                                    gameNumberList["${seatNum}_1"]
                                        .value
                                        .toStringAsFixed(0),
                                    10,
                                    false,
                                    Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                : SizedBox(),

        gameIsStarted &&
                userInfo != null &&
                userInfo["status"] == 2 &&
                userInfo["isAllin"] != null
            ? paddingMode == 0
                ? Positioned(
                    right: ssSetWidth(50.0 + 4.5),
                    top: ssSetWidth(21),
                    child: Container(
                      width: ssSetWidth(18.9),
                      height: ssSetWidth(16.65),
                      child: Image.asset(imgpath + "game/allin_icon.png"),
                    ),
                  )
                : Positioned(
                    left: ssSetWidth(50.0 + 4.5),
                    top: ssSetWidth(21),
                    child: Container(
                      width: ssSetWidth(18.9),
                      height: ssSetWidth(16.65),
                      child: Image.asset(imgpath + "game/allin_icon.png"),
                    ),
                  )
            : SizedBox(),

        //飞出的筹码
        //下注金额\
        userInfo != null &&
                (userInfo["buyBaoxian"] == null ||
                    userInfo["buyBaoxian"] == false) &&
                proTimerD < 0
            ? returnCollCallWidget(userInfo, seatNum, 0, paddingMode)
            : SizedBox(),
        returnCollCallWidget(userInfo, seatNum, 1, paddingMode),
        returnCollCallWidget(userInfo, seatNum, 2, paddingMode),
        returnCollCallWidget(userInfo, seatNum, 3, paddingMode),
        //庄家
//        gameIsStarted &&
//                userInfo != null && userInfo["status"] == 2 &&
//                userInfo["userType"] != null &&
//                userInfo["userType"] == 3
//            ? Positioned(
//                left: paddingMode == 2
//                    ? -ssSetWidth(14.0 + 4.5)
//                    : paddingMode == 3 ? ssSetWidth(50.0 + 4.5) : paddingMode ==0 ? ssSetWidth(0) : ssSetWidth(50-14.0),
//                top: paddingMode == 2 ? 0 : paddingMode == 3 ? ssSetWidth(77-14.0) : ssSetWidth(77+2.5),
//                child: Container(
////                    padding: EdgeInsets.only(left: 6, right: 6),
//                    height: ssSetWidth(14),
//                    width: ssSetWidth(14),
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(ssSetWidth(10)),
//                        color: Color(0xffffffff)),
//                    child: Center(
//                      child: setTextWidget("D", 10, true, Colors.black),
//                    )))
//            : SizedBox(),
        //"我赢啦"字符组件
        winner != null &&
                winnerAnimation != null &&
                winner["winnerSeat"].toString() ==
                    (nowCurrentIndex + 1).toString() &&
                winner["winnerSeat"].toString() == (seatNum + 1).toString()
            ? PositionedTransition(
                rect: winnerAnimation,
                child: Container(
                    // color: Colors.redAccent,
                    child: Center(
                        child: AutoSizeText(
                  "你赢啦!",
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: "pf",
                      shadows: [
                        Shadow(color: Colors.red[900], offset: Offset(-2, 1))
                      ],
                      fontSize: ssSp(45),
                      fontWeight: FontWeight.bold,
                      color: Color(0xffFF9F36)),
                ))),
              )
            : SizedBox(),
      ],
    ));
  }

//  GlobalKey _leftCardKey = GlobalKey();
//  GlobalKey _rightCardKey = GlobalKey();
  //玩家自己的手牌视图
  Widget handCards(int type) {
    //0 左边牌  1 右边牌 2 牌类型
    if (type == 0) {
      return PositionedTransition(
          rect: fapaiList["${nowCurrentIndex}_first"] ??
              RelativeRectTween(
                      begin: RelativeRect.fromLTRB(
                          0, 0, ssSetWidth(375), ssSetHeigth(667)),
                      end: RelativeRect.fromLTRB(
                          0, 0, ssSetWidth(375), ssSetHeigth(667)))
                  .animatedBy(controller),
          child: AnimatedOpacity(
              opacity: fapaiList["${nowCurrentIndex}_first"] != null &&fapaiList["${nowCurrentIndex}_first"].status != AnimationStatus.dismissed ? 1 : 0,
              duration: fapaiTime.milliseconds,
              child: Container(
//                color: Colors.red,
                  child: ImagesAnim(13.0, 22.0, 0, 200, false, 0,key: _leftCardKey))));
    } else if (type == 1) {
      return PositionedTransition(
          rect: fapaiList["${nowCurrentIndex}_second"] ??
              RelativeRectTween(
                      begin: RelativeRect.fromLTRB(
                          0, 0, ssSetWidth(375), ssSetHeigth(667)),
                      end: RelativeRect.fromLTRB(
                          0, 0, ssSetWidth(375), ssSetHeigth(667)))
                  .animatedBy(controller),
          child: AnimatedOpacity(
              opacity: fapaiList["${nowCurrentIndex}_second"] != null &&fapaiList["${nowCurrentIndex}_second"].status != AnimationStatus.dismissed ? 1 : 0,
              duration: fapaiTime.milliseconds,
//            key: _rightCardKey,
              child: Container(
                  child: ImagesAnim(13.0, 22.0, 0, 200, false, 0,
                      key: _rightCardKey))));
    } else {
      return fapaiEnded
          ? Positioned(
              bottom: 0 + ssSetHeigth(6) + safeBottomBarHeight(),
              left: 0,
              right: 0,
              child: UnconstrainedBox(
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ssSetWidth(8)),
                      color: Colors.black.withOpacity(0.4)),
                  child: setTextWidget(
                      myHandPokerType == "" ? "" : myHandPokerType,
                      12,
                      false,
                      Colors.white),
                ),
              ))
          : SizedBox();
    }
  }

  //更换座位,重新计算坐标以及开始动画
  Future<void> seatTrans() {
//    controller.dispose();
//    seatController.dispose();
    allocController();

    if (nowCurrentIndex < seatNumTemp) {
      moveStep = nowCurrentIndex + numTotal - seatNumTemp;
    } else {
      moveStep = nowCurrentIndex - seatNumTemp;
    }

    nowCurrentIndex = seatNumTemp;
    seatNumTemp = -1;
    endSitePosition.clear();
    for (int i = 0; i < numTotal; i++) {
      RelativeRect temp;
      temp = startSitePosition[(i + moveStep) >= numTotal
          ? (i + moveStep - numTotal)
          : (i + moveStep)];
      endSitePosition.add(temp);
    }

    resetAnimationList();
    setState(() {});
    seatController.forward();
    return null;
  }

  //所有座位的视图
  Widget setUserSites() {
    List<Widget> siteLists = List();
    for (int i = 0; i < numTotal; i++) {
      siteLists.add(PositionedTransition(
        rect: animationsList[i],
        child: Container(
        //  color: Colors.blueAccent,
          child: userSite(i, startSitePosition[i], () {
            nowCurrentIndex = i;
          }),
        ),
      ));
    }
    if (lastZhuangjiaTagAnimation != null)
      siteLists.add(PositionedTransition(
          rect: RelativeRectTween(
            begin: lastZhuangjiaTagAnimation,
            end: gameZhuangjiaTagAnimation,
          ).animatedBy(gameZhuangjiaTagController),
          child: Container(
              //                    padding: EdgeInsets.only(left: 6, right: 6),
              height: ssSetWidth(14),
              width: ssSetWidth(14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ssSetWidth(10)),
                  color: Color(0xffffffff)),
              child: Center(
                child: setTextWidget("D", 10, true, Colors.black),
              ))));
    return Positioned(
        top: safeStatusBarHeight() + ssSetHeigth(60),
        child: Container(
            width: ssSetWidth(375),
            height: viewHeight,
            child: Stack(children: siteLists.toList())));
  }
  Widget jiazhuAnniuWidget(){
    return ((callData["call"] != null ||
        (callData["follow"] != null && callData["allin"] != null)) &&
        isMyRound) //callData["follow"] == null && callData["pass"] == null &&
        ?jiazhuButtonView(hiddenJiazhuButton,gameIsPause,callData["call"] != null ? "加注" : "ALL IN",callData["call"] != null ? callData["call"]["minCall"].toDouble() : 0.0,callData["call"] != null ? callData["call"]["maxCall"].toDouble() : 0.0,(str){
          if(str == null){
            sendSocketMsg({
                            "messageType":
                                SocketMessageType().GAME_ACTION_REQUEST,
                            "gameActionType": GameActions().ALL_IN,
                            "bet": "0",
                            "gameHouseId": nowRoomInfo["id"]
                          });
          }else
          if (double.parse(str) == callData["call"]["maxCall"]) {
                          sendSocketMsg({
                            "messageType":
                                SocketMessageType().GAME_ACTION_REQUEST,
                            "gameActionType": GameActions().ALL_IN,
                            "bet": "0",
                            "gameHouseId": nowRoomInfo["id"]
                          });
                        } else {
                          sendSocketMsg({
                            "messageType":
                                SocketMessageType().GAME_ACTION_REQUEST,
                            "gameActionType": GameActions().CALL,
                            "bet": str,
                            "gameHouseId": nowRoomInfo["id"]
                          });
                        }

//                    Navigator.pop(context);
                        isMyRound = false;
                        otherButtonAnimationHidden();
        })
//    Positioned(
//      top:safeStatusBarHeight() + ssSetHeigth(60),
//      left:50,
//      right:50,
//      bottom:ssSetHeigth(667) - safeStatusBarHeight() - ssSetHeigth(60)- ssSetHeigth(viewHeight) +ssSetHeigth(tileHeight),
//      child: jiazhuButtonWidget()
    :SizedBox();
  }
}
