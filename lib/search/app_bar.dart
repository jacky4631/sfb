import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sufenbao/search/provider.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(searchProvider.notifier);

      return Container(
        height: kToolbarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.search_rounded,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: notifier.controller,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onSubmitted: notifier.submit,
                        decoration: const InputDecoration(
                          hintText: "搜索歌手, 歌曲, 专辑, 歌单",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true, //是文本垂直居中
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: InkWell(
                        onTap: () => notifier.clear(),
                        borderRadius: BorderRadius.circular(18),
                        child: const Icon(Icons.close_rounded, size: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
              child: const Text(
                "取消",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
