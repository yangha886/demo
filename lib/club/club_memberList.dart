import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star/club/club_infomation.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/jsonconver.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class ClubMemberList extends StatefulWidget {
  final String isSelectAdmin;
  final String adminListStr;
  ClubMemberList(this.isSelectAdmin,this.adminListStr);
  @override
  _ClubMemberListState createState() => _ClubMemberListState();
}

class _ClubMemberListState extends State<ClubMemberList> {
  ScrollController _scrollController = ScrollController();
  List memberList = List();
  List resarchResultList = List();
  List selectedAdmin ;
  void setData(){
    for (var item in nowClubInfo["clubUserList"]) {
      memberList.add(item);
      resarchResultList.add(item);
    }
    if (widget.isSelectAdmin == "1"){
      memberList.removeAt(0);
      resarchResultList.removeAt(0);
    }
  }
  @override
  void initState() {
    selectedAdmin = JsonConver().cvStringToDynamic(widget.adminListStr);
    _scrollController.addListener(() {
      cancelTextEdit(context);
    });
    setData();

    eventBus.on("clubAdminChanged", (arg) {
      memberList.clear();
      resarchResultList.clear();
      setData();
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isSelectAdmin == "0"?
        whiteAppBarWidget(
          "俱乐部成员",
          context,
          haveShadowLine: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Container(
            color:style.backgroundColor,
            child:InkWell(
            onTap: () {
              Application.router.navigateTo(context, clubConfigPath,
                      transition: TransitionType.inFromRight);
            },
            child: Image.asset(
              imgpath+"blacksetting.png",
              width: ssSetWidth(24.09),
              height: ssSetWidth(23.26),
            ),
          ),
          )
            )
          ],
        ):whiteAppBarWidget(
          "选择管理员",
          context,
          haveShadowLine: true,
          result: selectedAdmin
        ),
      body: Column(
        children: <Widget>[
          topSearchBar(),
          greyLineUI(0.5),
          Expanded(
              child: ListView.builder(
                  itemCount: resarchResultList.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return memberCell(index);
                  }))
        ],
      ),
    );
  }

  Widget memberCell(int index) {
    Map userInfo = resarchResultList[index];
    int selectedAdminIndex = -1;
    for (int i = 0; i<selectedAdmin.length;i++) {
      var item = selectedAdmin[i];
      if(item["user"]["id"].toString() == userInfo["user"]["id"].toString()){
        selectedAdminIndex = i;
        break;
      }
    }
    return Container(
      color: selectedAdminIndex != -1? style.backgroundColor:Colors.grey[100],
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 0),
      child: InkWell(
              onTap: () {
                if (widget.isSelectAdmin == "1") {
                  if (selectedAdmin.length==2 && selectedAdminIndex == -1){
                    showToast("管理员最多只能选择两个");
                    return;
                  }
                  if (selectedAdminIndex != -1) {
                    selectedAdmin.removeAt(selectedAdminIndex);
                  }else
                    selectedAdmin.add(resarchResultList[index]);
                  setState(() {
                    
                  });
                }
                cancelTextEdit(context);
              },
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      memberListInCell(resarchResultList[index],padAll: 2,),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            setTextWidget(
                                resarchResultList[index]["user"]["userNameOrigin"], 14, false, b33),
                            setTextWidget("ID:${resarchResultList[index]["user"]["id"]}", 12, false, g99)
                          ],
                        ),
                      )),
                      widget.isSelectAdmin == "0"?setTextWidget("暂无该数据", 12, false, lanse):
                      Container(
                        width: ssSetWidth(21.42),
                        height: ssSetWidth(15.1),
                        child: selectedAdminIndex != -1? Image.asset(imgpath+"admin_selected.png"):SizedBox(),
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
      )
    );
  }

  TextEditingController _editingController = TextEditingController();
  final GlobalKey key = GlobalKey();

  Widget topSearchBar() {
    return Container(
        color: Color(0xfff5f5f5),
        padding: EdgeInsets.only(top: 11, left: 15, right: 15, bottom: 11),
        child: Container(
          height: ssSetWidth(30),
          child: CupertinoTextField(
            controller: _editingController,
            key: key,
            prefix: Padding(
              padding: EdgeInsets.only(left: ssSetWidth(10)),
              child: Image.asset(
                imgpath+"Searchbar_icon_search.png",
                width: ssSetWidth(16),
                height: ssSetWidth(16),
              ),
            ),
            // suffix: IconButton(icon: Icon(Icons.cancel,size: 16,), onPressed: (){
            //   _editingController.text = "";
            // },
            // highlightColor: Colors.transparent,splashColor: Colors.transparent,),
            style: TextStyle(color: b33),
            decoration: BoxDecoration(
                color: style.backgroundColor,
                borderRadius: BorderRadius.circular(ssSetWidth(15)),
                border: Border.all(color: Color(0xffcccccc), width: 0.5)),
            placeholder: "搜索成员",
            placeholderStyle:
                TextStyle(color: Color(0xffcccccc), fontSize: ssSp(13)),
            autofocus: false,
            onEditingComplete: () {
              String searchKey = _editingController.text.toString();
              if (searchKey != "") {
                resarchResultList.clear();
                for (var item in memberList) {
                  if (item["user"]["userNameOrigin"].toString().contains(searchKey)) {
                    resarchResultList.add(item);
                  }
                }
              }else{
                resarchResultList = memberList.toList();
              }
              setState(() {});
              cancelTextEdit(context);
            },
            onTap: () {},
          ),
        ));
  }
}
