import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';

class ThemeConfig{
  Color themeColor;           //主题色
  Color supportColor;         //辅助色
  Color backgroundColor;      //背景色
  Color textTitleColor;       //文字标题
  Color textContextColor;     //文字内容
  Color textTipColor;         //文字提示
  Color textUnderLineColor;   //下划线
  Color textDivideLineColor;  //分割线
  Color textDivideBlockColor; //分割块
  Color btnUnActiveColor;     //未激活登录按钮
  Color loginRegColor;        //立即注册
  Color loginReSendCodeColor; //重新获取验证码
  Color clubTextFieldColor;   //俱乐部输入框
  Color clubJoinUnderLineColor;//加入俱乐部下划线
  Color playSliderColor;      //创建牌局滑动条
  Color minePictureMaskColor; //图片头像遮罩
  Color purityBlockColor;     //纯白/纯黑
  String iconMessage;         //消息
  String iconSetting;         //设置
  String iconShare;           //分享
  String iconScores;          //成绩
  String iconCards;           //派普
  String iconDatas;           //数据
  String gameType;            //游戏类型
  String gameTime;            //游戏时间
  String gameNumber;          //人数
  String gameDate;            //游戏日期
  String tabLeft_un;             //tab左边
  String tabLeft;             //tab左边
  String tabRight_un;            //tab右边
  String tabRight;            //tab右边
  int themeType;
  Color shareBarColor;
  Color wodeTitle;
  Color wodeId;
}

class blueTheme extends ThemeConfig{
  @override
  // TODO: implement themeColor
  Color get themeColor => Color(0xff1479ED);
  @override
  // TODO: implement supportColor
  Color get supportColor => Color(0xffff9f36);
  @override
  // TODO: implement backgroundColor
  Color get backgroundColor => Color(0xffffffff);
  @override
  // TODO: implement textTitleColor
  Color get textTitleColor => Color(0xff333333);
  @override
  // TODO: implement textContextColor
  Color get textContextColor => Color(0xff333333);
  @override
  // TODO: implement textTipColor
  Color get textTipColor => Color(0xffcccccc);
  @override
  // TODO: implement textUnderLineColor
  Color get textUnderLineColor => Color(0xffe5e5e5);
  @override
  // TODO: implement textDivideLineColor
  Color get textDivideLineColor => Color(0xfff5f5f5);
  @override
  // TODO: implement textDivideBlockColor
  Color get textDivideBlockColor => Color(0xffF5F5F5);
  @override
  // TODO: implement btnUnActiveColor
  Color get btnUnActiveColor => Color(0xff1479ED);
  @override
  // TODO: implement loginRegColor
  Color get loginRegColor => Color(0xff1479ED);
  @override
  // TODO: implement loginReSendCodeColor
  Color get loginReSendCodeColor => Color(0xff999999);
  @override
  // TODO: implement clubTextFieldColor
  Color get clubTextFieldColor => Color(0xffffffff);
  @override
  // TODO: implement clubJoinUnderLineColor
  Color get clubJoinUnderLineColor => Color(0xff666666);
  @override
  // TODO: implement playSliderColor
  Color get playSliderColor => Color(0xffE5E5E5);
  @override
  // TODO: implement minePictureMaskColor
  Color get minePictureMaskColor => Colors.transparent;
  @override
  // TODO: implement purityColor
  Color get purityBlockColor => Color(0xffffffff);
  @override
  // TODO: implement iconMessage
  String get iconMessage => imgpath+"notice_icon.png";
  @override
  // TODO: implement iconSetting
  String get iconSetting => imgpath+"blacksetting.png";
  @override
  // TODO: implement iconCards
  String get iconCards => imgpath+"mine/cards.png";
  @override
  // TODO: implement iconDatas
  String get iconDatas => imgpath+"mine/data.png";
  @override
  // TODO: implement iconScores
  String get iconScores => imgpath+"mine/score.png";
  @override
  // TODO: implement iconShare
  String get iconShare => imgpath+"mine/share.png";
  @override
  // TODO: implement gameDate
  String get gameDate => "";
  @override
  // TODO: implement gameNumber
  String get gameNumber => imgpath+"game/s_num.png";
  @override
  // TODO: implement gameTime
  String get gameTime => imgpath+"game/time.png";
  @override
  // TODO: implement gameType
  String get gameType => imgpath+"game/score.png";
  @override
  // TODO: implement tabLeft
  String get tabLeft => imgpath+"tab_club_s.png";
  @override
  // TODO: implement tabLeft_un
  String get tabLeft_un =>imgpath+"tab_club.png";
  @override
  // TODO: implement tabRight
  String get tabRight => imgpath+"tab_mine_s.png";
  @override
  // TODO: implement tabRight_un
  String get tabRight_un => imgpath+"tab_mine.png";
  @override
  // TODO: implement themeType
  int get themeType => 0;
  @override
  // TODO: implement shareBarColor
  Color get shareBarColor => Color(0xffc2e0ff);
  Color get wodeTitle =>Color(0xffffffff);
  Color get wodeId =>Color(0xffffffff).withOpacity(0.7);
}

