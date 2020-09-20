import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/event_bus.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/widgets/some_widgets.dart';

EventBus eventBus = new EventBus();
double ssSetWidth(double width) {
  return ScreenUtil().setWidth(width);
}

double safeStatusBarHeight() {
  return ScreenUtil.statusBarHeight;
}

double safeBottomBarHeight() {
  return ScreenUtil.bottomBarHeight;
}

double ssSetHeigth(double height) {
  return ScreenUtil().setHeight(height);
}

double ssSp(double sp) {
  return ScreenUtil().setSp(sp);
}

void cancelTextEdit(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void showToast(String str, {int time}) {
  Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: ssSp(14),
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: time ?? 1);
}

void showAlertView(
    BuildContext context,
    String title,
    String content,
    String cancelButtonTitle,
    String confirmButtonTitle,
    GestureTapCallback func) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return cancelButtonTitle != null
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(cancelButtonTitle),
                  ),
                  CupertinoDialogAction(
                    onPressed: func,
                    child: Text(confirmButtonTitle),
                  )
                ],
              )
            : CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: func,
                    child: Text(confirmButtonTitle),
                  )
                ],
              );
      });
}

//底部弹出拍照相册按钮
void showImgDialog(
    BuildContext context, void Function() camerafunc, void Function() imgfunc) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 171,
          margin: EdgeInsets.only(left: 15, right: 15), //控制底部的距离
          child: Column(
            children: <Widget>[
              Container(
                height: 101,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: camerafunc,
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            '拍照',
                            style: TextStyle(
//                                fontSize: Config.fontSize17,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: imgfunc,
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            '相册',
                            style: TextStyle(
//                                fontSize: Config.fontSize17,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      '取消',
                      style: TextStyle(
                          color: Colors.red,
//                          fontSize: Config.fontSize17,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

//底部弹出拍照相册按钮
void showShareView(BuildContext context, String url) {
  showModalBottomSheet(
      context: context,
      enableDrag:false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 275,
          padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 0,
              bottom: safeBottomBarHeight() ), //控制底部的距离
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      imgpath + "icon-facepoker-xxxhdpi.png",
                      width: 29,
                      height: 29,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7),
                      child: setTextWidget(
                          "Facepoker.com", 14, false, Color(0xff333333)),
                    ),
                    Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 29,
                        height: 29,
                        child: Center(
                          child: Image.asset(imgpath + "grey_close.png",
                              width: 12, height: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 0.5,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 24),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print("微博分享");
                      },
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            imgpath + "weibo.png",
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: setTextWidget(
                                "微博",
                                12,
                                false,
                                Color(0xff333333),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: InkWell(
                        onTap: () {
                          print("QQ分享");
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              imgpath + "qq.png",
                              width: 60,
                              height: 60,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: setTextWidget(
                                  "QQ",
                                  12,
                                  false,
                                  Color(0xff333333),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: InkWell(
                        onTap: () {
                          print("微信分享");
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              imgpath + "wechat.png",
                              width: 60,
                              height: 60,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: setTextWidget(
                                  "微信",
                                  12,
                                  false,
                                  Color(0xff333333),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  print("拷贝url");
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white),
                  height: 44,
                  width: ssSetWidth(345),
                  padding: EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    children: <Widget>[
                      setTextWidget("拷贝", 16, false, Color(0xff333333)),
                      Expanded(child: SizedBox()),
                      Image.asset(
                        imgpath + "copy.png",
                        width: 20.5,
                        height: 25.73,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      });
}

Future<File> getCameraImage() async {
  var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 200,
      maxHeight: 200); //maxWidth和maxHeight是像素，改变图片大小
  if (image == null) {
    return null;
  }
  File croped = await _cropImage(image);
  if (croped == null) {
    return null;
  }
  return croped; //裁剪图片的方法
}

Future<File> getPhotoImage() async {
  var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 200); //maxWidth和maxHeight是像素，改变图片大小
  if (image == null) {
    return null;
  }
  File croped = await _cropImage(image);
  if (croped == null) {
    return null;
  }
  return croped; //裁剪图片的方法
}

Future<File> _cropImage(_image) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: '编辑图片',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
  if (croppedFile == null) return null;
  return croppedFile;
}

void toCamera(void Function(String url, {File f}) up, context) async {
  var value = await getCameraImage();
  Navigator.pop(context);
  if (value != null) {
    var imgUrl = await uploadImage(value.path, context);
    if (imgUrl != null) {
      up(imgUrl, f: value);
    }
  }
}

void toPhoto(void Function(String url, {File f}) up, context) async {
  var value = await getPhotoImage();
  Navigator.pop(context);
  if (value != null) {
    var imgUrl = await uploadImage(value.path, context);
    if (imgUrl != null) {
      up(imgUrl, f: value);
    }
  }
}

double middleX = (375 - tileWidth) / 2;
double leftX = 5.5;
double rightX = 375 - tileWidth-leftX;
double tileWidth = 50;
double tileHeight = viewHeight / 5;
double viewHeight = ssSetHeigth(667) - safeStatusBarHeight() - ssSetHeigth(60) - ssSetWidth(50);
//底部居中座位
RelativeRect bottomCenterRect() {
  return RelativeRect.fromLTRB(
      ssSetWidth(middleX),
      viewHeight - tileHeight,
      ssSetWidth(middleX),
      ssSetHeigth(0));
}

//顶部居中座位
RelativeRect topCenterRect() {
  return RelativeRect.fromLTRB(ssSetWidth(middleX), ssSetHeigth(0),
      ssSetWidth(middleX), viewHeight - tileHeight);
}

//顶部左座位
RelativeRect topLeftRect() {
  return RelativeRect.fromLTRB(ssSetWidth(375/2 -tileWidth/2 - tileWidth - 11.5), ssSetHeigth(0),
  ssSetWidth(375/2 + tileWidth/2 + 11.5), viewHeight - tileHeight);
}

//顶部右座位
RelativeRect topRightRect() {
  return RelativeRect.fromLTRB(ssSetWidth(375/2 + tileWidth/2 + 11.5), ssSetHeigth(0),
      ssSetWidth(375/2 -tileWidth/2 - tileWidth -11.5), viewHeight - tileHeight);
}

//3层左下座位
RelativeRect left3BottomRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(leftX),
    tileHeight * 3,
    ssSetWidth(rightX),
    tileHeight,
  );
}

//3层左中座位
RelativeRect left3MidRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(leftX),
    tileHeight * 2,
    ssSetWidth(rightX),
    tileHeight * 2,
  );
}

//3层左上座位
RelativeRect left3TopRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(leftX),
    tileHeight,
    ssSetWidth(rightX),
    tileHeight * 3,
  );
}

//2层左下座位
RelativeRect left2BottomRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(leftX),
    tileHeight * 2.75,
    ssSetWidth(rightX),
    tileHeight * 1.25,
  );
}

