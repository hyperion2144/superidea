import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_template/i18n.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:flutter_rust_bridge_template/ffi.dart'
    if (dart.library.html) 'ffi_web.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late Future<Platform> platform;
  late Future<bool> isRelease;

  @override
  void initState() {
    super.initState();

    platform = api.platform();
    isRelease = api.rustReleaseMode();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        leading: MacosTooltip(
          message: 'Toggle Sidebar'.i18n,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
              maxWidth: 48,
              maxHeight: 38,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
      ),
      children: [
        ContentArea(
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("You're running on"),
                  FutureBuilder<List<dynamic>>(
                    future: Future.wait([platform, isRelease]),
                    builder: (context, snap) {
                      final style = MacosTheme.of(context).typography.headline;
                      if (snap.error != null) {
                        debugPrint(snap.error.toString());
                        return Tooltip(
                          message: snap.error.toString(),
                          child: Text('Unknown OS', style: style),
                        );
                      }

                      // Guard return here, the data is not ready yet.
                      final data = snap.data;
                      if (data == null) {
                        return const CircularProgressIndicator();
                      }

                      final Platform platform = data[0];
                      final release = data[1] ? 'Release' : 'Debug';
                      final text = const {
                            Platform.Android: 'Android',
                            Platform.Ios: 'iOS',
                            Platform.MacApple: 'MacOS with Apple Silicon',
                            Platform.MacIntel: 'MacOS',
                            Platform.Windows: 'Windows',
                            Platform.Unix: 'Unix',
                            Platform.Wasm: 'the Web',
                          }[platform] ??
                          'Unknown OS';
                      return Text('$text ($release)', style: style);
                    },
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
