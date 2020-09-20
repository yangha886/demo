
import 'package:flutter/material.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/pubRequest.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class ClubCreate extends StatefulWidget {
  @override
  _ClubCreateState createState() => _ClubCreateState();
}

class _ClubCreateState extends State<ClubCreate> {
  TextEditingController _clubNameController = TextEditingController();
  TextEditingController _clubDesController = TextEditingController();
  bool _canCreate = false;
  String clubLogoUrl = null;
  void changeCreateButtonStyle(String value) {
    if (_clubNameController.text.length > 0 &&
        _clubDesController.text.length > 0) {
      setState(() {
        _canCreate = true;
      });
    } else {
      setState(() {
        _canCreate = false;
      });
    }
    if(value == null)
    cancelTextEdit(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: whiteAppBarWidget("创建俱乐部", context),
        // resizeToAvoidBottomPadding: false,
        backgroundColor: style.textDivideBlockColor,
        body: GestureDetector(
            onTap: () {
              changeCreateButtonStyle(null);
            },
            child: Container(
              color: style.textDivideBlockColor,
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  clubAvatar(),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 11),
                    child: setTextWidget("俱乐部名称", 16, false, b33),
                  ),
                  mTextFiled(
                    _clubNameController,
                    changeCreateButtonStyle,
                    "俱乐部名称（2-10个字符或字母）",
                    1,
                    hintStyle:
                        TextStyle(color: style.textTipColor, fontSize: ssSp(16)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 11),
                    child: setTextWidget("俱乐部介绍", 16, false, b33),
                  ),
                  mTextFiled(
                    _clubDesController,
                    changeCreateButtonStyle,
                    "俱乐部介绍（10-50个字符）",
                    4,
                    hintStyle:
                    TextStyle(color: style.textTipColor, fontSize: ssSp(14)),
                  ),
                  createButton(),
                ],
              ),
            ))));
  }
  // File clubLogoFile = null;
  Widget clubAvatar() {
    return Container(
      height: ssSetWidth(130),
      width: ssSetWidth(375),
      padding: EdgeInsets.only(top: ssSetWidth(10), bottom: ssSetWidth(15)),
      color: style.backgroundColor,
      child: InkWell(
        onTap: () {
          showImgDialog(context, () {
                toCamera((url,{f}) {
                  clubLogoUrl = url;
                  // setState(() {
                  //   clubLogoFile = f;
                  // });
                }, context);
              }, () {
                toPhoto((url,{f}) {
                  clubLogoUrl = url;
                }, context);
              });
        },
        child: Image.asset(
          imgpath+"silverClub.png",
          width: ssSetWidth(100),
          height: ssSetWidth(100),
        ),
      ),
    );
  }

  Widget createButton() {
    return Padding(
      padding: EdgeInsets.only(left: 48, top: 50, right: 48),
      child: Container(
          width: ssSetWidth(280),
          height: ssSetWidth(44),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: lanse.withOpacity(_canCreate ? 1 : 0.41),
          ),
          child: FlatButton(
            onPressed: () {
              if (_canCreate) {
                mHttp.getInstance().postHttp("/jwt/club/add", (data){
                  eventBus.emit("clubChanged");
                  showToast("俱乐部创建成功");
                  Navigator.of(context).pop();
                  getClubInfo(data["data"]["id"].toString(), context);
                }, (error){

                },params: {"clubName":_clubNameController.text,"description":_clubDesController.text,"profilePicture":clubLogoUrl});
              }
            },
            child: setTextWidget("完成", 18, false, Colors.white),
          )),
    );
  }
}
