/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

typedef AsyncImageWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, String url);

///有宽高的Image
class AspectRatioImage extends StatelessWidget {
  final String url;
  late ImageProvider provider;
  late AsyncImageWidgetBuilder<ui.Image> builder;

  late ImageStreamListener listener;

  // const AsperctRaioImage(this.url, {Key? key}) : super(key: key);

  AspectRatioImage.network(url, {Key? key, required this.builder})
      : provider = CachedNetworkImageProvider(url),
        this.url = url;

  @override
  Widget build(BuildContext context) {
    final ImageConfiguration config = createLocalImageConfiguration(context);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(config);
    listener = ImageStreamListener(
          (ImageInfo image, bool sync) {
        completer.complete(image.image);
        stream.removeListener(listener);
      },
      onError: (object, stack) {
        completer.complete();
        stream.removeListener(listener);
        FlutterError.reportError(FlutterErrorDetails(
          context: ErrorDescription('image failed to precache'),
          library: 'image resource service',
          exception: object,
          stack: stack,
          silent: true,
        ));
      }
    );
    stream.addListener(listener);

    return FutureBuilder(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot, url);
          } else {
            return Container();
          }
        });
  }
}