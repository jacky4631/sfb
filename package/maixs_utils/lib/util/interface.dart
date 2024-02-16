import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:maixs_utils/config/net/pgyer_api.dart';
import '../util/utils.dart';
import '../widget/views.dart';
import '../model/data_model.dart';
import '../util/textedit_util.dart';

class ValueModel {
  final String text;
  final dynamic con;
  final String? tips;
  ValueModel(this.text, this.con, [this.tips]);
}

class CheckModel {
  final String text;
  final dynamic con;
  final String? tips;
  final bool? isPhone;
  CheckModel(this.text, this.con, {this.tips, this.isPhone});
}

class Interface {
  ///接口请求与非空验证统一处理
  static handle(
    BuildContext context, {
    required DataModel dataModel,
    required Future<void> Function() event,
    List<ValueModel> valueChecking = const [],
    void Function(DataModel)? success,
    bool isShowDialog = true,
  }) async {
    Future(() async {
      TextEditUtil teUtil = TextEditUtil();
      teUtil.addController(valueChecking.map((m) => {'text': m.text, 'con': m.con, 'tips': m.tips}).toList());
      var check = teUtil.check();
      if (check == null) {
        if (isShowDialog) buildShowDialog(context);
        await event();
        if (isShowDialog) pop(context);
        if (dataModel.flag >= 2) {
          if (success != null) success(dataModel);
        } else {
          showToast(dataModel.msg);
        }
      } else {
        showToast(check);
      }
    });
  }

  ///接口请求与非空验证统一处理2
  static request(
    BuildContext context, {
    DataModel? dataModel,
    required String path,
    required dynamic data,
    List<CheckModel> checking = const [],
    void Function()? success,
    void Function()? error,
    bool isShowDialog = true,
  }) async {
    Future(() async {
      var dm = DataModel();
      dataModel = dataModel ?? dm;
      TextEditUtil teUtil = TextEditUtil();
      teUtil.addController(checking.map((m) => {'text': m.text, 'con': m.con, 'tips': m.tips}).toList());
      var check = teUtil.check();
      if (check == null) {
        if (isShowDialog) buildShowDialog(context);
        await _toObjectApi(path, data, dataModel!);
        if (isShowDialog) pop(context);
        if (dataModel!.flag >= 2) {
          if (success != null) success();
        } else {
          showToast(dataModel?.msg);
          if (error != null) error();
        }
      } else {
        showToast(check);
      }
    });
  }

  ///对象接口
  static Future _toObjectApi(String path, data, DataModel dataModel) async {
    var res = await http.post(path, data: data).catchError((e) {
      error(e, (v, type, code) => dataModel.toError(v));
    });
    dataModel.toObject(res, (f) => f);
  }
}
