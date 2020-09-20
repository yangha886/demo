import 'package:flutter/material.dart';
import 'package:star/widgets/some_widgets.dart';

class MineChangeAvatar extends StatefulWidget {
  @override
  _MineChangeAvatarState createState() => _MineChangeAvatarState();
}

class _MineChangeAvatarState extends State<MineChangeAvatar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: whiteAppBarWidget("牌谱", context,haveShadowLine: true),
    );
  }
}