class darkTheme extends ThemeConfig{
  @override
  // TODO: implement themeColor
  Color get themeColor => Color(0xff357ED2);
  @override
  // TODO: implement supportColor
  Color get supportColor => Color(0xffDC8C33);
  @override
  // TODO: implement backgroundColor
  Color get backgroundColor => Color(0xff0F0F0F);
//  Color get backgroundColor => Colors.red;
  @override
  // TODO: implement textTitleColor
  Color get textTitleColor => Color(0xffFFFFFF).withOpacity(0.7);
  @override
  // TODO: implement textContextColor
  Color get textContextColor => Color(0xffFFFFFF).withOpacity(0.4);
  @override
  // TODO: implement textTipColor
  Color get textTipColor =>Color(0xffFFFFFF).withOpacity(0.3);
  @override
  // TODO: implement textUnderLineColor
  Color get textUnderLineColor =>Color(0xffFFFFFF).withOpacity(0.2);
  @override
  // TODO: implement textDivideLineColor
  Color get textDivideLineColor => Color(0xffFFFFFF).withOpacity(0.1);
  @override
  // TODO: implement textDivideBlockColor
  Color get textDivideBlockColor => Color(0xff000000);
  @override
  // TODO: implement btnUnActiveColor
  Color get btnUnActiveColor => Color(0xff357ED2);
  @override
  // TODO: implement loginRegColor
  Color get loginRegColor => Color(0xffFFFFFF).withOpacity(0.4);
  @override
  // TODO: implement loginReSendCodeColor
  Color get loginReSendCodeColor => Color(0xffffffff).withOpacity(0.4);
  @override
  // TODO: implement clubTextFieldColor
  Color get clubTextFieldColor => Color(0xffffffff).withOpacity(0.1);
  @override
  // TODO: implement clubJoinUnderLineColor
  Color get clubJoinUnderLineColor => Color(0xffffffff).withOpacity(0.5);
  @override
  // TODO: implement playSliderColor
  Color get playSliderColor => Color(0xffffffff).withOpacity(0.4);
  @override
  // TODO: implement minePictureMaskColor
  Color get minePictureMaskColor => Color(0xff000000).withOpacity(0.3);
  @override
//   TODO: implement purityColor
  Color get purityBlockColor => Colors.black;
  @override
  // TODO: implement iconMessage
  String get iconMessage => imgpath+"notice_icon.png";
  @override
  // TODO: implement iconSetting
  String get iconSetting => imgpath+"blacksetting.png";
  @override
  // TODO: implement iconCards
  String get iconCards => imgpath+"mine/cards.png";
  @override
  // TODO: implement iconDatas
  String get iconDatas => imgpath+"mine/data.png";
  @override
  // TODO: implement iconScores
  String get iconScores => imgpath+"mine/score.png";
  @override
  // TODO: implement iconShare
  String get iconShare => imgpath+"mine/share.png";
  @override
  // TODO: implement gameDate
  String get gameDate => "";
  @override
  // TODO: implement gameNumber
  String get gameNumber => imgpath+"game/s_num.png";
  @override
  // TODO: implement gameTime
  String get gameTime => imgpath+"game/time.png";
  @override
  // TODO: implement gameType
  String get gameType => imgpath+"game/score.png";
  @override
  // TODO: implement tabLeft
  String get tabLeft => imgpath+"tab_club_s.png";
  @override
  // TODO: implement tabLeft_un
  String get tabLeft_un =>imgpath+"tab_club.png";
  @override
  // TODO: implement tabRight
  String get tabRight => imgpath+"tab_mine_s.png";
  @override
  // TODO: implement tabRight_un
  String get tabRight_un => imgpath+"tab_mine.png";

  @override
  // TODO: implement themeType
  int get themeType => 1;
  @override
  // TODO: implement shareBarColor
  Color get shareBarColor => Color(0xff357ED2).withOpacity(0.1);
  Color get wodeTitle =>Color(0xffffffff).withOpacity(0.7);
  Color get wodeId =>Color(0xffffffff).withOpacity(0.5);
}