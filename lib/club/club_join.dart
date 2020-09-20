import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class ClubJoin extends StatefulWidget {
  @override
  _ClubJoinState createState() => _ClubJoinState();
}

class _ClubJoinState extends State<ClubJoin> {
  TextEditingController _controller = TextEditingController();
  bool _canJoin = false;
  String joinCode;
  void changeLoginButtonStyle() {
    if (joinCode != null && joinCode.length > 0) {
      setState(() {
        _canJoin = true;
      });
    } else {
      setState(() {
        _canJoin = false;
      });
    }
   cancelTextEdit(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: whiteAppBarWidget("加入俱乐部", context, haveShadowLine: true),
      body: Container(
        child: GestureDetector(
          onTap: () {
            changeLoginButtonStyle();
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 11),
                child: setTextWidget("输入俱乐部ID", 16, false, style.textTitleColor),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 29,left: 32,right: 32),
                  child: Container(

                    height: ssSetWidth(40),
                    child: PinCodeTextField(
                      length: 8,
                      obsecureText: false,
                      autoFocus: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(ssSetWidth(3)),
                        fieldHeight: ssSetWidth(35.24),
                        fieldWidth: ssSetWidth(32.24),
                        activeColor: style.clubJoinUnderLineColor,
                        activeFillColor:  Colors.transparent,
                        disabledColor:  Colors.transparent,
                        inactiveColor:  style.clubJoinUnderLineColor,
                        inactiveFillColor:  Colors.transparent,
                        selectedColor:  style.clubJoinUnderLineColor,
                        selectedFillColor:  Colors.transparent,
                        // activeFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 100),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      // errorAnimationController: errorController,
                      controller: _controller,
                      onCompleted: (v) {
                        joinCode = "6";
                        changeLoginButtonStyle();
                      },
                      onChanged: (value) {
                      },
                      onSubmitted: (value) {
                        joinCode = "6";
                        changeLoginButtonStyle();
                      },
                      textStyle: TextStyle(color: style.themeColor,fontWeight: FontWeight.bold, fontSize: ssSp(18)),
                    ),
                    //   child: VerificationBox(
                    //     count: 8,
                    //     itemWidget: 32,
                    //   autoFocus: true,
                    //   type: VerificationBoxItemType.underline,
                    //   onSubmitted: (value) {
                    // joinCode = "6";
                    // changeLoginButtonStyle();
                    //   },
                    //   textStyle: TextStyle(color: Color(0xff2E9BEB),fontSize: ssSp(18)),
                    // ),
                  )
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
                  width: ssSetWidth(257),
                  height: ssSetWidth(44),
                  child: FlatButton(
                    color: style.themeColor.withOpacity(_canJoin ? 1 : 0.41),
                    onPressed: () {
                      if (_canJoin) {
                        mHttp.getInstance().postHttp('/jwt/clubuser/add', (data) {
                          if (data["code"] == 200) {
                            showToast("已成功申请加入,等待群主通过申请");
                            Navigator.of(context).pop();
                          }
                        }, (error) {}, params: {
                          "clubId":joinCode
                        });
                      }
                    },
                    child: setTextWidget("加入俱乐部", 16, false, Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              )
            ],
          ),
        ),
        color: style.purityBlockColor,
      )
    );
  }
}
