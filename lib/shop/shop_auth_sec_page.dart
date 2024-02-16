/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_face_verify/flutter_ali_face_verify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:maixs_utils/widget/widget_tap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/shop/ali_face.dart';
import 'package:sufenbao/util/pic_helper.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../util/toast_utils.dart';
import '../widget/loading.dart';
import '../widget/pic_bottom_sheet.dart';

///首页
class ShopAuthSecPage extends StatefulWidget {
  @override
  _ShopAuthSecPageState createState() => _ShopAuthSecPageState();
}

class _ShopAuthSecPageState extends State<ShopAuthSecPage> {
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _cardNameController = new TextEditingController();
  TextEditingController _cardNoController = new TextEditingController();
  String cardFPath = '';
  String cardBPath = '';
  String facePath = '';
  String contractPath = '';
  bool cardComplete = false;
  bool faceComplete = false;
  bool contractComplete = false;
  bool loading = true;

  bool checkboxSelected = false;
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _cardNameController.dispose();
    _cardNoController.dispose();
    super.dispose();
  }

  var listDm = DataModel();

  ///初始化函数
  Future initData() async {
    Map<String, dynamic> json = await BService.userinfo(baseInfo: true);
    Map<String, dynamic> card = await BService.userCard();

    setState(() {
      loading = false;
      _mobileController.text = json['phone'];
      cardFPath = card['cardFPath']??'';
      cardBPath = card['cardBPath']??'';
      facePath = card['facePath']??'';
      contractPath = card['contractPath']??'';
      _cardNoController.text = card['cardNo']??'';
      _cardNameController.text = card['cardName']??'';
    });
    checkCardStatus();
    checkFaceStatus();
    checkContractStatus();
    readSeenData();
  }

  checkCardStatus() {
    setState(() {
      if (cardFPath != null &&
          cardFPath.isNotEmpty &&
          cardBPath != null &&
          cardBPath.isNotEmpty &&
          _cardNoController.text.isNotEmpty &&
          _cardNameController.text.isNotEmpty &&
          _mobileController.text.isNotEmpty) {
        cardComplete = true;
      }
    });
  }

  checkFaceStatus() {
    setState(() {
      if (cardComplete && facePath!.isNotEmpty) {
        faceComplete = true;
      }
    });
  }

  checkContractStatus() {
    setState(() {
      if (cardComplete &&
          faceComplete &&
          contractPath != null &&
          contractPath.isNotEmpty) {
        contractComplete = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        bgColor: Color(0xffF4F5F6),
        body: Stack(children: [
          MyCustomScroll(
            isGengduo: false,
            isShuaxin: false,
            refHeader: buildClassicHeader(color: Colors.grey),
            refFooter: buildCustomFooter(color: Colors.grey),
            headers: headers(context),
            itemPadding: EdgeInsets.all(8),
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            itemModel: listDm,
            itemModelBuilder: (i, v) {
              return PWidget.boxh(1);
            },
          ),
          btmBarView(context)
        ]));
  }

  List<Widget> headers(context) {
    if (loading) {
      return [
        PWidget.container(Global.showLoading2(), [null, 500])
      ];
    }
    return [
      PWidget.container(
        PWidget.column([
          PWidget.boxh(10),
          PWidget.row([
            PWidget.text('1.身份认证', [Colors.black, 18, true]),
            PWidget.icon(
                Icons.gpp_good_rounded, [cardComplete ? Colors.green : null])
          ]),
          PWidget.boxh(20),
          PWidget.row([
            Flexible(
              flex: 5,
              child: PWidget.column([
                WidgetTap(
                  child: PWidget.stack([
                    if (cardFPath == null || cardFPath == '')
                      PWidget.image('assets/images/mall/card1.png', [180, 120]),
                    if (cardFPath != null && cardFPath != '')
                      PWidget.wrapperImage(cardFPath, [180, 120]),
                    SvgPicture.asset(
                      'assets/svg/camera.svg',
                      width: 32,
                      height: 32,
                      color: Colors.grey,
                    ),
                  ], [
                    0,
                    0
                  ]),
                  onTap: () {
                    _showPicSheet(context, 1);
                  },
                ),
                PWidget.boxh(5),
                PWidget.text('上传身份证人像面', {'ct': true})
              ], "221"),
            ),
            Flexible(
              flex: 5,
              child: PWidget.column([
                WidgetTap(
                    child: PWidget.stack([
                      if (cardBPath == null || cardBPath == '')
                        PWidget.image(
                            'assets/images/mall/card2.png', [180, 120]),
                      if (cardBPath != null && cardBPath != '')
                        PWidget.wrapperImage(cardBPath, [180, 120]),
                      SvgPicture.asset(
                        'assets/svg/camera.svg',
                        width: 32,
                        height: 32,
                        color: Colors.grey,
                      ),
                    ], [
                      0,
                      0
                    ]),
                    onTap: () {
                      _showPicSheet(context, 2);
                    }),
                PWidget.boxh(5),
                PWidget.text('上传身份证国徽面', {'ct': true})
              ], "221"),
            )
          ]),
          PWidget.boxh(20),
          PWidget.row([
            PWidget.text('姓名          ', [Colors.black.withOpacity(0.75), 16]),
            buildTextField2(
                hint: '',
                con: _cardNameController,
                showSearch: false,
                height: 40,
                bgColor: Colors.white,
                border: new UnderlineInputBorder(
                  // 焦点集中的时候颜色
                  borderSide: BorderSide(
                    color: Color(0x19000000),
                  ),
                ))
          ]),
          PWidget.boxh(10),
          PWidget.row([
            PWidget.text('身份证号码', [Colors.black.withOpacity(0.75), 16]),
            buildTextField2(
                hint: '',
                con: _cardNoController,
                showSearch: false,
                height: 40,
                bgColor: Colors.white,
                border: new UnderlineInputBorder(
                  // 焦点集中的时候颜色
                  borderSide: BorderSide(
                    color: Color(0x19000000),
                  ),
                ))
          ]),
          PWidget.boxh(10),
          PWidget.row([
            PWidget.text('手机号码    ', [Colors.black.withOpacity(0.75), 16]),
            buildTextField2(
                con: _mobileController,
                hint: '',
                showSearch: false,
                bgColor: Colors.white,
                keyboardType: TextInputType.number,
                border: new UnderlineInputBorder(
                  // 焦点集中的时候颜色
                  borderSide: BorderSide(
                    color: Color(0x19000000),
                  ),
                ))
          ]),
        ]),
        [null, 380, Colors.white],
        {
          'br': 8,
          'pd': [8, 8, 8, 8],
          'mg': PFun.lg(6, 6, 6, 6)
        },
      ),
      PWidget.container(
        PWidget.column([
          PWidget.boxh(10),
          PWidget.row([
            PWidget.text('2.签署协议', [Colors.black, 18, true]),
            PWidget.icon(Icons.gpp_good_rounded,
                [contractComplete||checkboxSelected ? Colors.green : null])
          ]),
          PWidget.boxh(20),
          if(contractPath !=null && contractPath.isNotEmpty)
            PWidget.row([
              PWidget.spacer(),
              PWidget.text('查看', [Colors.black, 14]),
              PWidget.text('《电子协议${contractPath.substring(contractPath.lastIndexOf('/')+1, contractPath.lastIndexOf('.'))}》', [
                Colors.blue,
                14
              ], {
                'fun': () {
                  Navigator.pushNamed(context, '/shopContractPage', arguments: {'url': contractPath,
                    'title':contractPath.substring(contractPath.lastIndexOf('/')+1, contractPath.lastIndexOf('.'))});
                }
              }),
              PWidget.spacer(),
            ]),
          if(contractPath == null ||contractPath.isEmpty)
            createContractWidget(),
          PWidget.boxh(20),
        ]),
        [null, null, Colors.white],
        {
          'br': 8,
          'pd': [8, 8, 8, 8],
          'mg': PFun.lg(6, 6, 6, 6)
        },
      ),
      PWidget.container(
        PWidget.column([
          PWidget.boxh(10),
          PWidget.row([
            PWidget.text('3.', [Colors.black, 18, true]),
            PWidget.image('assets/images/share/alipay.png', [18, 18]),
            PWidget.text('人脸核验', [Colors.black, 18, true]),
            PWidget.icon(
                Icons.gpp_good_rounded, [faceComplete ? Colors.green : null])
          ]),
          PWidget.boxh(20),
          PWidget.column(
              [
                SvgPicture.asset(
                  'assets/svg/face.svg',
                  width: 72,
                  height: 72,
                  color: faceComplete ? Colors.green : Colors.grey,
                ),
                // PWidget.image('assets/images/mall/kuang.png', [150, 100]),
                PWidget.boxh(10),
                PWidget.text(faceComplete ? '已核验' : '点击识别',
                    [faceComplete ? Colors.green : Colors.black], {'ct': true}),
              ],
              "221",
              {'fun': faceVerify}),
          PWidget.boxh(5),
          PWidget.textNormal('1.将眼镜摘下，卸妆后再进行人脸核验',
              [Colors.blue, 13], {'ct': true}),
          PWidget.textNormal('2.移动到光线充足的地方进行人脸核验',
              [Colors.blue, 13], {'ct': true}),
        ]),
        [null, 340, Colors.white],
        {
          'br': 8,
          'pd': [8, MediaQuery.of(context).padding.bottom + 100, 8, 8],
          'mg': PFun.lg(6, 6, 6, 6)
        },
      ),

    ];
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    Color? bg;
    if(cardComplete&&contractComplete&&checkboxSelected&&faceComplete){
      bg = Colours.app_main;;
      setState(() {
      });
    }else{
      bg = Colors.grey[300];
    }
    return PWidget.positioned(
      SafeArea(
          child: Column(
        children: [
          RawMaterialButton(
              constraints: BoxConstraints(minHeight: 44),
              fillColor: bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              onPressed: () {
                if(!cardComplete) {
                  ToastUtils.showToast('请先完成身份认证');
                  return;
                }
                if (!contractComplete && !checkboxSelected) {
                  ToastUtils.showToast('请先阅读并同意《加盟服务合同》');
                  return;
                }
                if(!faceComplete) {
                  ToastUtils.showToast('请先完成人脸核验');
                  return;
                }
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '提交认证',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      )),
      [null, 10, 20, 20],
    );
  }

  Widget createContractWidget() {
    return PWidget.row([
      Checkbox(
        value: checkboxSelected,
        onChanged: (value) {
          if(!Seen){
            ToastUtils.showToast('请先阅读《加盟服务合同》');
            return;
          }
          checkboxSelected = !checkboxSelected;
          setState(() {});
        },
        shape: CircleBorder(),
        activeColor: Colors.blue,
      ),
      PWidget.text('我已阅读并同意', [Colors.black, 14]),
      PWidget.text('《加盟服务合同》', [
        Colors.blue,
        14
      ], {
        'fun': () {
          Navigator.pushNamed(context, '/shopContractPage').then((value) {
            if(value == true)
            checkboxSelected = true;
            setState(() {

            });
          });
        }
      }),
    ]);
  }


  void _showPicSheet(context, type) async {
    if(contractPath != null && contractPath.isNotEmpty) {
      ToastUtils.showToast('合同签署成功，不允许更改');
      return;
    }
    PicBottomSheet.showText(context, dataArr: ['拍照', '相册'], title: '请选择',
        clickCallback: (index, str) async {
      if(await Global.isHuawei()) {
          if (index == 1) {
            var isGrantedCamera = await Permission.camera.isGranted;
            if (!isGrantedCamera) {
              Global.showCameraDialog((){
                PicHelper.openCamera(context, cameraQuarterTurns: 0,
                    callback: (File file) async {
                      uploadPic(file, type, index);
                    });
              });
            } else {
              PicHelper.openCamera(context, cameraQuarterTurns: 0,
                  callback: (File file) async {
                    uploadPic(file, type, index);
                  });
            }
          } else if (index == 2) {
            int version = await Global.getAndroidVersion();
            bool isGrantedPhoto;
            if(version>= 33) {
              PermissionStatus status = await Permission.photos.status;
              isGrantedPhoto = status == PermissionStatus.granted;
            } else {
              PermissionStatus status = await Permission.storage.status;
              isGrantedPhoto = status == PermissionStatus.granted;
            }
            if (!isGrantedPhoto) {
              Global.showPhotoDialog((){
                PicHelper.selectPic(context, (File file) async {
                  uploadPic(file, type, index);
                });
              });
            } else {
              PicHelper.selectPic(context, (File file) async {
                uploadPic(file, type, index);
              });
            }
          }
      } else {
        if (index == 1) {
          PicHelper.openCamera(context, cameraQuarterTurns: 0,
              callback: (File file) async {
                uploadPic(file, type, index);
              });
        }else if (index == 2) {
          PicHelper.selectPic(context, (File file) async {
            uploadPic(file, type, index);
          });
        }
      }

    });
  }

  Future uploadPic(File file, type, index) async {
    Loading.show(context);
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    Map data =
        await BService.uploadCard(formData, type, angle: index == 1 ? 270 : 0);
    Loading.hide(context);
    if (!data['success']) {
      ToastUtils.showToast(data['msg']);
      return;
    }
    Map cardInfo = data['data'];
    if (type == 1) {
      cardFPath = cardInfo['url'];
      _cardNameController.text = cardInfo['cardName'];
      _cardNoController.text = cardInfo['cardNo'];
    } else if (type == 2) {
      cardBPath = cardInfo['url'];
    }
    setState(() {
      checkCardStatus();
    });
  }

  faceVerify() async {
    if(contractPath != null && contractPath.isNotEmpty) {
      ToastUtils.showToast('合同签署成功，不允许更改');
      return;
    }
    if (!cardComplete) {
      ToastUtils.showToast('请先完成身份认证');
      return;
    }
    if (!checkboxSelected) {
      ToastUtils.showToast('请先阅读并同意《加盟服务合同》');
      return;
    }
    if (faceComplete) {
      ToastUtils.showToast('人脸核验已完成');
      return;
    }
    Loading.show(context);
    //获取人脸识别流水号
    Map data = await BService.getAliFaceTicket(_cardNameController.text,
        _cardNoController.text, _mobileController.text);
    flog(data);
    if (data['code'] != '10000') {
      ToastUtils.showToast('身份认证失败，请查看信息是否有误');
      Loading.hide(context);
      return;
    }
    String certifyId = data['certify_id'];
    //打开支付宝人脸识别框
    var result = await startFaceService(certifyId, data['page_url']);
    if (result is AndroidAliFaceVerifyResult) {
      AndroidAliFaceVerifyResult aResult = result as AndroidAliFaceVerifyResult;
      if (!aResult.isSuccess) {
        ToastUtils.showToast("人脸核验失败");
        Loading.hide(context);
        return;
      }
    } else if (result is IosAliFaceVerifyResult) {
      IosAliFaceVerifyResult iResult = result as IosAliFaceVerifyResult;
      if (!iResult.isSuccess) {
        ToastUtils.showToast("人脸核验失败");
        Loading.hide(context);
        return;
      }
    }
    //校验识别结果
    Map faceResult = await BService.getAliFaceResult(certifyId, _mobileController.text);
    if (faceResult['code'] != '10000') {
      ToastUtils.showToast('支付宝人脸核验失败，请确保本人操作');
      Loading.hide(context);
      return;
    }
    Loading.hide(context);
    ToastUtils.showToast('人脸核验完成');
    initData();
  }

  Future<void> readSeenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Seen = await prefs.getBool('SeenStatus') ?? false;
    if(Seen){
      checkboxSelected = true;
    }
  }
}
