import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';

//label+textview的组件
Widget labelTextRow(String label, String placeHolder,
    TextEditingController controller, editComplete) {
  return Padding(
    padding: EdgeInsets.only(top: 34),
    child: Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 13),
          child: setTextWidget(label, 14, false, b33),
        ),
        Expanded(
          child: CupertinoTextField(
            style: TextStyle(color: b33),
            autofocus: false,
            controller: controller,
            cursorColor: b33,
            keyboardType: TextInputType.text,
            maxLength: 11,
            maxLengthEnforced: true,
            placeholder: placeHolder,
            decoration: BoxDecoration(color: Colors.transparent),
            onEditingComplete: () {
              editComplete();
            },
          ),
        )
      ],
    ),
  );
}
//密码+textview的组件
Widget pwdTextRow(
    TextEditingController _userNameController,void Function(String) changeLoginButtonStyle) {
  return Padding(
    padding: EdgeInsets.only(top: 25),
    child: Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(right:ssSetWidth(14)),child: setTextWidget("密码", 14, false, b33),),
        Expanded(
          child: CupertinoTextField(
            style: TextStyle(fontFamily: "pf",color: b33,fontSize: ssSp(15)),
            autofocus: false,
            obscureText: true,
            controller: _userNameController,
            cursorColor: b33,
            keyboardType: TextInputType.text,
            placeholder: "6-12个字符",
            decoration: BoxDecoration(color: Colors.transparent),
            onEditingComplete: () {
              changeLoginButtonStyle(null);
            },
            onChanged: (value){
              changeLoginButtonStyle(value);
            },
          ),
        )
      ],
    ),
  );
}
//手机号码样式的组件
Widget phoneTextRow(String countryCode, GestureTapCallback showDialog,
    TextEditingController _userNameController,void Function(String) changeLoginButtonStyle,
    {bool autoFocus}) {
  return Padding(
    padding: EdgeInsets.only(top: 34),
    child: Row(
      children: <Widget>[
        InkWell(
          child: setTextWidget(countryCode, 14, false, b33),
          onTap: showDialog,
        ),
        Icon(Icons.arrow_drop_down),
        Expanded(
          child: CupertinoTextField(
            style: TextStyle(color: b33),
            autofocus: autoFocus ?? false,
            controller: _userNameController,
            cursorColor: b33,
            keyboardType: TextInputType.number,
            maxLength: 11,
            maxLengthEnforced: true,
            placeholder: "请输入手机号码",
            decoration: BoxDecoration(color: Colors.transparent),
            onEditingComplete: () {
              changeLoginButtonStyle(null);
            },
            onChanged: (value){
              changeLoginButtonStyle(value);
            },
          ),
        )
      ],
    ),
  );
}

