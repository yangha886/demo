import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star/util/colorutil.dart';
import 'package:star/util/stringutil.dart';
import 'package:star/util/viewconfig.dart';
import 'package:star/widgets/some_widgets.dart';

class CountrySelectView extends StatefulWidget {
  void Function(String data) ontapArea;
  CountrySelectView(this.ontapArea);
  @override
  _CountrySelectViewState createState() => _CountrySelectViewState();
}

class _CountrySelectViewState extends State<CountrySelectView> {
  List copyAreanList = areanoList.toList();
  TextEditingController _controller= TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
            backgroundColor: Colors.transparent,
              child: Material(
                color: Colors.transparent,
                  child: Container(
                    height: ssSetWidth(359),
                    width: ssSetWidth(280),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left:15,right:5),
                          height: ssSetWidth(44),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                imgpath+"Searchbar_icon_search.png",
                                width: ssSetWidth(16),
                                height: ssSetWidth(16),
                              ),
                              Expanded(
                                child: CupertinoTextField(
                                  style: TextStyle(color: b33),
                                  autofocus: false,
                                  obscureText: true,
                                  controller: _controller,
                                  cursorColor: b33,
                                  keyboardType: TextInputType.text,
                                  placeholder: "国家/地区",
                                  decoration: BoxDecoration(color: Colors.transparent),
                                  onEditingComplete: () {
                                    print("object");
                                    if (_controller.text.length ==0) {
                                      copyAreanList = areanoList.toList();
                                    }else{
                                      copyAreanList.clear();
                                      for (var item in areanoList) {
                                        if (item["cnKey"].toString().contains(_controller.text) || item["enKey"].toString().contains(_controller.text)) {
                                          copyAreanList.add(item);
                                        }
                                      }
                                    }
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right:0),child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                                Navigator.pop(context);
                              }),)
                            ],
                          ),
                        ),
                        greyLineUI(1),
                        Expanded(child: Container(
                          padding: EdgeInsets.only(left:15,right:15),
                          child:ListView.builder(
                            itemCount: areanoList.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      widget.ontapArea("${areanoList[index]["shKey"].toString()}+${areanoList[index]["codeKey"].toString()}");
                                      // setState(() {
                                      //   countryCode = "${areanoList[index]["shKey"].toString()}+${areanoList[index]["codeKey"].toString()}";
                                      //   Navigator.pop(context);
                                      // });
                                    },
                                    child: Container(
                                      height: ssSetWidth(44),
                                      child: Row(
                                        children: <Widget>[
                                          Container(child: setTextWidget("+${areanoList[index]["codeKey"].toString()}", 13, true, b33)),
                                          Expanded(child: Padding(padding: EdgeInsets.only(left:10),child:setTextWidget("${areanoList[index]["cnKey"].toString()}", 13, false, b33))),
                                        ],
                                      ),
                                    )
                                  ),
                                  greyLineUI(0.5)
                                ],
                              );
                            }
                          ),)
                        )
                      ],
                    ),
                  )
                ),
            );
  }
}
