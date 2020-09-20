import 'package:flutter/material.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class MessageInfo extends StatefulWidget {
  String msgType;
  String title;
  MessageInfo(this.msgType,this.title);
  @override
  _MessageInfoState createState() => _MessageInfoState();
}

class _MessageInfoState extends State<MessageInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: whiteAppBarWidget(widget.title, context,haveShadowLine: true),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left:15,right:15,top: 15,bottom: 15),
          padding: EdgeInsets.only(left:15,right:15,top: 11,bottom: 11),
          decoration: BoxDecoration(
            color: style.purityBlockColor,
            borderRadius: BorderRadius.circular(ssSetWidth(6)),
            boxShadow: style.themeType == 0 ? [BoxShadow(color: g99.withOpacity(0.16), offset: Offset(0, 0),    blurRadius: 6.0, spreadRadius: 1),  BoxShadow(color: Color(0xffffffff))] : null,
          ),
          
          child: widget.msgType =="club" ? msgClubCell():widget.msgType=="room"? msgRoomCell():msgSystemCell(),
    )
      ),
    );
  }
  Widget cellHeaderView(String text,String time){
    return Row(
      children: <Widget>[
        setTextWidget(text, 14, false, style.textTitleColor),
        Expanded(child: SizedBox()),
        setTextWidget(time, 12, false, style.textContextColor)
      ],
    );
  }
  Widget msgClubCell(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cellHeaderView("俱乐部消息", "2020/6/16"),
          setTextWidget("俱乐部已解散",14,false, style.textContextColor)
        ],
      );
  }
  Widget msgRoomCell(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cellHeaderView("系统公告", "2020/6/16"),
          setTextWidget("小月月月邀请你加入他的牌局。",14,false, style.textContextColor,maxLines: 99),
          Container(
            padding: EdgeInsets.only(top:12),
            child: Row(
              children: <Widget>[
                Expanded(child:SizedBox()),
                Padding(
                  padding: EdgeInsets.only(right:15),
                  child: Container(
                    width: ssSetWidth(56),
                    height: ssSetWidth(28),
                    decoration: BoxDecoration(
                      border: Border.all(color: style.loginReSendCodeColor,width: 1),
                      borderRadius: BorderRadius.circular(ssSetWidth(28))
                    ),
                    child: Center(
                      child:InkWell(
                        onTap: (){
                          print("拒绝");
                        },
                        child: setTextWidget("拒绝", 14, false, g99),
                    )
                    ),
                  ),
                ),
                Container(
                    width: ssSetWidth(56),
                    height: ssSetWidth(28),
                    decoration: BoxDecoration(
                      color: style.themeColor,
                      border: Border.all(color: style.themeColor,width: 1),
                      borderRadius: BorderRadius.circular(ssSetWidth(28))
                    ),
                    child: Center(
                      child:InkWell(
                        onTap: (){
                          print("同意");
                        },
                        child: setTextWidget("同意", 14, false, Colors.white),
                    )
                    ),
                  ),
              ],
            )
          )
        ],
      );
  }
  Widget msgSystemCell(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cellHeaderView("系统公告", "2020/6/16"),
          setTextWidget("亲爱的玩家，我们的服务器将在明早4-11点进行维护。请合理安排游戏时间，当时请不要创建牌局，以免维护影响游戏进程。",14,false, style.textContextColor,maxLines: 99)
        ],
      );
  }
}