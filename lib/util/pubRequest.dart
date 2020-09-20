import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/stringutil.dart';

import 'jsonconver.dart';

void getClubInfo(String clubID, context) {
  mHttp.getInstance().postHttp("/jwt/club/get", (data) {
    print(data);
    nowClubInfo = data["data"];
    Application.router.navigateTo(context, clubInfomationPath,
        transition: TransitionType.inFromRight);
  }, (error) {}, params: {"clubId": clubID});
}

/// 获取牌局信息
/// 缓存到本地并 return 给需要的组件函数
Future<Map> getGameBoardInfo(int roomid, {int boardId: -1}) async {
  Map params = {
    "gameHouseId": roomid,
  };
  if (boardId > 0) {
    params["gameBoardId"] = boardId;
  }
  await mHttp.getInstance().postHttp("/jwt/gameBoardInfoController/getIndexAndLastGameBoardInfo", (rdata) async {
    print("接口返回牌局数据：$rdata");
    if(rdata["data"]!=null){
      return rdata["data"];
    }
//    Map temp = json.decode(rdata["data"]);
//    temp["isCollect"] = false;
    // 封装一下  缓存到本地
    // {"userId:houseId:boardId":page,...}
//    UserModel _userModel = UserInfo().getModel();
//    SharedPreferences instance = await SharedPreferences.getInstance();
//    await instance.setString("boardsMapStorage:${_userModel.id}:${nowRoomInfo['id']}:${rdata["gameBoardOfCurrentIndex"]}", JsonConver().cvjsonToString(rdata));
//    return rdata;
    return {};
  }, (error) {
    print("接口返回牌局数据错误：$error");
    return {};
  }, params: params);
  return {};
}

/// 收藏牌局
