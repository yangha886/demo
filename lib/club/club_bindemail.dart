import 'dart:async';

import 'package:flutter/material.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class ClubBindEmail extends StatefulWidget {
  @override
  _ClubBindEmailState createState() => _ClubBindEmailState();
}

class _ClubBindEmailState extends State<ClubBindEmail> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  bool _canBind = false;
  void changeBindButtonStyle() {
    if (_emailController.text.length > 0) {
      setState(() {
        _canBind = true;
      });
    } else {
      setState(() {
        _canBind = false;
      });
    }
    cancelTextEdit(context);
  }
  Timer _timer;
  var countdownTime= 0;
  @override
  void dispose(){
    super.dispose();
    if (_timer !=null) {
      _timer.cancel();
    }
    
  }
  startCountdown(){
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: whiteAppBarWidget("绑定安全邮箱", context,haveShadowLine: true,result: false),
      body: GestureDetector(
                onTap: () {
                  changeBindButtonStyle();
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
                        
                        labelTextRow("邮箱", "请输入邮箱地址", _emailController,changeBindButtonStyle),
                        greyLineUI(1),
                        // codeTextField(countdownTime, "请输入验证码", _codeController, changeBindButtonStyle, startCountdown),
                        // greyLineUI(1),
                        bindButton()
                      ],
                    ),
                  ),
                )),
    );
  }
  Widget bindButton() {
    return Padding(
        padding: EdgeInsets.only(top: 36),
        child: Container(
          height: ssSetWidth(44),
          width: ssSetWidth(300),
          child: FlatButton(
            color: lanse.withOpacity(_canBind ? 1 : 0.41),
            onPressed: () {
              if (_canBind) {
                mHttp.getInstance().postHttp("/jwt/club/update", (data){
                  if (data["code"] == 200) {
                    nowClubInfo["email"] = _emailController.text;
                    Navigator.pop(context,true);
                  }else{
                    showToast(data["msg"]);
                  }
                  
                }, (error){

                },params: {"email": _emailController.text,"clubId":nowClubInfo["id"].toString()});
              }
            },
            child: setTextWidget("完成", 18, false, style.backgroundColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
        )
    );
  }
}