import 'dart:convert';

import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_slider/flutter_radio_slider.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/httprequest/socketUtil.dart';
import 'package:star/routes/application.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/jsonconver.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class HomeCreateGame extends StatefulWidget {
  @override
  _HomeCreateGameState createState() => _HomeCreateGameState();
}

class _HomeCreateGameState extends State<HomeCreateGame> {
  TextEditingController _gameNameController = TextEditingController();
  bool _canCreate = false;
  void changeCreateButtonStyle(String value) {
    if (_gameNameController.text.length > 0) {
      setState(() {
        _canCreate = true;
      });
    } else {
      setState(() {
        _canCreate = false;
      });
    }
    if(value == null)
      cancelTextEdit(context);
  }
  double typeValue = 0,
      scoreValue = 0,
      personValue = 0,
      timeValue = 0,
      delayValue = 0,
      anteValue = 0;
  bool baoxianOn = false,
  stradOn = false,
  gpsOn = false;

  SliderThemeData themeData = null;
  List dicList = [
    {"title": "小盲/大盲", "divi": 7,"values":["1/2","2/4","5/10","10/20","20/40","25/50","50/100","100/200"],"value":0},
    {"title": "带入记分牌", "divi": 9,"values":["100","200","500","1000","2000","2500","5000","10000"],"value":0},
    {"title": "人数设置", "divi": 4,"values":["2","6","7","8","9"],"value":0},
    {"title": "牌局时长(h)", "divi": 5,"values":["0.5","1","2","3","4","5"],"value":0},
    {"title": "延时器", "divi": 4,"values":["1","2","3","4","5"],"value":0},
    {"title": "Ante", "divi": 2,"values":["0","1","2"],"value":0}
  ];
  Widget sliderViews(int i) {
    var item = dicList[i];
    //double ds = i==0? typeValue : i==1? scoreValue: i==2? personValue: i==3? timeValue: i==4? delayValue:anteValue;
    return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(padding: EdgeInsets.only(left:15,top:10),child: setTextWidget(item["title"], 13, false, g99),),
                  Expanded(child: SizedBox()),
                  Container(padding: EdgeInsets.only(right:15,top:10),child: setTextWidget(i== 1? (int.parse(item["values"][dicList[0]["value"]]) * (item["value"]+1)).toString() : item["values"][item["value"]] , 13, false, style.themeColor),),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child:SliderTheme(
                  data: themeData,
                  child: Slider(
                    max: item["divi"].toDouble(),
                    min: 0.0,
                    value: i==0? typeValue : i==1? scoreValue: i==2? personValue: i==3? timeValue: i==4? delayValue:anteValue, 
                    divisions: item["divi"],
                    onChanged: (value){
                      if(item["value"] == value.toInt()) return;
                      item["value"] = value.toInt();
                      setState(() {
                        dicList[i] = item;
                        switch (i) {
                          case 0:
                            typeValue=value;
                            break;
                          case 1:
                            scoreValue=value;
                            break;
                          case 2:
                            personValue=value;
                            break;
                          case 3:
                            timeValue=value;
                            break;
                          case 4:
                            delayValue=value;
                            break;
                          default:
                            anteValue=value;
                        }
                      });
                      
                    }
                  )
                ),
              )
            ],
          );
  }
  double valTest = 1;
  @override
  Widget build(BuildContext context) {
    themeData = SliderTheme.of(context).copyWith(
      trackHeight: 6,
      showValueIndicator: ShowValueIndicator.always,
      activeTickMarkColor:style.themeColor,
      activeTrackColor: style.themeColor,
      inactiveTrackColor: style.playSliderColor,
      inactiveTickMarkColor: Colors.transparent
    );
    return Scaffold(
      appBar: whiteAppBarWidget("创建牌局", context, haveShadowLine: true),
//      backgroundColor: Colors.red,
      body: Container(
        color: style.textDivideBlockColor,
        child:SingleChildScrollView(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: style.textDivideBlockColor,
                child:mTextFiled(
                  _gameNameController,
                  changeCreateButtonStyle,
                  "牌局名称（2-10个汉字）",
                  1,
                  hintStyle:
                  TextStyle(color: Color(0xffcccccc), fontSize: ssSp(16)),
                ),
              ),
              Container(color: style.backgroundColor,margin: EdgeInsets.only(top:10),child: sliderViews(0,),),
              Container(color: style.backgroundColor,child: sliderViews(1,),),
              Container(color: style.backgroundColor,child: sliderViews(2,),),
              Container(color: style.backgroundColor,child: sliderViews(3,),),
              Container(color: style.backgroundColor,child: sliderViews(4,),),
              Container(color: style.backgroundColor,child: sliderViews(5,),),
              greyLineUI(10,color: style.textDivideBlockColor),
              labelCell("Straddle", "",rightView: Switch(value: stradOn,activeTrackColor: style.btnUnActiveColor,inactiveTrackColor: style.textDivideBlockColor == Colors.black ?Colors.white.withOpacity(0.4): Color(0xffCCCCCC) , onChanged: (bool v){
                setState(() {
                  stradOn = v;
                });
              }),height: ssSetWidth(70)),
              greyLineUI(0.5,padding: EdgeInsets.only(left:15,right:15),color: style.textDivideLineColor),
              labelCell("保险", "",rightView: Switch(value: baoxianOn,activeTrackColor: style.btnUnActiveColor,inactiveTrackColor: style.textDivideBlockColor == Colors.black ? Colors.white.withOpacity(0.4): Color(0xffCCCCCC), onChanged: (bool v){
                setState(() {
                  baoxianOn = v;
                });
              }),height: ssSetWidth(70)),
              greyLineUI(0.5,padding: EdgeInsets.only(left:15,right:15),color: style.textDivideLineColor),
              labelCell("GPS和IP限制", "",rightView: Switch(value: gpsOn,activeTrackColor: style.btnUnActiveColor,inactiveTrackColor: style.textDivideBlockColor == Colors.black ? Colors.white.withOpacity(0.4): Color(0xffCCCCCC), onChanged: (bool v){
                setState(() {
                  gpsOn = v;
                });
              }),height: ssSetWidth(60)),
              greyLineUI(15,color: style.textDivideBlockColor),
              Padding(
                  padding: EdgeInsets.only(left:15,right:15,bottom:30),
                  child: Container(
                    width: ssSetWidth(375),
                    height: ssSetWidth(42),

                    decoration: BoxDecoration(
                        color: style.btnUnActiveColor.withOpacity(_canCreate?1:0.41),
                        borderRadius: BorderRadius.circular(ssSetWidth(21))
                    ),
                    child: InkWell(
                      onTap: (){
                        if(_canCreate){
                          mHttp.getInstance().postHttp("/jwt/housesettings/add", (data){
                            Map cao = jsonDecode(data["msg"]);
                            if (data["code"] != 200) {
                              showToast(data["msg"]);
                              return;
                            }
                            //socket请求进入房间
                            dismiss = FLToast.loading(text: 'Loading...');
                            sendSocketMsg({"messageType":SocketMessageType().GAME_HOUSE_REQUEST,"gameHouseMessage":HouseMessageType().INTO_HOUSE,"pwd":cao["housePwd"].toString()});
                          }, (error){

                          },params: {
                            "houseName":_gameNameController.text,
                            "houseType":"${dicList[0]["value"]+1}",
                            "matBlind":"${dicList[0]["values"][dicList[0]["value"]].toString().split("/")[1]}",//(int.parse(dicList[1]["values"][dicList[0]["value"]]) * (dicList[1]["value"]+1)).toString(),
                            "maxUserNumbers":"${dicList[2]["values"][dicList[2]["value"]]}",
                            "matMinScorecard":"${(int.parse(dicList[1]["values"][dicList[0]["value"]]) * (dicList[1]["value"]+1)).toString()}",
                            "matMaxScorecard":"${((int.parse(dicList[1]["values"][dicList[0]["value"]]) * (dicList[1]["value"]+1)) * 10).toString()}",
                            "matDelay":"20",
                            "matAnte":"${dicList[5]["values"][dicList[5]["value"]]}.00",
                            "matStraddle":stradOn?"1":"0",
                            "matInsurance":baoxianOn?"1":"0",
                            "matGpsAndIp":gpsOn?"1":"0",
                            "matTime":"${(double.parse(dicList[3]["values"][dicList[3]["value"]]) * 60).toInt()}"
                          });

                        }
                      },
                      child: Center(child:setTextWidget("现在开局", 16, false, style.textDivideBlockColor == Colors.black ?  _canCreate ? style.textTitleColor: style.textTipColor : Colors.white)),
                    ),
                  )
              )
            ],
          ),
        ),
      )
    );
  }
}