Widget codeTextField(var countdownTime, String placeHolder,
    TextEditingController controller, editComplete, startCountdown) {
  return Padding(
    padding: EdgeInsets.only(top: 25),
    child: Row(
      children: <Widget>[
        setTextWidget("验证码", 14, false, b33),
        Expanded(
          child: CupertinoTextField(
            style: TextStyle(color: b33),
            autofocus: false,
            controller: controller,
            cursorColor: b33,
            maxLength: 6,
            maxLengthEnforced: true,
            keyboardType: TextInputType.number,
            placeholder: placeHolder,
            decoration: BoxDecoration(color: Colors.transparent),
            onEditingComplete: () {
              editComplete();
            },
          ),
        ),
        Container(
          // width: ssSetWidth(90),
          height: ssSetWidth(28),
          child: FlatButton(
              color: countdownTime == 0 ? lanse : Color(0xFFCCCCCC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                if (countdownTime == 0) {
                  startCountdown();
                }
              },
              child: setTextWidget(
                  countdownTime == 0 ? "获取验证码" : "重发${countdownTime}s",
                  12,
                  false,
                  Colors.white.withOpacity(0.7))),
        )
      ],
    ),
  );
}
//文本框样式组件
Widget labelCell(String title, String value,{Widget rightView,func,bool hasArrow,Widget otherButton,double height,String leftImage}){
  return Container(
    height: height ?? ssSetWidth(44),
    color: style.backgroundColor,
    padding: EdgeInsets.only(left: 15,right: 15),
    child: func == null ? Row(
        children: <Widget>[
          leftImage != null?Padding(padding: EdgeInsets.only(right:11),child: Image.asset(leftImage,width: ssSetWidth(21),height: ssSetWidth(21),),):SizedBox(),
          setTextWidget(title, 14, false, b33),
          otherButton ?? SizedBox(),
          Expanded(child: SizedBox()),
          Padding(padding: EdgeInsets.only(right:hasArrow !=null ? 15 : 0),child: rightView ?? setTextWidget(value, 14, false, g99),),
          (hasArrow != null && hasArrow == true) ?Container(
            width: ssSetWidth(8.21),
            height: ssSetWidth(14.23),
            child: Image.asset(imgpath+"arrow_right.png"),
          ):SizedBox()
        ],
      ): InkWell(
      onTap: (){
        func() ?? NullThrownError();
      },
      child: Row(
        children: <Widget>[
          leftImage != null?Padding(padding: EdgeInsets.only(right:11),child: Image.asset(leftImage,width: ssSetWidth(21),height: ssSetWidth(21),),):SizedBox(),
          setTextWidget(title, 14, false, b33),
          otherButton ?? SizedBox(),
          Expanded(child: SizedBox()),
          Padding(padding: EdgeInsets.only(right:hasArrow !=null ? 15 : 0),child: rightView ?? setTextWidget(value, 14, false, g99),),
          hasArrow != null ?Container(
            width: ssSetWidth(8.21),
            height: ssSetWidth(14.23),
            child: Image.asset(imgpath+"arrow_right.png"),
          ):SizedBox()
        ],
      ),
    )
  );
}
//带边框的文本输入框组件
Widget mTextFiled(TextEditingController controller,void Function(String v)editComplete,String hintText,int maxLines,{EdgeInsetsGeometry padding,TextStyle hintStyle}){
  return Padding(
                    padding: padding ?? EdgeInsets.only(left: 15 , top:12,right: 15,bottom: 12),
                    child: TextField(
                      controller: controller,
                      onEditingComplete: (){
                        editComplete(null);
                      },
                      onChanged: (value){
                        editComplete(value);
                      },
                      maxLines: maxLines,
                      style: TextStyle(
                        color:  style.textTitleColor
                      ),
                      decoration: InputDecoration(

                        fillColor: style.clubTextFieldColor,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 7),
                        hintText: hintText,
                        hintStyle: hintStyle ?? TextStyle(color: Color(0xffcccccc),fontSize: ssSp(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(width: 0.5,color: style.textTipColor)
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(width: 0.5,color: style.textTipColor)
                        ),
                      ),
                    ),
                  );
}
//appbar组件
AppBar whiteAppBarWidget(String text,BuildContext context,{bool isMain,bool haveShadowLine, Icon icon,List<Widget> actions,Object result}){
  return AppBar(
              title: setTextWidget(text, 18, true, b33),
              elevation: haveShadowLine != null ? 1 : 0,
              leading: isMain != null ? null:IconButton(
                icon: icon ?? Image.asset(imgpath+"bar_back.png",width: ssSetWidth(11.31),height: ssSetWidth(19.8),),
                color: style.textTitleColor,
                highlightColor: style.backgroundColor,
                focusColor: style.backgroundColor,
                disabledColor: style.backgroundColor,
                hoverColor: style.backgroundColor,
                splashColor: style.backgroundColor,
                onPressed: () {
                  result != null? Navigator.of(context).pop(result):Navigator.pop(context);
                },
              ),
              actions: actions ?? null,
              backgroundColor: style.backgroundColor,
            );
}
//text组件
Text setTextWidget(title,double fontSize, bool isBold,Color color,{TextAlign textAlign,List<Shadow> shadow,int maxLines,}){
    return Text(title,overflow: TextOverflow.ellipsis,maxLines: maxLines ?? 1,style: TextStyle(fontFamily: 'pf',fontSize: ssSp(fontSize),shadows: shadow != null ? shadow: null,fontWeight: isBold == null? FontWeight.normal: isBold == true ? FontWeight.bold : FontWeight.normal, color: color,decoration: TextDecoration.none),textAlign: textAlign== null? TextAlign.left: textAlign,);
}
//灰线组件
Widget greyLineUI(double height,{Color color,EdgeInsetsGeometry padding}){
  return Container(
      margin: padding ?? null,
      color: color ?? style.textDivideLineColor,
      height: height,
  );
}
//image网络加载组件
CachedNetworkImage returnImageWithUrl(String url,{bool hasP,String pleacehold,double imgwidth, double imgheight,BoxFit boxF}){
  return CachedNetworkImage(
    placeholder: (context, url){
      if (hasP != null){
        return Image.asset(pleacehold ?? imgpath+"defaultAvatar.png",width: imgwidth??null,height: imgheight ?? null,);
      }else{
        return Container();
      }
    },
    imageUrl: url == "http://www.bookindle.club:8005/files/view/5efae0fb9669c0244fe6a5ff" ? "null" : url,
    errorWidget: (context, url, error) => Image.asset(pleacehold ?? imgpath+"defaultAvatar.png",width: imgwidth??null,height: imgheight ?? null,),
    width: imgwidth ??null,
    height: imgheight ??null,
    fit: boxF ?? null,
  );
}
//房间列表组件
Widget roomCell(int index, int type) {
  return Container(
      height: ssSetWidth(80),
      width: ssSetWidth(375),
      color: style.backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                circleMemberAvatar(-1),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 11, top: 6, bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        children: <Widget>[
                          setTextWidget("房间名称", 14, true, b33),
                          Container(
                            margin: EdgeInsets.only(left: 9),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff1479ed).withOpacity(0.21)),
                            child: setTextWidget("  德州局  ", 12, false, lanse),
                          ),
                          Expanded(child: SizedBox()),
                          type == 1
                              ? setTextWidget("2020-6-12", 12, false, g99)
                              : setTextWidget(index == 2 ? "正在游戏中" : "等待中", 12,
                                  false, index == 2 ? g99 : lanse)
                        ],
                      )),
                      Expanded(child: setTextWidget("创建者:柯南", 12, false, b33)),
                      Expanded(
                          child: Row(
                        children: <Widget>[
                          Image.asset(
                            imgpath + "room_type.png",
                            width: ssSetWidth(14),
                            height: ssSetWidth(14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: setTextWidget("1/2", 12, false, g99),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 21),
                            child: Image.asset(
                              imgpath + "room_time.png",
                              width: ssSetWidth(14),
                              height: ssSetWidth(14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: setTextWidget("30min/30min", 12, false, g99),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 21),
                            child: Image.asset(
                              imgpath + "tab_mine.png",
                              width: ssSetWidth(14),
                              height: ssSetWidth(14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: setTextWidget("2/6", 12, false, g99),
                          ),
                        ],
                      ))
                    ],
                  ),
                )),
              ],
            ),
          ),
          greyLineUI(1)
        ],
      ));
}
//头像组件
Widget circleMemberAvatar(int index, {double size, String avatarPath,bool noBorder}) {
  return Container(
      height: ssSetWidth(size ?? 47),
      width: ssSetWidth(size ?? 47),
      decoration: BoxDecoration(

        //backgroundBlendMode: BlendMode.colorDodge,
        borderRadius: BorderRadius.circular(ssSetWidth(6)),
        border: Border.all(
            color: noBorder == true? Colors.transparent : Color(index == 1 ? 0xffFF9F36 : 0xffe5e5e5),
            width: index == 1 ? 1 : noBorder == true?0: 0.5),
      ),
      child: ClipRRect(
        child: avatarPath == null
          ? Image.asset(
              imgpath + "defaultAvatar.png",
              width: ssSetWidth(size ?? 47),
              height: ssSetWidth(size ?? 47),
            )
          : returnImageWithUrl(avatarPath,hasP: true,imgheight: ssSetWidth(size ?? 47),imgwidth: ssSetWidth(size ?? 47)),
        borderRadius:BorderRadius.circular(ssSetWidth(6)),
      ));
}
//群成员头像组件
Widget memberListInCell(Map userInfo,{double padAll, bool isAdmin}) {
  return Container(
    width: ssSetWidth(60),
    height: ssSetWidth(60),
    child: Padding(
        padding: EdgeInsets.all(padAll ?? 7),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(6),
              child: userInfo != null
                  ? circleMemberAvatar(userInfo["role"], avatarPath: userInfo["user"]["profilePicture"])
                  : circleMemberAvatar(
                      -1,
                    ),
            ),
            (userInfo["role"] == 2 || isAdmin ==true)
                ? Positioned(
                    right: 3,
                    bottom: 0,
                    child: Container(
                      width: ssSetWidth(12.35),
                      height: ssSetWidth(14.1),
                      child: Image.asset(imgpath + "club_member_admin.png"),
                    ))
                : userInfo["role"]  == 1
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: ssSetWidth(12.35),
                          height: ssSetWidth(15),
                          child: Image.asset(imgpath + "Crown-icon.png"),
                        ))
                    : SizedBox()
          ],
        )),
  );
}

