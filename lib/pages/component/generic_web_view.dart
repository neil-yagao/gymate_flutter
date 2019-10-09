import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workout_helper/service/basic_dio.dart' as basic;

class GenericWebView extends StatefulWidget {
  final String title;
  final String url;
  final List<Widget> actions;
  final Widget leading;

  const GenericWebView({Key key, this.title, this.url, this.actions,this.leading}) : super(key: key);

  @override
  _GenericWebViewState createState() => _GenericWebViewState(title, url,actions,leading);
}

class _GenericWebViewState extends State<GenericWebView> {
  final String title;
  final String url;
  final List<Widget> actions;
  final Widget leading;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewController currentController;
  _GenericWebViewState(this.title, this.url, this.actions, this.leading);

  @override
  void dispose() {
    currentController?.clearCache();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        leading: leading,
        title: Text(title),
        actions: actions,
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      hidden: true,
      clearCache: true,
      appCacheEnabled: false,
//      floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favorited $url')),
                );
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }
}
