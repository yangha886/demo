import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/httprequest/socketUtil.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/game_widgets.dart';
import 'package:star/widgets/some_widgets.dart';
import 'package:web_socket_channel/status.dart' as status;

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  TextEditingController _codeControler = TextEditingController();
  UserModel _userModel;
  bool isIn = false;
  //当前已经有请求进入的弹窗时不再显示黑底
  bool isShowedGetinDialog = false;
  List nowGameList = List();
  void setChannel() async {
    loginSocket();
  }
  Widget buildMaterialDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
  @override
  void initState() {
    super.initState();
    // _codeControler.text = "222222";
    //登录成功调用
    eventBus.on("onLogin", (arg) {
      _userModel = arg;
      setChannel();
      // eventBus.emit("clubChanged", arg);
      eventBus.emit("mineChanged", arg);
    });
    //断线后需要重新进入房间
    eventBus.on("reToRoom", (arg) {
      if (!isInGame) {
        cancelTextEdit(context);
        showAlertView(context, "当前有房局", "是否重新进入房局", "放弃", "进入", () {
          Navigator.pop(context);
          nowRoomInfo = arg["data"]["gameHouse"];
          isIn = true;
          Application.router.navigateTo(context, gameMainPath);
        });
      }
    });
    //退出登录
    eventBus.on("quitLogin", (arg) {
      if (channel != null) {
        channel.sink.close(status.goingAway);
        channel = null;
      }
      cancelTextEdit(context);
      Application.router.navigateTo(context, loginMainPath,
          transition: TransitionType.inFromBottom);
    });
    //主题改变
    eventBus.on("onThemeChange", (arg) {
      setState(() {});
    });
    //主动进入房间
    eventBus.on("inHouse", (arg) {
      isIn = true;
      cancelTextEdit(context);
      Application.router.navigateTo(context, gameMainPath);
    });
    eventBus.on("somebodyRequestInSeat",(arg){
      print("有人请求坐下");
      //是否为第一个弹框
      bool isFirstShow = !isShowedGetinDialog;
      //房主弹出审核框
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: isShowedGetinDialog ? Colors.transparent : Colors.black45,
        transitionDuration: const Duration(milliseconds: 150),
        transitionBuilder: buildMaterialDialogTransitions,
        useRootNavigator: false,
        routeSettings: null,
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(
                builder: (BuildContext context) {
                  return UserInDialog(context,(value){
                    if(isFirstShow){
                      //因为可能同时弹出多个申请框, 只有第一个申请框点击按钮之后才设置没有显示的弹框了
                      isShowedGetinDialog = false;
                    }
                    sendSocketMsg({
                      "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                      "gameHouseMessage": HouseMessageType().SCORE_HOUSE_OWNER_TO_SERVER_REQUEST,
                      "gameHouseId": arg["data"]["data"]["gameHouseId"],
                      "requestScoreId":arg["data"]["data"]["requestScoreId"],
                      "isAccess":value
                    });
                  },{"cnName":arg["data"]["data"]["cnName"],"score":arg["data"]["data"]["score"]});
                }
            ),
          );
        },
      );
    });
    UserInfo().getAllUserInfo().then((model) {
      if (model.token == null) {
        Application.router.navigateTo(context, loginMainPath,
            transition: TransitionType.inFromBottom);
      } else {
        mHttp.getInstance().setToken(model.token);

        setState(() {
          _userModel = model;
        });
        setChannel();
        if (_userModel.nickName == "德州玩家") {
          // Application.router.navigateTo(context, regPreferInfoPath,
              // transition: TransitionType.inFromRight);
        }
        // eventBus.emit("clubChanged", model);
        eventBus.emit("mineChanged", model);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: style.backgroundColor,
        appBar: whiteAppBarWidget(
          "创建牌局",
          context,
          isMain: true,
          actions: [
            Container(
                color: style.backgroundColor,
                padding: EdgeInsets.only(right: 15),
                child: InkWell(
                    onTap: () {
                      cancelTextEdit(context);
                      Application.router.navigateTo(
                          context, "$messageListPath?msgType=0",
                          transition: TransitionType.inFromRight);
                    },
                    child: Center(
                        child: Stack(
                      children: <Widget>[
                        Image.asset(
                          imgpath + "notice_icon.png",
                          width: ssSetWidth(19.41),
                          height: ssSetWidth(21.97),
                        ),
                        Positioned(
                            top: 1,
                            right: 1,
                            child: Container(
                              width: ssSetWidth(5),
                              height: ssSetWidth(5),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                            ))
                      ],
                    ))))
          ],
        ),
        body: GestureDetector(
          onTap: (){
            cancelTextEdit(context);
          },
          child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    width: ssSetWidth(345),
                    height: ssSetWidth(120),
                    decoration: BoxDecoration(
                        color: lanse, borderRadius: BorderRadius.circular(6)),
                  child:InkWell(
                      onTap: () {
                        cancelTextEdit(context);
                        Application.router.navigateTo(
                            context, homeCreateGamePath,
                            transition: TransitionType.inFromRight);
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child:
                            Image.asset(imgpath + "home_create_bg.png"),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: ssSetWidth(29.93),
                                top: ssSetWidth(0),
                                right: ssSetWidth(14.81)),
                            child: Row(
                              children: <Widget>[
                                Image.asset(imgpath + "home_create_logo.png",
                                    width: ssSetWidth(46.07),
                                    height: ssSetWidth(65.73)),
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: ssSetWidth(14),
                                            top: ssSetWidth(9.85),
                                            bottom: ssSetWidth(14.88)),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            setTextWidget(
                                                "创建牌局", 18, true, Colors.white),
                                            setTextWidget("Create a hand", 12,
                                                true, Color(0xffB2D6FF)),
                                          ],
                                        ))),
                                Image.asset(imgpath + "white_arrow.png",
                                    width: ssSetWidth(11.9),
                                    height: ssSetWidth(20.64)),
                              ],
                            ),
                          ),
                          Container(
                            color: style.minePictureMaskColor,
                          )
                        ],
                      )),),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: joinByPwd(),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                      width: ssSetWidth(375),
                      child: setTextWidget("当前牌局", 18, true, b33),
                    )),
                nowGame(),
              ],
            ),
          ),
        ),
        )
    );
  }

  Widget nowGame() {
    if (nowGameList.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: 30),
        child: setTextWidget("当前暂无牌局", 18, false, g99),
      );
    }
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: nowGameList.length,
        itemBuilder: (context, index) {
          return roomCell(index, 0);
        });
  }

  String pwdCode;
  Widget joinByPwd() {
    //padding: EdgeInsets.only(top:15),
    return Container(
      height: ssSetWidth(116.7),
      width: ssSetWidth(345),
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: style.purityBlockColor,
        borderRadius: BorderRadius.circular(ssSetWidth(6)),
        boxShadow: style.textDivideBlockColor == Colors.black ? null :[
          BoxShadow(
              color: g99.withOpacity(0.16),
              offset: Offset(0, 0),
              blurRadius: 6.0,
              spreadRadius: 1),
          BoxShadow(color: Color(0xffffffff))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Image.asset(
              imgpath + 'joinbypwd.png',
              width: ssSetWidth(34.53),
              height: ssSetWidth(42.83),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 25, bottom: 25),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: setTextWidget("加入密码局", 16, false, b33),
                ),
                Container(
                  width: ssSetWidth(220),
                  height: ssSetWidth(40),
                  padding: EdgeInsets.only(top: 8),
                  child: PinCodeTextField(
                    length: 6,
                    textInputType: TextInputType.number,
                    obsecureText: false,
                    autoFocus: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      borderRadius: BorderRadius.circular(ssSetWidth(3)),
                      fieldHeight: ssSetWidth(30.24),
                      fieldWidth: ssSetWidth(25.24),
                      activeColor: style.clubJoinUnderLineColor,
                      activeFillColor: Colors.transparent,
                      disabledColor: Colors.transparent,
                      inactiveColor: style.clubJoinUnderLineColor,
                      inactiveFillColor: Colors.transparent,
                      selectedColor: style.clubJoinUnderLineColor,
                      selectedFillColor: Colors.transparent,
                      // activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    controller: _codeControler,
                    onCompleted: (v) {
                      sendSocketMsg({
                        "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                        "gameHouseMessage": HouseMessageType().INTO_HOUSE,
                        "pwd": v
                      }, haveLoading: true);
                      _codeControler.text = "";
                    },
                    onChanged: (value) {},
                    onSubmitted: (value) {
                      sendSocketMsg({
                        "messageType": SocketMessageType().GAME_HOUSE_REQUEST,
                        "gameHouseMessage": HouseMessageType().INTO_HOUSE,
                        "pwd": value
                      }, haveLoading: true);
                      _codeControler.text = "";
                    },
                    textStyle: TextStyle(color: b33, fontSize: ssSp(16)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
