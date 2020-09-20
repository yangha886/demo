import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/pubRequest.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class ClubMain extends StatefulWidget {
  @override
  _ClubMainState createState() => _ClubMainState();
}

class _ClubMainState extends State<ClubMain> {
  List clubLists = List();
  void getClubList(){
    mHttp.getInstance().postHttp("/jwt/club/getlist", (data){
      print(data);
      setState(() {
        clubLists = data["data"] ?? [];
      });
    }, (error){

    },noLoading: true);
  }

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    eventBus.on("onThemeChange", (arg) {
      setState(() {
        
      });
    });
    eventBus.on("clubChanged", (arg) {
      getClubList();
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,width: 375,height: 667);
    return Container(
        color: style.backgroundColor,
        child: Column(
          children: <Widget>[
            topRow(),
            greyLineUI(1,color: style.textDivideLineColor),
            middleButton(),
            clubTitle(),
            clubLists.length == 0? Expanded(child: Center(child: setTextWidget("暂未加入任何俱乐部", 18, false, g99)),) :clubList()
          ],
        ));
  }
  //俱乐部cell视图
  Widget clubInfoView(int index) {
    Map clubInfo = clubLists[index];
    print(clubInfo);
    return Container(
        height: ssSetWidth(60),
        color: style.backgroundColor,
        child: InkWell(
          onTap: (){
            getClubInfo(clubInfo["id"].toString(), context);
          },
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ssSetWidth(45),
                    height: ssSetWidth(45),
                    child: returnImageWithUrl(clubInfo["profileUrl"],hasP: true,pleacehold: imgpath+"goldClub.png")
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          setTextWidget(clubInfo["clubName"] ?? "接口返回null", 14, false, b33),
                          setTextWidget("ID:${clubInfo["id"]}", 12, false, g99)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: ssSetWidth(20.86),
                    height: ssSetWidth(18),
                    child: Image.asset(imgpath+"clubAvatar.png"),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 9),
                    child: setTextWidget(clubInfo["userNum"].toString(), 14, false, g99),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: greyLineUI(1, color: Color(0xfff5f5f5)),
              )
            ],
          ),
        ));
  }
  //俱乐部列表
  Widget clubList() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.only(top: 8, left: 15, right: 15),
          itemCount: clubLists.length,
          itemBuilder: (context, index) {
            return clubInfoView(index);
          }),
    );
  }
  //顶部视图
  Widget topRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: (safeStatusBarHeight()+10),
        left: 15,
        right: 15,
        bottom: 10,
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            imgpath+"appbar_Logo.png",
            width: ssSetWidth(123),
            height: ssSetWidth(34.58),
          ),
          Expanded(child: SizedBox()),
          Container(
   
        child:InkWell(
            onTap: () {
              Application.router.navigateTo(context, "$messageListPath?msgType=0",transition: TransitionType.inFromRight);
            },
            child: Center(
              child:Stack(
              children: <Widget>[
                Image.asset(
                    imgpath+"notice_icon.png",
                    width: ssSetWidth(19.41),
                    height: ssSetWidth(21.97),
                  ),
                Positioned(top: 1,right: 1,child: Container(width: ssSetWidth(5),height: ssSetWidth(5),decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),))
              ],
            )
            )
          )
      )
        ],
      ),
    );
  }
  //中间俩按钮
  Widget middleButton() {
    return Padding(
      padding: EdgeInsets.only(top: 11, left: 15, right: 15),
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
            onTap: () {
              Application.router.navigateTo(context, clubCreatePath,
                  transition: TransitionType.inFromRight);
            },
            child: Image.asset(imgpath+"createClub.png"),
          )),
          Container(
            width: 11,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              Application.router.navigateTo(context, clubJoinPath,
                  transition: TransitionType.inFromRight);
            },
            child: Image.asset(imgpath+"joinClub.png"),
          )),
        ],
      ),
    );
  }
  //标题
  Widget clubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 25, left: 15, right: 15),
      child: Container(
        width: ssSetWidth(375),
        child: setTextWidget("已加入的俱乐部", 16, true, b33),
      ),
    );
  }
}
