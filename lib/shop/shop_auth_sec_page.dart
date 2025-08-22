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
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/shop/ali_face.dart';
import 'package:sufenbao/util/pic_helper.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/toast_utils.dart';
import '../widget/loading.dart';
import '../widget/pic_bottom_sheet.dart';

// Global variable for seen status
bool Seen = false;

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

  ///初始化函数
  Future initData() async {
    Map<String, dynamic> json = await BService.userinfo(baseInfo: true);
    Map<String, dynamic> card = await BService.userCard();

    setState(() {
      loading = false;
      _mobileController.text = json['phone'];
      cardFPath = card['cardFPath'] ?? '';
      cardBPath = card['cardBPath'] ?? '';
      facePath = card['facePath'] ?? '';
      contractPath = card['contractPath'] ?? '';
      _cardNoController.text = card['cardNo'] ?? '';
      _cardNameController.text = card['cardName'] ?? '';
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
      if (cardComplete && faceComplete && contractPath != null && contractPath.isNotEmpty) {
        contractComplete = true;
      }
    });
  }

  Widget buildTextField2({
    required TextEditingController con,
    String hint = '',
    bool showSearch = true,
    double height = 50,
    Color bgColor = Colors.white,
    TextInputType keyboardType = TextInputType.text,
    InputBorder? border,
  }) {
    return Expanded(
      child: Container(
        height: height,
        child: TextField(
          controller: con,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: border ?? InputBorder.none,
            filled: true,
            fillColor: bgColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F6),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(headers(context)),
              ),
            ],
          ),
          btmBarView(context)
        ],
      ),
    );
  }

  List<Widget> headers(context) {
    if (loading) {
      return [
        Container(
          height: 500,
          child: Global.showLoading2(),
        )
      ];
    }
    return [
      Container(
        margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1.身份认证',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.gpp_good_rounded,
                  color: cardComplete ? Colors.green : Colors.grey,
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showPicSheet(context, 1);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (cardFPath.isEmpty)
                              Image.asset(
                                'assets/images/mall/card1.png',
                                width: 180,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            if (cardFPath.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cardFPath,
                                  width: 180,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 180,
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                            SvgPicture.asset(
                              'assets/svg/camera.svg',
                              width: 32,
                              height: 32,
                              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '上传身份证人像面',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showPicSheet(context, 2);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (cardBPath.isEmpty)
                              Image.asset(
                                'assets/images/mall/card2.png',
                                width: 180,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            if (cardBPath.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cardBPath,
                                  width: 180,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 180,
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                            SvgPicture.asset(
                              'assets/svg/camera.svg',
                              width: 32,
                              height: 32,
                              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '上传身份证国徽面',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '姓名          ',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                  ),
                ),
                buildTextField2(
                  hint: '',
                  con: _cardNameController,
                  showSearch: false,
                  height: 40,
                  bgColor: Colors.white,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x19000000),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '身份证号码',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                  ),
                ),
                buildTextField2(
                  hint: '',
                  con: _cardNoController,
                  showSearch: false,
                  height: 40,
                  bgColor: Colors.white,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x19000000),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '手机号码    ',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                  ),
                ),
                buildTextField2(
                  con: _mobileController,
                  hint: '',
                  showSearch: false,
                  bgColor: Colors.white,
                  keyboardType: TextInputType.number,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x19000000),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '2.签署协议',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.gpp_good_rounded,
                  color: contractComplete || checkboxSelected ? Colors.green : Colors.grey,
                )
              ],
            ),
            SizedBox(height: 20),
            if (contractPath.isNotEmpty)
              Row(
                children: [
                  Spacer(),
                  Text(
                    '查看',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/shopContractPage', arguments: {
                        'url': contractPath,
                        'title':
                            contractPath.substring(contractPath.lastIndexOf('/') + 1, contractPath.lastIndexOf('.'))
                      });
                    },
                    child: Text(
                      '《电子协议${contractPath.substring(contractPath.lastIndexOf('/') + 1, contractPath.lastIndexOf('.'))}》',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            if (contractPath.isEmpty) createContractWidget(),
            SizedBox(height: 20),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(6, 6, 6, MediaQuery.of(context).padding.bottom + 100),
        padding: EdgeInsets.all(8),
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '3.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/share/alipay.png',
                  width: 18,
                  height: 18,
                ),
                Text(
                  '人脸核验',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.gpp_good_rounded,
                  color: faceComplete ? Colors.green : Colors.grey,
                )
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: faceVerify,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/face.svg',
                    width: 72,
                    height: 72,
                    colorFilter: ColorFilter.mode(
                      faceComplete ? Colors.green : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    faceComplete ? '已核验' : '点击识别',
                    style: TextStyle(
                      color: faceComplete ? Colors.green : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
              '1.将眼镜摘下，卸妆后再进行人脸核验',
              style: TextStyle(color: Colors.blue, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            Text(
              '2.移动到光线充足的地方进行人脸核验',
              style: TextStyle(color: Colors.blue, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ];
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    Color? bg;
    if (cardComplete && contractComplete && checkboxSelected && faceComplete) {
      bg = Colours.app_main;
      setState(() {});
    } else {
      bg = Colors.grey[300];
    }
    return Positioned(
      bottom: 10,
      left: 20,
      right: 20,
      child: SafeArea(
        child: Column(
          children: [
            RawMaterialButton(
              constraints: BoxConstraints(minHeight: 44),
              fillColor: bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              onPressed: () {
                if (!cardComplete) {
                  ToastUtils.showToast('请先完成身份认证');
                  return;
                }
                if (!contractComplete && !checkboxSelected) {
                  ToastUtils.showToast('请先阅读并同意《加盟服务合同》');
                  return;
                }
                if (!faceComplete) {
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createContractWidget() {
    return Row(
      children: [
        Checkbox(
          value: checkboxSelected,
          onChanged: (value) {
            if (!Seen) {
              ToastUtils.showToast('请先阅读《加盟服务合同》');
              return;
            }
            checkboxSelected = !checkboxSelected;
            setState(() {});
          },
          shape: CircleBorder(),
          activeColor: Colors.blue,
        ),
        Text(
          '我已阅读并同意',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/shopContractPage').then((value) {
              if (value == true) checkboxSelected = true;
              setState(() {});
            });
          },
          child: Text(
            '《加盟服务合同》',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _showPicSheet(context, type) async {
    if (contractPath.isNotEmpty) {
      ToastUtils.showToast('合同签署成功，不允许更改');
      return;
    }
    PicBottomSheet.showText(context, dataArr: ['拍照', '相册'], title: '请选择', clickCallback: (index, str) async {
      if (await Global.isHuawei()) {
        if (index == 1) {
          var isGrantedCamera = await Permission.camera.isGranted;
          if (!isGrantedCamera) {
            Global.showCameraDialog(() {
              PicHelper.openCamera(context, cameraQuarterTurns: 0, callback: (File file) async {
                uploadPic(file, type, index);
              });
            });
          } else {
            PicHelper.openCamera(context, cameraQuarterTurns: 0, callback: (File file) async {
              uploadPic(file, type, index);
            });
          }
        } else if (index == 2) {
          int version = await Global.getAndroidVersion();
          bool isGrantedPhoto;
          if (version >= 33) {
            PermissionStatus status = await Permission.photos.status;
            isGrantedPhoto = status == PermissionStatus.granted;
          } else {
            PermissionStatus status = await Permission.storage.status;
            isGrantedPhoto = status == PermissionStatus.granted;
          }
          if (!isGrantedPhoto) {
            Global.showPhotoDialog(() {
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
          PicHelper.openCamera(context, cameraQuarterTurns: 0, callback: (File file) async {
            uploadPic(file, type, index);
          });
        } else if (index == 2) {
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
    Map data = await BService.uploadCard(formData, type, angle: index == 1 ? 270 : 0);
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
    if (contractPath.isNotEmpty) {
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
    Map data =
        await BService.getAliFaceTicket(_cardNameController.text, _cardNoController.text, _mobileController.text);
    if (data['code'] != '10000') {
      ToastUtils.showToast('身份认证失败，请查看信息是否有误');
      Loading.hide(context);
      return;
    }
    String certifyId = data['certify_id'];
    //打开支付宝人脸识别框
    var result = await startFaceService(certifyId, data['page_url']);
    if (result is AndroidAliFaceVerifyResult) {
      if (!result.isSuccess) {
        ToastUtils.showToast("人脸核验失败");
        Loading.hide(context);
        return;
      }
    } else if (result is IosAliFaceVerifyResult) {
      if (!result.isSuccess) {
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
    if (Seen) {
      checkboxSelected = true;
    }
  }
}
