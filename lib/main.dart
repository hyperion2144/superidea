import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_template/pages/article_page.dart';
import 'package:flutter_rust_bridge_template/theme.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:macos_ui/macos_ui.dart';
import 'dart:io' as io;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'i18n.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(800, 600),
    center: false,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

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
    return ChangeNotifierProvider(
        create: (context) => AppTheme(),
        builder: (context, _) {
          final appTheme = context.watch<AppTheme>();
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
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: appTheme.mode,
            debugShowCheckedModeBanner: false,
            home: I18n(child: const MyHomePage()),
          );
        });
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
          top: Image.asset(
            'assets/images/superidea_logo.png',
            height: 100,
            fit:BoxFit.fitHeight,
          ),
          decoration: BoxDecoration(color: MacosColors.controlColor.darkColor),
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
                  leading: const MacosIcon(EvaIcons.menu_2),
                  label: Text('Menu'.i18n),
                  trailing: const Text('2'),
                ),
                SidebarItem(
                  leading: const MacosIcon(LineAwesome.tag_solid),
                  label: Text('Tag'.i18n),
                  trailing: const Text('2'),
                ),
                SidebarItem(
                  leading: const MacosIcon(LineAwesome.tshirt_solid),
                  label: Text('Theme'.i18n),
                ),
                SidebarItem(
                  leading: const MacosIcon(LineAwesome.server_solid),
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
                          OctIcons.eye_24,
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
                  onPressed: () {},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const MacosIcon(
                          OctIcons.rocket_24,
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
                      icon: const MacosIcon(Iconsax.setting_4),
                      onPressed: () {},
                    ),
                    Tooltip(
                      message: 'Star Support Author'.i18n,
                      child: MacosIconButton(
                        icon: const MacosIcon(EvaIcons.github_outline),
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
                        isLabelVisible: true,
                        backgroundColor: primaryColor,
                        child: MacosIconButton(
                          icon: const MacosIcon(
                            Iconsax.info_circle,
                            color: MacosColors.systemGrayColor,
                          ),
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
