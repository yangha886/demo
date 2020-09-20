import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/jsonconver.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';
import 'dart:convert' as convert;
class ClubSetAdmin extends StatefulWidget {
  ClubSetAdmin();
  @override
  _ClubSetAdminState createState() => _ClubSetAdminState();
}

class _ClubSetAdminState extends State<ClubSetAdmin> {
  List adminList = List();
  String clubID;
  void setData(){
    clubID = nowClubInfo["id"].toString();
    for (var item in nowClubInfo["clubUserList"]) {
      if (item["role"] ==2) {
        adminList.add(item);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: whiteAppBarWidget("管理员设置", context),
        backgroundColor: Color(0xfff5f5f5),
        body: Padding(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: 1 + adminList.length,
              itemBuilder: (context, index) {
                if (index == adminList.length) {
                  return addAdminCell();
                } else {
                  return adminCell(index);
                }
              }),
        ));
  }

  Widget adminCell(int index) {
    return Container(
        color: style.backgroundColor,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 0),
        child: InkWell(
          onTap: () {
            cancelTextEdit(context);
          },
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  memberListInCell(adminList[index],padAll: 2,isAdmin: true),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        setTextWidget(adminList[index]["user"]["userNameOrigin"].toString(), 14, false, b33),
                        setTextWidget("ID:${adminList[index]["user"]["id"].toString()}", 12, false, g99)
                      ],
                    ),
                  )),
                  Container(
                    child: InkWell(
                      onTap: () {
                        print("删除");
                        showAlertView(context, "温馨提示", "确定删除管理员“${adminList[index]["user"]["userNameOrigin"].toString()}”吗？", "取消", "确定", (){
                          Navigator.pop(context);
                          setState(() {
                            adminList.removeAt(index);
                          });
                          List idList = List();
                          for (var item in adminList) {
                            idList.add(item["id"]);
                          }
                            
                          mHttp.getInstance().postHttp("/jwt/clubuser/addAdmin", (data){
                            List clubuserlisttemp = nowClubInfo["clubUserList"];
                            for (int i=0 ; i< clubuserlisttemp.length ; i++) {
                              var item = clubuserlisttemp[i];
                              if (idList.contains(item["id"])) {
                                item["role"] = 2;
                              }else if (item["role"].toString() =="2"){
                                item["role"] = 3;
                              }
                              clubuserlisttemp[i] = item;
                            }
                            nowClubInfo["clubUserList"] = clubuserlisttemp;
                            eventBus.emit("clubAdminChanged");
                            setState(() {
                              
                            });
                          }, (error){

                          },params: {"clubId":nowClubInfo["id"].toString(),"userIdList":idList});
                        });
                      },
                      child: setTextWidget("删除", 12, false, lanse),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: greyLineUI(
                  0.5,
                ),
              )
            ],
          ),
        ));
  }

  Widget addAdminCell() {
    return Container(
      margin: EdgeInsets.only(
          left: 15, right: 15, top: adminList.length == 0 ? 0 : 10),
      height: ssSetWidth(44),
      width: ssSetWidth(345),
      decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(ssSetWidth(4))),
      child: InkWell(
        onTap: (){
          var jsons = JsonConver().cvjsonToString(adminList);

            Application.router.navigateTo(context, "$clubMemberListPath?isSelect=1&adminStr=$jsons",transition: TransitionType.inFromRight)..then((value){
              print(value);
              List idList = List();
              for (var item in value) {
                idList.add(item["id"]);
              }
                
              mHttp.getInstance().postHttp("/jwt/clubuser/addAdmin", (data){
                adminList.clear();
                adminList.addAll(value);
                List clubuserlisttemp = nowClubInfo["clubUserList"];
                for (int i=0 ; i< clubuserlisttemp.length ; i++) {
                  var item = clubuserlisttemp[i];
                  if (idList.contains(item["id"])) {
                    item["role"] = 2;
                  }else if (item["role"].toString() =="2"){
                    item["role"] = 3;
                  }
                  clubuserlisttemp[i] = item;
                }
                nowClubInfo["clubUserList"] = clubuserlisttemp;
                eventBus.emit("clubAdminChanged");
                setState(() {
                  
                });
              }, (error){

              },params: {"clubId":nowClubInfo["id"].toString(),"userIdList":idList});
              
            });
        },
        child: Center(
          child: setTextWidget("+ 增加管理员", 16, false, lanse,
              textAlign: TextAlign.center)),
      ),
    );
  }
}
