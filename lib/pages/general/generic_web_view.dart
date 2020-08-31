import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'default_app_bar.dart';

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
    return Scaffold(
      appBar: DefaultAppBar.build(context,
        title: "",
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: actions
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('Pagable finished loading: $url');
          },
        );
      }),
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
}
