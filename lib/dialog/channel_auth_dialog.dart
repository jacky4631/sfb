/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 渠道授权弹窗
 */
import 'package:flutter/material.dart';
import 'package:flutter_alibc/alibc_model.dart';
import 'package:flutter_alibc/flutter_alibc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/colors.dart';
import 'package:sufenbao/util/alibc_init.dart';
import 'package:sufenbao/util/toast_utils.dart';

import 'package:dio/dio.dart';
import 'taobao_auth_error.dart';

class ChannelAuthDialog extends StatefulWidget {
  final Map data;
  ChannelAuthDialog(this.data, {Key? key}) : super(key: key);

  @override
  State<ChannelAuthDialog> createState() => _ChannelAuthDialogState();
}

class _ChannelAuthDialogState extends State<ChannelAuthDialog> {
  Map get data => widget.data;
  bool _authorizing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
      child: PWidget.column([
        PWidget.row([
          PWidget.image('assets/images/logo.png', [38, 38], {'crr': 19}),
          PWidget.boxw(8),
          SvgPicture.asset(
              'assets/svg/arrow.svg',
              width: 38,
              height: 38,
              color: Colours.app_main
          ),
          PWidget.boxw(8),
          PWidget.image('assets/images/mall/tb.png', [38, 38], {'crr': 19}),
        ], '221'),
        PWidget.boxh(8),
        PWidget.text('淘宝授权后可自动绑定订单',[Colors.black.withOpacity(0.75), 15, true]),
        PWidget.boxh(8),
        PWidget.text('您可以前往淘宝授权，也可以直接购买',[Colors.black.withOpacity(0.75), 13],{'max':2}),
        PWidget.boxh(8),
        _createButton(),
        if (data['showDirectBuy'] == true) ...[
          PWidget.boxh(8),
          TextButton(
            onPressed: _authorizing ? null : data['fun'],
            child: const Text('暂不授权，直接购买',
                style: TextStyle(color: Colours.app_main, fontSize: 14)),
          ),
        ],
      ], '221'),
    );
  }

  _createButton() {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Color(0xFFFB040F)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ))),
        onPressed: _authorizing ? null : _authorize,
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Text(
                      _authorizing ? '正在授权…' : '前往淘宝授权',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ]
          ),
        ));
  }

  void _showFailure(String message) {
    if (!mounted) return;
    setState(() {
      _authorizing = false;
    });
    ToastUtils.showToast(message);
  }

  Future<void> _authorize() async {
    setState(() {
      _authorizing = true;
    });
    //合规：百川 SDK 按需初始化，用户点击授权时才初始化
    if (!await AlibcInit.ensure()) {
      _showFailure(TaobaoAuthError.fallback);
      return;
    }
    // 与 TSQ 一致：重新登录，确保切换淘宝账号后获取新的授权凭证。
    FlutterAlibc.loginOut();
    FlutterAlibc.loginTaoBao(loginCallback: (LoginModel model) async {
      if (!mounted) return;
      if (model.errorCode != '0') {
        _showFailure(TaobaoAuthError.sdk(model.errorMessage, model.errorCode));
        return;
      }
      final token = model.data?.topAccessToken?.trim() ?? '';
      if (token.isEmpty) {
        _showFailure(TaobaoAuthError.missingToken);
        return;
      }
      try {
        final result = await BService.channelAuth(token);
        if (!mounted) return;
        if (result['success'] != true) {
          _showFailure(TaobaoAuthError.response(result));
          return;
        }
        setState(() => _authorizing = false);
        ToastUtils.showToast('授权成功');
        if (data['callback'] != null) data['callback']();
      } on DioException catch (error) {
        final body = error.response?.data;
        _showFailure(body is Map ? TaobaoAuthError.response(body)
            : TaobaoAuthError.fallback);
      } catch (error) {
        _showFailure(TaobaoAuthError.fallback);
      }
    });
  }

}
