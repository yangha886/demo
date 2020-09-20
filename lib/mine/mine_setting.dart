import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/club/club_infomation.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/theme_config.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class MineSetting extends StatefulWidget {
  @override
  _MineSettingState createState() => _MineSettingState();
}

class _MineSettingState extends State<MineSetting> {
  bool voiceOn = false;
  bool soundOn = false;
  bool themeOn = style.themeType == 0 ? false: true;
  UserModel _model = UserInfo().getModel();
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _model =
  // }
  void uploadUserAvatar(String sss) {
    mHttp.getInstance().postHttp("/jwt/user/editprofilepicture", (data) async {
      if (data["code"] == 200) {
        UserInfo().saveAllUserInfos(data["data"]);
        UserInfo().setUserAvatar(data["data"]["profilePicture"]);
        _model = UserInfo().getModel();
        setState(() {
          
        });
        eventBus.emit('mineChanged', _model);
      } else {
        showToast(data["msg"] ?? "未知错误");
      }
    }, (error) {}, params: {"profilePicture": sss},noLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    print(style);
    return Scaffold(

      appBar: whiteAppBarWidget("设置", context, haveShadowLine: true),
      body: SingleChildScrollView(
          child: Container(
            color: style.backgroundColor,
        child: Column(
          children: <Widget>[
            labelCell("头像", "",
                rightView: circleMemberAvatar(-1, avatarPath: _model.avatar),
                height: ssSetWidth(70), func: () {
              showImgDialog(context, () {
                toCamera((url,{f}) {
                  uploadUserAvatar(url);
                }, context);
              }, () {
                toPhoto((url,{f}) {
                  uploadUserAvatar(url);
                }, context);
              });
            }),
            greyLineUI(
              0.5,
              color: style.textDivideLineColor,
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            labelCell("昵称", _model.nickName, height: ssSetWidth(70)),
            greyLineUI(
              0.5,
              color: style.textDivideLineColor,
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            labelCell("ID", _model.id, height: ssSetWidth(70)),
            greyLineUI(
              0.5,
              color: style.textDivideLineColor,
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            labelCell("性别", _model.sex == "1" ? "男" : "女",
                height: ssSetWidth(70)),
            greyLineUI(10, color: style.textDivideBlockColor),
            labelCell("聊天语音", "",
                rightView: Switch(
                    value: voiceOn,
                    activeColor: style.themeColor,
                    activeTrackColor: style.themeColor,
                    inactiveTrackColor: style.textDivideLineColor,
                    onChanged: (bool v) {
                      setState(() {
                        voiceOn = v;
                      });
                    }),
                height: ssSetWidth(70)),
            greyLineUI(
              0.5,
              color: style.textDivideLineColor,
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            labelCell("主题切换", "",
                rightView: Switch(
                    value: themeOn,
                    activeColor: style.themeColor,
                    activeTrackColor: style.themeColor,
                    inactiveTrackColor: style.textDivideLineColor,
                    onChanged: (bool v) {
                      setState(() async{
                        themeOn = v;
                        style = v == true ? darkTheme() : blueTheme();
                        SharedPreferences _sp = await SharedPreferences.getInstance();
                        _sp.setInt("SYSTEMTHEMETYPE", v== true? 1:0);
//                        style = themeOn == true
//                            ? themeColorStyle.redWhite
//                            : themeColorStyle.whiteBlue;
//                        lanse = style == themeColorStyle.whiteBlue
//                            ? Color(0xff1479ED)
//                            : style == themeColorStyle.blackWhite
//                                ? Colors.black
//                                : Colors.red;
                        eventBus.emit("onThemeChange");
                      });
                    }),
                height: ssSetWidth(70)),
            greyLineUI(
              0.5,
              color: style.textDivideLineColor,
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            labelCell("游戏音效", "",
                rightView: Switch(
                    value: soundOn,
                    inactiveTrackColor: style.textDivideLineColor,
                    activeColor: style.themeColor,
                    activeTrackColor: style.themeColor,
                    onChanged: (bool v) {
                      setState(() {
                        soundOn = v;
                      });
                    }),
                height: ssSetWidth(70)),
            greyLineUI(
              0.5,
              color: style.textDivideLineColor,
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            labelCell("用户服务协议", "", hasArrow: true, height: ssSetWidth(70)),
            greyLineUI(
              0.5,

              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            labelCell("版本", "1.0.0", height: ssSetWidth(70)),
            greyLineUI(10, color: style.textDivideBlockColor),
            Container(
              width: ssSetWidth(375),
              height: ssSetWidth(44),
              color: style.backgroundColor,
              child: InkWell(
                onTap: () {
                  List storeKeysList = Global.globalShareInstance.getKeys().toList();
                  for(var key in storeKeysList){
                    if(key.contains("boardsMapStorage:") ||
                        key.contains("gameHouseInfoStorage:") ||
                        key.contains("boardsStorageNum:") ||
                        key.contains("minePageRecordStorage")){
                      Global.globalShareInstance.remove(key);
                    }
                  }
                  showAlertView(context, "提示", "缓存清理完成", null, "知道了", (){
                    Navigator.pop(context);
                  });
                },
                child: Center(
                  child: setTextWidget("清空缓存", 16, false, Color(0xff000000)),
                ),
              ),
            ),
            greyLineUI(10, color: style.textDivideBlockColor),
            Container(
              width: ssSetWidth(375),
              height: ssSetWidth(44),
              color: style.backgroundColor,
              child: InkWell(
                onTap: () {
                  UserInfo().userQuitLogin();
                  Navigator.of(context).pop();
                  eventBus.emit("quitLogin");
                },
                child: Center(
                  child: setTextWidget("退出", 16, false, Color(0xffFF0000)),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
