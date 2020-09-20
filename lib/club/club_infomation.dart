import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/jsonconver.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class ClubInfomation extends StatefulWidget {
  String nowGameJson;
  String recordGameJson;
  ClubInfomation();
  @override
  _ClubInfomationState createState() => _ClubInfomationState();
}

class _ClubInfomationState extends State<ClubInfomation>
    with SingleTickerProviderStateMixin {
  int userRole = 0;
  void getMemberList() {
    Application.router.navigateTo(
        context, "$clubMemberListPath?isSelect=0&adminStr=0",
        transition: TransitionType.inFromRight);
  }
  List showMemberList = List();
  List nowGameList = List();
  List recordGameList = List();
  TabController _tabController;
  void setData(){
    UserModel um = UserInfo().getModel();
    for (var item in nowClubInfo["clubUserList"]) {
      if (item["role"] ==1 || item["role"] == 2) {
        showMemberList.add(item);
      }
      if (item["user"]["id"].toString() == um.id && userRole == 0) {
        userRole = item["role"];
      }
    }
  }
  @override
  void dispose(){
    super.dispose();
    eventBus.off("clubAdminChanged");
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    setData();

    eventBus.on("clubAdminChanged", (arg) {
      showMemberList.clear();
      setData();
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar:
          whiteAppBarWidget("俱乐部名字", context, haveShadowLine: true, actions: [
        Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(
              color: style.backgroundColor,
              child: InkWell(
                onTap: () {
                  Application.router.navigateTo(context, clubConfigPath,
                      transition: TransitionType.inFromRight);
                },
                child: Image.asset(
                  imgpath + "blacksetting.png",
                  width: ssSetWidth(24.09),
                  height: ssSetWidth(23.26),
                ),
              ),
            ))
      ]),
      body: Column(
        children: <Widget>[
          Container(
            width: ssSetWidth(375),
            color: style.backgroundColor,
            height: ssSetWidth(97),
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: <Widget>[
                labelCell("成员  ${nowClubInfo["clubUserList"].length}/${nowClubInfo["maxNum"].toString()}", userRole == 3 ? "" : "查看",
                    hasArrow: userRole == 3 ? false : true,
                    height: ssSetWidth(30),
                    func: userRole == 3 ? null : getMemberList),
                Container(
                  width: ssSetWidth(375),
                  height: ssSetWidth(60),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: showMemberList.length,
                      itemBuilder: (context, index) {
                        return memberListInCell(showMemberList[index]);
                      }),
                )
              ],
            ),
          ),
          greyLineUI(10, color: Color(0xfff5f5f5)),
          Container(
            height: ssSetWidth(39),
            color: style.backgroundColor,
            child: TabBar(
                labelColor: b33,
                unselectedLabelColor: g99,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 80),
                // indicatorColor: Colors.redAccent,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: "牌局(${nowGameList.length})",
                  ),
                  Tab(text: "牌局记录")
                ]),
          ),
          greyLineUI(0.5, color: Color(0xfff5f5f5)),
          Expanded(
              child: TabBarView(controller: _tabController, children: <Widget>[
            roomList(0),
            roomList(1),
          ])),
          Container(
            height: ssSetWidth(42),
            width: ssSetWidth(345),
            margin: EdgeInsets.only(bottom: 5, left: 15, right: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ssSetWidth(21)),
                color: lanse),
            child: InkWell(
              onTap: () {
                print("创建牌局");
              },
              child: Center(child: setTextWidget("创建牌局", 16, false, style.backgroundColor)),
            ),
          )
        ],
      ),
    );
  }

  Widget roomList(int type, {bool noScroll}) {
    if (type ==0 && nowGameList.length ==0) {
      return Center(child:setTextWidget("暂无牌局", 18, false, g99));
    }else if (type ==1 && recordGameList.length == 0){
      return Center(child:setTextWidget("暂无牌局记录", 18, false, g99));
    }
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: ListView.builder(
            shrinkWrap: noScroll ?? false,
            physics: noScroll != null
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            itemCount: type == 0 ? nowGameList.length : recordGameList.length,
            itemBuilder: (context, index) {
              return roomCell(index, type);
            }));
  }
}




