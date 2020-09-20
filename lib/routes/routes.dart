import 'package:star/routes/application.dart';
import 'package:star/routes/route_handler.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static void configuerRoutes(Router router){
    router.notFoundHandler = Handler(
      handlerFunc: (context,paramers){
        print("not found this router");
      }
    );
    router.define(loginMainPath, handler: loginMainViewHandle);
    router.define(loginRegPhonePath, handler: loginRegPhoneViewHandle);
    router.define(clubCreatePath, handler: clubCreateViewHandle);
    router.define(clubConfigPath, handler: clubConfigViewHandle);
    router.define(clubInfomationPath, handler: clubInfomationViewHandle);
    router.define(clubJoinPath, handler: clubJoinViewHandle);
    router.define(clubMemberListPath, handler: clubMemberListViewHandle);
    router.define(clubSetAdminPath, handler: clubSetAdminViewHandle);
    router.define(messageListPath, handler: messageListViewHandle);
    router.define(messageInfoPath, handler: messageInfoViewHandle);
    router.define(clubBindEmailPath, handler: clubBindEmailViewHandle);
    router.define(mineCardInfoPath, handler: mineCardInfoHandle);
    router.define(mineCardsListPath, handler: mineCardsListHandle);
    router.define(mineChangeAvatarPath, handler: mineChangeAvatarHandle);
    router.define(mineDataPath, handler: mineDataHandle);
    router.define(mineScoreInfoPath, handler: mineScoreInfoHandle);
    router.define(mineScoreListPath, handler: mineScoreListHandle);
    router.define(mineSettingPath, handler: mineSettingHandle);
    router.define(homeCreateGamePath, handler: homeCreateGameHandle);
    router.define(regPreferInfoPath, handler: regPreferInfoHandle);
    router.define(gameMainPath, handler: gameMainHandle);
  }
}
