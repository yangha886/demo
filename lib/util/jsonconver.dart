import 'dart:convert';

class JsonConver{
  //对象=>json
  String cvjsonToString(infoData){
    String jsonString = json.encode(infoData);
    var jsons = jsonEncode(Utf8Encoder().convert(jsonString));
    return jsons;
  }
  

  //json=>对象
  dynamic cvStringToDynamic(str){
    if (str == "0") {
      return List();
    }
    var list = List<int>();
    ///字符串解码
    jsonDecode(str).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    dynamic map = json.decode(value);
    return map;
  }
}