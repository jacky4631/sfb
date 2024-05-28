/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
//后面再去研究自动生成对象 目前看起来版本不兼容
//https://pub.flutter-io.cn/documentation/build_runner/2.1.9/
class Userinfo {
  int uid = 1;
  String phone = '';
  String nickname = '';
  String realName = '';
  String avatar = '';
  int level = 0;
  int levelJd = 0;
  int levelPdd = 0;
  int levelDy = 0;
  int levelVip = 0;
  double totalCash = 0;
  String code = '';
  int spreadCount = 0;
  String aliProfile = '';
  num spreadUid = 0;
  double nowMoney = 0;
  double unlockMoney = 0;
  Userinfo();

  showName() {
    if (nickname == '') {
      return phone;
    }
    return nickname;
  }

  Userinfo.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        phone = json['phone']??'',
        nickname = json['nickname'],
        realName = json['realName'],
        avatar = json['avatar'],
        level = json['level']??3,
        levelJd = json['levelJd']??3,
        levelPdd = json['levelPdd']??3,
        levelDy = json['levelDy']??3,
        levelVip = json['levelVip']??3,
        totalCash = json['totalCash']??0,
        code = json['code'],
        aliProfile = json['aliProfile']??'',
        spreadCount = json['spreadCount'],
        spreadUid = json['spreadUid'],
        nowMoney = json['nowMoney'],
        unlockMoney = json['unlockMoney'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'phone': phone,
    'nickname': nickname,
    'realName': realName,
    'avatar': avatar,
    'level': level,
    'levelJd': levelJd,
    'levelPdd': levelPdd,
    'levelDy': levelDy,
    'levelVip': levelVip,
    'totalCash': totalCash,
    'code': code,
    'aliProfile': aliProfile,
    'spreadCount': spreadCount,
    'spreadUid': spreadUid,
    'nowMoney': nowMoney,
    'unlockMoney': unlockMoney
  };
}
