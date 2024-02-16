/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors.dart';
import '../util/global.dart';

class ShopContractPage extends StatefulWidget {
  final Map data;
  const ShopContractPage(this.data, {Key? key, }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ShopContractPage> {
  String remotePDFpath = "";
  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      String signContractUrl = widget.data == null ? "" : widget.data['url']??'';
      final url = signContractUrl.isNotEmpty ? signContractUrl : Global.homeUrl['contractPreviewUrl'];
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.data == null || widget.data['title'] == null ? "加盟服务合同" : '电子协议${widget.data['title']}';

    if(remotePDFpath == '') {
      return Scaffold(
          appBar: buildAppBar(title),
          body: Global.showLoading2()
      );
    }
    return PDFScreen(path: remotePDFpath, title: title);
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;
  final String? title;

  PDFScreen({Key? key, this.path, this.title}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}
int curentTimer = 5000;
class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  late Timer _timer;
  bool unsigned = true;

  @override
  void initState() {
    super.initState();
    if(widget.title !='加盟服务合同') {
      unsigned = false;
    }
    if(unsigned) {
      if(!Seen){
        _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
          curentTimer-=100;
          if(curentTimer <= 0){
            _timer.cancel();
          }
          setState(() {});
        });
      }else{
        curentTimer = 0;
      }
    }

  }
  @override
  void dispose() {
    if(_timer!=null){
      _timer.cancel();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(widget.title),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
            false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          ),
          if(unsigned)
            btmBarView(context),
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              backgroundColor: Colors.white,
              label: Text("${currentPage!+1}/$pages", style: TextStyle(color: Colors.black),),
              onPressed: () async {
                // await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
buildAppBar(title) {
  return AppBar(
    leading: BackButton(
        color: Colors.black
    ),
    title: Text(title, style: TextStyle(color: Colors.black),),
    backgroundColor: Colors.white,
  );
}
///底部操作栏
Widget btmBarView(BuildContext context) {
  Color? bg;
  String btnText = '阅读完成';
  if(curentTimer <= 0){
    bg = Colours.app_main;;
  }else{
    bg = Colors.grey[300];
    btnText = '阅读完成(${(curentTimer / 1000).toInt()})';
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
                  if(curentTimer <= 0) {
                    Seen = true;
                    SaveData();
                    Navigator.pop(context,true);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        btnText,
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
    [null, 10, 100, 100],
  );
}
Future<void> SaveData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('SeenStatus', Seen);
}