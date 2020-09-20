import 'dart:async';

import 'package:flui/flui.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/util/logutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:web_socket_channel/io.dart';
import 'package:supercharged/supercharged.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert' as convert;

import 'package:web_socket_channel/web_socket_channel.dart';

class SocketMessageType {
  /*
     * 登录请求
     */
  int LOGIN_REQUEST = 1;

  /*
     * 登录响应
     */
  int LOGIN_RESPONSE = 2;

  /*
     * 房间动作请求
     */
  int GAME_HOUSE_REQUEST = 3;

  /*
     * 房间动作响应
     */
  int GAME_HOUSE_RESPONSE = 4;

  /*
     * 游戏动作请求
     */
  int GAME_ACTION_REQUEST = 5;

  /*
     * 游戏动作响应
     */
  int GAME_ACTION_RESPONSE = 6;

  /*
     * IM消息请求
     */
  int MESSAGE_REQUEST = 7;

  /*
     * IM消息响应
     */
  int MESSAGE_RESPONSE = 8;

  /*
     * 服务器消息
     */
  int MESSAGE_NOTIFICATION = 9;

  /*
     * 心跳空消息
     */
  int HEAT_MESSAGE = 999;
}

class HouseMessageType {
  /*
     * 断线重连房间信息
     */
  int RE_CONNECTED = 120;
  /*
     * 断线重连房间信息
     */
  int START_RESPONSE = 200;
  /*
     * 开局
     */
  int START_GAME = 1001;
  /*
     * 进入房间
     */
  int INTO_HOUSE = 2000;

  /*
     * 离开房间
     */
  int LEAVE_HOUSE = 2001;

  /*
     * 站起
     */
  int STAND_UP = 3001;

  /*
     * 坐下
     */
  int SIT_DOWN = 3000;
  /*
     * 站起坐下响应
     */
  int SEAT_MESSAGE = 4001;
/*
     * 离开房间响应
     */
  int LEAVE_HOUSE_RESPONSE = 4002;
  /*
   * 申请带入分  玩家==>房主
   */
  int SCORE_USR_TO_HOUSE_OWNER_REQUEST=5001;
  int SCORE_USR_TO_HOUSE_OWNER_RESPONSE=5002;
  /*
   * 申请带入分请求  服务器==>房主
   */
  int SCORE_SERVER_TO_HOUSE_OWNER_REQUEST=5003;
  int SCORE_SERVER_TO_HOUSE_OWNER_RESPONSE=5004;

  /*
   * 审核结果  房主==>服务器
   */
  int SCORE_HOUSE_OWNER_TO_SERVER_REQUEST=5005;
  int SCORE_HOUSE_OWNER_TO_SERVER_RESPONSE=5006;
  int SCORE_HOUSE_OWNER_TO_SERVER_RESULT=5007;
  /*
   * 牌局结束
   */
  int GAME_OVER = 280;
}

class GameActions {
  /*
     * 跟注
     */
  int FOLLOW = 100;

  /*
     * 加注
     */
  int CALL = 110;

  /*
     * 看牌
     */
  int PASS = 120;

  /*
     * 弃牌
     */
  int CANCEL = 130;

  /*
     * all in
     */
  int ALL_IN = 140;

  /*
     * insurance
     */
  int INSURANCE = 150;

  /*
     * 唤醒
     */
  int WEAKUP = 200;

  /*
     * 发送初始化牌局信息
     */
  int UPDATE_GAME_BOARD = 210;
  int NOSEATHAND_POKER = 215;
  /*
     * 手牌
     */
  int HAND_POKER = 220;
  /*
     * 当前出手座位号
     */
  int CURRENT_HANDLER =230;
  /*
     * 进入下回合, 广播新的回合表
     */
  int NEXT_ROUND =240;
  /*
     * 秀牌
     */
  int SHOW_BLUFF =250;
   /**
     * 玩家操作记录信息
     */
  int USR_ACTION = 260;
//新的一局
  int NEW_GAMEPLAY = 270;
  /*
     * 比牌结果
     */
  int WINNER_RESULT =300;
  //玩家分数不够=>观战
  int OUT_PLAYER = 310;

  int CANCEL_INSURANCE = 420;
}

Function dismiss;
Function reConnectSocket;
Timer _timer;
IOWebSocketChannel channel;
bool socketFail = false;
bool isInGame = false;
int failCount = 0;
Map lastSocketMsg;
void checkAction() {
  print("检查通信中...");
  // if (channel.closeCode != null && channel.closeCode != 1001) {
  //   socketFail = true;
  // }
  if (socketFail == true) {
    print("连接异常");
    failCount++;
    if (dismiss != null) {
      if (!isInGame) showToast("连接超时,请重试");
      dismiss();
    }
    if (reConnectSocket != null) {
      reConnectSocket();
      reConnectSocket = null;
    }
    //未显示等待重连 ,则 显示该loading框
    if (reConnectSocket == null && isInGame && failCount <= 3) {
      reConnectSocket = FLToast.loading(text: "已断开连接,正在尝试重连($failCount)");
    }
    //尝试重新连接socket并登陆 多图片选择+多图片上传+界面数据修改+搜索框+iOS分发+录音BUG修复+答题界面卡顿优化+后台进程
    loginSocket();
  } else {
    if (lastSocketMsg != null) {
      print("正在尝试重新发送上一次的消息");
      sendSocketMsg(lastSocketMsg);
      lastSocketMsg = null;
    }
    print("连接正常");
    if (reConnectSocket != null) {
      reConnectSocket();
      reConnectSocket = null;
    }
  }
}

