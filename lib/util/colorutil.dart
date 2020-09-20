import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:star/util/theme_config.dart';

ThemeConfig style;
var b33 = style.textContextColor;
var g99 = style.textTitleColor;
//var bgcolor = style == themeColorStyle.whiteBlue ? baise : style == themeColorStyle.blackWhite ? Colors.black: Colors.red;
var lanse = Color(0xff1479ED);
class ColorsUtil {
   /// 十六进制颜色，
   /// hex, 十六进制值，例如：0xffffff,
   /// alpha, 透明度 [0.0,1.0]
   static Color hexColor(int hex,{double alpha = 1}){
    if (alpha < 0){
      alpha = 0;
    }else if (alpha > 1){
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16 ,
         (hex & 0x00FF00) >> 8,
         (hex & 0x0000FF) >> 0,
         alpha);
   }
}

