import 'package:dio/dio.dart';
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';

// -----还未测试 iOS 系统

// 是否弹升级框 - 直接引用
isPopup(context,currentVersion) async{
  Dio dio = Dio();
  Response response;
  response = await dio.get('http://bookindle.club:8091/version.json');

  if(currentVersion != response.data["title"]){
    print("版本不一致---------------");
    // 会自动区分是 Android 还是 iOS
    AppUpgrade.appUpgrade(
        context,
        _checkAppInfo(response.data),
        cancelText: '以后再说',
        okText: '马上升级',
        iosAppId:'',  // 用于跳转
        // appMarketInfo: 'none',
        onCancel: (){
          // print('onCancel');
        },
        onOk: (){
          // print('onOk');
        },
        downloadProgress: (count,total){
          // 能不能设置进度条？
          // print('count:$count,total:$total');
        },
        downloadStatusChange: (DownloadStatus status,{dynamic error}){
          // print('status:$status,error:$error');
        }
    );
  }else{
    print("版本一致-----");
  }
}

// _checkAppInfo 方法访问后台接口获取是否有新的版本信息，返回 Future<AppUpgradeInfo> 类型
// iosAppId 参数用于跳转到 app store
Future<AppUpgradeInfo> _checkAppInfo(updateInfo) async{
  List<String> contents = [];
  for(var i=0;i<updateInfo["contents"].length;i++){
    contents.add(updateInfo["contents"][i]);
  }
  updateInfo["contents"] = contents;
  return Future.delayed(Duration(seconds: 1),(){
    return AppUpgradeInfo(
      title:updateInfo["title"],
      contents: contents,
      apkDownloadUrl:updateInfo["apkDownloadUrl"],
      force:updateInfo["force"],   // 是否强制升级（没有取消的选项）
    );
  });
}