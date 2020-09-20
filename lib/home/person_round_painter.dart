import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'game_sound.dart';
bool onceplay = false;
class PersonRoundPatinter extends CustomPainter {
  Paint _paint = Paint()
    ..color = Color(0xff0fb216)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 3;
  ui.Image imgLight;
  /// 加载图片
  
  Color color;
  double progress;
  double halfW = 0.25/2;
  PersonRoundPatinter(this.progress,this.imgLight);
  @override
  void paint(Canvas canvas, Size size) {
    // _paint.color = color;
    if(this.progress > 0.7){
      _paint.color = Color(0xffFF3A0D);
    }
    if(this.progress >= 0.7 && onceplay == false){
      onceplay = true;
      GameSound.getInstance().playAudio2("shijiantishiyin");
    }else if (this.progress<0.7){
      onceplay = false;
    }
    if (this.progress <= halfW){      
      canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(size.width / 2.0+ (size.width - 1)* (this.progress / 0.25), 0.0),
          Offset(size.width - 1.0 , 0.0),
          Offset(size.width , 1.0),
        ],
        _paint);
      
    }

    if (this.progress <= 0.25+halfW){
      canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(size.width, 1.0+(this.progress >halfW ? (size.height - 2)* ((this.progress - halfW) / 0.25) : 0)),
          Offset(size.width, (size.height - 1)),
          Offset(size.width-1, (size.height - 1)),
        ],
        _paint);
      }
    if (this.progress <= 0.5+halfW){
      canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(size.width-1-(this.progress >halfW+0.25 ? (size.width - 1)* ((this.progress - halfW-0.25) / 0.25) : 0), size.height),
          Offset(1.0, size.height),
          Offset(1.0, size.height-1),
        ],
        _paint);
      }
    if (this.progress <= 0.75+halfW){
      canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(0.0, size.height - 2-(this.progress >halfW+0.5 ? (size.height - 1)* ((this.progress - halfW-0.5) / 0.25) : 0)),
          Offset(0.0, 1.0),
          Offset(1.0, 0.0),
        ],
        _paint);
      }
    if (this.progress < 1){
      canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(1.0+(this.progress >halfW+0.75 ? (size.width - 1)* ((this.progress - halfW-0.75) / 0.25) : 0), 0.0),
          Offset(size.width / 2, 0.0)
        ],
        _paint);
      }
    Offset _offset;
    Rect _center;
    if (this.progress > 0){
      if(this.progress <halfW)
      _offset = Offset(size.width / 2.0+ (size.width - 1)* (this.progress / 0.25), 0);
      else if(this.progress >=halfW && this.progress <= halfW+0.25)
      _offset = Offset(size.width, 1.0+(this.progress >=halfW ? (size.height - 1)* ((this.progress - halfW) / 0.25) : 0));
      // canvas.drawRect(Rect.fromCenter(center: ,width: 5,height: 5), Paint()..strokeWidth= 5..color= Colors.white);
    
      else if(this.progress >=halfW+0.25 && this.progress <= halfW+0.5)
      _offset = Offset(size.width-1-(this.progress >=halfW+0.25 ? (size.width - 1)* ((this.progress - halfW-0.25) / 0.25) : 0), size.height);
      // canvas.drawRect(Rect.fromCenter(center: Offset(size.width-1-(this.progress >halfW+0.25 ? (size.width - 1)* ((this.progress - halfW-0.25) / 0.25) : 0), size.height),width: 5,height: 5), Paint()..strokeWidth= 5..color= Colors.white);
    
      else if(this.progress >=halfW+0.5 && this.progress <= halfW+0.75)
      _offset = Offset(0.0, size.height - 1-(this.progress >=halfW+0.5 ? (size.height - 1)* ((this.progress - halfW-0.5) / 0.25) : 0));
      // canvas.drawRect(Rect.fromCenter(center: Offset(0.0, size.height - 1-(this.progress >halfW+0.5 ? (size.height - 1)* ((this.progress - halfW-0.5) / 0.25) : 0)),width: 5,height: 5), Paint()..strokeWidth= 5..color= Colors.white);
    
      else if(this.progress >=halfW+0.75 && this.progress <= 1)
        _offset = Offset(1.0+(this.progress >=halfW+0.75 ? (size.width - 1)* ((this.progress - halfW-0.75) / 0.25) : 0), 0.0);

      // _center = Rect.fromCenter(center:_offset);
      // canvas.drawRect(Rect.fromCenter(center: Offset(1.0+(this.progress >halfW+0.75 ? (size.height - 1)* ((this.progress - halfW-0.75) / 0.25) : 0), 0.0),width: 5,height: 5), Paint()..strokeWidth= 5..color= Colors.white);
      // canvas.drawImageNine(this.imgLight, _center,Rect.fromLTRB(3, 3, 3, 3), Paint()..strokeWidth= 5..color= Colors.white);
      _offset = Offset(_offset.dx -5, _offset.dy - 5);
      canvas.drawImage(this.imgLight, _offset, Paint()..strokeWidth= 1..color= Colors.white);
    }
    
  }

  @override
  bool shouldRepaint(PersonRoundPatinter oldDelegate) {
    return this != oldDelegate;
  }
}
