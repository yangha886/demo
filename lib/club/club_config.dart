import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/routes/application.dart';
import 'package:star/style/jhpickertool.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/jsonconver.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class ClubConfig extends StatefulWidget {
  ClubConfig();
  @override
  _ClubConfigState createState() => _ClubConfigState();
}

class _ClubConfigState extends State<ClubConfig> {
  String timeStr = "07:00";
  void alertHelp(){
    showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: SizedBox(),
                    content: SingleChildScrollView(
                        child: ListBody(
                            children: <Widget>[
                                Text('''1.（免审积分）为无需审核的带入记分牌总数。
2. 未结束牌局中免审带入的记分牌会被锁定，牌局结束后释放
放；牌局结束后免审积分会扣除输掉的记分牌。
3. 俱乐部创建者可设置免审积分的每日重置时间，系统会在该
时间将所有成员的免审积分恢复至设定值。'''),
                                
                            ],
                        ),
                    ),
                    actions: <Widget>[
                        FlatButton(
                            child: Text('确定'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        ).then((val) {
            print(val);
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: whiteAppBarWidget("俱乐部设置", context),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clubHeaderInfo(),
            greyLineUI(10,color: Colors.grey[100]),
            clubDes(),
            greyLineUI(10,color: Colors.grey[100]),
            clubOtherInfo(),
            greyLineUI(10,color: Colors.grey[100]),
            quitClub()
          ],
        ),
      ),
    );
  }
  List timeLists= List();
  int userRole = 0;
  String createrName;
  void setData(){
    for(int i =0; i<=23;i++){
      timeLists.add("${i<=9?"0":""}$i:00");
    }
    timeStr = nowClubInfo["refreshTime"].toString().substring(0,5);
    UserModel um = UserInfo().getModel();
    for (var item in nowClubInfo["clubUserList"]) {
      if (item["user"]["id"].toString() == um.id && userRole == 0) {
        userRole = item["role"];
        break;
      }
    }
    createrName = nowClubInfo["clubUserList"].first["user"]["userNameOrigin"];
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }
  void chooiceTime(){
    print("选择时间");
//       var aa =  [11,22,33,44];

       JhPickerTool.showStringPicker(context,
           data: timeLists,
//           normalIndex: 2,
//           title: "请选择2",
           clickCallBack: (int index,var str){
             mHttp.getInstance().postHttp("/jwt/club/update", (data){
               nowClubInfo["refreshTime"] = "$str:00";
             }, (error){

             },params: {"refreshTime": "$str:00","clubId":nowClubInfo["id"].toString()},noLoading: true);
             setState(() {
               timeStr = str;
             });
           }
       );
  }
  void bindEmail(){
    print("绑定邮箱");
    Application.router.navigateTo(context, clubBindEmailPath,transition: TransitionType.inFromRight).then((value){
      if(value == true){
        setState(() {
          
        });
      }
    });
  }
  void setAdmin(){
    print("设置管理员");
    String clubinfo = JsonConver().cvjsonToString(nowClubInfo);
    Application.router.navigateTo(context, "$clubSetAdminPath?info=$clubinfo",transition: TransitionType.inFromRight);
  }
  Widget quitClub(){
    return Container(
      color: style.backgroundColor,
      height: ssSetWidth(44),
      width: ssSetWidth(375),
      child: Center(
        child:InkWell(
        onTap: (){
          print("删除退出");
        },
        child: setTextWidget(userRole ==1?"解散俱乐部":"删除并退出", 16, false, Color(0xffff0000)),
      ),
      )
    );
  }
  Widget clubOtherInfo(){
    return Container(
      //height: ssSetWidth(183),
      color: style.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          labelCell("创始人",createrName,height: ssSetWidth(60)),
          greyLineUI(1,padding: EdgeInsets.only(left:15,right: 15)),
          userRole == 1?
          labelCell("管理员设置","",hasArrow: true,height: ssSetWidth(60)
            ,func: setAdmin):SizedBox(),
          userRole == 1?
          greyLineUI(1,padding: EdgeInsets.only(left:15,right: 15)):SizedBox(),
          (userRole == 1 || userRole == 2)?
          labelCell("免审积分 每日重置时间",timeStr,hasArrow: true,height: ssSetWidth(60)
            ,otherButton: Container(
              width: ssSetWidth(17),
              padding: EdgeInsets.only(left:5),
              height: ssSetWidth(20),
              child: InkWell(
                onTap: (){
                  alertHelp();
                },
                child: Image.asset(imgpath+"jifenHelp.png"),
              )
            ),func: chooiceTime):SizedBox(),
          (userRole == 1 || userRole == 2)?
          greyLineUI(1,padding: EdgeInsets.only(left:15,right: 15)):SizedBox(),
          userRole == 1?
          labelCell("安全邮箱",nowClubInfo["email"] == null?"未绑定":nowClubInfo["email"].toString(),hasArrow: true,height: ssSetWidth(60)
            ,func: bindEmail):SizedBox(),
        ],
      ),
    );
  }
  Widget clubDes(){
    return Container(
      color: style.backgroundColor,
      width: ssSetWidth(375),
      height: ssSetWidth(80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:11,left: 15),
            child: setTextWidget("俱乐部简介", 14, false, b33),
          ),
          Padding(
            padding: EdgeInsets.only(top:4,left: 15),
            child: setTextWidget(nowClubInfo["description"].toString(), 12, false, Color(0xff666666),maxLines: 2),
          )
        ],
      ),
    );
  }
  Widget clubHeaderInfo() {
    return Container(
      height: ssSetWidth(185),
      width: ssSetWidth(375),
      padding: EdgeInsets.only(top: ssSetWidth(10), bottom: ssSetWidth(10)),
      color: style.backgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:15),
            child: returnImageWithUrl(nowClubInfo["profileUrl"], hasP: true,pleacehold: imgpath+"goldClub.png",imgwidth: ssSetWidth(80),imgheight: ssSetWidth(80))
          ),
          Padding(
            padding: EdgeInsets.only(top:12),
            child: setTextWidget(nowClubInfo["clubName"], 14, false, b33)
          ),
          Padding(
            padding: EdgeInsets.only(top:1),
            child: setTextWidget("ID:${nowClubInfo["id"].toString()}", 12, false, g99)
          ),
          Padding(
            padding: EdgeInsets.only(top:1),
            child:Row(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right : 4),
                  width: ssSetWidth(16),
                  height: ssSetWidth(16),
                  child: Image.asset(imgpath+"tab_mine.png"),
                ),
                setTextWidget("${nowClubInfo["clubUserList"].length}/${nowClubInfo["maxNum"].toString()}", 14, false, g99)
              ],
            )
          ),
        ],
      ),
    );
  }
}