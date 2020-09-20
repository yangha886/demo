import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:star/util/viewconfig.dart';
//是否测试线
bool isDEBUG = false;

final String scheme = "http://";
final String host = isDEBUG ? "324893s95k.qicp.vip:19400" : "39.101.213.209:9001";
final String socketUrl = isDEBUG ? "ws://324893s95k.qicp.vip:36848" : "ws://39.99.207.97:9000";
// final String host = "192.168.110.13:9001";
// final String socketUrl = "ws://192.168.110.13:9000";
class mHttp {
  static final String GET = "get";
  static final String POST = "post";
  static final String PUT = "put";
  static final String PATCH = "patch";
  static final String DATA = "result";
  static final String CODE = "errorCode";
  static String token;
  Dio dio;
  static mHttp _instance;
  setToken(String tok){
    token = tok;
  }
  static mHttp getInstance() {
    if (_instance == null) {
      _instance = mHttp();
    }
    return _instance;
  }

  mHttp() {
    dio = Dio();
    dio.options = BaseOptions(
      baseUrl: scheme+host,
      connectTimeout: 5000,
      receiveTimeout: 10000,
      headers: {"Content-Type":"application/json"},
      contentType: ContentType.json.toString(),
    );
    // dio.interceptors.add(InterceptorsWrapper(
    //   onError: (error){
    //     return error;
    //   }
    // ));
  }

  //get请求
  getHttp(String url, Function successCallBack, Function errorCallBack,
      {params}) async {
    _requstHttp(url, successCallBack, errorCallBack,GET, params);
  }

  //post请求
  postHttp(String url, Function successCallBack, Function errorCallBack,
      {params,bool noLoading}) async {
    _requstHttp(url, successCallBack, errorCallBack,POST, params,noLoading);
  }
  //put请求
  putHttp(String url, Function successCallBack, Function errorCallBack,
      {params}) async {
    _requstHttp(url, successCallBack, errorCallBack,PUT, params);
  }
  //put请求
  patchHttp(String url, Function successCallBack, Function errorCallBack,
      {params}) async {
    _requstHttp(url, successCallBack, errorCallBack,PATCH, params);
  }
  _requstHttp(String url, Function successCallBack,Function errorCallBack,
      [String method, params, bool noLoading]) async {
    String errorMsg = '';
    int code;
    Function dismiss;
    if(noLoading == null)
      dismiss = FLToast.loading(text: 'Loading...');
    try {
      Response response;
      if (url == '/jwt/login'){
        dio.options.headers = {"Content-Type":"application/x-www-form-urlencoded"};
      }else if(dio.options.headers != {"Content-Type":"application/json"}){
        dio.options.headers = {"Content-Type":"application/json"};
      }
      _addStartHttpInterceptor(dio); //添加请求之前的拦截器
      if (method == GET) {
        if (params != null) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == POST) {
        if (params != null) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      } else if (method == PUT) {
        if (params != null) {
          response = await dio.put(url, data: params);
        } else {
          response = await dio.put(url);
        }
      } else {
        response = await dio.patch(url);
      }
      if(noLoading == null)
        dismiss();
      code = response.statusCode;
      if (code != 200) {
        errorMsg = '错误码：' + code.toString() + '，' + response.data.toString();
        _error(errorCallBack, errorMsg);
        return;
      }

      String dataStr = json.encode(response.data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      if (dataMap["status"] == "error"){
        if (errorCallBack != null) {
          errorCallBack(dataMap);
        }else
          _error(errorCallBack, dataMap["message"]);
      }else if (successCallBack != null) {
        successCallBack(dataMap);
      }
    } catch (e) {
      if(dismiss != null)
        dismiss();
      showToast(formatError(e));
      
    }
  }
  String formatError(DioError e) {
    
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {

      return "连接超时";
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {

      return "请求超时";
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {

      return "响应超时";
    } else if (e.type == DioErrorType.RESPONSE) {

      return "请求异常";
    } else if (e.type == DioErrorType.CANCEL) {

      return "请求取消";
    } else {

      return "未知错误";
    }
  }
  _error(Function errorCallBack, String error) {
    Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }

  _addStartHttpInterceptor(Dio dio) {
    if (token != null)
      dio.options.headers["Authorization"] ="Bearer $token";
  }
}
String getImageNameByPath(String filePath) {
    return filePath?.substring(filePath.lastIndexOf("/") + 1, filePath?.length);
}
Future<String> uploadImage(
      String filePath, BuildContext context,
      {cancelToken, bool showLoading = true}) async {
    BaseOptions options = BaseOptions();
    options.responseType =
        ResponseType.plain; //必须,否则上传失败后aliyun返回的提示信息(非JSON格式)看不到
    //创建一个formdata，作为dio的参数
    //File file = File(filePath);
    FormData data = FormData.fromMap({
      'Filename': DateTime.now().millisecondsSinceEpoch.toString(), //文件名，随意
      'file':await MultipartFile.fromFile(
          filePath, filename: getImageNameByPath(filePath)) //必须放在参数最后
    });
    Dio dio = new Dio(options);

    ProgressDialog pr = ProgressDialog(context, isDismissible: false);

    pr.style(
        message: '正在上传 0%',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0);
    await pr.show();
    return dio.post("http://www.bookindle.club:8005/files/upload", data: data,
        onSendProgress: (int sent, int total) {
      print("${(sent / total) * 100}");
      pr.update(
        progress: (sent / total) * 100,
        message: "正在上传 ${((sent / total) * 100).roundToDouble()}%",
        progressWidget: Container(
            padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
      );
    }).then((response) {
      Map<String, dynamic> dataMap = json.decode(response.data);
      pr.hide();
      if (dataMap != null) {
        return dataMap["data"].toString();
      }
    }).catchError((error) {
      pr.hide();
      print('upload err ===> $error');
      throw Exception(error);
    });
  }