import 'dart:convert';

import 'package:flui/flui.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:star/club/club_main.dart';
import 'package:star/home/home_main.dart';
import 'package:star/mine/mine_main.dart';
import 'package:star/provider/game_cards_provider.dart';
import 'package:star/provider/game_dashboard_theme_provider.dart';
import 'package:star/provider/game_message_provier.dart';
import 'package:star/provider/game_openpokers_provider.dart';
import 'package:star/provider/index_page_data_provider.dart';
import 'package:star/routes/application.dart';
import 'package:star/routes/routes.dart';
import 'package:star/httprequest/httprequest.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/global.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/theme_config.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/util/appUpdate.dart';
import 'dart:async';

import 'httprequest/getuserinfo.dart';
import 'httprequest/usermodel.dart';
void main() async{

  var gameMessageProvier = GameMessageProvier();
  var gameCardsProvider = GameCardsProvider();
  var gameDashboardThemeProvider = GameDashboardThemeProvider();
  var gameOpenPokersProvider = GameOpenPokersProvider();
  var pro = Providers();
  pro..provide(Provider<GameOpenPokersProvider>.value(gameOpenPokersProvider));
  pro..provide(Provider<GameMessageProvier>.value(gameMessageProvier));
  pro..provide(Provider<GameCardsProvider>.value(gameCardsProvider));
  pro..provide(Provider<GameDashboardThemeProvider>.value(gameDashboardThemeProvider));
  pro..provide(Provider<IndexPageDataProvider>.value(IndexPageDataProvider()));
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(ProviderNode(child: MyApp(),providers: pro,)));
  // runApp(ProviderNode(child: MyApp(),providers: pro,));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FLToastDefaults _toastDefaults = FLToastDefaults();
  int selectedIndex = 1;
  List<Widget> _list = [
    ClubMain(),
    HomeMain(),
    MineMain(),
  ];
  void indexOntap(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  Future _loadMineData() async{
    await mHttp.getInstance().postHttp('/jwt/userstatistics/getuserstatistics', (mineData) async{
      await Global.globalShareInstance.setString('minePageRecordStorage', jsonEncode(mineData["data"]));
      Provide.value<IndexPageDataProvider>(context).getMineData(mineData["data"]);
    }, (error){
    });
  }

  Widget bottomBarItem(int index){
    return Container(
      //padding: EdgeInsets.only(top:5),
      height:66,
      width: 100,
//      color: style.backgroundColor,
      child: InkWell(
        highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () async{
            if (selectedIndex != index) {
              setState(() {
                selectedIndex = index;
              });
              if(index == 2){
                await _loadMineData();
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              index == 0? Image.asset(selectedIndex == 0? style.tabLeft : style.tabLeft_un,width: 31.86,height: 27.17,):
              Image.asset(selectedIndex == 2? style.tabRight : style.tabRight_un,width: 26.29,height: 26.18),
              Text(index==0?"俱乐部":"我的",style: TextStyle(color: selectedIndex==index?style.themeColor : g99,fontSize: 10),)
            ],
          ),
        )
    );
  }
  Future<void> getThemeData() async{

  }
  @override
  void initState(){
    isPopup(context, "新版本v1.0.1");
    super.initState();

    eventBus.on("onThemeChange", (arg) {
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context){
    if(style== null){
      int type = 0;
      style = type == null? blueTheme() : type == 0? blueTheme() : darkTheme();

    }
//    print( MediaQuery.of(context).size.height * 0.1,);
//    scheduleMicrotask(() async{
//      int type = 0;
//      style = type == null? blueTheme() : type == 0? blueTheme() : darkTheme();
//      if(style!= null){
//        return;
//      }
//      print(111111111);
//      SharedPreferences _sp = await SharedPreferences.getInstance();
//      type = _sp.getInt("SYSTEMTHEMETYPE");
//      style = type == null? blueTheme() : type == 0? blueTheme() : darkTheme();
//    });
//    print("222222");
    final route = Router();
    Routes.configuerRoutes(route);
    Application.router = route;
    return FLToastProvider(
      defaults: _toastDefaults, 
      child: Theme(data: ThemeData.dark(), child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: style == null? Scaffold(backgroundColor: style.backgroundColor,): Scaffold(
//          backgroundColor: Colors.grey,
         resizeToAvoidBottomPadding: false,
          body: IndexedStack(
              index: selectedIndex,
              children: _list
          ),
          bottomNavigationBar: BottomAppBar(
            color:style.backgroundColor,
//            color: style.backgroundColor,
            shape: style.backgroundColor ==  Color(0xff0F0F0F)? null: CircularNotchedRectangle(),
            child: Row(
              children: [
                bottomBarItem(0),
                SizedBox(), //中间位置空出
                bottomBarItem(2),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
//              backgroundColor : style.backgroundColor,
            onPressed: (){
              setState(() {
                selectedIndex =1;
              });
            },
            child: Image.asset(imgpath+"centerAdd.png",),
          ),
        ),
      )));
  }
}