import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/country_select.dart';
import 'package:star/widgets/some_widgets.dart';

class LoginReg extends StatefulWidget {
  final String viewType; //0 reg 1 reset
  LoginReg(this.viewType);
  @override
  _LoginRegState createState() => _LoginRegState();
}

class _LoginRegState extends State<LoginReg> {
  String countryCode = "CN+86";
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  bool _canLogin = false;
  Timer _timer;
  var countdownTime = 0;

  startCountdown() {
    if (_userNameController.text.length != 11) {
      showToast("请先输入11位手机号码");
      return;
    }
    showAlertView(
        context,
        "确认手机号码",
        """将发送验证码到这个号码：\n${_userNameController.text}
                  """,
        "取消",
        "确定", () {
          Navigator.pop(context);
        mHttp.getInstance().postHttp("/jwt/code/getmobilecode", (data) {
        countdownTime = 60;
        final call = (timer) {
          setState(() {
            if (countdownTime == 0) {
              _timer.cancel();
            } else
              countdownTime -= 1;
          });
        };
        _timer = Timer.periodic(Duration(seconds: 1), call);
      }, (error) {}, params: {"mobile": _userNameController.text}); 
    });
    
  }

  void changeLoginButtonStyle(String value) {
    if (_userNameController.text.length > 0 &&
        _pwdController.text.length > 0 &&
        _codeController.text.length > 0) {
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

  @override
  void dispose() {
    super.dispose();
    if (_timer !=null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: whiteAppBarWidget(widget.viewType == "0" ?"新用户注册" : "重置密码", context, icon: Icon(Icons.close)),
        body: GestureDetector(
            onTap: () {
              changeLoginButtonStyle(null);
            },
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                width: ssSetWidth(375),
                height: ssSetHeigth(667),
                padding: EdgeInsets.only(
                    left: ssSetWidth(34), right: ssSetWidth(34)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    phoneTextRow(countryCode, (() {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return CountrySelectView((d) {
                              setState(() {
                                countryCode = d;
                                Navigator.pop(context);
                              });
                            });
                          });
                    }), _userNameController, changeLoginButtonStyle),
                    greyLineUI(1),
                    codeTextField(countdownTime, "请输入验证码", _codeController,
                        changeLoginButtonStyle, startCountdown),
                    greyLineUI(1),
                    pwdTextRow(_pwdController, changeLoginButtonStyle),
                    greyLineUI(1),
                    loginButton()
                  ],
                ),
              ),
            )),
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
                if(widget.viewType =="0"){
                  mHttp.getInstance().postHttp("/jwt/code/register", (data) async{
                    print(data);
                    if (data["data"] == null) {
                      showAlertView(context, "温馨提示", data["msg"], null, "确定", (){
                        Navigator.pop(context);
                      });
                      return;
                    }
                    mHttp.getInstance().setToken(data["data"]["token"]);
                    await UserInfo().saveAllUserInfos(data["data"]);
                    Application.router.navigateTo(context, regPreferInfoPath,transition: TransitionType.inFromRight);
                    
                  }, (error){

                  },params: {"mobile":_userNameController.text,"code":_codeController.text,"passWord":_pwdController.text});
                }else{

                }
                
              }
            },
            child: setTextWidget(widget.viewType =="0" ? "下一步" : "完成", 18, false, style.backgroundColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
        ));
  }
}
