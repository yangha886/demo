class UserModel{
  static UserModel get instance =>_getInstance();
  static UserModel um;
  static UserModel _getInstance(){
    if (um == null){
      um = new UserModel();
    }
    return um;
  }

  String userName;
  String token;
  String sex;
  String mobile;
  String nickName;
  String avatar;
  String name;
  String id;
  String isGame;
}