void sendSocketMsg(data, {bool haveLoading, bool isLogin = false}) async {
  if (haveLoading != null && haveLoading == true) {
    dismiss = FLToast.loading(text: 'Loading...');
  }
  String t = convert.jsonEncode(data);
  //發送一則socket消息
  print("此时发送了一段socket命令,命令内容为\n========================\n$t\n===========以上=============");
  channel.sink.add(t);
  print("已发送SOCKET请求");
  socketFail = true;
  if (!isLogin) {
    print("记录当前的发送消息" + t);
    lastSocketMsg = data;
  }
  //五秒後檢查是否已接受到消息,未接收則判斷則直接強行斷掉socket重新連接
  if (_timer != null) {
    _timer.cancel();
    _timer = null;
  }
  _timer = Timer(isDEBUG ? 10.minutes : 10.minutes, () {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    checkAction();
  });
}

void loginSocket() {
  if (failCount == 2) {
    print("重连三次异常,");
    if (dismiss != null) {
      dismiss();
      dismiss = null;
    }
    if (reConnectSocket != null) {
      reConnectSocket();
      reConnectSocket = null;
    }
    showToast("重连失败,请确认是否当前网络是否异常");
    failCount = 0;
    return;
  }
  print("重新请求登路");
  UserModel _userModel = UserInfo().getModel();
  if (channel != null) {
    channel.sink.close(status.goingAway);
    channel = null;
  }
  channel = IOWebSocketChannel.connect(socketUrl, pingInterval: 10.minutes);

  channel.stream.listen((event) {
    reciveSocketMsg(event);
  }, onDone: () {
    if (dismiss != null) {
      dismiss();
      dismiss = null;
    }
    showToast("断开与服务器的连接");
    // socketFail = true;
  }, onError: (err) {
    WebSocketChannelException ex = err;
    print(ex.message);
    if (dismiss != null) {
      dismiss();
      dismiss = null;
    }
    // socketFail = true;
  });
  Map test = {
    "messageType": SocketMessageType().LOGIN_REQUEST.toString(),
    "token": _userModel.token.toString()
  };
  sendSocketMsg(test, isLogin: true);
}

void reciveSocketMsg(event) {
  failCount = 0;
  if (reConnectSocket != null) {
    reConnectSocket();
    reConnectSocket = null;
  }

  socketFail = false;
  Map data = convert.jsonDecode(event);
  if (data["messageType"] == SocketMessageType().LOGIN_RESPONSE) {
    // socketSession = data["data"]["sessionId"].toString();
//    print(data);
  } else {
    lastSocketMsg = null;
    print("fasong");
    if (data["messageType"] == SocketMessageType().GAME_HOUSE_RESPONSE) {
      if (int.parse(data["data"]["msg"]) == HouseMessageType().INTO_HOUSE) {
        if (data["data"]["code"] != 200) {
          showToast(data["data"]["data"]);
        } else {
          nowRoomInfo = data["data"]["data"];
          eventBus.emit("inHouse");
        }
      }else if (HouseMessageType().SCORE_SERVER_TO_HOUSE_OWNER_REQUEST == int.parse(data["data"]["msg"])){
        eventBus.emit("somebodyRequestInSeat",data);
      } else if (int.parse(data["data"]["msg"]) ==
              HouseMessageType().SEAT_MESSAGE ||
          int.parse(data["data"]["msg"]) ==
              HouseMessageType().LEAVE_HOUSE_RESPONSE ||
          int.parse(data["data"]["msg"]) == HouseMessageType().START_GAME) {
        eventBus.emit("gameSession", data);
      } else if (int.parse(data["data"]["msg"]) ==
          HouseMessageType().RE_CONNECTED) {
        eventBus.emit("reToRoom", data["data"]);
      }else{
        eventBus.emit("gameSession", data);
      }
    }
    else if (data["messageType"] ==
        SocketMessageType().GAME_ACTION_RESPONSE) {

      if (int.parse(data["data"]["msg"]) == 6000) {
        eventBus.emit("zhongtu", data);
      }else
      eventBus.emit("gameSession", data);
    } else if (data["messageType"] == SocketMessageType().MESSAGE_RESPONSE) {
      print("IM消息响应");
    } else if (data["messageType"] ==
        SocketMessageType().MESSAGE_NOTIFICATION) {
      print("服务器消息");
    } else {
      print("其他动作相应");
    }
  }
  if (dismiss != null) {
    dismiss();
  }
  print(data);
//   LogUtil.d(data);
}
