/// Material 3 canonical window size classes.
///
/// Apps use `LayoutBuilder` + `DittoWindowClass.of(width)` to make
/// responsive layout decisions. Shared by all three Flutter surfaces.
enum DittoWindowClass {
  /// < 600px — phones.
  compact,

  /// 600–839px — small tablets, foldables.
  medium,

  /// 840–1199px — tablets, small desktops.
  expanded,

  /// ≥ 1200px — desktops, large tablets in landscape.
  large;

  /// Classify a pixel width into a window class.
  static DittoWindowClass of(double width) {
    if (width < 600) return compact;
    if (width < 840) return medium;
    if (width < 1200) return expanded;
    return large;
  }

  /// Whether this class should show a permanent sidebar.
  bool get showPermanentSidebar => this != compact;
}
