import 'package:fluro/fluro.dart';
import 'package:star/club/club_bindemail.dart';
import 'package:star/club/club_config.dart';
import 'package:star/club/club_create.dart';
import 'package:star/club/club_infomation.dart';
import 'package:star/club/club_join.dart';
import 'package:star/club/club_memberList.dart';
import 'package:star/club/club_setAdmin.dart';
import 'package:star/club/message_info.dart';
import 'package:star/club/message_list.dart';
import 'package:star/home/game_main.dart';
import 'package:star/home/home_create_game.dart';
import 'package:star/login/login_main.dart';
import 'package:star/login/login_prefer_info.dart';
import 'package:star/login/login_reg.dart';
import 'package:star/mine/mine_cardinfo.dart';
import 'package:star/mine/mine_cardslist.dart';
import 'package:star/mine/mine_changeavatar.dart';
import 'package:star/mine/mine_data.dart';
import 'package:star/mine/mine_scoreinfo.dart';
import 'package:star/mine/mine_scorelist.dart';
import 'package:star/mine/mine_setting.dart';
Handler loginMainViewHandle = Handler(
  handlerFunc: (context,parameters){
    return LoginMain();
  }
);
Handler loginRegPhoneViewHandle = Handler(
  handlerFunc: (context,parameters){
    String viewType = parameters["viewType"].first;
    return LoginReg(viewType);
  }
);

Handler clubCreateViewHandle = Handler(
  handlerFunc: (context,parameters){
    return ClubCreate();
  }
);

Handler clubConfigViewHandle = Handler(
  handlerFunc: (context,parameters){
    return ClubConfig();
  }
);

Handler clubInfomationViewHandle = Handler(
  handlerFunc: (context,parameters){
    return ClubInfomation();
  }
);
Handler clubJoinViewHandle = Handler(
  handlerFunc: (context,parameters){
    return ClubJoin();
  }
);
Handler clubMemberListViewHandle = Handler(
  handlerFunc: (context,parameters){
    String isSelect = parameters["isSelect"].first;
    String adminStr = parameters["adminStr"].first;

    return ClubMemberList(isSelect,adminStr);
  }
);
Handler clubSetAdminViewHandle = Handler(
  handlerFunc: (context,parameters){
    return ClubSetAdmin();
  }
);
Handler clubBindEmailViewHandle = Handler(
  handlerFunc: (context,parameters){
    return ClubBindEmail();
  }
);
Handler messageListViewHandle = Handler(
  handlerFunc: (context,parameters){
    String msgType = parameters["msgType"].first;
    return MessageList(msgType);
  }
);

Handler messageInfoViewHandle = Handler(
  handlerFunc: (context,parameters){
    String msgType = parameters["type"].first;
    String title = parameters["title"].first;
    return MessageInfo(msgType,title);
  }
);

Handler mineCardInfoHandle = Handler(
  handlerFunc: (context,parameters){
    String curKey = parameters["curKey"].first;
    String winnerName = parameters["winnerName"].first;
    String winnerType = parameters["winnerType"].first;
    String winnerScore = parameters["winnerScore"].first;
    return MineCardInfo(curKey,winnerName,winnerType,winnerScore);
  }
);
Handler mineCardsListHandle = Handler(
  handlerFunc: (context,parameters){
    String boardKeyContain = parameters["boardKeyContain"].first;
    String isFromMine = parameters["isFromMine"].first;
    return MineCardsList(boardKeyContain,isFromMine);
  }
);
Handler mineChangeAvatarHandle = Handler(
  handlerFunc: (context,parameters){
    return MineChangeAvatar();
  }
);
Handler mineDataHandle = Handler(
  handlerFunc: (context,parameters){
    return MineData();
  }
);
Handler mineScoreInfoHandle = Handler(
  handlerFunc: (context,parameters){
    String curKey = parameters["curKey"].first;
    return MineScoreInfo(curKey);
  }
);
Handler mineScoreListHandle = Handler(
  handlerFunc: (context,parameters){
    return MineScoreList();
  }
);
Handler mineSettingHandle = Handler(
  handlerFunc: (context,parameters){
    return MineSetting();
  }
);

Handler homeCreateGameHandle = Handler(
  handlerFunc: (context,parameters){
    return HomeCreateGame();
  }
);

Handler regPreferInfoHandle = Handler(
  handlerFunc: (context,parameters){
    return LoginPreferInfo();
  }
);

Handler gameMainHandle = Handler(
  handlerFunc: (context,parameters){
    return GameMain();
  }
);