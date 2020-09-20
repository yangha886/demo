import 'package:shared_preferences/shared_preferences.dart';

String imgpath = "assets/images/";
String avatarHost = "http://bookindle.club:8005/files/view/";
var nowClubInfo;
var nowRoomInfo;
// String socketSession;
String returnPokeImg(String id){
  return imgpath+"pokes/poke_$id.png";
}
bool soundOn = true;
double soundVolume = 0.5;
List areanoList=[
    {
            "enKey": "China",
            "cnKey": "中国",
            "shKey": "CN",
            "codeKey": 86
        },
        {
            "enKey": "Cambodia",
            "cnKey": "柬埔寨",
            "shKey": "KH",
            "codeKey": 855
        },
        {
            "enKey": "Cameroon",
            "cnKey": "喀麦隆",
            "shKey": "CM",
            "codeKey": 237
        },
        {
            "enKey": "Canada",
            "cnKey": "加拿大",
            "shKey": "CA",
            "codeKey": 1
        },
        {
            "enKey": "Cape Verde",
            "cnKey": "开普",
            "shKey": "CV",
            "codeKey": 238
        },
        {
            "enKey": "Cayman Islands",
            "cnKey": "开曼群岛",
            "shKey": "KY",
            "codeKey": 1345
        },
        {
            "enKey": "Central African Republic",
            "cnKey": "中非共和国",
            "shKey": "CF",
            "codeKey": 236
        },
        {
            "enKey": "Chad",
            "cnKey": "乍得",
            "shKey": "TD",
            "codeKey": 235
        },
        {
            "enKey": "Chile",
            "cnKey": "智利",
            "shKey": "CL",
            "codeKey": 56
        },
        {
            "enKey": "Colombia",
            "cnKey": "哥伦比亚",
            "shKey": "CO",
            "codeKey": 57
        },
        {
            "enKey": "Comoros",
            "cnKey": "科摩罗",
            "shKey": "KM",
            "codeKey": 269
        },
        {
            "enKey": "Cook Islands",
            "cnKey": "库克群岛",
            "shKey": "CK",
            "codeKey": 682
        },
        {
            "enKey": "Costa Rica",
            "cnKey": "哥斯达黎加",
            "shKey": "CR",
            "codeKey": 506
        },
        {
            "enKey": "Croatia",
            "cnKey": "克罗地亚",
            "shKey": "HR",
            "codeKey": 385
        },
        {
            "enKey": "Cuba",
            "cnKey": "古巴",
            "shKey": "CU",
            "codeKey": 53
        },
        {
            "enKey": "Curacao",
            "cnKey": "库拉索",
            "shKey": "CW",
            "codeKey": 599
        },
        {
            "enKey": "Cyprus",
            "cnKey": "塞浦路斯",
            "shKey": "CY",
            "codeKey": 357
        },
        {
            "enKey": "Czech",
            "cnKey": "捷克",
            "shKey": "CZ",
            "codeKey": 420
        },
    {
            "enKey": "Afghanistan",
            "cnKey": "阿富汗",
            "shKey": "AF",
            "codeKey": 93
        },
        {
            "enKey": "Albania",
            "cnKey": "阿尔巴尼亚",
            "shKey": "AL",
            "codeKey": 355
        },
        {
            "enKey": "Algeria",
            "cnKey": "阿尔及利亚",
            "shKey": "DZ",
            "codeKey": 213
        },
        {
            "enKey": "American Samoa",
            "cnKey": "美属萨摩亚",
            "shKey": "AS",
            "codeKey": 1684
        },
        {
            "enKey": "Andorra",
            "cnKey": "安道尔",
            "shKey": "AD",
            "codeKey": 376
        },
        {
            "enKey": "Angola",
            "cnKey": "安哥拉",
            "shKey": "AO",
            "codeKey": 244
        },
        {
            "enKey": "Anguilla",
            "cnKey": "安圭拉",
            "shKey": "AI",
            "codeKey": 1264
        },
        {
            "enKey": "Antigua and Barbuda",
            "cnKey": "安提瓜和巴布达",
            "shKey": "AG",
            "codeKey": 1268
        },
        {
            "enKey": "Argentina",
            "cnKey": "阿根廷",
            "shKey": "AR",
            "codeKey": 54
        },
        {
            "enKey": "Armenia",
            "cnKey": "亚美尼亚",
            "shKey": "AM",
            "codeKey": 374
        },
        {
            "enKey": "Aruba",
            "cnKey": "阿鲁巴",
            "shKey": "AW",
            "codeKey": 297
        },
        {
            "enKey": "Australia",
            "cnKey": "澳大利亚",
            "shKey": "AU",
            "codeKey": 61
        },
        {
            "enKey": "Austria",
            "cnKey": "奥地利",
            "shKey": "AT",
            "codeKey": 43
        },
        {
            "enKey": "Azerbaijan",
            "cnKey": "阿塞拜疆",
            "shKey": "AZ",
            "codeKey": 994
        },
    {
            "enKey": "Bahamas",
            "cnKey": "巴哈马",
            "shKey": "BS",
            "codeKey": 1242
        },
        {
            "enKey": "Bahrain",
            "cnKey": "巴林",
            "shKey": "BH",
            "codeKey": 973
        },
        {
            "enKey": "Bangladesh",
            "cnKey": "孟加拉国",
            "shKey": "BD",
            "codeKey": 880
        },
        {
            "enKey": "Barbados",
            "cnKey": "巴巴多斯",
            "shKey": "BB",
            "codeKey": 1246
        },
        {
            "enKey": "Belarus",
            "cnKey": "白俄罗斯",
            "shKey": "BY",
            "codeKey": 375
        },
        {
            "enKey": "Belgium",
            "cnKey": "比利时",
            "shKey": "BE",
            "codeKey": 32
        },
        {
            "enKey": "Belize",
            "cnKey": "伯利兹",
            "shKey": "BZ",
            "codeKey": 501
        },
        {
            "enKey": "Benin",
            "cnKey": "贝宁",
            "shKey": "BJ",
            "codeKey": 229
        },
        {
            "enKey": "Bermuda",
            "cnKey": "百慕大群岛",
            "shKey": "BM",
            "codeKey": 1441
        },
        {
            "enKey": "Bhutan",
            "cnKey": "不丹",
            "shKey": "BT",
            "codeKey": 975
        },
        {
            "enKey": "Bolivia",
            "cnKey": "玻利维亚",
            "shKey": "BO",
            "codeKey": 591
        },
        {
            "enKey": "Bosnia and Herzegovina",
            "cnKey": "波斯尼亚和黑塞哥维那",
            "shKey": "BA",
            "codeKey": 387
        },
        {
            "enKey": "Botswana",
            "cnKey": "博茨瓦纳",
            "shKey": "BW",
            "codeKey": 267
        },
        {
            "enKey": "Brazil",
            "cnKey": "巴西",
            "shKey": "BR",
            "codeKey": 55
        },
        {
            "enKey": "Brunei",
            "cnKey": "文莱",
            "shKey": "BN",
            "codeKey": 673
        },
        {
            "enKey": "Bulgaria",
            "cnKey": "保加利亚",
            "shKey": "BG",
            "codeKey": 359
        },
        {
            "enKey": "Burkina Faso",
            "cnKey": "布基纳法索",
            "shKey": "BF",
            "codeKey": 226
        },
        {
            "enKey": "Burundi",
            "cnKey": "布隆迪",
            "shKey": "BI",
            "codeKey": 257
        },
    {
            "enKey": "Democratic Republic of the Congo",
            "cnKey": "刚果民主共和国",
            "shKey": "CD",
            "codeKey": 243
        },
        {
            "enKey": "Denmark",
            "cnKey": "丹麦",
            "shKey": "DK",
            "codeKey": 45
        },
        {
            "enKey": "Djibouti",
            "cnKey": "吉布提",
            "shKey": "DJ",
            "codeKey": 253
        },
        {
            "enKey": "Dominica",
            "cnKey": "多米尼加",
            "shKey": "DM",
            "codeKey": 1767
        },
        {
            "enKey": "Dominican Republic",
            "cnKey": "多米尼加共和国",
            "shKey": "DO",
            "codeKey": 1809
        },
    {
            "enKey": "Ecuador",
            "cnKey": "厄瓜多尔",
            "shKey": "EC",
            "codeKey": 593
        },
        {
            "enKey": "Egypt",
            "cnKey": "埃及",
            "shKey": "EG",
            "codeKey": 20
        },
        {
            "enKey": "El Salvador",
            "cnKey": "萨尔瓦多",
            "shKey": "SV",
            "codeKey": 503
        },
        {
            "enKey": "Equatorial Guinea",
            "cnKey": "赤道几内亚",
            "shKey": "GQ",
            "codeKey": 240
        },
        {
            "enKey": "Eritrea",
            "cnKey": "厄立特里亚",
            "shKey": "ER",
            "codeKey": 291
        },
        {
            "enKey": "Estonia",
            "cnKey": "爱沙尼亚",
            "shKey": "EE",
            "codeKey": 372
        },
        {
            "enKey": "Ethiopia",
            "cnKey": "埃塞俄比亚",
            "shKey": "ET",
            "codeKey": 251
        },
    {
            "enKey": "Faroe Islands",
            "cnKey": "法罗群岛",
            "shKey": "FO",
            "codeKey": 298
        },
        {
            "enKey": "Fiji",
            "cnKey": "斐济",
            "shKey": "FJ",
            "codeKey": 679
        },
        {
            "enKey": "Finland",
            "cnKey": "芬兰",
            "shKey": "FI",
            "codeKey": 358
        },
        {
            "enKey": "France",
            "cnKey": "法国",
            "shKey": "FR",
            "codeKey": 33
        },
        {
            "enKey": "French Guiana",
            "cnKey": "法属圭亚那",
            "shKey": "GF",
            "codeKey": 594
        },
        {
            "enKey": "French Polynesia",
            "cnKey": "法属波利尼西亚",
            "shKey": "PF",
            "codeKey": 689
        },
    {
            "enKey": "Gabon",
            "cnKey": "加蓬",
            "shKey": "GA",
            "codeKey": 241
        },
        {
            "enKey": "Gambia",
            "cnKey": "冈比亚",
            "shKey": "GM",
            "codeKey": 220
        },
        {
            "enKey": "Georgia",
            "cnKey": "格鲁吉亚",
            "shKey": "GE",
            "codeKey": 995
        },
        {
            "enKey": "Germany",
            "cnKey": "德国",
            "shKey": "DE",
            "codeKey": 49
        },
        {
            "enKey": "Ghana",
            "cnKey": "加纳",
            "shKey": "GH",
            "codeKey": 233
        },
        {
            "enKey": "Gibraltar",
            "cnKey": "直布罗陀",
            "shKey": "GI",
            "codeKey": 350
        },
        {
            "enKey": "Greece",
            "cnKey": "希腊",
            "shKey": "GR",
            "codeKey": 30
        },
        {
            "enKey": "Greenland",
            "cnKey": "格陵兰岛",
            "shKey": "GL",
            "codeKey": 299
        },
        {
            "enKey": "Grenada",
            "cnKey": "格林纳达",
            "shKey": "GD",
            "codeKey": 1473
        },
        {
            "enKey": "Guadeloupe",
            "cnKey": "瓜德罗普岛",
            "shKey": "GP",
            "codeKey": 590
        },
        {
            "enKey": "Guam",
            "cnKey": "关岛",
            "shKey": "GU",
            "codeKey": 1671
        },
        {
            "enKey": "Guatemala",
            "cnKey": "瓜地马拉",
            "shKey": "GT",
            "codeKey": 502
        },
        {
            "enKey": "Guinea",
            "cnKey": "几内亚",
            "shKey": "GN",
            "codeKey": 224
        },
        {
            "enKey": "Guinea-Bissau",
            "cnKey": "几内亚比绍共和国",
            "shKey": "GW",
            "codeKey": 245
        },
        {
            "enKey": "Guyana",
            "cnKey": "圭亚那",
            "shKey": "GY",
            "codeKey": 592
        },
   {
            "enKey": "Haiti",
            "cnKey": "海地",
            "shKey": "HT",
            "codeKey": 509
        },
        {
            "enKey": "Honduras",
            "cnKey": "洪都拉斯",
            "shKey": "HN",
            "codeKey": 504
        },
        {
            "enKey": "Hong Kong",
            "cnKey": "中国香港",
            "shKey": "HK",
            "codeKey": 852
        },
        {
            "enKey": "Hungary",
            "cnKey": "匈牙利",
            "shKey": "HU",
            "codeKey": 36
        },
    {
            "enKey": "Iceland",
            "cnKey": "冰岛",
            "shKey": "IS",
            "codeKey": 354
        },
        {
            "enKey": "India",
            "cnKey": "印度",
            "shKey": "IN",
            "codeKey": 91
        },
        {
            "enKey": "Indonesia",
            "cnKey": "印度尼西亚",
            "shKey": "ID",
            "codeKey": 62
        },
        {
            "enKey": "Iran",
            "cnKey": "伊朗",
            "shKey": "IR",
            "codeKey": 98
        },
        {
            "enKey": "Iraq",
            "cnKey": "伊拉克",
            "shKey": "IQ",
            "codeKey": 964
        },
        {
            "enKey": "Ireland",
            "cnKey": "爱尔兰",
            "shKey": "IE",
            "codeKey": 353
        },
        {
            "enKey": "Israel",
            "cnKey": "以色列",
            "shKey": "IL",
            "codeKey": 972
        },
        {
            "enKey": "Italy",
            "cnKey": "意大利",
            "shKey": "IT",
            "codeKey": 39
        },
        {
            "enKey": "Ivory Coast",
            "cnKey": "象牙海岸",
            "shKey": "CI",
            "codeKey": 225
        },
    {
            "enKey": "Jamaica",
            "cnKey": "牙买加",
            "shKey": "JM",
            "codeKey": 1876
        },
        {
            "enKey": "Japan",
            "cnKey": "日本",
            "shKey": "JP",
            "codeKey": 81
        },
        {
            "enKey": "Jordan",
            "cnKey": "约旦",
            "shKey": "JO",
            "codeKey": 962
        },
    {
            "enKey": "Kazakhstan",
            "cnKey": "哈萨克斯坦",
            "shKey": "KZ",
            "codeKey": 7
        },
        {
            "enKey": "Kenya",
            "cnKey": "肯尼亚",
            "shKey": "KE",
            "codeKey": 254
        },
        {
            "enKey": "Kiribati",
            "cnKey": "基里巴斯",
            "shKey": "KI",
            "codeKey": 686
        },
        {
            "enKey": "Kuwait",
            "cnKey": "科威特",
            "shKey": "KW",
            "codeKey": 965
        },
        {
            "enKey": "Kyrgyzstan",
            "cnKey": "吉尔吉斯斯坦",
            "shKey": "KG",
            "codeKey": 996
        },
    {
            "enKey": "Laos",
            "cnKey": "老挝",
            "shKey": "LA",
            "codeKey": 856
        },
        {
            "enKey": "Latvia",
            "cnKey": "拉脱维亚",
            "shKey": "LV",
            "codeKey": 371
        },
        {
            "enKey": "Lebanon",
            "cnKey": "黎巴嫩",
            "shKey": "LB",
            "codeKey": 961
        },
        {
            "enKey": "Lesotho",
            "cnKey": "莱索托",
            "shKey": "LS",
            "codeKey": 266
        },
        {
            "enKey": "Liberia",
            "cnKey": "利比里亚",
            "shKey": "LR",
            "codeKey": 231
        },
        {
            "enKey": "Libya",
            "cnKey": "利比亚",
            "shKey": "LY",
            "codeKey": 218
        },
        {
            "enKey": "Liechtenstein",
            "cnKey": "列支敦士登",
            "shKey": "LI",
            "codeKey": 423
        },
        {
            "enKey": "Lithuania",
            "cnKey": "立陶宛",
            "shKey": "LT",
            "codeKey": 370
        },
        {
            "enKey": "Luxembourg",
            "cnKey": "卢森堡",
            "shKey": "LU",
            "codeKey": 352
        },
    {
            "enKey": "Macau",
            "cnKey": "中国澳门",
            "shKey": "MO",
            "codeKey": 853
        },
        {
            "enKey": "Macedonia",
            "cnKey": "马其顿",
            "shKey": "MK",
            "codeKey": 389
        },
        {
            "enKey": "Madagascar",
            "cnKey": "马达加斯加",
            "shKey": "MG",
            "codeKey": 261
        },
        {
            "enKey": "Malawi",
            "cnKey": "马拉维",
            "shKey": "MW",
            "codeKey": 265
        },
        {
            "enKey": "Malaysia",
            "cnKey": "马来西亚",
            "shKey": "MY",
            "codeKey": 60
        },
        {
            "enKey": "Maldives",
            "cnKey": "马尔代夫",
            "shKey": "MV",
            "codeKey": 960
        },
        {
            "enKey": "Mali",
            "cnKey": "马里",
            "shKey": "ML",
            "codeKey": 223
        },
        {
            "enKey": "Malta",
            "cnKey": "马耳他",
            "shKey": "MT",
            "codeKey": 356
        },
        {
            "enKey": "Martinique",
            "cnKey": "马提尼克",
            "shKey": "MQ",
            "codeKey": 596
        },
        {
            "enKey": "Mauritania",
            "cnKey": "毛里塔尼亚",
            "shKey": "MR",
            "codeKey": 222
        },
        {
            "enKey": "Mauritius",
            "cnKey": "毛里求斯",
            "shKey": "MU",
            "codeKey": 230
        },
        {
            "enKey": "Mayotte",
            "cnKey": "马约特",
            "shKey": "YT",
            "codeKey": 269
        },
        {
            "enKey": "Mexico",
            "cnKey": "墨西哥",
            "shKey": "MX",
            "codeKey": 52
        },
        {
            "enKey": "Moldova",
            "cnKey": "摩尔多瓦",
            "shKey": "MD",
            "codeKey": 373
        },
        {
            "enKey": "Monaco",
            "cnKey": "摩纳哥",
            "shKey": "MC",
            "codeKey": 377
        },
        {
            "enKey": "Mongolia",
            "cnKey": "蒙古",
            "shKey": "MN",
            "codeKey": 976
        },
        {
            "enKey": "Montenegro",
            "cnKey": "黑山",
            "shKey": "ME",
            "codeKey": 382
        },
        {
            "enKey": "Montserrat",
            "cnKey": "蒙特塞拉特岛",
            "shKey": "MS",
            "codeKey": 1664
        },
        {
            "enKey": "Morocco",
            "cnKey": "摩洛哥",
            "shKey": "MA",
            "codeKey": 212
        },
        {
            "enKey": "Mozambique",
            "cnKey": "莫桑比克",
            "shKey": "MZ",
            "codeKey": 258
        },
        {
            "enKey": "Myanmar",
            "cnKey": "缅甸",
            "shKey": "MM",
            "codeKey": 95
        },
    {
            "enKey": "Namibia",
            "cnKey": "纳米比亚",
            "shKey": "NA",
            "codeKey": 264
        },
        {
            "enKey": "Nepal",
            "cnKey": "尼泊尔",
            "shKey": "NP",
            "codeKey": 977
        },
        {
            "enKey": "Netherlands",
            "cnKey": "荷兰",
            "shKey": "NL",
            "codeKey": 31
        },
        {
            "enKey": "New Caledonia",
            "cnKey": "新喀里多尼亚",
            "shKey": "NC",
            "codeKey": 687
        },
        {
            "enKey": "New Zealand",
            "cnKey": "新西兰",
            "shKey": "NZ",
            "codeKey": 64
        },
        {
            "enKey": "Nicaragua",
            "cnKey": "尼加拉瓜",
            "shKey": "NI",
            "codeKey": 505
        },
        {
            "enKey": "Niger",
            "cnKey": "尼日尔",
            "shKey": "NE",
            "codeKey": 227
        },
        {
            "enKey": "Nigeria",
            "cnKey": "尼日利亚",
            "shKey": "NG",
            "codeKey": 234
        },
        {
            "enKey": "Norway",
            "cnKey": "挪威",
            "shKey": "NO",
            "codeKey": 47
        },
    {
            "enKey": "Oman",
            "cnKey": "阿曼",
            "shKey": "OM",
            "codeKey": 968
        },
    {
            "enKey": "Pakistan",
            "cnKey": "巴基斯坦",
            "shKey": "PK",
            "codeKey": 92
        },
        {
            "enKey": "Palau",
            "cnKey": "帕劳",
            "shKey": "PW",
            "codeKey": 680
        },
        {
            "enKey": "Palestine",
            "cnKey": "巴勒斯坦",
            "shKey": "BL",
            "codeKey": 970
        },
        {
            "enKey": "Panama",
            "cnKey": "巴拿马",
            "shKey": "PA",
            "codeKey": 507
        },
        {
            "enKey": "Papua New Guinea",
            "cnKey": "巴布亚新几内亚",
            "shKey": "PG",
            "codeKey": 675
        },
        {
            "enKey": "Paraguay",
            "cnKey": "巴拉圭",
            "shKey": "PY",
            "codeKey": 595
        },
        {
            "enKey": "Peru",
            "cnKey": "秘鲁",
            "shKey": "PE",
            "codeKey": 51
        },
        {
            "enKey": "Philippines",
            "cnKey": "菲律宾",
            "shKey": "PH",
            "codeKey": 63
        },
        {
            "enKey": "Poland",
            "cnKey": "波兰",
            "shKey": "PL",
            "codeKey": 48
        },
        {
            "enKey": "Portugal",
            "cnKey": "葡萄牙",
            "shKey": "PT",
            "codeKey": 351
        },
        {
            "enKey": "Puerto Rico",
            "cnKey": "波多黎各",
            "shKey": "PR",
            "codeKey": 1787
        },
    {
            "enKey": "Qatar",
            "cnKey": "卡塔尔",
            "shKey": "QA",
            "codeKey": 974
        },
    {
            "enKey": "Republic Of The Congo",
            "cnKey": "刚果共和国",
            "shKey": "CG",
            "codeKey": 242
        },
        {
            "enKey": "Réunion Island",
            "cnKey": "留尼汪",
            "shKey": "RE",
            "codeKey": 262
        },
        {
            "enKey": "Romania",
            "cnKey": "罗马尼亚",
            "shKey": "RO",
            "codeKey": 40
        },
        {
            "enKey": "Russia",
            "cnKey": "俄罗斯",
            "shKey": "RU",
            "codeKey": 7
        },
        {
            "enKey": "Rwanda",
            "cnKey": "卢旺达",
            "shKey": "RW",
            "codeKey": 250
        },
    {
            "enKey": "Saint Kitts and Nevis",
            "cnKey": "圣基茨和尼维斯",
            "shKey": "KN",
            "codeKey": 1869
        },
        {
            "enKey": "Saint Lucia",
            "cnKey": "圣露西亚",
            "shKey": "LC",
            "codeKey": 1758
        },
        {
            "enKey": "Saint Pierre and Miquelon",
            "cnKey": "圣彼埃尔和密克隆岛",
            "shKey": "PM",
            "codeKey": 508
        },
        {
            "enKey": "Saint Vincent and The Grenadines",
            "cnKey": "圣文森特和格林纳丁斯",
            "shKey": "VC",
            "codeKey": 1784
        },
        {
            "enKey": "Samoa",
            "cnKey": "萨摩亚",
            "shKey": "WS",
            "codeKey": 685
        },
        {
            "enKey": "San Marino",
            "cnKey": "圣马力诺",
            "shKey": "SM",
            "codeKey": 378
        },
        {
            "enKey": "Sao Tome and Principe",
            "cnKey": "圣多美和普林西比",
            "shKey": "ST",
            "codeKey": 239
        },
        {
            "enKey": "Saudi Arabia",
            "cnKey": "沙特阿拉伯",
            "shKey": "SA",
            "codeKey": 966
        },
        {
            "enKey": "Senegal",
            "cnKey": "塞内加尔",
            "shKey": "SN",
            "codeKey": 221
        },
        {
            "enKey": "Serbia",
            "cnKey": "塞尔维亚",
            "shKey": "RS",
            "codeKey": 381
        },
        {
            "enKey": "Seychelles",
            "cnKey": "塞舌尔",
            "shKey": "SC",
            "codeKey": 248
        },
        {
            "enKey": "Sierra Leone",
            "cnKey": "塞拉利昂",
            "shKey": "SL",
            "codeKey": 232
        },
        {
            "enKey": "Singapore",
            "cnKey": "新加坡",
            "shKey": "SG",
            "codeKey": 65
        },
        {
            "enKey": "Saint Maarten (Dutch Part)",
            "cnKey": "圣马丁岛（荷兰部分）",
            "shKey": "SX",
            "codeKey": 1721
        },
        {
            "enKey": "Slovakia",
            "cnKey": "斯洛伐克",
            "shKey": "SK",
            "codeKey": 421
        },
        {
            "enKey": "Slovenia",
            "cnKey": "斯洛文尼亚",
            "shKey": "SI",
            "codeKey": 386
        },
        {
            "enKey": "Solomon Islands",
            "cnKey": "所罗门群岛",
            "shKey": "SB",
            "codeKey": 677
        },
        {
            "enKey": "Somalia",
            "cnKey": "索马里",
            "shKey": "SO",
            "codeKey": 252
        },
        {
            "enKey": "South Africa",
            "cnKey": "南非",
            "shKey": "ZA",
            "codeKey": 27
        },
        {
            "enKey": "South Korea",
            "cnKey": "韩国",
            "shKey": "KR",
            "codeKey": 82
        },
        {
            "enKey": "Spain",
            "cnKey": "西班牙",
            "shKey": "ES",
            "codeKey": 34
        },
        {
            "enKey": "Sri Lanka",
            "cnKey": "斯里兰卡",
            "shKey": "LK",
            "codeKey": 94
        },
        {
            "enKey": "Sudan",
            "cnKey": "苏丹",
            "shKey": "SD",
            "codeKey": 249
        },
        {
            "enKey": "Suriname",
            "cnKey": "苏里南",
            "shKey": "SR",
            "codeKey": 597
        },
        {
            "enKey": "Swaziland",
            "cnKey": "斯威士兰",
            "shKey": "SZ",
            "codeKey": 268
        },
        {
            "enKey": "Sweden",
            "cnKey": "瑞典",
            "shKey": "SE",
            "codeKey": 46
        },
        {
            "enKey": "Switzerland",
            "cnKey": "瑞士",
            "shKey": "CH",
            "codeKey": 41
        },
        {
            "enKey": "Syria",
            "cnKey": "叙利亚",
            "shKey": "SY",
            "codeKey": 963
        },
    {
            "enKey": "Taiwan",
            "cnKey": "中国台湾",
            "shKey": "TW",
            "codeKey": 886
        },
        {
            "enKey": "Tajikistan",
            "cnKey": "塔吉克斯坦",
            "shKey": "TJ",
            "codeKey": 992
        },
        {
            "enKey": "Tanzania",
            "cnKey": "坦桑尼亚",
            "shKey": "TZ",
            "codeKey": 255
        },
        {
            "enKey": "Thailand",
            "cnKey": "泰国",
            "shKey": "TH",
            "codeKey": 66
        },
        {
            "enKey": "Timor-Leste",
            "cnKey": "东帝汶",
            "shKey": "TL",
            "codeKey": 670
        },
        {
            "enKey": "Togo",
            "cnKey": "多哥",
            "shKey": "TG",
            "codeKey": 228
        },
        {
            "enKey": "Tonga",
            "cnKey": "汤加",
            "shKey": "TO",
            "codeKey": 676
        },
        {
            "enKey": "Trinidad and Tobago",
            "cnKey": "特立尼达和多巴哥",
            "shKey": "TT",
            "codeKey": 1868
        },
        {
            "enKey": "Tunisia",
            "cnKey": "突尼斯",
            "shKey": "TN",
            "codeKey": 216
        },
        {
            "enKey": "Turkey",
            "cnKey": "土耳其",
            "shKey": "TR",
            "codeKey": 90
        },
        {
            "enKey": "Turkmenistan",
            "cnKey": "土库曼斯坦",
            "shKey": "TM",
            "codeKey": 993
        },
        {
            "enKey": "Turks and Caicos Islands",
            "cnKey": "特克斯和凯科斯群岛",
            "shKey": "TC",
            "codeKey": 1649
        },
    {
            "enKey": "Uganda",
            "cnKey": "乌干达",
            "shKey": "UG",
            "codeKey": 256
        },
        {
            "enKey": "Ukraine",
            "cnKey": "乌克兰",
            "shKey": "UA",
            "codeKey": 380
        },
        {
            "enKey": "United Arab Emirates",
            "cnKey": "阿拉伯联合酋长国",
            "shKey": "AE",
            "codeKey": 971
        },
        {
            "enKey": "United Kingdom",
            "cnKey": "英国",
            "shKey": "GB",
            "codeKey": 44
        },
        {
            "enKey": "United States",
            "cnKey": "美国",
            "shKey": "US",
            "codeKey": 1
        },
        {
            "enKey": "Uruguay",
            "cnKey": "乌拉圭",
            "shKey": "UY",
            "codeKey": 598
        },
        {
            "enKey": "Uzbekistan",
            "cnKey": "乌兹别克斯坦",
            "shKey": "UZ",
            "codeKey": 998
        },
    {
            "enKey": "Vanuatu",
            "cnKey": "瓦努阿图",
            "shKey": "VU",
            "codeKey": 678
        },
        {
            "enKey": "Venezuela",
            "cnKey": "委内瑞拉",
            "shKey": "VE",
            "codeKey": 58
        },
        {
            "enKey": "Vietnam",
            "cnKey": "越南",
            "shKey": "VN",
            "codeKey": 84
        },
        {
            "enKey": "Virgin Islands, British",
            "cnKey": "英属处女群岛",
            "shKey": "VG",
            "codeKey": 1340
        },
        {
            "enKey": "Virgin Islands, US",
            "cnKey": "美属维尔京群岛",
            "shKey": "VI",
            "codeKey": 1284
        },
    {
            "enKey": "Yemen",
            "cnKey": "也门",
            "shKey": "YE",
            "codeKey": 967
        },
    {
            "enKey": "Zambia",
            "cnKey": "赞比亚",
            "shKey": "ZM",
            "codeKey": 260
        },
        {
            "enKey": "Zimbabwe",
            "cnKey": "津巴布韦",
            "shKey": "ZW",
            "codeKey": 263
        }];