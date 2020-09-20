import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/httprequest/usermodel.dart';

class Global {
  static SharedPreferences globalShareInstance;
  static UserModel currentUser;
  static Future init() async{
    globalShareInstance = await SharedPreferences.getInstance();
    currentUser = UserModel.instance;
//    if(currentUser.id == null){
//
//    }
  }
  /// 进入（只保留近期三天牌局或 最新 n 条） 或 离开 app 就查询缓存，清除冗余信息
}