//2层左上座位
RelativeRect left2TopRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(leftX),
    tileHeight * 1.25,
    ssSetWidth(rightX),
    tileHeight * 2.75,
  );
}

//3层右下座位
RelativeRect right3BottomRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(rightX),
    tileHeight * 3,
    ssSetWidth(leftX),
    tileHeight,
  );
}

//3层右中座位
RelativeRect right3MidRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(rightX),
    tileHeight * 2,
    ssSetWidth(leftX),
    tileHeight * 2,
  );
}

//3层右上座位
RelativeRect right3TopRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(rightX),
    tileHeight,
    ssSetWidth(leftX),
    tileHeight * 3,
  );
}

//2层右下座位
RelativeRect right2BottomRect() {
  return RelativeRect.fromLTRB(
      ssSetWidth(rightX),
      tileHeight * 2.75,
      ssSetWidth(leftX),
      tileHeight * 1.25);
}

//2层右上座位
RelativeRect right2TopRect() {
  return RelativeRect.fromLTRB(
    ssSetWidth(rightX),
    tileHeight * 1.25,
    ssSetWidth(leftX),
    tileHeight * 2.75,
  );
}

RelativeRect sitePosition(int total, int index) {
  if (total == 2) {
    if (index == 0) {
      return bottomCenterRect();
    } else {
      return topCenterRect();
    }
  } else if (total == 6) {
    if (index == 0) {
      return bottomCenterRect();
    } else if (index == 1) {
      return left2BottomRect();
    } else if (index == 2) {
      return left2TopRect();
    } else if (index == 3) {
      return topCenterRect();
    } else if (index == 4) {
      return right2TopRect();
    } else {
      return right2BottomRect();
    }
  } else if (total == 7) {
    if (index == 0) {
      return bottomCenterRect();
    } else if (index == 1) {
      return left2BottomRect();
    } else if (index == 2) {
      return left2TopRect();
    } else if (index == 3) {
      return topLeftRect();
    } else if (index == 4) {
      return topRightRect();
    } else if (index == 5) {
      return right2TopRect();
    } else {
      return right2BottomRect();
    }
  } else if (total == 8) {
    if (index == 0) {
      return bottomCenterRect();
    } else if (index == 1) {
      return left3BottomRect();
    } else if (index == 2) {
      return left3MidRect();
    } else if (index == 3) {
      return left3TopRect();
    } else if (index == 4) {
      return topCenterRect();
    } else if (index == 5) {
      return right3TopRect();
    } else if (index == 6) {
      return right3MidRect();
    } else {
      return right3BottomRect();
    }
  } else {
    if (index == 0) {
      return bottomCenterRect();
    } else if (index == 1) {
      return left3BottomRect();
    } else if (index == 2) {
      return left3MidRect();
    } else if (index == 3) {
      return left3TopRect();
    } else if (index == 4) {
      return topLeftRect();
    } else if (index == 5) {
      return topRightRect();
    } else if (index == 6) {
      return right3TopRect();
    } else if (index == 7) {
      return right3MidRect();
    } else {
      return right3BottomRect();
    }
  }
}
