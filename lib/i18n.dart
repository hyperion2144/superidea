import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en") +
      {
        "en": "Article",
        "zh": "文章",
      } +
      {
        "en": "Menu",
        "zh": "菜单",
      } +
      {
        "en": "Tag",
        "zh": "标签",
      } +
      {
        "en": "Theme",
        "zh": "主题",
      } +
      {
        "en": "Remote",
        "zh": "远程",
      } +
      {
        "en": "About",
        "zh": "关于",
      } +
      {"en": "Contact", "zh": "联系"} +
      {"en": "Login", "zh": "登录"} +
      {"en": "Register", "zh": "注册"} +
      {"en": "Logout", "zh": "登出"} +
      {"en": "Homepage", "zh": "首页"} +
      {"en": "Settings", "zh": "设置"} +
      {"en": "Preview", "zh": "预览"} +
      {"en": "Sync", "zh": "同步"} +
      {"en": "Language", "zh": "语言"} +
      {"en": "Simple Chinese", "zh": "简体中文"} +
      {"en": "English", "zh": "英文"} +
      {"en": "Site Source File Path", "zh": "站点源文件路径"} +
      {"en": "Save", "zh": "保存"} +
      {"en": "Version", "zh": "版本"} +
      {"en": "Star Support Author", "zh": "Star 支持作者"} +
      {"en": "Toggle Sidebar", "zh": "切换侧边栏"} +
      {"en": "Search", "zh": "搜索"} +
      {"en": "New", "zh": "新建"} +
      {
        "en": "Published",
        "zh": "已发布",
      } +
      {
        "en": "Unpublished",
        "zh": "未发布",
      } +
      {
        "en": "Selected",
        "zh": "已选",
      } +
      {"en": "Close", "zh": "关闭"} +
      {
        "en": "Cancel",
        "zh": "取消",
      } +
      {"en": "Name", "zh": "名称"} +
      {"en": "Internal", "zh": "内部"} +
      {"en": "External", "zh": "外部"} +
      {"en": "Link", "zh": "链接"} +
      {"en": "Input or Select from below", "zh": "输入或从下面选择"} +
      {
        "en": "Archives",
        "zh": "归档",
      } +
      {
        "en": "Tags",
        "zh": "标签",
      };

  String get i18n => localize(this, _t);
}
