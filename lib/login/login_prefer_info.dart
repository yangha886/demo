
import 'package:flutter/material.dart';
import 'package:star/club/club_infomation.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class LoginPreferInfo extends StatefulWidget {
  
  @override
  _LoginPreferInfoState createState() => _LoginPreferInfoState();
}

class _LoginPreferInfoState extends State<LoginPreferInfo> {
  UserModel _userModel;
  @override
  void initState(){
    _userModel =UserInfo().getModel();
  }
  void uploadUserAvatar(String sss) {
    mHttp.getInstance().postHttp("/jwt/user/editprofilepicture", (data) async {
      if (data["code"] == 200) {
        UserInfo().saveAllUserInfos(data["data"]);
        UserInfo().setUserAvatar(data["data"]["profilePicture"]);
        _userModel = UserInfo().getModel();
        setState(() {
          
        });
      } else {
        showToast(data["msg"] ?? "未知错误");
      }
    }, (error) {}, params: {"profilePicture": sss},noLoading: true);
  }
  TextEditingController _controller = TextEditingController();
  bool _canFinish = false;
  int sexType = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: style.backgroundColor,
            body: GestureDetector(
              onTap: () {
                if (_controller.text.length > 0) {
                        setState(() {
                          _canFinish = true;
                        });
                      } else {
                        setState(() {
                          _canFinish = false;
                        });
                      }
                cancelTextEdit(context);
              },
              child: SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(top: 27, left: 48, right: 48),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: safeStatusBarHeight() - 10),
                      child: Container(
                        width: ssSetWidth(375),
                        child: Center(
                          child: setTextWidget("完善资料", 18, true, b33),
                        ),
                      ),
                    ),
                    Container(
                        width: ssSetWidth(375),
                        padding: EdgeInsets.only(top: 27),
                        color: style.backgroundColor,
                        child: InkWell(
                          onTap: () {
                            showImgDialog(context, () {
                              toCamera((url,{f}) {
                                uploadUserAvatar(url);
                              }, context);
                            }, () {
                              toPhoto((url,{f}) {
                                uploadUserAvatar(url);
                              }, context);
                            });
                          },
                          child:
                              Center(child: circleMemberAvatar(-1, size: 101,avatarPath: _userModel!= null? _userModel.avatar:"")),
                        )),
                    labelTextRow("昵称", "8个汉字或16个英文字母", _controller, () {
                      if (_controller.text.length > 0) {
                        setState(() {
                          _canFinish = true;
                        });
                      } else {
                        setState(() {
                          _canFinish = false;
                        });
                      }
                      cancelTextEdit(context);
                    }),
                    greyLineUI(1),
                    Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Container(
                        width: ssSetWidth(375),
                        child: setTextWidget("昵称只能设置一次", 12, false, g99),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 28,left:28,right:28),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: ssSetWidth(90),
                              height: ssSetWidth(30),
                              decoration: BoxDecoration(
                                border: Border.all(color: sexType == 0?lanse:g99),
                                  color: sexType == 0 ? lanse : style.backgroundColor,
                                  borderRadius:
                                      BorderRadius.circular(ssSetWidth(15))),
                              child: InkWell(
                                onTap: () {
                                  if (sexType != 0) {
                                    setState(() {
                                      sexType = 0;
                                    });
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Image.asset(
                                      imgpath +
                                          (sexType == 0
                                              ? 'woman_s.png'
                                              : 'woman_us.png'),
                                      width: ssSetWidth(10.12),
                                      height: ssSetWidth(16.62),
                                    ),),
                                    Expanded(child: setTextWidget("女生", 14, false, sexType == 0?style.backgroundColor:g99),)
                                  ],
                                ),
                              )),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Container(
                              width: ssSetWidth(90),
                              height: ssSetWidth(30),
                              decoration: BoxDecoration(
                                border: Border.all(color: sexType == 1?lanse:g99),
                                  color: sexType == 1 ? lanse : style.backgroundColor,
                                  borderRadius:
                                      BorderRadius.circular(ssSetWidth(15))),
                              child: InkWell(
                                onTap: () {
                                  if (sexType != 1) {
                                    setState(() {
                                      sexType = 1;
                                    });
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Image.asset(
                                      imgpath +
                                          (sexType == 0
                                              ? 'man_us.png'
                                              : 'man_s.png'),
                                      width: ssSetWidth(18.52),
                                      height: ssSetWidth(16.44),
                                    ),),
                                    Expanded(child: setTextWidget("男生", 14, false, sexType == 1?style.backgroundColor:g99),)
                                  ],
                                ),
                              )),
                              
                        ],
                      ),
                    ),
                    bindButton()
                  ],
                ),
              )),
            )),
        onWillPop: () async {
          return false;
        });
  }
  Widget bindButton() {
    return Padding(
        padding: EdgeInsets.only(top: 36),
        child: Container(
          height: ssSetWidth(44),
          width: ssSetWidth(300),
          child: FlatButton(
            color: lanse.withOpacity(_canFinish ? 1 : 0.41),
            onPressed: () {
              if (_canFinish) {
                mHttp.getInstance().postHttp("/jwt/user/edituser", (data) async{
                  if (data["msg"] == "保存成功") {
                    await UserInfo().saveUserInfo("userNameOrigin", _controller.text);
                    await UserInfo().saveUserInfo("sex", sexType == 0? "2":"1");
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                    //这里可能会有问题
                    eventBus.emit('onLogin',UserInfo().getModel());
                  }
                }, (error){

                },params: {"userNameOrigin":_controller.text,"sex":sexType == 0? "2":"1"});
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
