import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/httprequest/httprequest.dart';
import 'usermodel.dart';
class UserInfo {
  Future<String> getUserName() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("username");
    return userName;
  }
  Future<String> getUserNameOrigin() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("userNameOrigin");
    return userName;
  }
  Future<String> getSex() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("sex");
    return userName;
  }
  Future<String> getMobile() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("mobile");
    return userName;
  }
  Future<String> getProfilePicture() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("profilePicture");
    return userName;
  }
  Future<String> getName() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name");
    return userName;
  }
  Future<String> getID() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("id");
    return userName;
  }
  Future<String> getIsGame() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("isGame");
    return userName;
  }
  Future<String> getUserToken() async{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("token");
    return userName;
  }

  Future saveUserInfo(key,value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value.toString());
    UserModel um = UserModel.instance;
    if(key == "userNameOrigin"){
      um.nickName = value;
    }else if (key == "sex"){
      um.sex = value;
    }
  }
  Future saveAllUserInfos(Map formData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    formData.forEach((key,value){
      prefs.setString(key, value.toString());
    });
    await getAllUserInfo();
  }
  Future<UserModel> getAllUserInfo() async{
    UserModel um = UserModel.instance;
    if (um.userName == null)
      um.userName = await getUserName();
    if (um.token == null)
      um.token = await getUserToken();
    if (um.name == null)
    um.name = await getName();
    if (um.avatar == null)
    um.avatar = await getProfilePicture();
    if (um.isGame == null)
    um.isGame = await getIsGame();
    if (um.mobile == null)
    um.mobile = await getMobile();
    if (um.id == null)
    um.id = await getID();
    if (um.sex == null)
    um.sex = await getSex();
    if (um.nickName == null)
    um.nickName = await getUserNameOrigin();
    return um;
  }
  UserModel getModel(){
    return UserModel.instance;
  }
  void setUserAvatar(String avatar){
    UserModel um = UserModel.instance;
    um.avatar = avatar;
  }
  void userQuitLogin() async{
    // 视情况清除不同的字段,暂定退出账号清除所有缓存，便于测试
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    UserModel um = UserModel.instance;
    um.userName = null;
    um.token = null;
    um.name = null;
    um.avatar = null;
    um.isGame = null;
    um.mobile = null;
    um.id = null;
    um.sex = null;
    um.nickName = null;
    mHttp.getInstance().setToken(null);
  }
}