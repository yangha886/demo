import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/httprequest/getuserinfo.dart';
import 'package:star/httprequest/socketUtil.dart';
import 'package:star/httprequest/usermodel.dart';
import 'package:star/provider/game_dashboard_theme_provider.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:supercharged/supercharged.dart';
import 'package:provide/provide.dart';
class GameVar {
  //动画控制器
  AnimationController controller;
  //透明动画控制器
  AnimationController alphaController;
  Animation<double> alphaAnimation;
  //玩家出手回合的叠加层视图长度动画控制器
  AnimationController userRoundStokeLengthController;
  //出手回合导火索动画
  Animation<double> userRoundStokeLengthAnimation;
  AnimationController gameZhuangjiaTagController;
  RelativeRect lastZhuangjiaTagAnimation;
  RelativeRect gameZhuangjiaTagAnimation;
  //赢家动画
  Animation<RelativeRect> winnerAnimation;
  Animation<RelativeRect> winnerScoreAnimation;
  //玩家按钮动画控制器
  AnimationController gameButtonPositionController;
  //发牌动画控制器
  Map<String,AnimationController> fapaiControllers = Map();

  //发牌动画,Map对象key对应座位信息以及第一章牌第二章牌
  Map<String, Animation<RelativeRect>> fapaiList = Map();
  Map<String,RelativeRect> fapaiCenterPoint = Map();
  //收集筹码第一步动画控制器(先从已下注的用户手里收集到中间位置,每个用户收集5次, 一共持续2秒, 即每次收集动画持续400毫秒)
  Map<String,Map<String,Map<String,dynamic>>> collCallFirstController = Map();
  //进入加注页面隐藏掉背景上的加注按钮
  bool hiddenJiazhuButton = false;
  Timer goumaiBaoxianTimer;
  int proTimerD = -1;
  //用户筹码动画,map对象 key对应每个有下注的玩家
  Map<String, Animation<RelativeRect>> userCallList = Map();
  //动画曲线
  Curve defaultCurve = Curves.easeIn;
  //游戏数值动画控制器
  AnimationController gameNumberController;
  //数值动画 key="桌号_类型(0 总积分 1 下注额)" 回合池总额key="round_total" 底池总额key="game_total"
  Map<String, Animation<double>> gameNumberList = Map();
  //公牌
  List openPokers = List();
  //游戏已结束
  bool gameEnd = false;
  List<Widget> fenchiList;
  //最低快捷下注值
  int minCall,maxCall;
  Map argData = Map();
  List baoxianData;
  //收集筹码的组件
  List<Widget> collCallAniWidget = List();
  //暂停叠层视图
  OverlayEntry overlayEntry;
  //游戏暂停
  bool gameIsPause = false;
  //每回合下注筹码
  double roundCallTotal = 0.0;
  //当前局总筹码
  double gameCallTotal = 0.0;
  //数值变动控制器
  AnimationController changeNumController;
  //每个用户的筹码以及底池的数值
  List<Animation<int>> numAnimation = List();
  //发牌 收筹码等各种动画的中心点
  Offset centerOffset;
  //用户模型
  final UserModel userModel = UserInfo().getModel();
  Map nowUserInfo;
  //临时落座下标
  int seatNumTemp = -1;
  //总人数
  int numTotal = 0;
  //入座总人数
  int seatPersonNum = 0;
  //每次需要播放动画时, 设置这个列表,需要对应每个座位的当前位置以及终点位置,
  //默认初始化时用当前位置座位终点
  List<Animation<RelativeRect>> animationsList = List();
  //座位当前位置信息
  List<RelativeRect> startSitePosition = List();
  //座位终点位置信息
  List<RelativeRect> endSitePosition = List();
  //发牌动画位置信息
  List<RelativeRect> fapaiPosition = List();
  //当前牌局的所有玩家信息
  List usersList = List();
  //房局总回合数据
  Map roomRound = Map();
  //赢家信息
  Map winnerInfo ;
  //桌位信息
  List<Map> seatList = List();
  //底池快捷下注
  Map callData;
  //發牌動畫結束
  bool fapaiEnded = false;
  //我的手牌
  List myHandPoker = List();
  //我的手牌类型
  String myHandPokerType = "";
  //面前正对着的座位号
  int nowCurrentIndex = 0;
  Map choumaPosition = Map();
  //用户是否落座
  bool isSeated = false;
  //用于落座动画时的座位移动步数
  int moveStep = 0;
  //游戏是否已开始
  bool gameIsStarted = false;
  //是我的回合
  bool isMyRound = false;
  bool isFanpai = false;
  //自动操作,. 0 无操作 1 让或弃 2自动跟注
  int autoAction = 0;
  //左边抽屉的类型(0,计分器,1,聊天信息)
  int leftDrawType = 0;
  //发牌动画时长控制
  int fapaiTime = 210;
  //申请带入分数显示中
  bool showInScoreDialog = false;
  Timer timer;
  //画布主题改变
  void changeDashboardTheme(int theme,BuildContext context)async{
    //持久化
    SharedPreferences _sp = await SharedPreferences.getInstance();
    //保存画布主题色
    _sp.setInt("DASHBOARDTHEME", theme);
    //通知
    Provide.value<GameDashboardThemeProvider>(context)
        .setThemeType(theme);
  }
  //获取当前画布主题
  void getDashboardTheme(BuildContext context)async{
    //持久化
    SharedPreferences _sp = await SharedPreferences.getInstance();
    //读取画布主题色
    int theme = _sp.getInt("DASHBOARDTHEME");
    if(theme == null){
      changeDashboardTheme(0, context);
    }else
    //通知
    Provide.value<GameDashboardThemeProvider>(context)
        .setThemeType(theme);
  }
  Duration thinkTime =
      //5.seconds;
      20.seconds;

  static double pkTop = ssSetHeigth(667) - (ssSetHeigth(667) - safeBottomBarHeight() - viewHeight -ssSetHeigth(60) - safeStatusBarHeight()) - (tileHeight - ssSetWidth(77.5)) + ssSetHeigth(4);
  static double pkBottom  = ssSetHeigth(25) + safeBottomBarHeight();

  static double pkH = ssSetHeigth(667) - pkTop - pkBottom;
  static double pkW = pkH  /1.5;
  //左邊手牌的RECT
  RelativeRect leftHandPokerRect = RelativeRect.fromLTRB(
      ssSetWidth(375 / 2 - 2) - pkW ,
      pkTop,
      ssSetWidth(375 / 2 + 2),
      pkBottom) ;
  //右邊手牌的RECT
  RelativeRect rightHandPokerRect = RelativeRect.fromLTRB(
      ssSetWidth(375 / 2 + 2),
      pkTop,
      ssSetWidth(375 / 2 -2)- pkW,
      pkBottom );
  void autoPass() {
    //自动让或弃
    if (callData["pass"] == null) {
      sendSocketMsg({
        "messageType": SocketMessageType().GAME_ACTION_REQUEST,
        "gameActionType": GameActions().CANCEL,
        "bet": "0.0",
        "gameHouseId": nowRoomInfo["id"]
      });
      return;
    } else {
      sendSocketMsg({
        "messageType": SocketMessageType().GAME_ACTION_REQUEST,
        "gameActionType": GameActions().PASS,
        "bet": "0.0",
        "gameHouseId": nowRoomInfo["id"]
      });
      return;
    }
  }

}
