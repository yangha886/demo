import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:star/club/club_infomation.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class MessageList extends StatefulWidget {
  final String msgType;
  MessageList(this.msgType);
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList>
    with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  List _editSelectList = List();
  int nowMsgType ;
  TabController _tabController;
  @override
  void initState() {
    nowMsgType = int.parse(widget.msgType);
    for (int i = 0; i< 20; i++){
      msgClubList.add(i);
    }
    for (int i = 0; i< 1; i++){
      msgRoomList.add(i);
    }
    for (int i = 0; i< 10; i++){
      msgSystemList.add(i);
    }
    //初始化并监听tab,滚动时将状态改成未编辑
    _tabController = TabController(initialIndex: nowMsgType,length: 3, vsync: this)..addListener(() {
      nowMsgType = _tabController.index;
      //这里的判断是为了减少划屏时的渲染内存消耗
      if (_isEditing){
        setState(() {
          _isEditAll = false;
          _editSelectList.clear();
          _isEditing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: style.backgroundColor,
        appBar:
            whiteAppBarWidget("消息", context, haveShadowLine: true, actions: [
          Container(
              color: style.backgroundColor,
              padding: EdgeInsets.only(right: 12),
              child: Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child:
                      setTextWidget(_isEditing ? "取消" : "编辑", 16, false, style.themeColor),
                ),
              ))
        ]),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: ssSetWidth(39),
                  color: style.backgroundColor,
                  child: TabBar(
                      labelColor: style.themeColor,
                      unselectedLabelColor: b33,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 80),
                      // indicatorColor: Colors.redAccent,
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
//                          child: setTextWidget("俱乐部",14, false, _tabController.index == 0 ? style.themeColor : b33),
                            text: "俱乐部"
                        ),
                        Tab(text: "房间"),
                        Tab(text: "系统")
                      ]),
                ),
                greyLineUI(0.5, color: style.textDivideLineColor),
                Expanded(
                    child: TabBarView(
                      physics: _isEditing? NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(),
                        controller: _tabController,
                        children: <Widget>[
                      messageList(0),
                      messageList(1),
                      messageList(2),
                    ])),
                _isEditing ? bottomEditView():SizedBox()
              ],
            ),
          ],
        ));
  }
  List msgClubList = List();
  List msgRoomList = List();
  List msgSystemList = List();
  bool _isEditAll = false;
  //底部编辑视图
  Widget bottomEditView(){
    return Container(
      width: ssSetWidth(375),
      height: ssSetWidth(49),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border:Border(top: BorderSide(color:Color(0xfff5f5f5),width: 1))
      ),
      padding: EdgeInsets.only(left:15,right:15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
                    width: ssSetWidth(18),
                    height: ssSetWidth(18),
                    margin: EdgeInsets.only(right:15),
                    child: InkWell(
                      onTap: (){
                        _isEditAll = !_isEditAll;
                        _editSelectList.clear();
                        if (_isEditAll){
                          for (var item in nowMsgType == 0? msgClubList: nowMsgType ==1? msgRoomList: msgSystemList) {
                            _editSelectList.add(item);
                          }
                        }
                        setState(() {
                          
                        });
                      },
                      child: Image.asset(_isEditAll ? imgpath+"edit_s.png":imgpath+"edit_u.png"),
                    ),
                  ),
          setTextWidget("全选", 14, false, b33),
          Expanded(child: SizedBox()),
          Container(
            child: InkWell(
              onTap: (){
                if (_editSelectList.length > 0){
                  showAlertView(context, "温馨提示", "是否删除选中的消息？", "取消", "确定", (){
                    Navigator.pop(context);
                    switch (nowMsgType){
                    case 0:{
                      if (_isEditAll){
                        msgClubList.clear();
                      }else{
                        for (var item in _editSelectList) {
                          msgClubList.remove(item);
                        }
                      }
                      break;
                    }
                    case 1:{
                      if (_isEditAll){
                        msgRoomList.clear();
                      }else{
                        for (var item in _editSelectList) {
                          msgRoomList.remove(item);
                        }
                      }
                      
                      break;
                    }
                    case 2:{
                      if (_isEditAll){
                        msgSystemList.clear();
                      }else{
                        for (var item in _editSelectList) {
                          msgSystemList.remove(item);
                        }
                      }
                      
                    }
                    
                  }
                 setState(() {
                        _isEditing = false;
                      }); 
                  });
                  
                }
              },
              child: setTextWidget("删除", 14, false, Color(0xffff0000).withOpacity(_editSelectList.length > 0 ? 1 : 0.4)),
            ),
          )
        ],
      ),
    );
  }
  void showMyMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("title"),
            content: new Text("内容内容内容内容内容内容内容内容内容内容内容"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  //消息列表cell视图
  Widget messageCell(int index, int type) {
    return Container(
        height: ssSetWidth(63),
        width: ssSetWidth(375),
        color: style.backgroundColor,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: InkWell(
          onTap: (){
            if (_isEditing){
              List nowList = nowMsgType == 0? msgClubList: nowMsgType ==1? msgRoomList: msgSystemList;
              if (_editSelectList.contains(index)){
                _editSelectList.remove(index);
              }else{
                _editSelectList.add(index);
              }
              setState(() {
                if (nowList.length == _editSelectList.length){
                  _isEditAll = true;
                }else if (_isEditAll == true){
                  _isEditAll = false;
                }
              });
            }else{
              Application.router.navigateTo(context, "$messageInfoPath?type=${nowMsgType== 0 ? 'club': nowMsgType == 1? 'room':'system'}&title=${Uri.encodeComponent(nowMsgType== 0 ? '俱乐部名字': nowMsgType == 1? '牌局请求':'系统公告')}",transition: TransitionType.inFromRight);
            }
          },
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  !_isEditing ? SizedBox(): Container(
                    width: ssSetWidth(18),
                    height: ssSetWidth(18),
                    margin: EdgeInsets.only(right:15),
                    child: Image.asset(_editSelectList.contains(index) ? imgpath+"edit_s.png":imgpath+"edit_u.png"),
                  ),
                  type == 2 ? SizedBox() : circleMemberAvatar(0),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: setTextWidget(
                                    type == 2 ? "系统公告" : type == 1 ? "牌局请求":"蒙特利俱乐部",
                                    14,
                                    true,
                                    style.textTitleColor)),
                            Container(
                                child: setTextWidget(
                                    "2020/6/16", 12, false, style.textContextColor)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: setTextWidget(
                                    type == 2
                                        ? "亲爱的玩家，我们的服务器将在明早4-11点进行维护sdfsdfsdf..." :
                                      type ==1 ?"小月月月请你加入牌局"  : "俱乐部已解散",
                                    12,
                                    false,
                                    style.textContextColor)),
                            (type == 2 && index < 2)
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.red),
                                    child: setTextWidget(
                                        "  1  ", 12, false, Colors.white),
                                  )
                                : SizedBox()
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            greyLineUI(1,color: style.textDivideLineColor)
          ],
        ),
        ));
  }
  //消息表格
  Widget messageList(int type) {
    int count = type == 0? msgClubList.length: type ==1? msgRoomList.length: msgSystemList.length;
    if (count == 0){
      return Padding(
                          padding: EdgeInsets.only(top: 57),
                          child: Container(
                            child: setTextWidget("暂无消息", 14, false, g99,
                                textAlign: TextAlign.center),
                          ));
    }else
    return ListView.builder(
        itemCount: type == 0? msgClubList.length: type ==1? msgRoomList.length: msgSystemList.length,
        itemBuilder: (context, index) {
          return messageCell(index, type);
        });
  }
}
