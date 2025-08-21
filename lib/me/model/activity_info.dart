/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
class ActivityInfo {
  String img = '';
  String url = '';
  String webUrl = '';
  String title = '';
  String color = '';
  ActivityInfo();

  ActivityInfo.fromJson(Map json)
      : img = json['img'] ?? '',
        url = json['url'] ?? '',
        webUrl = json['webUrl'] ?? '',
        title = json['title'] ?? '',
        color = json['color'] ?? '';

  Map<String, dynamic> toJson() => {'img': img, 'url': url, 'webUrl': webUrl, 'title': title, 'color': color};
}
