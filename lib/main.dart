import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_template/pages/article_page.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:macos_ui/macos_ui.dart';
import 'dart:io' as io;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<void> main() async {
  if (!kIsWeb) {
    if (io.Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: I18n(child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
          minWidth: 200,
          // TODO: Get and Set avatar on top.
          top: const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: CircleAvatar(),
          ),
          builder: (BuildContext context, ScrollController scrollController) {
            return SidebarItems(
              currentIndex: pageIndex,
              onChanged: (i) {
                setState(() => pageIndex = i);
              },
              itemSize: SidebarItemSize.large,
              // TODO: Fetching item number and show.
              items: [
                SidebarItem(
                  leading: const MacosIcon(Icons.article_outlined),
                  label: Text('Article'.i18n),
                  trailing: const Text('2'),
                ),
                SidebarItem(
                  leading: const MacosIcon(Icons.menu_outlined),
                  label: Text('Menu'.i18n),
                  trailing: const Text('2'),
                ),
                SidebarItem(
                  leading: const MacosIcon(FontAwesomeIcons.tag),
                  label: Text('Tag'.i18n),
                  trailing: const Text('2'),
                ),
                SidebarItem(
                  leading: const MacosIcon(FontAwesomeIcons.shirt),
                  label: Text('Theme'.i18n),
                ),
                SidebarItem(
                  leading: const MacosIcon(FontAwesomeIcons.server),
                  label: Text('Remote'.i18n),
                ),
              ],
            );
          },
          // TODO: Add Buttons pressed function.
          bottom: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PushButton(
                  secondary: true,
                  controlSize: ControlSize.large,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  // color: MacosColors.controlColor.darkColor,
                  onPressed: () {},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MacosIcon(
                          Icons.remove_red_eye,
                          color: MacosTheme.of(context).typography.body.color,
                        ),
                        SizedBox.fromSize(
                          size: const Size(10, 10),
                        ),
                        Text(
                          'Preview'.i18n,
                        ),
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PushButton(
                  controlSize: ControlSize.large,
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  // color: Colors.black54,
                  onPressed: () {},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const MacosIcon(
                          Icons.sync,
                          color: MacosColors.textColor,
                        ),
                        SizedBox.fromSize(
                          size: const Size(10, 10),
                        ),
                        Text('Sync'.i18n),
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MacosIconButton(
                      icon: const MacosIcon(Icons.settings),
                      onPressed: () {},
                    ),
                    Tooltip(
                      message: 'Star Support Author'.i18n,
                      child: MacosIconButton(
                        icon: const FaIcon(FontAwesomeIcons.github),
                        onPressed: () {},
                      ),
                    ),
                    // TODO: Receive message from superidea or discusion, and display badge count shake animate when message unread.
                    ShakeWidget(
                      shakeConstant: ShakeVerticalConstant2(),
                      duration: const Duration(seconds: 10),
                      autoPlay: false,
                      enableWebMouseHover: false,
                      child: Badge(
                        label: const Text('1'),
                        child: MacosIconButton(
                          icon: const MacosIcon(FontAwesomeIcons.message),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
      child: [
        const ArticlePage(),
      ][pageIndex],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
