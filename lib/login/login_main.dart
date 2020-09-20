import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/country_select.dart';
import 'package:star/widgets/some_widgets.dart';

class LoginMain extends StatefulWidget {
  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  int loginType = 0;
  String countryCode = "CN+86";
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  bool _canLogin = false;
  void changeLoginButtonStyle(String value) {
    if (_userNameController.text.length > 0 &&
        (loginType == 0
            ? _pwdController.text.length > 0
            : _codeController.text.length > 0)) {
      setState(() {
        _canLogin = true;
      });
    } else {
      setState(() {
        _canLogin = false;
      });
    }
    if(value == null)
    cancelTextEdit(context);
  }
  void showCountryList(){

  }
  @override
  void dispose(){
    super.dispose();
    if(_timer!=null)
      _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: style.backgroundColor,
            body: GestureDetector(
                onTap: () {
                  changeLoginButtonStyle(null);
                },
                child: SingleChildScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    width: ssSetWidth(375),
                    height: ssSetHeigth(667),
                    padding: EdgeInsets.only(
                       left: ssSetWidth(24), right: ssSetWidth(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        logoView(),
                        titleView(),
                        loginTypeRow(),
                        phoneTextRow(countryCode,((){
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return CountrySelectView((d){
                                setState(() {
                                  countryCode = d;
                                  Navigator.pop(context);
                                });
                              });
                            }
                          );
                        }), _userNameController, changeLoginButtonStyle),
                        greyLineUI(1),
                        loginType == 0 ? pwdTextRow(_pwdController, changeLoginButtonStyle) : codeTextField(countdownTime, "请输入6位验证码", _codeController, changeLoginButtonStyle, startCountdown),
                        greyLineUI(1),
                        registRow(),
                        loginButton(),
                        Expanded(child: SizedBox()),
                        setTextWidget("抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。", 11, false, g99),
                        setTextWidget("适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。", 11, false, g99),
                        SizedBox(height:10)
                      ],
                    ),
                  ),
                )),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }

  Widget titleView() {
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: setTextWidget("Facepoker", 18, true, b33));
  }

  Widget logoView() {
    return Padding(
      padding: EdgeInsets.only(top: safeStatusBarHeight() + 22),
      child: Container(
        width: ssSetWidth(80),
        height: ssSetWidth(80),
        child: Image.asset(imgpath+"icon-facepoker-xxxhdpi.png"),
      ),
    );
  }

  Widget loginTypeRow() {
    return Padding(
        padding: EdgeInsets.only(top: ssSetHeigth(44)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
              color: style.backgroundColor,
              child: InkWell(
                  onTap: () {
                    if (loginType == 1) {
                      loginType = 0;
                      changeLoginButtonStyle(null);
                    }
                  },
                  child: loginType == 0
                      ? setTextWidget("手机号登录", 18, true, b33,
                          textAlign: TextAlign.center)
                      : setTextWidget("手机号登录", 16, false, g99,
                          textAlign: TextAlign.center)),
            )),
            Expanded(
                child: Container(
              color: style.backgroundColor,
              child: InkWell(
                  onTap: () {
                    if (loginType == 0) {
                      loginType = 1;
                      changeLoginButtonStyle(null);
                    }
                  },
                  child: loginType == 1
                      ? setTextWidget("验证码登录", 18, true, b33,
                          textAlign: TextAlign.center)
                      : setTextWidget("验证码登录", 16, false, g99,
                          textAlign: TextAlign.center)),
            ))
          ],
        ));
  }

  Timer _timer;
  var countdownTime= 0;
  
  startCountdown(){
    mHttp.getInstance().postHttp("/jwt/code/getmobilecode", (data){
      countdownTime = 60;
      final call = (timer){
        setState(() {
          if (countdownTime == 0){
            _timer.cancel();
          }else
            countdownTime -=1;
        });
      };
      _timer = Timer.periodic(Duration(seconds: 1), call);
    }, (error){

    },params: {"mobile":_userNameController.text});
    
  }


  Widget registRow() {
    return Padding(
      padding: EdgeInsets.only(top: 6),
      child: Row(
        children: <Widget>[
          Container(
            color: style.backgroundColor,
            child: InkWell(
              child: setTextWidget("重置密码", 13, false, g99),
              onTap: () {
                print("重置密码");
                Application.router.navigateTo(context, "${loginRegPhonePath}?viewType=1",transition: TransitionType.inFromRight);
              },
            ),
          ),
          Expanded(child: SizedBox()),
          Container(
                  color: style.backgroundColor,
                  child: InkWell(
                    child: setTextWidget("立即注册", 13, false, lanse,
                        textAlign: TextAlign.right),
                    onTap: () {
                      print("立即注册");
                      Application.router.navigateTo(context, "${loginRegPhonePath}?viewType=0",transition: TransitionType.inFromRight);
                    },
                  ))
        ],
      ),
    );
  }

  Widget loginButton() {
    return Padding(
        padding: EdgeInsets.only(top: 36),
        child: Container(
          height: ssSetWidth(44),
          width: ssSetWidth(300),
          child: FlatButton(
            color: lanse.withOpacity(_canLogin ? 1 : 0.41),
            onPressed: () {
              if (_canLogin) {
                
                if (loginType == 0) {
                  // if (isFAKEDATA) {
                  //   Navigator.popUntil(context, ModalRoute.withName("/"));
                  //   return;
                  // }
                  FormData loginData =FormData.fromMap({"mobile":_userNameController.text,"passWord":_pwdController.text});
                  mHttp.getInstance().postHttp('/jwt/login', (data) async{
                    mHttp.getInstance().setToken(data["token"]);
                    await UserInfo().saveAllUserInfos(data);
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                    eventBus.emit('onLogin',UserInfo().getModel());
                  }, (error){
                    showAlertView(context, "温馨提示", error["message"], null, "确定", (){
                      Navigator.pop(context);
                    });
                  },params: loginData);
                } else {
                  mHttp.getInstance().postHttp(
                    "/jwt/code/loginbycode", (data) async {
                      mHttp.getInstance().setToken(data["token"]);
                    await UserInfo().saveAllUserInfos(data);
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                    eventBus.emit('onLogin',UserInfo().getModel());
                  }, (error) {
                    showAlertView(context, "温馨提示", error["message"], null, "确定", (){
                      Navigator.pop(context);
                    });
                  },
                  params: {
                    "mobile": _userNameController.text,
                    "code": _codeController.text
                  });
                }
              }
            },
            child: setTextWidget("登录", 18, false, style.backgroundColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
        )
    );
  }
}
